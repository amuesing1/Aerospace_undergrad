function WindTunnel()

count = 1;
for lab = [11:14]
    for speed = [1:20]
        outputString = sprintf('lab0%d_cylinder_%d.csv',lab,speed);
        yn = exist(outputString,'file');
        if yn ~= 0
            [ClC(:,count),CdC(:,count),CpC(:,count)] = Cylinder(outputString);
            airspeed(count) = speed;
            count = count + 1;
        end
    end
end

count = 1;
for lab = [11:14]
    for angleTmp = [-10:20]
        outputString = sprintf('lab0%d_airfoil_%d.csv',lab,angleTmp);
        yn = exist(outputString,'file');
        if yn ~= 0
            [ClA(:,count),CdA(:,count),CnA(:,count),CaA(:,count),CpA(:,count),dx,dy] = Airfoil(outputString);
            angle(count) = angleTmp;
            count = count + 1;
        end
    end
end


numCylinder = size(ClC);
figure(1);
for k = 1:numCylinder(2)
   cylinderLegend{k,1} = sprintf('%d m/s',airspeed(k));
end
theta = 0:15:360;
plot(theta,CpC)
xlim([0 360]);
legend(cylinderLegend,'Location','northeastoutside');
xlabel('Azimuthal Angle (deg)');
ylabel('Coefficient of Pressure');
title('Coefficients of Pressure');
set(gca,'YDir','reverse');


numAirfoil = size(ClA);
figure(2);
for k = 1:numAirfoil(2)
   airfoilLegend{k,1} = sprintf('%d deg',angle(k));
end
plot(dx,CpA)
legend(airfoilLegend,'Location','northeastoutside');
xlabel('X/C');
ylabel('Coefficient of Pressure');
title('Coefficients of Pressure');
set(gca,'YDir','reverse');



figure(3);
hold all;
symbols = ['+','o','*','x','d','s','p','h','^','v','>','<'];
count = 1;
for k = [1:numAirfoil(2)]
    if count > 12
        count = 1;
    end
    plots(k) = scatter(angle(k),ClA(:,k),symbols(count));
    count = count + 1;
end
for k = 1:numAirfoil(2)
   angleLegend{k,1} = sprintf('%d deg',angle(k));
end
legend(plots,angleLegend,'Location','northeastoutside');
xlabel('Angle (deg)');
ylabel('Coefficient of Lift');
title('Coefficient of Lift vs Angle');
end

