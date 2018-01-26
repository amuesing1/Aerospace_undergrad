close all; clear all; clc;
profile on
files = dir('*.txt');

%% Uncomment to plot all at once
%figHandle=figure;
%hold on

%static plots all separate
for text = files'
    data = load(text.name);
    time = data(:,1);
    x_S = data(:,2);%input our actual spacecraft position data
    y_S = data(:,3);
    x_M = data(:,4);
    y_M = data(:,5);
    
    r_E = 6371000;
    x_E = 0:r_E;
    y_E = sqrt((r_E)^2-(x_E).^2);
    
    theta_M = 42.5;
    r_EM = 384403;
    
    figure
    plot(x_S, y_S, x_M, y_M, x_E, y_E);
    C = strsplit(text.name, '_');
    obj = C{1,2};
    clr = C{1,3};
    title(['Obejctive ',obj,', with clearance ',clr,' at 0.5 m/s precision']);
    xlabel('X position in space [m]');
    ylabel('Y position in space [m]');
    legend('Spacecraft','Moon','Location','SE');
    %figure(figHandle);
    %plot(x_S, y_S, x_M, y_M, x_E, y_E);
end

%% Uncomment to plot 1 animation 
%plot 1 animation
% data_A=load('Optimum_1_100000_0p5.txt');
% x_S=data_A(:,2); y_S=data_A(:,3);
% x_M=data_A(:,4); y_M=data_A(:,5);
% figure
% h1 = animatedline('Color',[1 0 0]);
% h2 = animatedline('Color',[0 0 1]);
% for k = 1:50:length(x_S)
%     addpoints(h1,x_S(k),y_S(k));
%     drawnow
%     addpoints(h2,x_M(k),y_M(k));
%     drawnow
% end

profile viewer
