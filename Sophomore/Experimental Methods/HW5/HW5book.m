function HW5book
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here
clc 
clear all
n=[1 2 3 4 5 6];
y=[5.0 14.4 23.1 32.3 41.0 50.4];
sum_n2=sum(n.^2);
sum_n=sum(n);
sum_y=sum(y);
sum_yn=sum(y.*n);
delta=length(y)*sum_n2-sum_n.^2;
A=(sum_n2*sum_y-sum_n*sum_yn)/delta;
B=(length(y)*sum_yn-sum_n*sum_y)/delta;
wave=2*B;

i=1;
sum_in=0;
while i<=length(y)
    in=(y(i)-A-B*n(i)).^2;
    sum_in=sum_in+in;
    i=i+1;
end
uncer_y=sqrt((1/(length(y)-2))*sum_in);
uncer_B=uncer_y*sqrt(length(y)/delta);

fileID = fopen('8.15.txt','w');
crap='wavelength = %1f\r\n';
fprintf(fileID,crap,wave);
crap='uncertainty of B = %1f';
fprintf(fileID,crap,uncer_B);
fclose(fileID);

t=[10 40 70 100 130 160];
y=[188 102 60 18 16 5];
z=log(y);
sigma_v=sqrt(y);
sigma_z=1./y.*sigma_v;
sigma_z2=1./sqrt(y);

w=y;
sum_wt2=sum(w.*t.^2);
sum_wt=sum(w.*t);
sum_wz=sum(w.*z);
sum_wzt=sum(w.*z.*t);
sum_w=sum(w);
delta=sum_w*sum_wt2-sum_wt^2;
A=(sum_wt2*sum_wz-sum_wt*sum_wzt)/delta;
B=(sum_w*sum_wzt-sum_wt*sum_wz)/delta;
tau=inv(-B);
uncer_B=sqrt(sum_w/delta);

plot(t,z,'*')
hold on
p=linspace(0,160);
plot(p,A+B*p)
errorbar(t, z, sigma_z, '.');
xlabel('time');
ylabel('log of decays');
title('Log of Decays Over Time')



fileID = fopen('8.26.txt','w');
i=1;
while i<=length(t)
if sigma_z(i)-sigma_z2(i)<=.001
    fprintf(fileID,'confirmed uncertanties match\r\n');
else
    fprintf(fileID,'do not match');
end
i=i+1;
end
fprintf(fileID,'tau = %1f\r\n', tau);
fprintf(fileID,'uncertainty = %1f\r\n\r\n', uncer_B);
fprintf(fileID,'%1s %10f %10f %01f %10f %10f %10f\r\n','t',t(1),t(2),t(3),t(4),t(5),t(6));
fprintf(fileID,'%1s %10f %10f %10f %10f %10f %10f\r\n','y',y(1),y(2),y(3),y(4),y(5),y(6));
fprintf(fileID,'%1s %10f %10f %10f %10f %10f %10f\r\n\r\n','z',z(1),z(2),z(3),z(4),z(5),z(6));
fprintf(fileID,'sum of w*t^2 = %1f\r\n',sum_wt2);
fprintf(fileID,'sum of w*z = %1f\r\n',sum_wz);
fprintf(fileID,'sum of w*t = %1f\r\n',sum_wt);
fprintf(fileID,'sum of w*tt*z = %1f\r\n',sum_wzt);
fprintf(fileID,'sum of w = %1f\r\n',sum_w);
fclose(fileID);
end

