function rv = plot_data(numgroups,M,M0,m,R,g,beta,r,k,tau,class_set)
%Lab 4 - 2003 Dynamics & Systems
%Chad Eberl
%Jeremy Muesing
%Josh Mellin

%Purpose:  This is code for lab 4 for ASEN 2003

%Inputs: numgroups = number of groups being read
%        M = mass of the wheel [kg]
%        M0 = mass of the trailing apparatus [kg]
%        m = mass of added rod [kg]
%        R = radius of wheel [m]
%        g = gravity [m/s^2]
%        beta = angle of the ramp [deg]
%        r = distance from center of wheel to extra mass [m]
%        k = radius of gyration [m]
%        tau = torque due to friction [N*m]
%        class_set = determines if we are reading the class set or our own
%          data set. If class_set == 1, it is the class data set, otherwise
%          it is our own data set.

%Outputs: rv = 1 means it was successful
%         Plots for the data sets with the modeled angular
%         velocity plotted as well.
%         Residuals for the angular velocity of the data compared to the
%         model.

if class_set == 1
    str = ' Class Data Set';
else str = ' Our Data Set';
end


where = [.1 .1 .5 .5]; %Where the plots are displayed on the screen
nbins = 20; %number of bins for the histograms
titlefont = 16; %font size for the title
axesfont = 14; %font size for the axes

balance = 1; %If balance == 1, then the system is balanced

timevec = NaN * ones(40,numgroups);
thetavec = NaN * ones(40,numgroups);
omegavec = NaN * ones(40,numgroups);
residuals = [];

unbal_timevec = NaN * ones(40,numgroups);
unbal_thetavec = NaN * ones(40,numgroups);
unbal_omegavec = NaN * ones(40,numgroups);
unbal_residuals = [];

% Read in our data sets
for j = 1:numgroups

[time,theta,omega] = read_data(j,balance,class_set);
[time2,theta2,omega2] = read_data(j,balance+1,class_set);

[~,omegasim1] = balanced_wheel(M,M0,R,g,beta,k,theta);
[~,omegasim2] = unbalanced_wheel(M,M0,m,R,g,beta,r,k,tau,theta2);

timevec(1:length(time),j) = time;
thetavec(1:length(theta),j) = theta;
omegavec(1:length(omega),j) = omega;

unbal_timevec(1:length(time2),j) = time2;
unbal_thetavec(1:length(theta2),j) = theta2;
unbal_omegavec(1:length(omega2),j) = omega2;

% find the residuals for the data
residual = (omega - omegasim1);
residuals = [residuals; residual];

residual2 = (omega2 - omegasim2);
unbal_residuals = [unbal_residuals; residual2];

end

% find the vector for the balanced and unbalanced wheel models
theta = linspace(.5,15,200);
[thetasim1,omegasim1] = balanced_wheel(M,M0,R,g,beta,k,theta);
[thetasim2,omegasim2] = unbalanced_wheel(M,M0,m,R,g,beta,r,k,tau,theta);

% plot the data for the balanced wheel
balanced = figure('units','normalized','outerposition',where);
subplot(2,1,1)
hold on
plot(thetasim1,omegasim1,'k');
plot(thetavec,omegavec,'x');
ttle = strcat('Omega vs. Theta -> Balanced ',str);
title(ttle,'FontSize',titlefont);
xlabel('Theta [rad]','FontSize',axesfont);
ylabel('Omega [rad/sec]','FontSize',axesfont);
legend('Model','Data Values');
hold off

% plot the histogram of the residuals
subplot(2,1,2)
residuals = residuals/std(residuals);
histfit(residuals,nbins);
h = findobj('Type','Line');
set(h(1),'Color',[.25 .85 .25]);
axis([-5,5,0,max(hist(residuals,nbins))+1]);
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[1 .5 0],'EdgeColor','k');
title('Histogram of Residuals','FontSize',titlefont);
xlabel('\sigma (sigma)','FontSize',axesfont);
ylabel('Number of Counts','FontSize',axesfont);

% plot the data for the unbalanced wheel
unbalanced = figure('units','normalized','outerposition',where);
subplot(2,1,1)
hold on
plot(thetasim2,omegasim2,'k');
plot(unbal_thetavec,unbal_omegavec,'x');
ttle2 = strcat('Omega vs. Theta -> Unbalanced ',str);
title(ttle2,'FontSize',titlefont);
xlabel('Theta [rad]','FontSize',axesfont);
ylabel('Omega [rad/sec]','FontSize',axesfont);
legend('Model','Data Values');
hold off

% plot the histogram of the residuals
subplot(2,1,2)
unbal_residuals = unbal_residuals/std(unbal_residuals);
histfit(unbal_residuals,nbins);
h = findobj('Type','Line');
set(h(1),'Color',[.25 .85 .25]);
axis([-5,5,0,max(hist(unbal_residuals,nbins))+1]);
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[1 .5 0],'EdgeColor','k');
title('Histogram of Residuals','FontSize',titlefont);
xlabel('\sigma (sigma)','FontSize',axesfont);
ylabel('Number of Counts','FontSize',axesfont);

fprintf('%s %20.2f\n','Balanced:',mean(residuals))
fprintf('%s %18.2f\n','Unbalanced:',mean(unbal_residuals))


rv = 1; %success

balancetitle = strcat('balanced_',num2str(class_set));
balancetitle = strcat(balancetitle,'.png');
saveas(balanced,balancetitle);

unbalancetitle = strcat('unbalanced_',num2str(class_set));
unbalancetitle = strcat(unbalancetitle,'.png');
saveas(unbalanced,unbalancetitle);


end



