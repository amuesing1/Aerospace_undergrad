function F = Mole_Solver(x)

% eta_hf = x(1)
% eta_h = x(2)
% eta_f = x(3)
% eta_h2 = x(4)
% eta_f2 = x(5)
% eta_t = x(1) + x(4) + x(5) + x(2) + x(3)

KP1 = 2.08E8;
KP2 = 0.3480;
KP3 = 2.084E4;
Pm = 1;

F(1) = x(1) + 2*x(4) + x(2) - 2;
F(2) = x(1) + 2*x(5) + x(3) - 2;

F(3) = KP1*x(4)*x(5) - x(1)^2;
F(4) = (KP2/Pm)*x(4)*(x(1) + x(4) + x(5) + x(2) + x(3)) - x(2)^2;
F(5) = (KP3/Pm)*x(5)*(x(1) + x(4) + x(5) + x(2) + x(3)) - x(3)^2;