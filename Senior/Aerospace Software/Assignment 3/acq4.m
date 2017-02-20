function [fq_est,cp_est,c_meas,testmat,testmatfull]=acq4(sv,freq,maxdop,rawdat,fs,ncp,zeropad);
%function [fq_est,cp_est,c_meas,testmat,testmatfull]=acq4(sv,freq,maxdop,rawdat,fs,ncp,zeropad);
%
% This function does the circular convolution approach to GNSS signal 
% acquisition (based on the paper from Delft U.).  It takes as input:
%
%		sv:		the particular GPS-SPS C/A code or if sv==0 then the GLONASS
%				m-sequence is used.
%
%		freq:	the expected carrier frequency (in Hz)
%	
%		maxdop:	the maximum deviation from the expected carrier frequency as
%				a result of doppler and LO frequency drift
%
%		rawdat:	the raw GNSS CMDA data, the program requires at least two full
%				code periods of data
%
%		fs:		the sampling frequency at which the data was collected
%
%		ncp:	number of code periods to perform acq on (min=1, max=10)
%				this allows better noise averaging - correlating over mult
%				code periods - max is 10 (or 5 for GLONASS) since you need to look
%				at two consective blocks and 20 would be a bit period
%
%		zeropad: a binary field to determine whether to pad the input data vector
%					with zeros to the next highest power of two to speed FFT computations
%					if 1 then zero-padding is used, if 0 then zero-padding is not used
%					since this can be problematic for sequences less than 1ms, it is 
%					only applicable for sequences of 2ms or longer and with a sequence
%					of 2ms it may only provide performance of 1ms (worst case)
%
% Using these inputs it performs the acqusition algorithm on two consective
% blocks of data.  It is necessary to use two blocks in case of a data bit 
% transition between the first two codes in the data set.  Since there will
% not be a transition between two consective codes, this should guarantee acq
% will work.  The outputs are:
%
%		fq_est:	the best estimate of true carrier frequency within plus/minus
%				(250 Hz/ncp).  If ncp=10, then fq_est is accurate with plus/minus
%				25 Hz (but slower process since smaller frequency steps are
%				used).
%
%		cp_est:	the best estimate of code phase, specifically this give the 
%				sample number (index) in the rawdat array where the code period
%				actually starts
%
%		c_meas:	a confidence measure, this is the ratio of the average of the 
%				maximum value along with its two direct neighbors values to the
%				average of the remaining points calculated from being > 1/2 chip
%				away
%
% Speed-up:  It will greatly speed things up if you know where the bit transition
% occurs so you only need to search one block.  Also a good frequency estimate 
% will cut down on the frequency search space.

%%
% nominal period of code is 1.0 msec; nss is the number of samples in one code
% period
%%
nss=round((1.0e-3)*fs);
ns=ncp*nss;  % ns is the number of samples to correlate over

inda=0;
indb=0;
%should zero pad, find next highest power of two - but only if using 2 or more ms of data 
%(why? 1ms blocks can fail depending on location of start of code period; even 2ms blocks can suffer a performance
% degradation so they give performance of slightly better than 1ms of data - worst case)
if ((zeropad==1) & (ncp > 1))     
   while (indb == 0);  
      if ((2 ^ inda) >= ns)  %found next highest power of 2
         indb = (2 ^ inda); %record that value and exit loop
      end
      inda = inda + 1;
   end
end

if (indb > ns)  %check if zeropadding is needed
   rawdat1=[rawdat(1,1:ns) zeros(1,indb-ns)];
   rawdat2=[rawdat(1,ns+1:2*ns) zeros(1,indb-ns)];
   ns=indb; %set size of vector to next highest power of 2
else
   rawdat1=rawdat(1,1:ns);
   rawdat2=rawdat(1,ns+1:2*ns);
end

%%
% the frequency step is determined by the number of code periods you go over
% if a single code period is done, it take 1ms of time so when you downconvert
% you must be sure you accumulate over at most 1/4 sinusoid (to avoid transitions
% associated with the carrier). If you go over 10 periods (10 ms), must resolve
% it down to 50 Hz steps.
%%
freqstp=500/ncp;
freqbins=size((freq-maxdop:freqstp:freq+maxdop),2);

if (sv==0)  % use GLONASS
	ca=glocode2(fs,ns);
else  % use appropriate GPS-SPS C/A code
	ca=cacode2(sv,fs,ns);
end

argvec =(i*2*pi).*(0:1/fs:(ns-1)/fs);

testmat=zeros(1,nss);
fq_est=0;
tempa=zeros(1,ns);
tempb=zeros(1,ns);
tempc=zeros(1,ns);
tempd=zeros(1,ns);
tempe=zeros(1,ns);
tempf=zeros(1,ns);
indb=1;
tempa=fft(ca+i*ca);

tic;
tt=0;
%freq_vec=freq-maxdop:freqstp:freq+maxdop;  %use this if you want to know all the freq bins tested
for inda=freq-maxdop:freqstp:freq+maxdop  
   text2=['SV: ',num2str(sv),'  Freq Step: ',num2str(indb),'  of ',num2str(freqbins),' (time:',num2str((toc-tt),4),')'];
   tt=toc;
%    if (rem(indb,50)==0)
%       disp(text2)
%    end
	tempb = exp(inda .* argvec);  % take complex exp to get I & Q components
%%
% mix with the LO code to bring to baseband, upper sideband is filtered out
% though accumulation in circular convolution technique
%%
	tempc = (fft(rawdat1 .* tempb));
	tempd = (fft(rawdat2 .* tempb));

%but since the algorithm is zero padding the raw data, you should conjugate the opposite
%just be sure to adjust the code phase as needed as the result from the below will be    
%equal to (nss-cp_est) of the other conjugate 
   tempe = abs(ifft(tempa .* conj(tempc)));  
   tempf = abs(ifft(tempa .* conj(tempd)));
      
	if (max(tempe(1,1:nss))<max(tempf(1,1:nss)))
		tempe(1,:)=tempf(1,:);
	end
%%
% note we do not indicate which block the maximum has come from, this info would
% speed things up (only need to process one or the other) if you were going to
% be dealing with the same data set multiple times.
%%
	if (max(testmat(1,:))<max(tempe(1,1:nss)))
		testmat(1,:)=tempe(1,1:nss);
		fq_est=inda;
   end
   testmatfull(indb,:)=tempe(1,1:nss); %include this line if you want results from all freq vectors tested
   indb=indb+1;
end

%%now determine the metric that indicates if it is real signal or not...
%find out how many samples is 1 chip (round up)
if (sv==0)  %if GLONASS
   nschip=round(fs/511e3);
else %if GPS
	nschip=round(fs/1.023e6);
end

[tempb,tempc]=max(testmat);  % find code phase (value and index of maximum)

%here is the code phase estimate
cp_est= nss-tempc+1; %definitely within +/- 1 but could be off by a sample as a result of indexing

%%% Now provide metric if the signal is detected or not.  Many different ways to do this.
%here is the first approach
% first get the max value
tempa=testmat(1,tempc);
% find the 2nd highest max more than 1.0 chips away, dependent on where max was found
if ((tempc > (nschip+1)) & (tempc < (nss-nschip)))
	tempb=max([testmat(1,1:tempc-(nschip+1)) testmat(1,tempc+(nschip+1):nss)]);
elseif (tempc <= (nschip+1))
	tempb=max(testmat(1,tempc+(nschip+1):nss-((nschip+1)-tempc)));
else
	tempb=max(testmat(1,1+tempc+nschip+1-nss:tempc-(nschip+1)));
end
c_meas(1)=tempa/tempb;

%here is the second approach
% first get the max value
tempa=testmat(1,tempc);
% find the avg of all points more than 1.0 chips away from maximum, dependent on where max was found
if ((tempc > (nschip+1)) & (tempc < (nss-nschip)))
	tempb=mean([testmat(1,1:tempc-(nschip+1)) testmat(1,tempc+(nschip+1):nss)]);
elseif (tempc <= (nschip+1))
	tempb=mean(testmat(1,tempc+(nschip+1):nss-((nschip+1)-tempc)));
else
	tempb=mean(testmat(1,1+tempc+nschip+1-nss:tempc-(nschip+1)));
end
c_meas(2)=tempa/tempb;

%here is the third approach
% first get the max value
tempa=testmat(1,tempc);
% find the avg of all points more than 1.0 chips away from maximum, but just use the points on
% either side of the maximum to simply logic and avg should be pretty close
if (tempc > round(nss/2))
	tempb=mean(testmat(1,((round(nss/2)) + nschip):(nss-nschip)));
else   
	tempb=mean(testmat(1,nschip:((round(nss/2)) - nschip)));
end
c_meas(3)=tempa/tempb;

%reverse the order of testmat to correspond to the true cp_est
testmat=testmat(nss:-1:1);
