%% function [p, samples] = learnP_A_B(f_maps,I,opts)
% learns a model p for P(A,B) based on image statistics computed over f_maps
% 
% INPUTS
%  f_maps     - NxMxF array of F feature maps for an NxM image
%  opts       - parameter settings (see setEnvironment)
%
% OUTPUTS
%  p        - model for P(A,B) (Eqn. 1 in paper)
%
% -------------------------------------------------------------------------
% Crisp Boundaries Toolbox
% Phillip Isola, 2014 [phillpi@mit.edu]
% Please email me if you find bugs, or have suggestions or questions
% -------------------------------------------------------------------------

function [p] = learnP_A_B(f_maps,I,opts)
    
    if (strcmp(opts.model_type,'kde'))
        
        %% sample feature pairs {A,B}
%         if (strcmp(opts.imagetype,'Hyper'))  %Sampling for Hyperspectral images 
%             F = MySampling(f_maps,opts);% My Code
%         else   
            Nsamples = opts.kde.Nkernels;
            F = sampleF(f_maps,Nsamples,I,opts);
%         end     
        Nsamples_val = 500;
        F_val = sampleF(f_maps,Nsamples_val,I,opts);
        
        %% fit model
        if (~opts.kde.learn_bw)
            p = kde(F',0.06,[],'g');
%          mesh(hist(p));
        else
            p = kde(F','lcv',[],'g');

            %f = @(bw,p) nLOO_LL_anis(bw,p);
            f = @(bw,p,F_val) nLOO_LL_anis(bw,p,F_val);
            fminsearch_opts.Display = 'off';%'iter';
            fminsearch_opts.MaxIter = 20;

            reg_min = opts.kde.min_bw; % this regularizes for things like perceptual discriminability, that do not show up in the likelihood fit
                                       %  reduces the impact of
                                       %  outlier channels and noise
            reg_max = opts.kde.max_bw;
            
            for i=1:2 % for some reason repeatedly running fminsearch continues to improve the objective
                bw = getBW(p,1);
                bw_star = fminsearch(@(bw) f(bw,p,F_val), bw(1:size(bw,1)/2), fminsearch_opts);
                bw_star = cat(1,bw_star,bw_star);
                adjustBW(p,min(max(bw_star,reg_min),reg_max));
            end
        end
    else
        error('unrecognized model type');
    end
end

function [H] = nLOO_LL_anis(bw,p,F_val)
    bw = cat(1,bw,bw);
    adjustBW(p,bw);
    H = -evalAvgLogL(p,F_val');
end