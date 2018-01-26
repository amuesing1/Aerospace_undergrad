function [e_i,e_q,p_i,p_q,l_i,l_q,carrierfq,codefq]=gpstrackcorr(prn, mycodephase, mycarrfreq, fs, corrspacing, codeperiods)
%function [e_i,e_q,p_i,p_q,l_i,l_q,carrierfq,codefq]=gpstrackcorr(prn, mycodephase, mycarrfreq, fs, corrspacing, codeperiods)
%
%Inputs
%  prn - the prn number of the GPS satellite (SV) to track
%  mycodephase - the starting sample number (integer) in the input data
%  mycarrfreq - the starting carrier frequency for the GPS SV to track
%  fs - sampling frequency
%  corrspacing - configuration of the reflected correlators
%                (recognize they are reversed, ex: -7.25:0.05:1.25)
%  codeperiods - amount of data to process
%
%Outputs
% e_i,e_q,p_i,p_q,l_i,l_q - the 6 output accumulator values recorded once
%                           each code period corresponding to early, late,
%                           and prompt (e, l, p) and inphase and
%                           quadrature (i, q)
%carrierfq - tracked carrier frequency
%codefq - tracked code frequency
%
%Requires
% m-file: cacode.m (to generate the C/A code, 1 sample/chip)
%         closeloop.m (compiled m-file to close all loops)

%compute number of correlator measurements here
numcorr=size(corrspacing,2);
%make direct correlator measurements symmetric about 0 offset
dircorr=corrspacing(find(corrspacing==(-corrspacing(end))):end);
numdircorr=size(dircorr,2);

% open input data files or exit if either cannot be opened...
fid1=fopen('GPSantennaUp.sim','rb');
fid2=fopen('GPSantennaDown.sim','rb');
if ((fid1 == -1)|(fid2 == -1))
    disp('Could not open input files, returning...')
    return
end

% open output files in working directory or return if cannot be opened...
fid3=fopen('OutRI.bin','wb');  fid4=fopen('OutRQ.bin','wb');
fid5=fopen('OutDI.bin','wb');  fid6=fopen('OutDQ.bin','wb');
if ((fid3 == -1)|(fid4 == -1)|(fid5 == -1)|(fid6 == -1))
    disp('Could not open output files, returning...')
    return
end

%skip through both input files to start at the designated locaiton
fseek(fid1,mycodephase*2,'bof');  %x2 for complex
fseek(fid2,mycodephase*2,'bof');  %x2 for complex

%generate the GPS C/A code (1023 samples) for the satellite of interest
ca=cacode(prn);
%create a vector of three periods of this code so one can reference prior
%the first sample and beyond the last sample
ca=[ca ca ca];

%loop counter for times through the loop
loopcnt=1;
%define initial code frequency
codefreq = 1.0230e6;
%define code phase (in chips) which is "left over"
remcodephase = 0.0;
%define carrier frequency which is used over whole tracking period
carrfreq = mycarrfreq;
%define how much carrier phase is "left over" at the end of each code
%period to reset trig argument rather than grown indefinitely
remcarrphase = 0.0;
%define early-late offset (in chips)
earlylate = 0.5;
%initiate the CNo (signal-to-noise ratio) to be 0
CNo=0;

%preallocate vectors to speed processing
e_i=zeros(1,codeperiods);e_q=zeros(1,codeperiods);
p_i=zeros(1,codeperiods);p_q=zeros(1,codeperiods);
l_i=zeros(1,codeperiods);l_q=zeros(1,codeperiods);
carrierfq=zeros(1,codeperiods); codefq=zeros(1,codeperiods);
corrchip=zeros(1,numcorr);
corrmeas_i=zeros(1,numcorr);corrmeas_q=zeros(1,numcorr);
corrmeas_ii=zeros(1,numdircorr);corrmeas_qq=zeros(1,numdircorr);

%tracking loop initialization
oldcarr_nco=0;olderrorcarr=0;
oldcode_nco=0;olderrorcode=0;

%MAIN LOOP - while less than the number of specified code periods then
%continue processing
while (loopcnt <=  codeperiods)
    %since it can be time consuming, do a periodic display of current stage
    %also a good point to display any debugging information
    if (rem(loopcnt,10)==0)
        trackingStatus=['  Completed ',int2str(loopcnt),' of ', ...
            int2str(codeperiods),' msec  [C/No: ',num2str(CNo,3),']'];
        disp(trackingStatus)
    end
    
    %update the phasestep based on code freq (variable) and sampling frequency (fixed)
    codephasestep=codefreq/fs;
    
    %find the size of a "block" or code period in whole samples
    %note - not starting from zero, but rather where you left off from last code period
    blksize=ceil((1023-remcodephase)/codephasestep);   %numchips = 1023
    %disp(num2str(blksize))
    %read in the appropriate number of samples to process this interation
    [rawdata,scount] = fread(fid1,blksize*2,'schar');  %x2 for complex
    %convert data stream in real/imag complex components
    rawdata=(rawdata(1:2:end) + 1i .* rawdata(2:2:end)).';
    %if did not read in enough samples, then could be out of data - better exit
    if (scount ~= blksize*2)
        disp('Not able to read requested direct samples, returning...')
        return
    end
    %read in reflection data
    [rawdata2,scount] = fread(fid2,blksize*2,'schar');   %x2 for complex
    %convert data stream in real/imag complex components
    rawdata2=(rawdata2(1:2:end) + 1i .* rawdata2(2:2:end)).';
    %if did not read in enough samples, then could be out of data - better exit
    if (scount ~= blksize*2)
        disp('Not able to read requested reflected samples, returning...')
        return
    end
    
    %adjust code phase - MODIFY WITH CAUTION
    %define index into early code vector
    tcode=(remcodephase-earlylate):codephasestep:((blksize-1)*codephasestep+remcodephase-earlylate);
    tcode2=ceil(tcode)+1023;
    earlycode=ca(tcode2);
    %define index into late code vector
    tcode=(remcodephase+earlylate):codephasestep:((blksize-1)*codephasestep+remcodephase+earlylate);
    tcode2=ceil(tcode)+1023;
    latecode=ca(tcode2);
    %get the values of the PRN code for the extra correlator measurements
    for inda=1:numcorr
        tcode=(remcodephase+corrspacing(1,inda)):codephasestep:((blksize-1)*codephasestep+remcodephase+corrspacing(1,inda));
        tcode2=ceil(tcode)+1023;
        corrchip(inda,1:blksize)=ca(tcode2);
    end
    %define index into prompt code vector
    tcode=remcodephase:codephasestep:((blksize-1)*codephasestep+remcodephase);
    tcode2=ceil(tcode)+1023;
    promptcode=ca(tcode2);
    %now compute the remainder for next time around
    remcodephase = (tcode(blksize) + codephasestep) - 1023.0;
    
    %generate the carrier frequency to mix the signal to baseband
    time=(0:blksize) ./ fs;
    %get the argument to sin/cos functions
    trigarg = ((carrfreq * 2.0 * pi) .* time) + remcarrphase;
    %compute the "leftover" on sample after the last to start there next time
    remcarrphase=rem(trigarg(blksize+1),(2 * pi));
    carrsig = exp(1i .* trigarg(1:blksize));
    
    %generate the six standard accumulated values
    %first mix to baseband
    tempdatacos = real(carrsig .* rawdata);
    tempdatasin = imag(carrsig .* rawdata);
    %now get early, late, and prompt values for each
    e_i(loopcnt) = sum(earlycode .* tempdatasin);
    e_q(loopcnt) = sum(earlycode .* tempdatacos);
    p_i(loopcnt) = sum(promptcode .* tempdatasin);
    p_q(loopcnt) = sum(promptcode .* tempdatacos);
    l_i(loopcnt) = sum(latecode .* tempdatasin);
    l_q(loopcnt) = sum(latecode .* tempdatacos);
    
    %do the extra correlator measurements if specified, only look at inphase measurements (assume carrier phase locked)
    tempdatacos2 = real(carrsig .* rawdata2);
    tempdatasin2 = imag(carrsig .* rawdata);
    for inda=1:numcorr
        corrmeas_i(inda)=sum(corrchip(inda,1:blksize) .* tempdatasin2);  %inphase component
        corrmeas_q(inda)=sum(corrchip(inda,1:blksize) .* tempdatacos2);
    end
    for inda=(numcorr-numdircorr+1):numcorr  %do prompt measurement, but with only a subset
        corrmeas_ii(inda-(numcorr-numdircorr))=sum(corrchip(inda,1:blksize) .* tempdatasin);  %inphase component
        corrmeas_qq(inda-(numcorr-numdircorr))=sum(corrchip(inda,1:blksize) .* tempdatacos);
    end
    
    %write those correlator measurements out to a file for later analysis
    scount=fwrite(fid3,corrmeas_i,'float');
    scount=scount+fwrite(fid4,corrmeas_q,'float');
    scount=scount+fwrite(fid5,corrmeas_ii,'float');
    scount=scount+fwrite(fid6,corrmeas_qq,'float');
    if (scount ~= (2*numcorr+2*numdircorr))
        disp('Not able to write the output samples, exiting...')
        return
    end
    
    %call function to close tracking loops (closed loop control system)
    [carrfreq,codefreq,oldcarr_nco_out,olderrorcarr_out,oldcode_nco_out,olderrorcode_out]= ...
        closeloop(e_i(loopcnt),e_q(loopcnt),p_i(loopcnt),p_q(loopcnt),l_i(loopcnt),l_q(loopcnt), ...
        oldcarr_nco,olderrorcarr,oldcode_nco,olderrorcode,mycarrfreq,1.023e6,2);
    oldcarr_nco=oldcarr_nco_out;
    olderrorcarr=olderrorcarr_out;
    oldcode_nco=oldcode_nco_out;
    olderrorcode=olderrorcode_out;
    carrierfq(loopcnt)=carrfreq;
    codefq(loopcnt)=codefreq;
    
    %increment loop counter
    loopcnt=loopcnt+1;
    
    %get CNo, update every 400msec, int period=0.001sec
    if (rem(loopcnt,400)==0)
        CNo=CNoVSM(p_i(loopcnt-399:loopcnt),p_q(loopcnt-399:loopcnt),0.001);
    end
end