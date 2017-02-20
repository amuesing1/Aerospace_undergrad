% Jeremy Muesing
% ASTR 3750
% crater_project.m
% Created 11/17/16
% Modified 12/1/16

close all
clear all
clc
% There are effectively two parts to this code. The first is to run the
% simulation until saturation is reached. The second is run to provide an
% image of the surface past saturation. Both layer the surface with craters
% but in order to do multiple simulations for Monte Carlo, the two parts
% are separated because computation time is significantly reduced if the 
% simulation is stopped at saturation.

v = sqrt((6.67E-11*1.989E30)/228.9E9); %speed of object at 1.5 AU (Mars)
rho_p = 3.93; %g/cm^3 (Mars)
g = 3.711; %planet gravity (Mars)
frac_rim = .5; %fraction of the rim that can be removed before "erased"
frac_A = .75; %fraction of area that can be removed before "erased"
number = 200; %Max number of craters
sim_num = 100; %number of simulations

% Part C
for a=1:sim_num
    A_cov = zeros(1,number);
    rim_cov = zeros(1,number);
    is_cov =  zeros(1,number);
    time2sat(a)=0;
    for i=1:number
        if time2sat(a)==0;
            x(i) = 500*rand;
            y(i) = 500*rand;
%     We can only count craters with diameter larger than 10 but inevitably
%     there will be "planet destroyers" that will hit. To keep this
%     simulation void of impacts that would erase the entire area, the
%     maximum size crater is specified to be the largest on Earth.
            D(i)=0;
            while D(i)<10 | D(i)>250
                    theta(i) = 90*rand; %angle at which the impactor hits
                    rho_i(i) = 7.3*rand;
                    while rho_i(i)<1.3
                        rho_i(i)=7.3*rand; %density of objects are in range of 1.3-7.3
                    end                    % http://palaeo.gly.bris.ac.uk/communication/brana/equation.html
%             The next line is to create an exponential curve regarding
%             the size of the impactors. The density of the impactor is a
%             random distribution but the frequency of the impactor
%             decreases with size. The 1E4 is to make the craters more 
%             realistic for computation time. The bounds set at the 
%             beginning of the loop specify which craters are too small to 
%             count and so big they erase too much area. The E4 doesn't 
%             change the craters made, it simply puts them on the correct
%             order of magnitude more often.
                    R_i(i) = 1/(1E4*rand);
                    m(i) = (4/3)*R_i(i)^3*rho_i(i); %mass of impactor

                    D(i) = (2*rho_i(i).^.11*R_i(i).^.12*(.5*m(i)*v^2).^.22*(sind(...
                        theta(i))).^(1/3))/(rho_p^.33*g^.22);
            end
%     Calculating which craters are covered
            for j = 1:i-1
                if i-j>=1
                    d = sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
                    r = D(i)/2;
                    R = D(j)/2;
%             This is an equation to determine the area of intersecting
%             circles. http://mathworld.wolfram.com/Circle-CircleIntersection.html
                    A_real = r^2*acos((d^2+r^2-R^2)/(2*d*r))+...
                        R^2*acos((d^2+R^2-r^2)/(2*d*R))-...
                        .5*sqrt((-d+r+R)*(d+r-R)*(d-r+R)*(d+r+R));
                    A_real = real(A_real);
%             The same page gives intersecting chords of the circles
                    chord = .5*sqrt((-d+r+R)*(d+r-R)*(d-r+R)*(d+r+R));
                    chord = real(chord);
%             http://mathworld.wolfram.com/CircularSegment.html
                    angle = 2*asin(chord/(2*R));
                    rim_real = real(angle)*R;
                    A_cov(j) = A_cov(j)+A_real;
                    rim_cov(j) = rim_cov(j)+rim_real;
%             is the center covered | Area covered | Rim covered
                    if d<(D(i)/2) | A_cov(j)/(pi*(D(j)/2)^2)>frac_A |...
                            rim_cov(i)/(pi*D(i))>frac_rim
                        is_cov(j)=1;
                    end
                end
                time(i) = i*1000;
                num_o_craters(i) = length(D)-sum(is_cov);
%                 The next section is determining if the surface is
%                 saturated. If the newest crater erases or finishes
%                 erasing an old crater, the program checks if the new
%                 crater could have gone anywhere else without erasing any
%                 craters. If it can, that crater is placed in its original
%                 location, not the new one. The simulation then continues
%                 to create craters until this is not that case and stops
%                 at the saturation point.
                try_again=1;
                if is_cov(j)==1
                    for x_test=1:500
                        for y_test=1:500
                            if try_again==1
                                d = sqrt((x_test-x(j))^2+(y_test-y(j))^2);
                                A_test = r^2*acos((d^2+r^2-R^2)/(2*d*r))+...
                                    R^2*acos((d^2+R^2-r^2)/(2*d*R))-...
                                    .5*sqrt((-d+r+R)*(d+r-R)*(d-r+R)*(d+r+R));
                                A_test = real(A_test);
                                chord = .5*sqrt((-d+r+R)*(d+r-R)*(d-r+R)*(d+r+R));
                                chord = real(chord);
                                angle = 2*asin(chord/(2*R));
                                rim_test = real(angle)*R;
%                                 The area/rim taken up changes from the
%                                 original location and is acounted for by
%                                 real and test variables for each.
                                new_A = A_cov(j)-A_real+A_test;
                                new_rim = rim_cov(j)-rim_real+rim_test;
                                if d<(D(i)/2) | new_A/(pi*(D(j)/2)^2)>frac_A |...
                                        new_rim/(pi*D(i))>frac_rim
                                    try_again=1;
                                else
                                    try_again=0;
                                end
                                if x_test==500 & y_test==500
                                    time2sat(a)=i*1000;
                                end
                            end
                            if time2sat(a)>0
                                try_again=0;
                            end
                        end
                    end
%                     Sloppy but it allows creaters to be deleted without
%                     messing up the indices used for time.
                    D(j)=0;
                    x(j)=-500;
                    y(j)=-500;
                end
            end
        end
    end
    close all
%     Yeah I know this is sloppy but it is the result of trying to run a
%     monte carlo simulation and provide a single example plot of those
%     simulations without writing the code 3 times
    figure
    plot(time,num_o_craters)
    xlabel('Time (yr)')
    ylabel('Number of visable craters')
    title('Number of visable craters over time')
    clear x y D num_o_craters time
end

% Part B
for i=1:number
    x(i) = 500*rand;
    y(i) = 500*rand;
    D(i)=0;
    while D(i)<10 | D(i)>250
        theta(i) = 90*rand; %angle at which the impactor hits
        rho_i(i) = 7.3*rand;
        while rho_i(i)<1.3
            rho_i(i)=7.3*rand; %density of objects are in range of 1.3-7.3
        end                    % http://palaeo.gly.bris.ac.uk/communication/brana/equation.html
        R_i(i) = 1/(1E4*rand);
        m(i) = (4/3)*R_i(i)^3*rho_i(i); %mass of impactor

        D(i) = (2*rho_i(i).^.11*R_i(i).^.12*(.5*m(i)*v^2).^.22*(sind(...
                theta(i))).^(1/3))/(rho_p^.33*g^.22);
    end
end

average_time2sat=mean(time2sat);

% Plotting
figure
histfit(time2sat,round(sim_num/4))
xlabel('Years to saturation')
ylabel('# of simulations')
title('Monte Carlo regarding saturation of surface')

%plot 1
figure
scatter(x(1:round(number/4)),y(1:round(number/4)),pi*(D(1:round(number/4))...
    ./4).^2,'filled','MarkerEdgeColor',[0 0 0],'LineWidth',1)
xlabel('distance (km)')
ylabel('distance (km)')

%plot 2
figure
scatter(x(1:round(number/2)),y(1:round(number/2)),pi*(D(1:round(number/2))...
    ./4).^2,'filled','MarkerEdgeColor',[0 0 0],'LineWidth',1)
xlabel('distance (km)')
ylabel('distance (km)')

%plot 3
figure
scatter(x(1:round(3*number/4)),y(1:round(3*number/4)),pi*(D(1:...
    round(3*number/4))./4).^2,'filled','MarkerEdgeColor',[0 0 0],'LineWidth',1)
xlabel('distance (km)')
ylabel('distance (km)')

%full
figure
scatter(x,y,pi*(D./4).^2,'filled','MarkerEdgeColor',[0 0 0],'LineWidth',1)
xlabel('distance (km)')
ylabel('distance (km)')