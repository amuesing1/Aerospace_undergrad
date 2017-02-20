function [cl,cd] = shockexpansion(alpha,gamma,Minf,c,phi1,phi2,phi3,phi4)
%SHOCKEXPANSION Computes cl and cd for a quadrilateral airfoil
%   Function inputs general quadrilateral geometry with supersonic-flow
%   conditions, then computes the static pressure ratio on each surface.
%   cl and cd (wave drag) are then computed from resolved pressure forces. 
%
% Upper-surface pressure calculations
n=0;
[~, ~, PinfP0inf, ~, ~] = flowisentropic(gamma, Minf);
% Surface 1
if phi1 > alpha %oblique-shock solution
    theta=phi1-alpha;
    Beta = beta(Minf,theta,gamma,n);
    Mn1 = Minf*sind(Beta);
    [~, ~, P1Pinf, ~, Mn1, P01P01, ~] = flownormalshock(gamma,Mn1);
    M1 = Mn1/sind(Beta - theta);
else %P-M solution
    [~, nuinf, ~] = flowprandtlmeyer(gamma, Minf);
    nu1 = nuinf + (alpha - phi1);
    [M1, ~, ~] = flowprandtlmeyer(gamma, nu1 ,'nu');
    [~, ~, P1P01, ~, ~] = flowisentropic(gamma, M1);
    P1Pinf = P1P01/PinfP0inf;
end
% Surface 2
%P-M solution
   % [~, ~, PinfP0inf, ~, ~] = flowisentropic(gamma, M1);
    [~, nu1, ~] = flowprandtlmeyer(gamma, M1);
    nu2 = nu1 + (phi1 + phi2);
    [M2, ~, ~] = flowprandtlmeyer(gamma, nu2 ,'nu');
    [~, ~, P2P02, ~, ~] = flowisentropic(gamma, M2);
    P2Pinf = (P1Pinf*P2P02)/P1P01;
% Surface 3
if -phi3 < alpha %oblique-shock solution
    theta=phi3+alpha;
    Beta = beta(Minf,theta,gamma,n);
    Mn3 = Minf*sind(Beta);
    [~, ~, P3Pinf, ~, Mn3, P03P01, ~] = flownormalshock(gamma,Mn3);
    M3 = Mn3/sind(Beta - theta);
else %P-M solution
   % [~, ~, PinfP0inf, ~, ~] = flowisentropic(gamma, Minf);
    [~, nuinf, ~] = flowprandtlmeyer(gamma, Minf);
    nu3 = nuinf + (pi3 - alpha);
    [M3, ~, ~] = flowprandtlmeyer(gamma, nu3 ,'nu');
    [~, ~, P3P03, ~, ~] = flowisentropic(gamma, M3);
    P3Pinf = P3P03/PinfP0inf;
end
% Surface 4
%P-M solution
    %[~, ~, PinfP0inf, ~, ~] = flowisentropic(gamma, M3);
    [~, nu3, ~] = flowprandtlmeyer(gamma, M3);
    nu4 = nu3 + (phi3 + phi4);
    [M4, ~, ~] = flowprandtlmeyer(gamma, nu4 ,'nu');
    [~, ~, P4P04, ~, ~] = flowisentropic(gamma, M4);
    P4Pinf = (P03P01*P4P04)/PinfP0inf; %weird calculation not in our book

    
% HW 12
%     P1Pinf=0.6112;
%     P2Pinf=-.9438;
%     P3Pinf=2.9438;
%     P4Pinf=1.3888;

% Find cl and cd
cl=(2/(gamma*Minf^2))*((-1/(sind(phi1+phi2)))*(sind(phi2)*cosd(phi1-alpha)...
    *P1Pinf+sind(phi1)*cosd(phi2+alpha)*P2Pinf)+(1/sind(phi3+phi4))...
    *(sind(phi4)*cosd(phi3+alpha)*P3Pinf+sind(phi3)*cosd(phi4-alpha)*P4Pinf));
cd=(2/(gamma*Minf^2))*((1/(sind(phi1+phi2)))*(sind(phi2)*sind(phi1-alpha)...
    *P1Pinf+sind(phi1)*sind(phi2+alpha)*P2Pinf)+(1/sind(phi3+phi4))...
    *(sind(phi4)*sind(phi3+alpha)*P3Pinf-sind(phi3)*sind(phi4-alpha)*P4Pinf));
end