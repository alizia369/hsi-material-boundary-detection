%% function [rf] = learnPMIPredictor(f_maps,p,opts)
% learns a random forest rf that approximates PMI_{\rho}(A,B)
% 
% INPUTS
%  f_maps   - NxMxF array of F feature maps for an NxM image
%  p        - model for P(A,B) (Eqn. 1 in paper)
%  opts     - parameter settings (see setEnvironment)
%
% OUTPUTS
%  rf       - random forest that approximates PMI_{\rho}(A,B)
%
% -------------------------------------------------------------------------
% Crisp Boundaries Toolbox
% Phillip Isola, 2014 [phillpi@mit.edu]
% Please email me if you find bugs, or have suggestions or questions
% -------------------------------------------------------------------------

function [rf] = learnPMIPredictor(I,f_maps,p,opts)
    
    %%
    Nsamples = opts.PMI_predictor.Nsamples_learning_PMI_predictor;
    im_size = size(f_maps(:,:,1));
    datacube=I;
%     %% get all local pairs
%     if (strcmp(opts.imagetype,'Hyper'))
%        [ii,jj] = getSpectralLocalPairs(im_size,opts);
%     else  
       [ii,jj] = getLocalPairs(datacube,im_size,[],[],Nsamples); 
%        [ii,jj] = getSSLocalPairs(datacube,im_size,Nsamples); 
%     end  
    %% extract features
    [F,F_unary] = extractF(f_maps,ii,jj,opts);
    
    %% evaluate affinities
    pmi = evalPMI(p,F,F_unary,ii,jj,opts);
    
    %% learn PMI predictor: g(F) --> PMI
    Ntrees = opts.PMI_predictor.Ntrees;
    rf = fastRFreg_train(F,pmi,Ntrees);
end