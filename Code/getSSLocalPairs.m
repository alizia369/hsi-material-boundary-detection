%% function [ii jj] = getLocalPairs(im_size,rad,rad_inner,Nsamples)
%-------------Suhad---------------
% returns pairs of nearby pixel positions in an image of size im_size
% {ii(i),jj(i)} is the i-th pair
% 
% INPUTS
%  im_size       - size of image (num rows x num cols)
%  rad           - only return pairs at most rad pixels apart
%  rad_inner     - only return pairs at least rad_inner pixels apart
%  opts          - parameter settings (see setEnvironment)
%
% OUTPUTS
%  ii - linear indices in image of first pixels in sampled pairs
%  ii - linear indices in image of second pixels in sampled pairs
%
% 
% EQUIVALENCE TO BSR CODE
%  The following call:
%    [ii jj] = getLocalPairs(im_size);
%  
%  will give the same indices ii and jj as the following, which uses buildW
%  from http://www.eecs.berkeley.edu/Research/Projects/CS/vision/grouping/resources.html
%    l{1} = zeros(im_size(1) + 1, im_size(2));
%    l{1}(2:end, :) = ones(im_size);
%    l{2} = zeros(im_size(1), im_size(2) + 1);
%    l{2}(:, 2:end) = ones(im_size);
%    [ii,jj,~] = buildW(l{1},l{2});
%  (note that buildW is not included in the crisp boundaries toolbox)
% 
% -------------------------------------------------------------------------
% Crisp Boundaries Toolbox
% Phillip Isola, 2014 [phillpi@mit.edu]
% Please email me if you find bugs, or have suggestions or questions
% -------------------------------------------------------------------------

function [ii, jj] = getSSLocalPairs(datacube,im_size,Nsamples)
    noPix=im_size(1,1)*im_size(1,2);
    which_idx = randi(noPix,Nsamples,1);
%     ii = ii(which_idx);
    
    % sample position
%     ii = discretesample(sample_from(:)./sum(sample_from(:)),Nsamples);
%     ii = unique(ii);
%     Nsamples = length(ii);
    [yy,xx] = ind2sub(im_size,which_idx);
    m = (yy <6) | (xx <6)|(yy >im_size(1)-6) | (xx >im_size(2)-6);
    yy = yy(~m);
    xx = xx(~m);
    Nsamples = length(xx);
    p0 = cat(2,yy(:),xx(:));
  
 % % _______________________________My Sampling Suhad_________________________ 
    p1=p0;
    Mx=0;
    for k=1:  Nsamples
        y=yy(k);x=xx(k);
        Vec1=squeeze(datacube(y,x,:));
        N=norm(Vec1);
        Vec1=Vec1/N;
        for i=y-5:y+5
            for j=x-5:x+5
                Vec2=squeeze(datacube(i,j,:));
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

     m = (p1(:,1)<5) | (p1(:,2)<5) | (p2(:,1)<5) | (p2(:,2)<5) | ...
        (p1(:,1)>im_size(1)) | (p1(:,2)>im_size(2)) | (p2(:,1)>im_size(1)) | (p2(:,2)>im_size(2));
    %p0 = p0(~m,:);
    p1 = p1(~m,:);
    p2 = p2(~m,:);

    %
    ii = sub2ind(im_size,p1(:,1),p1(:,2));
    jj = sub2ind(im_size,p2(:,1),p2(:,2));
        
    
end