function dydt = TrajectoryNoAir(t,y,data)


V = y(1);
theta = y(2);
x = y(3);
z = y(4);
mR = y(5);
v = y(6);


%%%%%%%%%%%%%%%%
% These two values act as a way of preventing oscillation between the
% different phases. Ex) Once it's started phase 2, it cannot enter phase 1
% again.
ballisticPhase = y(7);

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



    
if v < vB && ballisticPhase == 0
    
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
    dballisticPhasedt = 0;

else
 
    mR = mB + mairI;
    F = 0;
    dvdt = 0;
    dmdt = 0;
    dVdt = (F-D-mR*g0*sin(theta))/mR;
    dthetadt = (-g0*cos(theta))/V; 
    dballisticPhasedt = 10;
            
end

dForcedt = F;



dydt = zeros(6,1);
dydt(1) = dVdt;
dydt(2) = dthetadt;
dydt(3) = dxdt;
dydt(4) = dzdt;
dydt(5) = dmdt;
dydt(6) = dvdt;
dydt(7) = dballisticPhasedt;
dydt(8) = dForcedt;


end

