close all
clear all
clc
% read and assign data
data=xlsread('hw5makeup.xlsx');
energy=data(:,1);
crossx=data(:,2);
stdx=data(:,3);

% assign weighted matrix
for i=1:length(stdx)
    w(i,1)=1/(stdx(i).^2);
end

% calcularte A and B values for best fit line
sum_wenergy2=sum(w.*energy.^2);
sum_wenergy=sum(w.*energy);
sum_wcrossx=sum(w.*crossx);
sum_wcrossxenergy=sum(w.*crossx.*energy);
sum_w=sum(w);
delta=sum_w*sum_wenergy2-sum_wenergy^2;
A=(sum_wenergy2*sum_wcrossx-sum_wenergy*sum_wcrossxenergy)/delta;
B=(sum_w*sum_wcrossxenergy-sum_wenergy*sum_wcrossx)/delta;
% determine uncertainties
uncer_A=sqrt(sum_wenergy2/delta);
uncer_B=sqrt(sum_w/delta);

for i=1:length(energy)
Amatrix(i,1)=1;
Amatrix(i,2)=energy(i);
end

W=eye(10);
for i=1:length(stdx)
W(i,i)=W(i,i)/(stdx(i).^2);
end

Q=(Amatrix'*W*Amatrix).^(-1);

uncer2=[1 0.4]*Q*[1 0.4]';
uncer_crossx=sqrt(uncer2);

x=linspace(0.05,0.4,100);

value=A+B*(0.4);
max=value+uncer_crossx;
min=value-uncer_crossx;

% graphing
hold on
plot(energy,crossx)
plot(x,A+B*x,'r')
plot(0.4,value)
errorbar(energy, crossx, stdx, '.')
errorbar(0.4, value, uncer_crossx, 'r.')
title('Inverse Energy vs. Cross Sectional Area')
xlabel('Inverse Energy')
ylabel('CrossX')
legend('Data','Best Fit Line')
hold off

% printing file
fileID = fopen('hw5makeup.txt','w');
fprintf(fileID,'A. B0=%1f & B1=%f\n', A, B);
fprintf(fileID,'B. uncertainty in B0=%1f\n', uncer_A);
fprintf(fileID,'   uncertainty in B1=%1f\n', uncer_B);
fprintf(fileID,'D. uncertainty in CrossX=%1f\n', uncer_crossx);
fprintf(fileID,'   Minimum value of CrossX at Inverse Energy=0.4 is %1f\n', min);
fprintf(fileID,'   Maximum value of CrossX at Inverse Energy=0.4 is %1f\n', max);
fclose(fileID);