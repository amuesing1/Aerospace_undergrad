function [v2] = Gibbs_Method(r1,r2,r3)
%GIBBS_METHOD 
%INPUTS: r1, r2, r3
%OUTPUT: Use r2 and v2 to calculate orbital elements
mu = 398600;
%1) Calculate magnitude of R1, R2, R3
r1_norm = norm(r1);
r2_norm = norm(r2);
r3_norm = norm(r3);

%2) Calculate C12, C23, and C31
C12 = cross(r1,r2);
C23 = cross(r2,r3);
C31 = cross(r3,r1);

%3) Check that dot(uhat_r1,C23) = 0
uhat_r1 = r1./r1_norm;

% if dot(uhat_r1, C23) ~= 0
%     fprintf('Error')
%     return
% end

%Calculate N, D, and S

N = r1_norm.*cross(r2,r3) + r2_norm.*cross(r3,r1) + r3_norm.*cross(r1,r2);

D = cross(r1,r2) + cross(r2,r3) + cross(r3,r1);

S = r1.*(r2_norm-r3_norm) + r2.*(r3_norm-r1_norm) + r3.*(r1_norm-r2_norm);

%Calculate v2

v2 = sqrt(mu/(norm(N)*norm(D)))*((cross(D,r2)/norm(r2))+S)

[h_mag,i,OMEGA,e_mag,omega,theta] = Elements(r2,v2)











end

