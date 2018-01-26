close all
clear all
clc

time_interval=2; % days
years=time_interval/252;
names={'AAPL', 'XOM', 'AXP', 'LMT', 'NYT', 'WMT','NKE', 'AET', ...
    'ALCO', 'ALE', 'BMY', 'BRT', 'CAT', 'DCO', 'DD', 'DIS', 'EMR', 'FDX', ...
    'FL', 'GE', 'GTY', 'IBM', 'JNJ', 'KO', 'LLY', 'MMM','MO','MRK','MSI',...
    'NAV','NC','PBI','PCG','PEI','PEP','PFE','SJW','SPA','SYY','TXN','UIS'...
    ,'UTX','WFC','WY','XRX'};
for i=1:length(names)
    filename{i}=strcat(names(i),'_buying_patterns.txt');
    reference_file_names{i}=strcat(names(i),'_buying_patterns');
    load(char(filename{i}));
    
    variable_name=char(strcat(names(i),'_buying_patterns'));
    variable=eval(variable_name);
    if isempty(variable)==0
        figure(1)
        plot(1980+years*variable(:,1),variable(:,4))
        hold on
        legend(names);
        xlabel('Year')
        ylabel('Total Alpha Value')
        title('Total Alpha value of Stocks over time')

        figure(2)
        plot(1980+years*variable(:,1),variable(:,2))
        hold on
        legend(names);
        xlabel('Year')
        ylabel('Beta Values')
        title('Beta value of Stocks over time')

        figure(3)
        plot(1980+years*variable(:,1),variable(:,3))
        hold on
        legend(names);
        xlabel('Year')
        ylabel('Alpha Values')
        title('Alpha value of Stocks over time')
    end
end