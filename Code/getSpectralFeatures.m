%% function [f_maps] = getSpectralFeatures(Hyper_Img,scale,which_feature,opts)
% 
% INPUTS
%  Hyper_img        - NxMxZ query image;Hyperspectral image
%  scale         - how many times should the image be downsampled?
%  which_feature - which feature types to compute? can contain multiple entries
%  opts          - parameter settings (see setEnvironment)
%
% OUTPUTS
%  f_maps        - NxMxF array of F feature maps input Hyper_img
%
function [f_maps] = getSpectralFeatures(Hyper_Img,scale,Spectral_feature,opts)
im = [];

[n,mm,B]=size(Hyper_Img); 

% -----------Spectral Angle Distance & Spectral Distance-------
if (strcmp(Spectral_feature,'Spect1'))
    im=zeros(n,mm,8);%11 144=3*3*16 block size
     for Row = 1:n
       for Col=1: mm         
          if (Row <=1) || (Row >= size(Hyper_Img,1)-1) || (Col <= 1) || (Col >= size(Hyper_Img,2)-1)
             continue;
          end
         SubCube=Hyper_Img(Row-1:Row+1,Col-1:Col+1,:);
          k=1;
          CentrPoint=squeeze(SubCube(3,3,:));
          for i=1:3
            for j=1:3
                if (i==3) &&(i==j)
                    continue;
                end
                tempVec=squeeze(SubCube(i,j,:));
                SAM_Feature(k)=Spectral_Angle(CentrPoint,tempVec);
                k=k+1;
            end
          end  
         im(Row,Col,:)= SAM_Feature(:);
       end
     end
end   
%----------------------Spectral Gradient----------------------
if (strcmp(Spectral_feature,'SpectGrad'))
    im=zeros(n,mm,8);%11 144=3*3*16 block size
     for Row = 1:n
       for Col=1: mm         
          if (Row <=1) || (Row >= size(Hyper_Img,1)-1) || (Col <= 1) || (Col >= size(Hyper_Img,2)-1)
             continue;
          end
         SubCube=Hyper_Img(Row-1:Row+1,Col-1:Col+1,:);
          k=1;
          CentrPoint=squeeze(SubCube(3,3,:));
          for i=1:3
            for j=1:3
                if (i==3) &&(i==j)
                    continue;
                end
                tempVec=squeeze(SubCube(i,j,:));
                SAMGr_Feature(k)=Spectral_Grad_Angle(CentrPoint,tempVec);
                k=k+1;
            end
          end  
         im(Row,Col,:)= SAMGr_Feature(:);
       end
     end
end    
% -----------Spectral Correlation (Bad Result)----------------
if (strcmp(Spectral_feature,'Spect'))
    im=zeros(n,mm,24);
     for Row = 1:n
       for Col=1: mm         
          if (Row <=2) || (Row >= size(Hyper_Img,1)-2) || (Col <= 2) || (Col >= size(Hyper_Img,2)-2)
             continue;
          end
         SubCube=Hyper_Img(Row-2:Row+2,Col-2:Col+2,:);
          k=1;
          CentrPoint=squeeze(SubCube(5,5,:));
          sum_point=sum(CentrPoint);
          sum_point2=sum(CentrPoint.^2);
          for i=1:5
            for j=1:5
                if (i==5) &&(i==j)
                    continue;
                end
                tempVec=squeeze(SubCube(i,j,:));
                sum_Nbr=sum(tempVec);
                sum_Nbr2=sum(tempVec.^2);

                w=sum(CentrPoint.*tempVec);
                Nom=(5*w)-(sum_point*sum_Nbr);
                Dom=sqrt(((5*sum_point2)-(sum_point^2))*((5*sum_Nbr2)-(sum_Nbr^2)));

                CSM_Feature(k)=(1-Nom/Dom);
%                 SAM_Feature(k)=Spectral_Angle(CentrPoint,tempVec);
                k=k+1;
            end
          end  
         im(Row,Col,:)= CSM_Feature(:);
       end
     end
end 
%----------------3D Features :Magitude of gradient-------------
if (strcmp(Spectral_feature,'3DHisMag'))
     im=zeros(n,mm,35);% 5 block size * 7 edges (6+1)
     for Row = 1:n
       for Col=1: mm         
          if (Row <= 1) || (Row >= size(Hyper_Img,1)-1) || (Col <= 1) || (Col >= size(Hyper_Img,2)-1)
             continue;
          end
          s=1;
          for k=1:8:B
             SubCube=Hyper_Img(Row-1:Row+1,Col-1:Col+1,k:k+7);
             [Gr,Gc,Gw]=gradient(SubCube);
             Mag=sqrt(Gr.^2+Gc.^2+Gw.^2);
             [N,edges] = histcounts(Mag(:),6);
    %          im(Row,Col,:)=Mag(:);
             Hf(:,s)=edges(:);
             s=s+1;
          end   
          im(Row,Col,:)=Hf(:);
       end
     end
end  
%----------------Histogram of Magitude----------------------
if (strcmp(Spectral_feature,'HisMag'))
    im=zeros(n,mm,10);%11 144=3*3*16 block size
     for Row = 1:n
       for Col=1: mm         
          if (Row <= 1) || (Row >= size(Hyper_Img,1)-1) || (Col <= 1) || (Col >= size(Hyper_Img,2)-1)
             continue;
          end
         SubCube=Hyper_Img(Row-1:Row+1,Col-1:Col+1,:);
         [Gr,Gc,Gw]=gradient(SubCube);
         Mag=sqrt(Gr.^2+Gc.^2+Gw.^2);
         [N,edges] = histcounts(Mag(:),9);
%          im(Row,Col,:)=Mag(:);
         im(Row,Col,:)=edges(:);
       end
     end
end    
  
  if (strcmp(Spectral_feature,'MSkKu'))
      im=zeros(n,mm,3);
      for Row = 1:n
       for Col=1: mm         
          if (Row <= 1) || (Row >= size(Hyper_Img,1)-1) || (Col <= 1) || (Col >= size(Hyper_Img,2)-1)
             continue;
          end
         SubCube=Hyper_Img(Row-1:Row+1,Col-1:Col+1,:);
         im(Row,Col,1)=mat2gray(squeeze(mean(SubCube(:))));
         im(Row,Col,2)=mat2gray(squeeze(skewness(SubCube(:))));
         im(Row,Col,3)=mat2gray(squeeze(kurtosis(SubCube(:))));
     
%          im=cat(3,im,Hf(Row,Col,1:3));
       end
      end  
%       im=Hf;
  end    

  % Entropy & Gradient
 if (strcmp(Spectral_feature,'GrStEnt'))
    Hf(:,:,1)=mat2gray(squeeze(mean(Hyper_Img,3)));
    Hf(:,:,2)=mat2gray(squeeze(skewness(Hyper_Img,0,3)));
    Hf(:,:,3)=mat2gray(squeeze(kurtosis(Hyper_Img,0,3)));
    
    [~,~,Gz] = imgradientxyz(Hyper_Img);
    MagZ=sum((Gz.^2),3);
    Hf(:,:,4)=mat2gray(MagZ.^0.5);
    Hf(:,:,5)=mat2gray(squeeze(std(Hyper_Img,0,3)));
    for i=1:n
        for j=1:mm
            Hf(i,j,6)=Entropy(Hyper_Img(i,j,:));
        end
    end    
    im=cat(3,im,Hf(:,:,1:3)); 
 end

 if (strcmp(Spectral_feature,'var'))
        
      im=zeros(n,mm,8);  
     %% variance features
      f = pcaIm(Hyper_Img);
      for Row = 1:n
       for Col=1: mm         
          if (Row <=1) || (Row >= size(Hyper_Img,1)-1) || (Col <= 1) || (Col >= size(Hyper_Img,2)-1)
             continue;
          end
          s=1;
          for k=1:5:B %20
            SubCube=f(Row-1:Row+1,Col-1:Col+1,k:k+4); %k:k+19
%             St(s)=std(std(std(SubCube,0,3)));
            St(s)=var(SubCube(:));
            s=s+1;
          end  
          im(Row,Col,:)=St(:); 
       end  
      end  
%         Nhood_rad = 2^(scale-1);
%         se = strel('disk',Nhood_rad,0);
% %         vf = mat2gray(sqrt(stdfilt(f,getnhood(se))));
%         vf = mat2gray(sqrt(stdfilt(f,ones(3,3,5))));
%         vf=std(vf,0,3);
%         im = cat(3,im,vf);
 end
if (strcmp(Spectral_feature,'PCA'))
%     im=zeros(n,mm,4);
     [X, Y, W]=size(Hyper_Img);
    data1=reshape(Hyper_Img,X*Y,W);
    Coff=pca(data1');
    firstcomp=Coff(:,1:5);

    pcaimg1=reshape(firstcomp(:,1),X,Y);
    pcaimg2=reshape(firstcomp(:,2),X,Y);
    pcaimg3=reshape(firstcomp(:,3),X,Y);
    pcaimg4=reshape(firstcomp(:,4),X,Y);
    pcaimg5=reshape(firstcomp(:,5),X,Y);
    pcaimg=cat(3,pcaimg1,pcaimg2,pcaimg3);
   
    indata = double(pcaimg);
    percent = 0.999;
    ndata = numel(indata);
    [val,~] = sort(indata(:));
    upos = round(ndata*percent);
    maxd = val(upos);
    mind = min(indata(:));
    outdata1 = (indata-double(mind)*ones(size(indata))) / (maxd-mind);
    outdata1(find(outdata1(:)>1)) = 1;
    im=Hyper_Img(:,:,1:4);
end  
%% downsample
    im = imresize(im,2^(-(scale-1)));
    
    %%
    if (opts.features.decorrelate)
        im = mat2gray(pcaIm(im));
    end
    
    %%
    f_maps = im;
end