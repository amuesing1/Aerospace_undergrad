function [Q] = Perifocal_to_Equatorial(Omega,i,omega)
% All inputs need to be in RADIANS

Q(1,1) = -sin(Omega)*cos(i)*sin(omega) + cos(Omega)*cos(omega); % good
Q(1,2) = -sin(Omega)*cos(i)*cos(omega) - cos(Omega)*sin(omega); % 
Q(1,3) = sin(Omega)*sin(i);
Q(2,1) = cos(Omega)*cos(i)*sin(omega) + sin(Omega)*cos(omega);
Q(2,2) = cos(Omega)*cos(i)*cos(omega) - sin(Omega)*sin(omega);
Q(2,3) = -cos(Omega)*sin(i);
Q(3,1) = sin(i)*sin(omega);
Q(3,2) = sin(i)*cos(omega);
Q(3,3) = cos(i);


end

