function [carrfreq,codefreq,oldcarr_nco_out,olderrorcarr_out,oldcode_nco_out,olderrorcode_out]=closeloop(e_i,e_q,p_i,p_q,l_i,l_q, ...
    oldcarr_nco,olderrorcarr,oldcode_nco,olderrorcode,carrfreq_basis,codefreq_basis,trackmode);
%function [carrfreq,codefreq,oldcarr_nco_out,olderrorcarr_out,oldcode_nco_out,olderrorcode_out]=closeloop(e_i,e_q,p_i,p_q,l_i,l_q, ...
%    oldcarr_nco,olderrorcarr,oldcode_nco,olderrorcode,carrfreq_basis,codefreq_basis,trackmode);
%
%Compiled closeloop module
% D. Akos - UCBoulder - Spring 2004
%
%Inputs
%e_i,e_q,p_i,p_q,l_i,l_q - the 6 output accumulator values recorded once each code period corresponding
%                          to early, late, and prompt (e, l, p) and inphase and quadrature (i, q)
%oldcarr_nco - the last carrier NCO command
%olderrorcarr - the last carr loop error
%oldcode_nco - the last code NCO command
%olderrorcode - the last code loop error
%carrfreq_basis - the base carrier freq
%codefreq_basis - the base code freq
%trackmode - if "0" then no tracking is done
%            if "1" only code tracking is done
%            if "2" both code and carrier tracking are done
%
%Outputs
%carrfreq - the updated carrier frequency to use
%codefreq - the updated code frequency to use
%oldcarr_nco_out - the next oldcarr_nco to use as input 
%olderrorcarr_out - the next olderrorcarr to use as input
%oldcode_nco_out - the next oldcode_nco to use as input
%olderrorcode_out - the next olderrorcode to use as input

if (trackmode == 0)
    carrfreq=carrfreq_basis;
    codefreq=codefreq_basis;
    oldcarr_nco_out=0; 
    olderrorcarr_out=0;
    oldcode_nco_out=0;
    olderrorcode_out=0;
else
    %implement code tracking
    %summation interval
    PDI=0.001; 
    %code 2nd order loop parameters
    detector_scale_factor=0.5;
    %Define loop bandwidth in Hz
    LBW=1.2;
    % Define damping coefficient for 2nd order loop
    zeta=0.7071;			
    % solve natural frequency
    Wn=LBW*8*zeta/(4*zeta.^2+1);
    % solve for t1 & t2
    tau1=detector_scale_factor / (Wn .* Wn);
    tau2= 2 * zeta / Wn;
    %disp([num2str(e_i),' ',num2str(e_q),' ',num2str(l_i),' ',num2str(l_q)])
    %implement code loop discriminator (phase detector)
    errorcode=(sqrt(e_i  * e_i  + e_q  * e_q ) - ...
        sqrt(l_i  * l_i  + l_q  * l_q )) / ...
        (sqrt(e_i  * e_i  + e_q  * e_q ) + ...
        sqrt(l_i  * l_i  + l_q  * l_q ));
    %implement code loop filter and generate NCO command
    code_nco = oldcode_nco + (tau2/tau1) * (errorcode - olderrorcode) + errorcode * (PDI/tau1);
    %modify code freq based on NCO command
    codefreq = codefreq_basis - code_nco;
    %update old values for next time through
    oldcode_nco_out=code_nco;
    olderrorcode_out=errorcode;
    if (trackmode == 2)
        %implement carrier tracking
        %summation interval
        PDI=0.001; 
        %carrier 2nd order loop parameters
        detector_scale_factor=0.25;
        %Define loop bandwidth in Hz
        LBW=25;
        % Define damping coefficient for 2nd order loop
        zeta=0.7071;			
        % solve natural frequency
        Wn=LBW*8*zeta/(4*zeta.^2+1);
        % solve for t1 & t2
        tau1=detector_scale_factor / (Wn .* Wn);
        tau2= 2 * zeta / Wn;
        %implement carrier loop discriminator (phase detector)
        errorcarr=atan(p_q / p_i)/(2.0 * pi);
        %implement carrier loop filter and generate NCO command
        carr_nco = oldcarr_nco + (tau2/tau1) * (errorcarr - olderrorcarr) + errorcarr * (PDI/tau1);
        %modify carrier phase/freq based on NCO command
        carrfreq = carrfreq_basis + carr_nco; 
        %update for next time through loop
        oldcarr_nco_out = carr_nco;
        olderrorcarr_out = errorcarr;
    else 
        carrfreq = carrfreq_basis; 
        oldcarr_nco_out=0;
        olderrorcarr_out=0;
    end
end