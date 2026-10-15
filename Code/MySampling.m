function [F]=MySampling(f_maps,opts)
% Take the detected keypoints as a selected points instead of random
% sampling
%Load Keypoints file
% Put all the keypoints in single band and remove the redundant points
[filename, pathname] = uigetfile({'*.mat','Map Files (*.hdr,*.dat,*.raw,*.mat)'},'Load KeyPoints File');
if (filename==0) % cancel pressed
     msgbox('Error',Error',Eror');
    return;
end
cd(pathname);
if strcmp(filename(end-3:end), '.mat')
  PointsMap=importdata(filename);
else
    error('Invalid File Format');
end 
%% sampling params
    sig = opts.sig;
    max_offset = 4*sig+1;
    
    %% sample
im_size = size(f_maps(:,:,1));
AllPointMap = cell(3,1);
TempPointMap = cell(3,1);
for octave=1:3  
  for i=1:size(PointsMap,2)
     TempPointMap{octave,1}(:,:,i)= sum(PointsMap{octave,i},3)>=1;
  end    
end  

for octave=1:3
    AllPointMap{octave,1}=sum(TempPointMap{octave,1},3)>=1;
end  
MapPoints=AllPointMap{1,1};
SSCindx = find(MapPoints); % Scale-Space-Corner Index
No_keys=length(SSCindx);
for octave=2:3
    TempMap=AllPointMap{octave,1};
    SSCindx = find(TempMap); % Scale-Space-Corner Index
    No_keys=length(SSCindx);
    if isempty(SSCindx)
       continue;
    end  
    for ssc = 1:No_keys
        [Row,Col] = ind2sub([size(TempMap,1),size(TempMap,2)],SSCindx(ssc));
        Row = Row*2^(octave-1); Col = Col*2^(octave-1);
        MapPoints(Row,Col)=1;
    end
       
end    
SSCindx = find(MapPoints);
Nsamples = length(SSCindx);
[yy,xx] = ind2sub(im_size,SSCindx);
p0 = cat(2,yy(:),xx(:));
 % choose random offset
r = randn(Nsamples,2)*sqrt(sig);
r_n = r./repmat(sqrt(sum(r.^2,2)),[1 2]);
r = r+r_n;

% cap offset
s = sign(r);
r = min(abs(r),max_offset);
r = s.*r;

% make pair of points
p1 = p0;
p2 = p0;
p1(:,1:2) = p1(:,1:2)+r;
p2(:,1:2) = p0(:,1:2)-r;
%p0 = round(p0);
p1 = round(p1);
p2 = round(p2);
    
% remove out of bounds samples
m = (p1(:,1)<1) | (p1(:,2)<1) | (p2(:,1)<1) | (p2(:,2)<1) | ...
    (p1(:,1)>im_size(1)) | (p1(:,2)>im_size(2)) | (p2(:,1)>im_size(1)) | (p2(:,2)>im_size(2));
%p0 = p0(~m,:);
p1 = p1(~m,:);
p2 = p2(~m,:);

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