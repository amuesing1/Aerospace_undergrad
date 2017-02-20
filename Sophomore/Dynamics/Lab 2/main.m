close all
clear all
clc
datafoam=xlsread('foamballdata.xlsx');
time_stop_r=xlsread('pingpongm3.xlsx');
time_stop_o=xlsread('stopwatch.xlsx');
datapingpong=xlsread('pingpongm12.xlsx');

%extracting data
for i=1:10
   %foam ball data
   fh0(i)=datafoam(7*i-6,3)-datafoam(7*i,3);
   fh1(i)=datafoam(7*i-4,3)-datafoam(7*i,3);
   fh2(i)=datafoam(7*i-2,3)-datafoam(7*i,3);
   fts(i)=datafoam(7*i,1)-datafoam(7*i-6,1);
   ft1(i)=datafoam(7*i-3,1)-datafoam(7*i-5,1);
   ft2(i)=datafoam(7*i-1,1)-datafoam(7*i-3,1);
   %ping pong ball data
   ph0(i)=datapingpong(6*i-5,3)-datapingpong(6*i,3);
   ph1(i)=datapingpong(6*i-3,3)-datapingpong(6*i,3);
   ph2(i)=datapingpong(6*i-1,3)-datapingpong(6*i,3);
   pt1(i)=datapingpong(6*i-2,1)-datapingpong(6*i-4,1);
   pt2(i)=datapingpong(6*i,1)-datapingpong(6*i-2,1);
   pts_avg(i)=mean(time_stop_o(i,:));
end

%allocating data into corresponding arrays
pong_heights(1,:)=ph0;
pong_heights(2,:)=ph1;
pong_heights(3,:)=ph2;
pong_times(1,:)=pt1;
pong_times(2,:)=pt2;

foam_heights(1,:)=fh0;
foam_heights(2,:)=fh1;
foam_heights(3,:)=fh2;
foam_times(1,:)=ft1;
foam_times(2,:)=ft2;

% coefficients of restitution
[epm1]=method1(pong_heights);
[epm2]=method2(pong_times);
[epm3]=method3(pts_avg,ph0);

[efm1]=method1(foam_heights);
[efm2]=method2(foam_times);
[efm3]=method3(fts,fh0);

% mean, median, and stadard deviation of every number and trial

[mean_ph0, median_ph0, sigma_x_ph0]=deviations(ph0);
[mean_ph1, median_ph1, sigma_x_ph1]=deviations(ph1);
[mean_ph2, median_ph2, sigma_x_ph2]=deviations(ph2);
[mean_pts, median_pts, sigma_x_pts]=deviations(pts_avg);
[mean_pt1, median_pt1, sigma_x_pt1]=deviations(pt1);
[mean_pt2, median_pt2, sigma_x_pt2]=deviations(pt2);
[mean_pm1, median_pm1, sigma_x_pm1]=deviations(epm1);
[mean_pm2, median_pm2, sigma_x_pm2]=deviations(epm2);
[mean_pm3, median_pm3, sigma_x_pm3]=deviations(epm3);

[mean_fh0, median_fh0, sigma_x_fh0]=deviations(fh0);
[mean_fh1, median_fh1, sigma_x_fh1]=deviations(fh1);
[mean_fh2, median_fh2, sigma_x_fh2]=deviations(fh2);
[mean_fts, median_fts, sigma_x_fts]=deviations(fts);
[mean_ft1, median_ft1, sigma_x_ft1]=deviations(ft1);
[mean_ft2, median_ft2, sigma_x_ft2]=deviations(ft2);
[mean_fm1, median_fm1, sigma_x_fm1]=deviations(efm1);
[mean_fm2, median_fm2, sigma_x_fm2]=deviations(efm2);
[mean_fm3, median_fm3, sigma_x_fm3]=deviations(efm3);

%human error
sigma_x_fh0=sigma_x_fh0+.005;
sigma_x_ph0=sigma_x_ph0+.005;

%average per trial
mean_pm1=mean(mean_pm1);
mean_fm1=mean(mean_fm1);

mean_pong_heights=[mean_ph0,mean_ph1,mean_ph2];
mean_pong_times=[mean_pt1,mean_pt2];

mean_foam_heights=[mean_fh0,mean_fh1,mean_fh2];
mean_foam_times=[mean_ft1,mean_ft2];

%errors
[er1p,er2p,er3p]=errors( mean_pong_heights,mean_pts,mean_pong_times,sigma_x_ph0,sigma_x_ph1,sigma_x_pt1,sigma_x_pt2,sigma_x_pts);
[er1f,er2f,er3f]=errors( mean_foam_heights,mean_fts,mean_foam_times,sigma_x_fh0,sigma_x_fh1,sigma_x_ft1,sigma_x_ft2,sigma_x_fts);

fprintf('e method 1 ping pong: %1f +- %1f\n',mean_pm1,er1p);
fprintf('e method 2 ping pong: %1f +- %1f\n',mean_pm2,er2p);
fprintf('e method 3 ping pong: %1f +- %1f\n',mean_pm3,er3p);
fprintf('e method 1 foam: %1f +- %1f\n',mean_fm1,er1f);
fprintf('e method 2 foam: %1f +- %1f\n',mean_fm2,er2f);
fprintf('e method 3 foam: %1f +- %1f\n',mean_fm3,er3f);
