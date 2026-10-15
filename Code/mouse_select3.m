%function Boundaries = mouse_select2(A,R,Gray_Entropy_n,RGB,NDVI,hyper_DSM,hyper_DSM_Entropy,hyper_nDSM,hyper_nDSM_Entropy,bbox)
%function Boundaries = mouse_select2(A,R,Normalized)
function Boundaries = mouse_select3(A)

% Example usage:
%[A, R, bbox] = geotiffread('crop12.tif'); %original image
%Boundaries = mouse_select2(A,R,Gray_Entropy_n,RGB,NDVI,hyper_DSM,hyper_DSM_Entropy,hyper_nDSM,hyper_DSM_Entropy,bbox);
filename = 'sub_Minions_largeSize';
original_filename = [filename '.mat'];
A = importdata(original_filename);
%A=imread('indian_pines_corrected');

RED = double(A(:,:,16));
GREEN = double(A(:,:,8));
BLUE = double(A(:,:,1));
RGB (:,:,1) = RED;
RGB (:,:,2) = GREEN;
RGB (:,:,3) = BLUE;
%prompt = 'Enter the type of selection criteria 1= street 2=shadow and 3= tree';
%prompt = 'Enter the type of selection criteria 1= street 2=Tree Type1 3= Tree Type2 4= Grass';
prompt = 'Enter the type of selection criteria 1= street 2=Tree 3=Grass 4=Water';
x = input(prompt);
prompt = 'Enter 1=training';
b = input(prompt);
%figure; mapshow (mat2gray(RGB),R); hold on;
figure; imshow (mat2gray(RGB)); hold on;
impixelinfo;
%Boundary{100}=[];
%figure; imshow (mat2gray(RGB));
count = 0;
% tr_f=1;
% ts_f=1;
% tr_label=1;
% ts_label=1;
%fp1 = fopen('Training_geolocation.txt', 'wt');
fp1 = fopen('Training_pixellocation.txt', 'wt');
fp2 = fopen('Testing_pixellocation.txt', 'wt');
%fp3 = fopen('Training_label.txt', 'wt');
%fp4 = fopen('Testing_label.txt', 'wt');
%fp4 = fopen('Training feature.txt', 'wt');
%fp5 = fopen('Testing feature.txt', 'wt');
%fp6 = fopen('Training label.txt', 'wt');
%fp7 = fopen('Testing label.txt', 'wt');
while(1)
    h = imfreehand;
    position = round(h.getPosition());
    [~,idx]= unique(position,'rows','first');
    position= position(sort(idx),:);
    %position = wait(h); %impixelinfo;
    [rows,cols]=size(position);
    if(b==1)
        fprintf(fp1,'%d\n',rows);
    else
        fprintf(fp2,'%d\n',rows);
    end
    %fprintf(fp1,'Number of points: %d\n',rows);
    %fprintf(fp2,'Number of points: %d\n',rows);
    for i = 1:rows
        %fprintf(fp1,'%f\t%f\t%d\n',position(i,1),position(i,2),x);
        %y1 = floor((position(i,1)*R(1,2) - R(3,1)*R(1,2) + R(3,2)*R(1,1) - position(i,2)*R(1,1))/(R(2,1)*R(1,2)-R(2,2)*R(1,1)));
        %x1 = floor((position(i,2) - R(3,2) - y1*R(2,2))/R(1,2));
        if(b==1)
            fprintf(fp1,'%d\t%d\t%d\n',position(i,2),position(i,1),x);
            %fprintf(fp3,'%d\n',x);
            %end
        else
            fprintf(fp2,'%d\t%d\t%d\n',position(i,2),position(i,1),x);
            %fprintf(fp4,'%d\n',x);
        end
    end
    %         H_entropy=Normalized(x1,y1,1);
    %         H_R=Normalized(x1,y1,2);
    %         H_G=Normalized(x1,y1,3);
    %         H_B=Normalized(x1,y1,4);
    %         L_DSM=Normalized(x1,y1,5);
    %         L_DSMEntropy=Normalized(x1,y1,6);
    %         L_nDSM=Normalized(x1,y1,7);
    %         L_nDSMEntropy=Normalized(x1,y1,8);
    %         H_NDVI=Normalized(x1,y1,9);
    
    %         H_entropy=Gray_Entropy_n(x1,y1);
    %         H_R=RGB(x1,y1,1);
    %         H_G=RGB(x1,y1,2);
    %         H_B=RGB(x1,y1,3);
    %         H_NDVI=NDVI(x1,y1);
    %         L_DSM=hyper_DSM(x1,y1);
    %         L_DSMEntropy=hyper_DSM_Entropy(x1,y1);
    %         L_nDSM=hyper_nDSM(x1,y1);
    %         L_nDSMEntropy=hyper_nDSM_Entropy(x1,y1);
    %         fprintf(fp3,'%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%d\n',H_entropy,H_R,H_G,H_B,L_DSM,L_DSMEntropy,L_nDSM,L_nDSMEntropy,H_NDVI,x);
    %b = mod(i,2);
    %prompt = 'Enter 1=training';
    %b = input(prompt);
    %if (b==1)
    %fprintf(fp4,'%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n',H_entropy,H_R,H_G,H_B,L_DSM,L_DSMEntropy,L_nDSM,L_nDSMEntropy,H_NDVI);
    %fprintf(fp6,'%d\n',x);
    %             train_feat(tr_label,1)=H_entropy;
    %             train_feat(tr_label,2)=H_R;
    %             train_feat(tr_label,3)=H_G;
    %             train_feat(tr_label,4)=H_B;
    %             train_feat(tr_label,5)=H_NDVI;
    %             train_feat(tr_label,6)=L_DSM;
    %             train_feat(tr_label,7)=L_DSMEntropy;
    %             train_feat(tr_label,8)=L_nDSM;
    %             train_feat(tr_label,9)=L_nDSMEntropy;
    %else
    %fprintf(fp5,'%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t\n',H_entropy,H_R,H_G,H_B,L_DSM,L_DSMEntropy,L_nDSM,L_nDSMEntropy,H_NDVI);
    %fprintf(fp7,'%d\n',x);
    %end
    %add_feature(x1,y1,H_entropy,H_R,H_G,H_B,H_NDVI,L_DSM,L_DSMEntropy,L_nDSM,L_nDSMEntropy,x,i);
    %end
    
    %plot(position1(:,1),position1(:,2),'-r'); hold off;
    count = count + 1;
    Boundary{count} = position;
    disp('Press any key from keyboard to finish, If you want to continue click mouse');
    %here = 1;
    w = waitforbuttonpress;
    if w == 0
        %prompt='key is not pressed goto next selection. Enter the type of selection criteria 1= street 2=Tree Type1 3= Tree Type2 4= Grass';
        prompt = 'Enter the type of selection criteria 1= street 2=Tree 3=Grass';
        x = input(prompt);
        prompt = 'Enter 1=training';
        b = input(prompt);
    else
        disp('Key press');
        break;
    end
end
fclose(fp1);
fclose(fp2);
%fclose(fp3);
%fclose(fp4);
% fclose(fp5);
% fclose(fp6);
% fclose(fp7);
Boundaries = Boundary;
end

% function add_feature(x1,y1,H_entropy,H_R,H_G,H_B,H_NDVI,L_DSM,L_DSMEntropy,L_nDSM,L_nDSMEntropy,x,i)
% fp3 = fopen('ALL feature_label', 'wt');
% fp4 = fopen('Training feature', 'wt');
% fp5 = fopen('Testing feature', 'wt');
% fp6 = fopen('Training label', 'wt');
% fp7 = fopen('Testing label', 'wt');
% % H_entropy=Gray_Entropy_n(x1,y1);
% % H_R=RGB(x1,y1,1);
% % H_G=RGB(x1,y1,2);
% % H_B=RGB(x1,y1,3);
% % H_NDVI=NDVI(x1,y1);
% % L_DSM=hyper_DSM(x1,y1);
% % L_DSMEntropy=hyper_DSM_Entropy(x1,y1);
% % L_nDSM=hyper_nDSM(x1,y1);
% % L_nDSMEntropy=hyper_nDSM_Entropy(x1,y1);
% fprintf(fp3,'%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%d\n',H_entropy,H_R,H_G,H_B,H_NDVI,L_DSM,L_DSMEntropy,L_nDSM,L_nDSMEntropy,x);
% b = mod(i,2);
% if b==0
%     fprintf(fp4,'%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n',H_entropy,H_R,H_G,H_B,H_NDVI,L_DSM,L_DSMEntropy,L_nDSM,L_nDSMEntropy);
%     fprintf(fp6,'%d\n',x);
% else
%     fprintf(fp5,'%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t\n',H_entropy,H_R,H_G,H_B,H_NDVI,L_DSM,L_DSMEntropy,L_nDSM,L_nDSMEntropy);
%     fprintf(fp7,'%d\n',x);
% end
% fclose(fp3);
% fclose(fp4);
% fclose(fp5);
% fclose(fp6);
% fclose(fp7);
% end
%position2=unique(position1,'rows');
%position1=round(position1);
%position2=h.getPosition();impixelinfo;
%h1 = imfreehand;
%position2 = wait(h1); impixelinfo;