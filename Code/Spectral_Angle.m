function SA  = Spectral_Angle(X,Y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Spectral gradient angle is invariant to illumination  
z=norm(X)*norm(Y);
w=sum(X.*Y);
SA=acos(w/z);

end

