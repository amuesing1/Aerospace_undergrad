function Optimizer()

maxPressure = 150;           %psi
minCoefPres = 0.3;          %minimum coefficient of pressure
simTime = 10;               %choose an appropriate simulation time (if you get 'Undefined function or variable "index"', turn this value up)
stepSize = 2;               %set to 1,2,4,5 or 10 (larger numbers are faster but less accurate)


% Determines altitude vs volume fraction for nominal case, 'no air phase'
% case, 'purely ballistic' case and percent differences.
count = 1;
for volume = 10:1:60
    [height(1,count),t,y,data] = AltitudeObjective([maxPressure, volume, minCoefPres, 89.99, simTime, 0]);
    height(3,count) = AltitudeObjectiveNoAir([maxPressure, volume, minCoefPres, 89.99, simTime, 0]);
    height(2,count) = volume;
    percentDif(1,count) = ((height(1,count) - height(3,count))/height(1,count))*100;
    
    %Finds equivalent V0
    mi = data.mRI;
    size1 = size(y);
    mf = y(size1(1),5);
    I = max(y(:,9))/(data.massWater*data.g0);
    V0 = I*data.g0*log(mi/mf);
    
    [height(4,count),t1,y1,data1] = AltitudeObjective([0, 0, minCoefPres, 89.99, simTime, V0]);
    percentDif(2,count) = ((height(1,count) - height(4,count))/height(1,count))*100;
    count = count + 1;
end
figure(1)
hold on;
nom = plot(height(2,:),height(1,:),'blue');
noAir = plot(height(2,:),height(3,:),'black');
airDif = plot(height(2,:),percentDif(1,:),'--k');
ballistic = plot(height(2,:),height(4,:),'green');
balDif = plot(height(2,:),percentDif(2,:),'--g');
[M,I] = max(height(1,:));
optimalVolume = height(2,I);
outputString = sprintf('Volume Fraction vs Height\nMax Height of %3.1fm at %2.0f%% water\n(psi: %3.1f, Cd: %1.1f)',M,optimalVolume,maxPressure,minCoefPres);
title(outputString);
xlabel('Water Volume Percent');
ylabel('Altitude (m) & Percent Difference');
legend([nom,noAir,airDif,ballistic,balDif],'Nominal','Ignored Air Phase','Percent Difference (w/o Air)','Purely Ballistic','Percent Difference (ballistic)','Location','northeastoutside');


% Determines distance travelled vs launch angle and volume fraction for
% nominal,'no air' and 'purely ballistic' cases and their associated
% percent differences.
count = 1;
for angle = 20:stepSize:60
    for volume = 10:stepSize:50
        [distance(count,1),t,y,data] = DistanceObjective([maxPressure, volume, minCoefPres, angle, simTime, 0]);
        distance(count,4) = DistanceObjectiveNoAir([maxPressure, volume, minCoefPres, angle, simTime, 0]);
        distance(count,2) = angle;
        distance(count,3) = volume;
        percentDif(count,1) = ((distance(count,1)-distance(count,4))/distance(count,1))*100;
        
        %Finds equivalent V0
        mi = data.mRI;
        size1 = size(y);
        mf = y(size1(1),5);
        I = max(y(:,9))/(data.massWater*data.g0);
        V0 = I*data.g0*log(mi/mf);
        [distance(count,5),t1,y1,data1] = DistanceObjective([0, 0, minCoefPres, angle, simTime, V0]);
        percentDif(count,2) = ((distance(count,1)-distance(count,5))/distance(count,1))*100;
        count = count + 1;
    end
end

% Plots the 'nominal','no air' and 'purely ballistic' angle vs volume vs
% distance graph
figure(2)
hold on;
[X,Y] = meshgrid(20:stepSize:60,10:stepSize:50);
f = scatteredInterpolant(distance(:,2),distance(:,3),distance(:,1));        %nominal case
f1 = scatteredInterpolant(distance(:,2),distance(:,3),distance(:,4));       %case without air phase
f2 = scatteredInterpolant(distance(:,2),distance(:,3),distance(:,5));       %purely ballistic case
f3 = scatteredInterpolant(distance(:,2),distance(:,3),percentDif(:,1));     %percent difference between nominal and no air phase
f4 = scatteredInterpolant(distance(:,2),distance(:,3),percentDif(:,2));     %percent difference between nominal and purely ballistic case
Z = f(X,Y);
Z1 = f1(X,Y);
Z2 = f2(X,Y);
Z3 = f3(X,Y);
Z4 = f4(X,Y);
nom1 = surf(X,Y,Z,'EdgeColor','black');
noAir1 = surf(X,Y,Z1,'EdgeColor','blue');
ballistic1 = surf(X,Y,Z2,'EdgeColor','green');
colormap hsv
alpha(.5)

% Determines the optimal angle and volume fraction
[M,I] = max(distance(:,1));
bestAngle = distance(I,2);
bestVolume = distance(I,3);
maxDistance = M;

outputString = sprintf('Volume Fraction and Launch Angle vs Distance\nMax Distance of %3.1fm at %2.0f%c with %2.0f%% water\n(psi: %3.1f, Cd: %1.1f)',maxDistance,bestAngle,char(176),bestVolume,maxPressure,minCoefPres);
title(outputString);
xlabel('Launch Angle (deg)');
ylabel('Water Volume Percent');
zlabel('Distance (meters)');
legend([nom1,noAir1,ballistic1],'Nominal','Ignored Air Phase','Purely Ballistic');



% Plots percent difference of 'no air' trials and 'purely ballistic' trials
% with the nominal condition.
figure(3)
hold on;
airDif1 = surf(X,Y,Z3,'EdgeColor','blue');
balDif1 = surf(X,Y,Z4,'EdgeColor','green');
legend([airDif1,balDif1],'Percent Difference (w/o Air)','Percent Difference (ballistic)');
colormap hsv
alpha(.5)

title('Volume Fraction and Launch Angle vs Percent Difference (distance)');
xlabel('Launch Angle (deg)');
ylabel('Water Volume Percent');
zlabel('Percent Difference');


end

