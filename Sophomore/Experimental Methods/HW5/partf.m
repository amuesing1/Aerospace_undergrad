function [sigma_A,sigma_B,sigma_C] = partf(y,uncer_y_poly)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
Amat=[4 -2 1;1  -1 1;0 0 1;4 2 1];
%Make Weight Matrix
sigma_yVec_sq=ones(1,length(y)).*(1/uncer_y_poly^2);
Wmat=diag(sigma_yVec_sq');

%Calc Q matrix
Qmat=inv(Amat'*Wmat*Amat);

sigma_A=sqrt(Qmat(1,1));
sigma_B=sqrt(Qmat(2,2));
sigma_C=sqrt(Qmat(3,3));

fileID = fopen('partf.txt','w');
crap='uncertainty of A = %1f\r\n';
fprintf(fileID,crap,sigma_A);
crap='uncertainty of B = %1f\r\n';
fprintf(fileID,crap,sigma_B);
crap='uncertainty of C = %1f';
fprintf(fileID,crap,sigma_C);
fclose(fileID);
end

