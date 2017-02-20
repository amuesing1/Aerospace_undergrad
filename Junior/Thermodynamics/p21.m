clear all
close all
clc
C1=3.74177E8;
C2=1.43878E4;
lambda=linspace(.01,1000,1000000);
T=5780;
for i=1:length(lambda)
    Eb(i)=C1/((lambda(i)^5)*(exp(C2/(lambda(i)*T))-1));
end

figure()
loglog(lambda,Eb)
xlabel('\lambda')
ylabel('E_b_\lambda')
title('Spectral Blackbody Emissive Power vs Wavelength')
axis square