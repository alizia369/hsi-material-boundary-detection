function Gaussian_Filter=Gaussian3(sigma)
filterLength = 8*ceil(sigma);
n = (filterLength - 1)/2;
x = -n:n;

% Create 1-D Gaussian Kernel
c = 1/(sqrt(2*pi)*sigma);
Gaussian_Filter = c * exp(-(x.^2)/(2*sigma^2));
% Normalize to ensure kernel sums to one
Gaussian_Filter = Gaussian_Filter/sum(Gaussian_Filter);