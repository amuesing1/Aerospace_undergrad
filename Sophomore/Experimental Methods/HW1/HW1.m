%   Jeremy Muesing
%   ASEN 2012
%   HW1
%   9/5/14
%   
%   Statement:
%   Solving for distance from a crankshaft to piston
%   in terms of the angle betwen the vertical distance
%   and the crank.
%   Assumptions/Properties:
%   We are given that the connecting rod and crank are
%   1.0ft and 0.5ft respectively. Although the pupose
%   is to create optimal rod lengths, we assume they
%   are constant for this problem. At 0 degrees, the
%   distance is 1.5ft and at 180 it is 0.5ft.
%   Laws:
%   Using the law of sines, angle B and C can be
%   represented in terms of A. B=asin(sin(A)/2) &
%   C=180-A-B.
%   By using law of cosines, the distance can be
%   be calculated dependent of the angle A.
A = linspace(0,360,360); %Full rotation
d = sqrt(1.25-cosd(180-A-asind(sind(A)/2)));%Law of cosines
plot(A,d);
axis([0 360 0 1.5]);
xlabel('Angle');
ylabel('Distance');
title('Distance of Piston from Crank');
print
%   Graping the distance as a funciton of A we determined
%   that the distance varries as a sinusoidal function
%   undergoing simple harmonic motion from a high point
%   of 1.5ft and low of 0.5ft. The graph alos could be
%   represented as d=cos(A)+1 to achieve the same result.