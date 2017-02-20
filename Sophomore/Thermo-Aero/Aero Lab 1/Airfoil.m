function [Cl,Cd,Cn,Ca,Cp,dx,dy] = Airfoil(input_file)

% read usable data in input file
data=csvread(input_file,3,0);

i=1;
j=1;
matrix=zeros(20,8);
% Add all 10 rows for each port number
while j<=20
    while data(i)==j
        k=1;
        while k<=8
            matrix(j,k)=matrix(j,k)+data(i,k);
            k=k+1;
        end
        i=i+1;
    end
    j=j+1;
end
% find average of data for each port
matrix=matrix./10;
% copy port 1 to port 21 to create loop
matrix(21,:)=matrix(1,:);

% calculate coefficient of pressure at each port
Cp=matrix(:,2)./(.5*matrix(:,8).*matrix(:,4).^2);

% integrate coefficient of pressure with respect to x/c to find normal
% coefficient
Cn=-trapz(matrix(:,6),Cp);
% integrate coefficient of pressure with respect to y/c to find axial
% coefficient
Ca=-trapz(matrix(:,7),Cp);

% calculate coefficient of lift and drag from angle of attack
Cl=Cn*cosd(matrix(1,5))-Ca*sind(matrix(1,5));
Cd=Ca*cosd(matrix(1,5))-Cn*sind(matrix(1,5));

% copy x/c and y/c values to output
dx = matrix(:,6);
dy = matrix(:,7);
end