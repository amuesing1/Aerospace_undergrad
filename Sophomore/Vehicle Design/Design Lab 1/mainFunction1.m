function [Wto] = mainFunction( Mach, R, S, AR, Alt, Payload, Ct, E )

%% Calculating Wto

Wto = (10.^((S-0.84)/-0.06)); %pounds

%% Calculating Wempty

Wempty = (S .* Wto);

%% Startup and Takeoff

WfOverWi(1)=0.972;

%% Climb and Accelerate to Cruise

if Mach >= 1
    WfOverWi(2) = 0.96 - 0.03*(Mach-1);
end
if Mach < 1
    WfOverWi(2) = 1 - 0.04*Mach;
end


%% Cruise to Destination

if Mach >= 1
    LOverDMax = 11*(Mach)^(-0.5);
    LOverD = 0.94*(LOverDMax);
end
if Mach < 1
    LOverDMax = AR + 10;
    LOverD = 0.94*(LOverDMax);
end

[T, a, p, rho] = atmoscoesa(Alt);
V = Mach * 1.9438 * a; % 1.9438 nm per m/s

WfOverWi(3)= exp(R/((V/Ct)*LOverD));


%% Loiter

WfOverWi(4)= exp(E/(LOverD/Ct));


%%  Landing

WfOverWi(5)=0.972;

%% Calculating Wto with addition of engine weight at end

for i = 2:5
    Wto = Payload./(1-S-((1-(WfOverWi(i)/WfOverWi(i-1)))/.94)) + (4*2282);
end


end

