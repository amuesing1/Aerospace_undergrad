% Aaron McCusker, Jeremy Muesing, Dustin Fishelman
% ASEN 3128
% Homework 2, Problem 1
% Plotting the necessary angle of attack and elevator deflection for
% various altitudes given information about the aircraft

i = 1;
for altitude = linspace(0,10000,200)
    [~,~,~,rho] = atmoscoesa(altitude);
    b = [.1577/rho;-0.071];
    A = [0.088 0.0108; -0.0088 -0.0246];
    x = A\b;
    alpha_trim(i) = x(1);
    delta_trim(i) = x(2);
    i = i+1;
end

figure(1)
plot(linspace(0,10000,200),alpha_trim)
xlabel('Altitude (m)')
ylabel('\alpha trim (deg)')
title('\alpha trim for Varying Altitudes')

figure(2)
plot(linspace(0,10000,200),delta_trim)
xlabel('Altitude (m)')
ylabel('\delta trim (deg)')
title('\delta trim for Varying Altitudes')