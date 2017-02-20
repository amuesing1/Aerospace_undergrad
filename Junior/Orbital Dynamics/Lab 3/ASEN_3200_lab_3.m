close all
clear all
clc
count=1;

for i={'1','2','3','4','5'}
    filename=char(strcat('torque(.',i,')'));
    if exist(filename, 'file')
        temp(:,:)=load(filename);
        data(count,:,:)=temp(:,:);
        
        fit=polyfit(data(count,7:end-15,1),data(count,7:end-15,3),1);
%         x=linspace(min(data(count,:,1)),max(data(count,:,1)),length(data));
        
        % calculating MOI
        MOI(count)=max(data(count,:,2))/fit(1); %kg*m^2
        Inertia=mean(MOI);
        
        count=count+1;
        clear temp
    end
end

overshoot=10; %percent
ts=3; %sec
p=5; %percent settling time

K2=(-2*Inertia*log(p/100))/ts

% K1_jeremy=(((-pi*K2)/(2*Inertia*log(overshoot/100)))^2+((K2^2)/(4*Inertia^2)))*Inertia

% K1_jeff=(((-log(p/100))/((sqrt(((log(overshoot/100))^2)/(pi^2+(log(overshoot/100))^2))*ts)))^2)*Inertia

K1=((K2^2)/(4*Inertia))*((pi^2)/((log(overshoot/100))^2)+1)


dtr=pi/180;
Hz2rps=2*pi;  rps2Hz=1/2/pi; % Conversions to/from Hz and rad/s

% Put in your wn and zeta here:
wn=sqrt(K1/Inertia) * Hz2rps; % Natural frequency of 9 Hz
zeta = (K2/(2*Inertia))*sqrt(Inertia/K1)

numerator = [K1/Inertia];
denominator = [ 1 2*zeta*wn wn^2];

sys = tf(numerator, denominator)

step(sys)
grid