function [Cl,Cd,Cp] = Cylinder(input_file)

% read usable data in input file
data=csvread(input_file,3,0);

i=1;
j=1;
matrix=zeros(13,11);
% Add all 10 rows for each port number
while j<=13
    while data(i)==j
        k=1;
        while k<=11
            matrix(j,k)=matrix(j,k)+data(i,k);
            k=k+1;
        end
        i=i+1;
    end
    j=j+1;
end
% find average of data for each port
matrix=matrix./10;

% calculate coefficient of pressure for each port
Cp=matrix(:,2)./matrix(:,3);
% copy port data to opposite side of cylinder
Cp2=flipud(Cp(1:12));
Cp(14:25)=Cp2(1:12);

% calculate ideal coefficient of pressure data
angle = [0:15:360]';
Cp_ideal=1-4*sind(angle).^2;

% calculate x/c of ports
dx=(1-cosd(angle))/2;
% copy location to ports on opposite side
dx2=flipud(dx(1:12));
dx(14:25)=dx2(1:12);

% calculate y/c of ports
dy = sind(angle)/2 + 0.5;

% integrate coefficient of pressure with respect to x/c to find normal
% coefficient
Cn=-trapz(dx,Cp);
% integrate coefficient of pressure with respect to y/c to find axial
% coefficient
Ca=-trapz(dy,Cp);

% coefficient of lift and drag equal the normal and axial coefficients
% (respectively)
Cl=Cn;
Cd=Ca;
end

