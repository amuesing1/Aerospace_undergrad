%findandtrack
%basic functionality to do GPS Bistatic Reflection Processing

% close all; fclose all; clear;  clc;
% disp('GPS Bistatic Processing')
function [e_i,e_q,p_i,p_q,l_i,l_q,carrierfq,codefq] = findandtrack(prn,msec_to_process,fs,intfreq)
%%input parameters to set (specific to data file)
% prn=18;  %GPS satellite number (03 05 06 09 12 14 18 21 22 30 31 )
% msec_to_process = 1000;  %msec of data to process
% fs=4.096e6;  %sampling frequency
% intfreq=0e6;  %intermediate frequency
corrspacing=-28.1:0.05:1.1;  %correlator measurement spacing
%the following are now hard coded along with the complex data format
%filename='GPSantennaUp.sim';  %direct file
%filename2='GPSantennaDown.sim';  %reflected file

%%first open the direct data file and get first block of data to work with
fid=fopen('GPSantennaUp.sim','rb');  %open binary file containing direct data
rawdat=(fread(fid,2000000,'schar'))';  %read in 2M samples
rawdat=rawdat(1:2:end)+ i .* rawdat(2:2:end);  %convert to complex IQ pairs
fclose(fid);  %close the file

%%first do satellite acqusition and get approx code phase/freq estimate
disp('Initiating GPS satellite acquisition...')
[fq_est,cp_est,c_meas,testmat]=acq4(prn,intfreq,9000,rawdat,fs,4,0);
disp(['  Acquisition Metric is: ',num2str(c_meas(1)),' (should be >2.0)']); 
%refine the acqusition estimate to get better code phase/frequency
[fq_est,cp_est,c_meas,testmat]=acq4(prn,fq_est,400,rawdat,fs,10,0);
disp(['  Refined Acq Metric is: ',num2str(c_meas(1)),' (should be >2.0)']); 

%%now do the main bistatic tracking/processing
disp('Initiating GPS satellite signal tracking...')
tstart=tic;  %start the timer
[e_i,e_q,p_i,p_q,l_i,l_q,carrierfq,codefq] = ...
    gpstrackcorr(prn, cp_est, fq_est, fs, corrspacing, msec_to_process);
toc(tstart);

%%finished!
% disp('Finished!  Run scripts: corrplot.m or plotresults.m for results visualization')
end
