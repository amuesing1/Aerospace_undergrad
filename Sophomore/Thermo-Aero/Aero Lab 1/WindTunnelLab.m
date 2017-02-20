function WindTunnelLab()
% Imports and analyses airfoil and cylinder data from an arbitrary number
% of files of varying speeds and angles of attack. Data is used to create
% non-dimensional units for coefficients of pressure (as well as normal and
% axial) and coefficients of drag and analyse their corresponding
% uncertainty.
%
% Input: None
% Output: None



% Following the naming convention, this searches for all cylinder file
% speeds and lab sections, creating matricies for Cl, Cd, Cp and deltaCp in
% order of the test's airspeed.
count = 1;
for speed = [1:20]
    for lab = [11:13]
        outputString = sprintf('lab0%d_cylinder_%d.csv',lab,speed);
        yn = exist(outputString,'file');
        if yn ~= 0
            % Imports cylinder data
            [ClC(:,count),CdC(:,count),CpC(:,count),delcp(count,:)] = Cylinder(outputString);
            airspeed(count) = speed;
            count = count + 1;
        end
    end
end

% Following the naming convention, this searches for all airfoil file
% angles and lab sections, creating matricies for Cl, Cd, Cn, Ca, Cp,
% deltaCl, deltaCp and port locations x and y. (In order of AOA)
count = 1;
for angleTmp = [-10:20]
    for lab = [11:13]
        outputString = sprintf('lab0%d_airfoil_%d.csv',lab,angleTmp);
        yn = exist(outputString,'file');
        if yn ~= 0
            % inports airfoil data
            [ClA(:,count),CdA(:,count),CnA(:,count),CaA(:,count),CpA(:,count),dx,dy,delcl(count,:),delcpA(count,:)] = Airfoil(outputString);
            angle(count) = angleTmp;
            count = count + 1;
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plots Cylinder Cp vs Asimuthal Angle
numCylinder = size(ClC);
figure(1);

% Creates legend for each line
for k = 1:numCylinder(2)
   cylinderLegend{k,1} = sprintf('%d m/s',airspeed(k));
end
cylinderLegend{numCylinder(2)+1,1} = 'Ideal';

% Plots Cp and ideal case
theta = 0:15:360;
theta1 = 0:1:360;
Cp_ideal=1-4*sind(theta1).^2;
plot(theta,CpC,theta1,Cp_ideal)

% Creates plot labels
xlim([0 360]);
legend(cylinderLegend,'Location','northeastoutside');
xlabel('Azimuthal Angle (deg)');
ylabel('Coefficient of Pressure');
title('Cylinder Cp vs Azimuthal Angle');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plots Airfoil Cp vs X/C
numAirfoil = size(ClA);
figure(2);

% Creates legend for each line
for k = 1:numAirfoil(2)
   airfoilLegend{k,1} = sprintf('%d deg',angle(k));
end
plot(dx,CpA);

% Creates plot labels
legend(airfoilLegend,'Location','northeastoutside');
xlabel('X/C');
ylabel('Coefficient of Pressure');
title('Airfoil Cp');
set(gca,'YDir','reverse');      % Flips y axis


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plots Airfoil Cl vs angle of attack
figure(3);
hold all;

% Creates symbol array to cycle through when plotting
symbols = ['+','o','*','x','d','s','p','h','^','v','>','<'];
count = 1;
for k = [1:numAirfoil(2)]
    % cylces the symbols
    if count > 12
        count = 1;
    end
    plots(k) = scatter(angle(k),ClA(:,k),symbols(count));
    count = count + 1;
end

% Creates legend for each point
for k = 1:numAirfoil(2)
   angleLegend{k,1} = sprintf('%d deg',angle(k));
end

% Creates error array, approximating the error as the average of all port
% errors in a given test
for k = 1:numAirfoil(2)
   error(k) = mean(delcl(:,k)); 
end
angleLegend{numAirfoil(2)+1,1} = 'Thin Airfoil';

% Adds errror bars and thin airfoil line
errorbar(angle,ClA,error,'.k','MarkerSize',1);
plots(numAirfoil(2)+1) = plot(angle,2*pi*((angle*pi/180)+(5*pi/180)));

% Labels plots
legend(plots,angleLegend,'Location','northeastoutside');
xlabel('Angle (deg)');
ylabel('Coefficient of Lift');
title('Coefficient of Lift vs Angle (w/ error)');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plots Airfoil Cd vs angle of attack
figure(4);
hold all;

% Creates symbol array to cycle through when plotting
symbols = ['+','o','*','x','d','s','p','h','^','v','>','<'];
count = 1;
for k = [1:numAirfoil(2)]
    % cylces the symbols
    if count > 12
        count = 1;
    end
    plots(k) = scatter(angle(k),CdA(:,k),symbols(count));
    count = count + 1;
end

% Creates legend for each point
for k = 1:numAirfoil(2)
   angleLegend{k,1} = sprintf('%d deg',angle(k));
end
angleLegend{numAirfoil(2)+1,1} = 'Thin Airfoil';

% Plots thin airfoil line
y = zeros(size(angle));
plots(numAirfoil(2)+1) = plot(angle,y);

% Plots error in Cd
errorbar(angle,CdA,error,'.k','MarkerSize',1);

% Labels Plots
legend(plots,angleLegend,'Location','northeastoutside');
xlabel('Angle (deg)');
ylabel('Coefficient of Drag');
title('Coefficient of Drag vs Angle (w/ error)');
set(gca,'YDir','reverse');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots example of cylinder Cp vs azimuthal angle with corresponding error
% bars
figure(5)
hold on;
error(1,1:13) = delcp(1,:);
error(1,14:25) = fliplr(delcp(1,1:12));
errorbar(theta,CpC(:,1),error,'MarkerSize',1);
legend('8 m/s','Location','northoutside');
xlabel('Azimuthal Angle (deg)');
ylabel('Coefficient of Pressure');
title('Cylinder Cp Error');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots example of airfoil Cp vs X/C with corresponding error bars
figure(6)
hold on;
error1(1,1:20) = delcpA(17,:);
error1(1,21) = delcpA(1,1);
errorbar(dx,CpA(:,17),error1,'MarkerSize',1);
legend('11 Degree AOA','Location','northoutside');
xlabel('X/C');
ylabel('Coefficient of Pressure');
title('Airfoil Cp Error');
set(gca,'YDir','reverse');
end

function [Cl,Cd,Cp,delcp] = Cylinder(input_file)
% Imports cylinder data file into usable matrix, averaging each set of data
% points for each port. Calculates the coefficients of pressure, drag,
% normal, axial, lift and drag as well as calculates X/C and Y/C. (delcp is
% determined by a separate function)
%
% Input:    input_file  --  name of file to import data from
%
% Output:   Cl  --  coefficient of lift
%           Cd  --  coefficient of drag
%           Cp  --  coefficient of pressure
%           delcp  --  uncertainty in values for Cp (and Cd)

% read usable data in input file
data=csvread(input_file,4,0);

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


angle = [0:15:360]';

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

% determines error at each port for current cylinder file
[delcp] = cylinder_uncertainty(data,matrix);

end

function [Cl,Cd,Cn,Ca,Cp,dx,dy,delcl,delcpA] = Airfoil(input_file)
% Imports airfoil data file into usable matrix, averaging each set of data
% points for each port. Calculates the coefficients of pressure, drag,
% normal, axial, lift and drag as well as extracts X/C and Y/C from the
% data file. (delcl and delcpA are determined by a separate function)
%
% Input:    Cl  --  coefficient of lift
%           Cd  --  coefficient of drag
%           Cn  --  coefficient of normal force
%           Ca  --  coefficient of axial force
%           Cp  --  coefficient of pressure
%           dx  --  port location x distance fraction (X/C = x location/cord length)
%           dy  --  port location y distance fraction (Y/C = y locat/cord length)
%           delcl  --  uncertainty in coefficient of lift
%           delcpA  --  uncertainty in coefficient of pressure

% read usable data in input file
data=csvread(input_file,4,0);

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

% determines error for each port for current airfoil file
[delcl,delcpA] = airfoil_uncertainty(data,matrix);

end

function [delcp] = cylinder_uncertainty(data,matrix)
% Calculates the uncertainty in the coefficient of pressure for cylinder
% data. 
%
% Input:    data  --  direct file data matrix
%           matrix  --  averaged data for port locations
%
% Output:   delcp  --  uncertainty in coefficient of pressure


pinfstd=0;
qinfstd=0;
count=10;
i=1;

% determined standard deviation of measured values (given 10 data points
% each)
while count<=130
    pinfstd(i) = std(data(count-9:count,2));
    qinfstd(i) = std(data(count-9:count,3));
    i=i+1;
    count=count+10;
end
delcp=0;

% determines propogation of measurement error to Cp value
for i=1:13
    delcp(i)=sqrt(((1/matrix(i,3))*pinfstd(i))^2+((matrix(i,2)/(matrix(i,3))^2)*qinfstd(i))^2);
end
end

function [delcl,delcp] = airfoil_uncertainty(data,matrix)
% Calculates the uncertainty in the coefficient of pressure and liftfor 
% airfoil data. 
%
% Input:    data  --  direct file data matrix
%           matrix  --  averaged data for port locations
%
% Output:   delcp  --  uncertainty in coefficient of pressure
%           delcl  --  uncertainty in coefficient of lift


pinfstd=0;
qinfstd=0;
count=10;
i=1;

% determines standar deviation of measured values (given 10 data points
% each)
while count<=200
pinfstd(i) = std(data(count-9:count,2));
qinfstd(i) = std(data(count-9:count,3));
i=i+1;
count=count+10;
end
delcp=0;

% determines propogation of measurement error to Cp and Cl values.
for i=1:20
    delcp(i)=sqrt(((1/matrix(i,3))*pinfstd(i))^2+((matrix(i,2)/(matrix(i,3))^2)*qinfstd(i))^2);
end
delcl=delcp*2;
end