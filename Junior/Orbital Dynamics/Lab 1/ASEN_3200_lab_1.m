clear all
close all
clc


%% part 1
% super complicated data reading since filesizes are different
count=1;
limit=600; %number of data points
for i={'manual','computer'}
    for j={'mems','phys'}
        filename=char(strcat(i,'_',j));
        if exist(filename, 'file')
            temp(:,:)=load(filename);
            data(count,:,:)=temp(10:limit,:); %start were real data starts
            
            
            % line of best fit
            fit=polyfit(data(count,:,3),data(count,:,2),1);
            x=linspace(min(data(count,:,3)),max(data(count,:,3)),length(data));
            %finding position
            for l=1:length(data)-1
                position_correction(count,l)=((data(count,l,2)-fit(2))...
                    /fit(1))*(data(count,l+1,1)-data(count,l,1));
                position(count,l)=data(count,l,3)*(data(count,l+1,1)...
                    -data(count,l,1));
            end
            
            % names for variable titles
            type1=char(i);
            type2=char(j);
            
            %graphing rate vs voltage
            figure
            hold on
            plot(data(count,:,3),data(count,:,2))
            plot(x,fit(1)*x+fit(2),'Linewidth',2)
            xlabel('Input rate (rad/s)')
            ylabel('Gyro Output (V)')
            legend('Data','Line of Best Fit')
            title(sprintf('Rate vs Voltage: %s control with %s gyro',type1,type2))
            hold off
            
            %graphing positions vs time
            figure
            hold on
            plot(data(count,1:end-1,1),position(count,:),'.-')
            plot(data(count,1:end-1,1),position_correction(count,:),'Linewidth',2)
            xlabel('Time (s)')
            ylabel('Position (rad)')
            legend('Position from raw data','Position with bias and sensitivity corrections')
            title(sprintf('Position vs Time: %s control with %s gyro',type1,type2))
            
            count=count+1;
            clear temp
        end
    end
end

%% part 2

clear all

count=1;
figure
hold on
for i={'1','2','3','4','45','5'}
    filename=char(strcat('torque_',i));
    if exist(filename, 'file')
        temp(:,:)=load(filename);
        data(count,:,:)=temp(:,:);
        
        fit=polyfit(data(count,7:end-15,1),data(count,7:end-15,3),1);
        x=linspace(min(data(count,:,1)),max(data(count,:,1)),length(data));
        
        % calculating MOI
        MOI(count)=max(data(:,2))/fit(1); %kg*m^2
        
        
        plot(data(count,:,1),data(count,:,3),'Linewidth',2)
        plot(x,fit(1)*x+fit(2),'--','HandleVisibility','off')
        type1=char(i);
        
        xlabel('Time (s)')
        ylabel('Angular Velocity (rad/s)')
        title('Torque Wheel')
        
        
        count=count+1;
        clear temp
    end
end
plot(x,ones(size(x))*146)
legend('\tau=.1','\tau=.2','\tau=.3','\tau=.4','\tau=.45','\tau=.5')

