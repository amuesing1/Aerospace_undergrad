clear all
clc
close all
data=csvread('lab013_cylinder_8.csv',3,0);
    i=1;
    j=1;
    matrix=zeros(13,11);
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
matrix=matrix./10;

angle=zeros(13,1);
i=2;
while i<=13
    increment=180/12;
    angle(1)=0;
    angle(i)=angle(i-1)+increment;
    i=i+1;
end
%Cp=zeros(25,1);
Cp=matrix(:,2)./matrix(:,3); %dynamic pressure/ airspeed dynamic
Cp2=flipud(Cp(1:12)); %flips matrix usidedown
Cp(14:25)=Cp2(1:12); %creates mirror data points for cylinder

Cp_ideal=1-4*sind(angle).^2; %reference Cp

%x positioning
dx=(1-cosd(angle))/2;
dx2=flipud(dx(1:12)); %same as Cp
dx(14:25)=dx2(1:12);
%y positioning
dy=sind(angle);
dy2=-flipud(dy(1:12));
dy(14:25)=dy2(1:12);

%x=(0:15:360);
%plotting
scatter(dy,Cp)

%integrals
Cn=-trapz(dx,Cp);
Ca=-trapz(dy,Cp);

Cl=Cn %coefficient of lift
Cd=Ca %coefficent of drag

