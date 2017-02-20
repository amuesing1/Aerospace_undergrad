function dydt = Trajectory(t,y,data)


V = y(1);
theta = y(2);
x = y(3);
z = y(4);
mR = y(5);
v = y(6);


%%%%%%%%%%%%%%%%
% These two values act as a way of preventing oscillatin between the
% different phases. Ex) Once it's started phase 2, it cannot enter phase 1
% again.
airPhase = y(7);
ballisticPhase = y(8);

CD = data.CD;
cd = data.cd;
pa = data.pa;
g0 = data.g0;
mB = data.mB;
AB = data.AB;
At = data.At;
R = data.R;
vB = data.vB;
TairI = data.TairI;
rhowater = data.rhowater;
rhoair = data.rhoair;
gamma = data.gamma;
vairI = data.vairI;
pairI = data.pairI;
mairI = data.mairI;
stageTwoStartMass = data.stageTwoStartMass;


% These are the same for each phase
D = (1/2)*rhoair*(V^2)*CD*AB;           %Drag
dxdt = V*cos(theta);
dzdt = V*sin(theta);
mair = mR - mB;
pend = pairI*((vairI/vB)^gamma);
Tend = TairI*((vairI/vB)^(gamma-1));
pair = pend*((mair/mairI)^gamma);


% Compensates for overshoot during phase 1, so there isn't negative air
% mass
if v >= vB && airPhase == 0
        mR = mB + mairI;
end
    
if v < vB && airPhase == 0
    
    p = pairI*((vairI/v)^gamma);
    Ve = sqrt((2*(p-pa))/rhowater);
    massflow = cd*rhowater*At*Ve;
    F = massflow*Ve;
    
    if sqrt(x^2 + z^2) < 0.3
        dthetadt = 0;
    else
        dthetadt = (-g0*cos(theta))/V;
    end
    
    dVdt = (F-D-mR*g0*sin(theta))/mR;
    dvdt = cd*At*Ve;
    dmdt = -massflow;
    dairPhasedt = 0;
    dballisticPhasedt = 0;

elseif pair > pa && ballisticPhase == 0
    rho = mair/vB;
    T = pair/(rho*R);
    pcrit = pair*(((2/(gamma+1))^(gamma/(gamma-1))));
    
    if pcrit > pa
        Te = (2/(gamma+1))*T;
        pe = pcrit;
        rhoe = pe/(R*Te);
        Ve = sqrt(gamma*R*Te);
    else
        pe = pa;
        Me = sqrt((2/(gamma-1))*(((pair/pa)^((gamma-1)/gamma))-1));
        Te = T*(1+((gamma-1)/2)*(Me^2));
        rhoe = pa/(R*Te);
        Ve = Me*sqrt(gamma*R*Te);
    end
    
    massflowair = cd*rhoe*At*Ve;
    F = massflowair*Ve+(pe-pa)*At;
    dmdt = -massflowair;
    dVdt = (F-D-mR*g0*sin(theta))/mR;
    dthetadt = (-g0*cos(theta))/V;
    dvdt = 0;
    dairPhasedt = 10;
    dballisticPhasedt = 0;
        
else
 
    F = 0;
    dvdt = 0;
    dmdt = 0;
    dVdt = (F-D-mR*g0*sin(theta))/mR;
    dthetadt = (-g0*cos(theta))/V; 
    dballisticPhasedt = 10;
    dairPhasedt = 0;
            
end

dForcedt = F;



dydt = zeros(6,1);
dydt(1) = dVdt;
dydt(2) = dthetadt;
dydt(3) = dxdt;
dydt(4) = dzdt;
dydt(5) = dmdt;
dydt(6) = dvdt;
dydt(7) = dairPhasedt;
dydt(8) = dballisticPhasedt;
dydt(9) = dForcedt;


end

