clear all
close all
clc

global g
g=9.81;

data=load('8am_3_16_test1');


groups=1:13;
tests=1:2;
counter=0;
for i=1:length(groups)
    for j=1:length(tests)
        [data_all_holder,counter,existance]=read_data(groups(i),tests(j),counter);
        if existance==1
            data_all(:,:,counter)=data_all_holder;
        end
    end
end

sizing=size(data_all);

t_step=1/1652;
for i=1:size(data_all)
    time(i)=t_step*i;
end

plot(time,data_all(:,3,4))


for i=1:sizing(3)
    [deltav,ISP(i)]=Isp(1.161,.154,data_all(:,:,i));
    [thrust]=interpolation(data_all(:,:,i));

    max_thrust(i)=max(thrust(:,2));
    avg_thrust(i)=mean(thrust(:,2));

end
figure()
plot(thrust(:,1),thrust(:,2));
xlabel('Time (s)');
ylabel('Force (N)')

% t_step=1/1652;
% for i=1:size(data)
%     time(i)=t_step*i;
% end
% 
% plot(time,data(:,3))