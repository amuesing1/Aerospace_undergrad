function [dr,dv ] = CW(t,P,dr_0,dv_0)
% inputs: t=time from start point (seconds)
%         P=period of orbit (seconds)
%         dr_0=starting position vector (km) (column vector)
%         dv_0=starting velocity vector (km/s) (column vector)
mu=398600;
R=((P/(2*pi))^2*mu)^(1/3);
n=sqrt(mu/R^3);


Phi_rr=[4-3*cos(n*t) 0 0;6*(sin(n*t)-n*t) 1 0;0 0 cos(n*t)];
Phi_rv=[(1/n)*sin(n*t) (2/n)*(1-cos(n*t)) 0; (2/n)*(cos(n*t)-1) ...
    (1/n)*(4*sin(n*t)-3*n*t) 0; 0 0 (1/n)*sin(n*t)];
Phi_vr=[3*n*sin(n*t) 0 0;6*n*(cos(n*t)-1) 0 0; 0 0 -n*sin(n*t)];
Phi_vv=[cos(n*t) 2*sin(n*t) 0;-2*sin(n*t) 4*cos(n*t)-3 0; 0 0 cos(n*t)];
dr=Phi_rr*dr_0+Phi_rv*dv_0;
dv=Phi_vr*dr_0+Phi_vv*dv_0;
dr=norm(dr);
dv=norm(dv);
end

