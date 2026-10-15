%% function [E,E_oriented,Ws] = findBoundaries(I,type)
%
% INPUTS
%  I    - NxMxC query image; C can be 1 (grayscale) or 3 (color)
%  type - specifies parameter set to use (see setEnvironment)
%
% OUTPUTS
%  E          - NxM boundary map
%  E_oriented - NxMxO boundary map split into boundaries energy at O orientations
%  Ws         - affinity matrices; Ws{i} is the affinity matrix for the image at
%                scale i
% 
% -------------------------------------------------------------------------
% Crisp Boundaries Toolbox
% Phillip Isola, 2014 [phillpi@mit.edu]
% Please email me if you find bugs, or have suggestions or questions
% -------------------------------------------------------------------------

function [E,E_oriented,Ws] = findBoundaries(Img,type)
    
    addpath(genpath(pwd));
    
    if (~exist('type','var'))
        opts = setEnvironment('speedy');
    else
        opts = setEnvironment(type);
    end
if (strcmp(opts.imagetype,'Hyper'))
   I=Img;
else    
   I = im2uint8(Img);
   if (size(Img,3)==1)
        I = repmat(Img,[1 1 3]);
   end
end  
    %% get affinity matrix
    [Ws,im_sizes] = getW(I,opts);
    
    %% get contours
    [E,E_oriented] = getE(Ws,im_sizes,I,opts);
end