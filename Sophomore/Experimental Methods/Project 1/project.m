clc
clear all
close all
FID=fopen('input.txt');
i=1;
read=0;
while read~=-1
    read=fgets(FID); %read next line
    if read~=-1 %last increment doesn't crash
    numbers=str2num(read); %input line into array
    time(i)=numbers(1);
    water(i)=numbers(2);
    temp(i)=numbers(3);
    end
    i=i+1;
end

%computing best fit line for bottom end of data before sample is inserted by
%finding sums of the arrays and using them to compute A and B values for
%linear equation
sum_timeb2=sum(time(1:200).^2);
sum_timeb=sum(time(1:200));
sum_tempb=sum(temp(1:200));
sum_timeb_tempb=sum(temp(1:200).*time(1:200));
deltab=length(temp(1:200))*sum_timeb2-sum_timeb.^2;
Ab=(sum_timeb2*sum_tempb-sum_timeb*sum_timeb_tempb)/deltab;
Bb=(length(temp(1:200))*sum_timeb_tempb-sum_timeb*sum_tempb)/deltab;

%computing best fit line for top end of data after sample and calorimeter
%have come to equilibrium
sum_timet2=sum(time(600:1000).^2);
sum_timet=sum(time(600:1000));
sum_tempt=sum(temp(600:1000));
sum_timet_tempt=sum(temp(600:1000).*time(600:1000));
deltat=length(temp(600:1000))*sum_timet2-sum_timet.^2;
At=(sum_timet2*sum_tempt-sum_timet*sum_timet_tempt)/deltat;
Bt=(length(temp(600:1000))*sum_timet_tempt-sum_timet*sum_tempt)/deltat;

%after choosing the value of 346 seconds by looking at my graph, this finds
%the closest value in the time area to the value of 346 s by substractnig
%each value and comparing the minimum. The closest value is then stored in
%closestx1 which is used to create the vertical line at intersection
%between the data and the best fit line.
val1 = 346; %value to find picked by estiamted guess
tmp = abs(time-val1);
[idx idy] = min(tmp); %index of closest value
closestx1 = time(idy); %closest value

%finding both values of the top and bottom best fit lines and their
%intersection with the vertical line just created at the bottom line's
%intersection with the data. These values are then averaged to find the
%average temperature.
temp0c=Ab+Bb*closestx1;
tempnot2=At+Bt*closestx1;
avg_temp=(tempnot2+temp0c)/2;

%same theory as above to find the closest value we have in the sample data
%to the found average temperature for plotting purposes. declaring a value
%to find and subtracting all values in the array to find the closest one.
%That closest value is stored in closesty and the x value is also stored
%both for plotting purposes.
val2 = avg_temp; %value to find
tmp = abs(temp-val2);
[idx idy] = min(tmp); %index of closest value
closesty = temp(idy);
closestx2 = time(idy); %closest value

%declaring the values that are used in the specific heat calculation. For
%temperatures already found such as temp0 it is just placing them into
%Kelvin. temp 2 is found using the data found above for the intersection
%value of the average temperature and the upper temperature line of best
%fit. the initial temperature of the sample is the temperature of the
%boiling water which remains almost constant throughout the lab so I just
%took the average value of it over the time the experiment was done. The
%mass of the sample and calorimeter are given and the specific heat of
%aluminum was given and converted from cal/g*C to J/g*K
temp0=temp0c+273;
temp2=(At+Bt*closestx2)+273;
temp1=mean(water(600:800))+273;
ms=113.533;
mc=485.7;
Cc=0.895375;

%calculation to find specific heat and the whole purpose of the lab
Cs=(mc*Cc*(temp2-temp0))/(ms*(temp1-temp2));

%CALCULATING ERROR SECTION
%calculating error in best fit lines/temperatures
%bottom line and temperature 0
i=1;
sum_in=0;
while i<=length(time(1:200))
    in=(temp(i)-Ab-Bb*time(i)).^2;
    sum_in=sum_in+in;
    i=i+1;
end
uncer_temp0=sqrt((1/(length(time(1:200))-2))*sum_in); %uncertainty in bottom line

%top line and temperature 2
i=600;
sum_in=0;
while i<=1000
    in=(temp(i)-At-Bt*time(i)).^2;
    sum_in=sum_in+in;
    i=i+1;
end
uncer_tempnot2=sqrt((1/(length(time(600:1000))-2))*sum_in); %uncertainty in top line
uncer_temp2=uncer_tempnot2+uncer_temp0; %two are averaged so the uncertainties add

dTbar=uncer_temp0+uncer_temp2; %not independent
%error in thermocouple using standard deviation. they are independent and
%random from one another
dThat=sqrt(std(water(600:800))^2+uncer_temp2^2); 
dms=0.005; %error provided for sample
dmc=.1; %error provided for calorimeter
% finding partials
dcs_dmc=((Cc*(temp2-temp0))/(ms*(temp1-temp2)))*dmc; %partial for mass of calorimeter
dcs_dms=-((mc*Cc*(temp2-temp0))/(ms^2*(temp1-temp2)))*dms; %partial for mass of sample
dcs_dTbar1=((mc*Cc)/(ms*(temp1-temp2)))*dTbar; %partial for top temp
dcs_dTbar2=-((mc*Cc*(temp2-temp0))/(ms*(temp1-temp2)^2))*dThat; %partial for bottom temp
%error calculation
err=sqrt(dcs_dmc^2+dcs_dms^2+dcs_dTbar1^2+dcs_dTbar2^2);

percent=(err/Cs)*100;

CsCal=Cs*0.238845897; %converting to cal/g*C
errCal=err*0.238845897;

fileID = fopen('output.txt','w');
fprintf(fileID,'Specific heat of sample is %1f +- %1f kJ/kg*K\n',Cs,err);
fprintf(fileID,'Or\n');
fprintf(fileID,'Specific heat of sample is %1f +- %1f cal/g*C\n',CsCal,errCal);
fprintf(fileID,'Which is a %1f percent error\n',percent);
fclose(fileID);
 
%PLOTTING
x=linspace(1,1040); %used for best fit lines
figure(1)
%plot data
plot(time,temp) 
hold on
%plot best fit line before sample is inserted
plot(x,Ab+Bb*x,'r')
hold on
%plot best fit line after sample comes to equilibrium
plot(x,At+Bt*x,'g') 
hold on
%plot intersection of data and bottom best fit line
line([closestx1 closestx1], [24 32], 'Color','m'); 
hold on
%plot star at average temperature intersection of the data
plot(closestx2,closesty,'r*') 
hold on
%plot vertical line at average temperature to intersect top best fit line
line([closestx2 closestx2], [24 32], 'Color','c'); 
title('Calorimetry Experiment')
xlabel('Time (s)')
ylabel('Temperature C')

figure(2)
plot(time,water)
title('Boiling Water')
xlabel('Time (s)')
ylabel('Temperature C')
