% Demo of crisp boundaries
%
% -------------------------------------------------------------------------
% Crisp Boundaries Toolbox
% Phillip Isola, 2014 [phillpi@mit.edu]
% Please email me if you find bugs, or have suggestions or questions
% -------------------------------------------------------------------------
% test this algorithm on hyperspectral image
% First we load HSI
[filename, pathname] = uigetfile({'*.hdr;*.dat;*.raw;*.mat;*.bsq;*.L1R','Hyper Files (*.hdr,*.dat,*.raw,*.mat)'},'Load Hyperspectral File');
if (filename==0) % cancel pressed
     msgbox('Error',Error',Eror');
    return;
end
cd(pathname);
if strcmp(filename(end-3:end), '.mat')
    datacube=importdata(filename);
    if isstruct(datacube)
        datacube=datacube.ref;
        
        if size(datacube,3) == 31
            bandname = (420:10:720)';
        end 
    else 
        switch size(datacube,3)
            case 10
                bandname= [534,548,571,582,595,606,620,628,638,641];
             case 16
                bandname= [467,473,483,495,510,520,534,548,571,582,595,606,620,628,638,641];    
            case 12
                bandname= (530:10:640);
            case 20
                bandname= (690:10:880);
            case 31
                bandname = (410:10:710)';
            case 33
                bandname = (400:10:720)';
            case 41
                bandname = (600:10:1000)';
            case 40
                 bandname=(590:10:980);
            case 51
                bandname = (500:10:1000)';
            case 61 
                bandname = (400:10:1000)';
            case 65
                bandname = (450:10:1090)';
            case 148
                bandname = (linspace(415,950,148))';
            otherwise
                bandname = (1:1:size(datacube,3))';
        end
    end
                
   description = 'online database';
else    
    [ datacube, bandname, description] = Load_Spec(filename); 
end    
imagetype='Hyper';
numofBand = length(bandname);
midBand = round(numofBand/2);

figure; imshow(datacube(:,:,midBand));
 type = 'speedy'; % use this for fastest results
% type = 'accurate_low_res'; % use this for slightly slower but more accurate results
% type = 'accurate_high_res'; % use this for slow, but high resolution results

% I=imread('253027.jpg');
if (strcmp(imagetype,'Hyper'))
%    I=datacube;
   smooth1=Gaussian3(2.5);%2
   smooth2=Gaussian3(2);%1.8
   I=Conv3D(smooth2,smooth1,datacube);
else   
   I = squeeze(datacube(:,:,midBand+1));
end
I=imresize(I,[600 700]);
[E,E_oriented] = findBoundaries(I,type);

%   subplot(121); imshow(squeeze(datacube(:,:,midBand))); subplot(122); imshow(1-mat2gray(E));
  figure;imshow(1-mat2gray(E));  