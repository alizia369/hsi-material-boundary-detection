function Sdatacube=Conv3D(GaussianF_Lambda,GaussianF_XY,data)
% Convolution Function for 3D
%Apply Gaussian filter on Y-dimension
[x,y,z]=size(data);
temp=double(data(:));% convert the daat to one dimension col by col
%Yfilter=filter(GaussianF,1,temp);
Yfilter=conv(temp,GaussianF_XY,'same');
data=reshape(Yfilter,[x,y,z]); %reconvert the vector to 3d array

%Apply Gaussian filter on X-dimension
XtoY=permute(data,[2,1,3]);% replace row with col.
temp=XtoY(:); % convert the datacube to one D vector row by row

% Xfilter=filter(GaussianF,1,temp);% Applay Gaussian filter
Xfilter=conv(temp,GaussianF_XY,'same');
data=reshape(Xfilter,[y,x,z]);% reshape the vector into 3d array
data=permute(data,[2,1,3]);% change row with col as the original

% Apply Gaussian filte on weavlength dimension
YtoW=permute(data,[3,2,1]);% replace col with depth.
temp=YtoW(:); % convert the datacube to  1D vector 

Wfilter=conv(temp,GaussianF_Lambda,'same');
data=reshape(Wfilter,[z,y,x]);% reshape the vector into 3d array
data=permute(data,[3,2,1]);% change pixel vector with col as the original
Sdatacube=data;
