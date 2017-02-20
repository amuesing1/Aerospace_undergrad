%function lab3_airfoil(airfoil_12)
data=csvread('airfoil_12.csv',3,0);
    i=1;
    j=1;
    matrix=zeros(20,8);
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
matrix=matrix./10;
matrix(21,:)=matrix(1,:);

Cp=matrix(:,2)./(.5*matrix(:,8).*matrix(:,4).^2);

%scatter(matrix(:,9),Cp)

Cn=-trapz(matrix(:,6),Cp);
Ca=-trapz(matrix(:,7),Cp);

Cl=Cn*cosd(matrix(1,5))-Ca*sind(matrix(1,5));
Cd=Ca*cosd(matrix(1,5))-Cn*sind(matrix(1,5));
%end

%PLOTTING
%cp vs. x/c
figure(1);
plot(matrix(:,6),Cp,'r'); %%Need to flip negative to positive?
xlabel('Distance from Start/Chord Length (x/c)');
ylabel('Coefficient of Pressure');

%cl as a function of AoA
figure(2);
plot(matrix(1,5),Cl,'bo');
xlabel('Angle of Attack (degrees)');
ylabel('Coefficient of Lift');

%cd as a function of AoA
figure(3);
plot(matrix(1,5),Cd,'m*')
xlabel('Angle of Attack');
ylabel('Coefficient of Drag');