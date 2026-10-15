clc;
I=imread('DSC6020.JPG');
I1=imresize(I,[512 512]);
imshow(I1);
I1=rgb2gray(I1);
W=double(I1);
% n=size(W);
m=length(W);
noPixel=m^2;
W1=zeros(size(W));
sigma=2;
%step1: Form the affinity matrix
for i=1:noPixel
    for j=1:noPixel
        N = sqrt((W(i,1) - W(j,1))^2 + (W(i,2) - W(j,2))^2); 
        W1(i,j) = exp(-N/(2*sigma^2));
%         N=norm(W(i)-W(j));
%        W1(i,j)=exp(-(power(N,2))/(2*x.^2));
    end
end



% D = zeros(size(W1));
% for i=1:size(W1,1)
%     D(i,i) = sum(W1(i,:));
% end
D=sum(W1,2);
Di    = sparse(1:size(W1, 1), 1:size(W1, 2), D);

% for i=1:n
%     for j=2:n
%        D(i,i)=D(i,i)+W1(i,j);
%     end
% end
%disp('Diagonal matrix');
%disp(D);

% for i=1:size(W1,1)
%     for j=1:size(W1,2)
%         NL1(i,j) = W1(i,j) / (sqrt(D(i,i)) * sqrt(D(j,j)));  
%     end
% end
% 
% for i=1:n
%     for j=1:n
%         if(i==j)
%             A(i,j)=D(i,j).^(-0.5);
%         else
%             A(i,j)=0;
%         end
%     end
% end
 D(D == 0) = eps;
        % calculate D^(-1/2)
 Di = spdiags(1./(D.^0.5), 0, size(Di, 1), size(Di, 2));
%disp('A:which is D power -0.5');
%disp(A);
%  L=A*W1*A;
  L=Di*W1*Di;

%disp('step2:L=A*W1*A');
%disp(L);
[VE,VA]=eig( L);
% [eigVectors,eigValues] = eig(NL1);

%disp('Eigen values');
%disp(VA);
%disp('step:3 Eigen vectors'); Compute the Eigen vectors and form the matrix S
%disp(VE);

% k = 3;
% nEigVec = eigVectors(:,(size(eigVectors,1)-(k-1)): size(eigVectors,1));

% construct the normalized matrix U from the obtained eigen vectors
% for i=1:size(nEigVec,1)
%     n = sqrt(sum(nEigVec(i,:).^2));    
%     U(i,:) = nEigVec(i,:) ./ n; 
% end

% perform kmeans clustering on the matrix U
% IDX = reshape(kmeans(U(:),3),size(I1)); 
U = bsxfun(@rdivide, VE, sqrt(sum(VE.^2, 2)));
% for i=1:n
%     for j=1:n
%         S(i,j)=VE(i,j).^2;
%         S1(i,j)=S(i,j).^(.5);
%     end
% end

 Y=VE/S1;
%disp('Step4: Normalising each row,getting Y');
%disp(Y);


%Step5: Treating each row yi of Y as a point, cluster them into K clusters by using k-means algorithm

 J=reshape(kmeans(VE(:),3),size(I1));
figure,imshow(uint8(J),[])