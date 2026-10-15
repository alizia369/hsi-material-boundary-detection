%% function [F] = sampleF(f_maps,Nsamples,datacube,opts)
% samples feature pairs {A,B} at nearby pixel positions in f_maps
% 
% INPUTS
%  f_maps    - NxMxF array of F feature maps for an NxM image
%  N_samples - how many samples to take?
%  opts      - parameter settings (see setEnvironment)
%  
% OUTPUS
%  F         - each row is a sampled feature pair ,B}{A
%                A and B each have equal dimensionality
% 
% -------------------------------------------------------------------------
% Crisp Boundaries Toolbox
% Phillip Isola, 2014 [phillpi@mit.edu]
% Please email me if you find bugs, or have suggestions or questions
% -------------------------------------------------------------------------

function [F] = sampleF(f_maps,Nsamples,datacube,opts)
    
    %% sampling params
%     sig = opts.sig;
%     max_offset = 4*sig+1;
    
    %% sample
    im_size = size(f_maps(:,:,1));
    sample_from = ones(im_size);
    
    % sample position
    ii = discretesample(sample_from(:)./sum(sample_from(:)),Nsamples);
    ii = unique(ii);
    [yy,xx] = ind2sub(im_size,ii);
     m = (yy <6) | (xx <6)|(yy >im_size(1)-6) | (xx >im_size(2)-6);
     yy = yy(~m);
     xx = xx(~m);
     Nsamples = length(xx);
    p0 = cat(2,yy(:),xx(:));
    
 % % _______________________________My Sampling Suhad_________________________ 
    datacube2=imresize(datacube,[im_size(1) im_size(2)]);
    p1=p0;   
    Mx=0;
    for k=1:  Nsamples
        y=yy(k);x=xx(k);

        Vec1=squeeze(datacube2(y,x,:));
        N=norm(Vec1);
        Vec1=Vec1/N;
        for i=y-5:y+5
            for j=x-5:x+5               
               Vec2=squeeze(datacube2(i,j,:));
                N=norm(Vec2);
                Vec2=Vec2/N;
%                 SAM=Spectral_Angle(Vec1,Vec2);
                 SAM=norm(Vec1-Vec2);
                if SAM>Mx
                    Mx=SAM;
                    TempI=i;
                    TempJ=j;
                end  % End If  
            end    % End i
        end    % End j
        p2(k,1)=TempI;
        p2(k,2)=TempJ;
    end    
    %%
    % choose random offset
%     r = randn(Nsamples,2)*sqrt(sig);
%     r_n = r./repmat(sqrt(sum(r.^2,2)),[1 2]);
%     r = r+r_n;
%     
%     % cap offset
%     s = sign(r);
%     r = min(abs(r),max_offset);
%     r = s.*r;
%     
%     % make pair of points
%     p1 = p0;
%     p2 = p0;
%     p1(:,1:2) = p1(:,1:2)+r;
%     p2(:,1:2) = p0(:,1:2)-r;
%     %p0 = round(p0);
%     p1 = round(p1);
%     p2 = round(p2);
%     
    % remove out of bounds samples
%     m = (p1(:,1)<3) | (p1(:,2)<3) | (p2(:,1)<3) | (p2(:,2)<3) | ...
%         (p1(:,1)>im_size(1)) | (p1(:,2)>im_size(2)) | (p2(:,1)>im_size(1)) | (p2(:,2)>im_size(2));
%     %p0 = p0(~m,:);
%     p1 = p1(~m,:);
%     p2 = p2(~m,:);
    
    %
    ii = sub2ind(im_size,p1(:,1),p1(:,2));
    jj = sub2ind(im_size,p2(:,1),p2(:,2));
    F = zeros(size(p1,1),size(f_maps,3)*2);
    for c=1:size(f_maps,3)
        tmp = f_maps(:,:,c);
        F(:,c) = tmp(ii);
        F(:,c+size(f_maps,3)) = tmp(jj);
    end
    
    %% order A and B so that we only have to model half the space (assumes
    % symmetry: p(A,B) = p(B,A))
    if (opts.model_half_space_only)
        F = orderAB(F);
    end
end