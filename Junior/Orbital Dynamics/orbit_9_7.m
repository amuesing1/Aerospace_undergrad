close all
clear all
clc

data=load('9_7_data.txt');

%% 9.7
mass=sum(data(:,1));
pos_vec=[0 0 0];
for i=1:3
    for j=1:length(data)
        pos_vec(i)=pos_vec(i)+((1/mass)*data(j,1)*data(j,i+1)); 
        I_p=mass*[(pos_vec(2)^2+pos_vec(3)^2) -pos_vec(1)*pos_vec(2) ...
            -pos_vec(1)*pos_vec(3);-pos_vec(1)*pos_vec(2) (pos_vec(1)^2+pos_vec(3)^2) ...
            -pos_vec(2)*pos_vec(3); -pos_vec(1)*pos_vec(3) -pos_vec(2)*pos_vec(3) ...
            (pos_vec(1)^2+pos_vec(2)^2)];
    end
end

I_o=0;
for i=1:length(data)
   I_o=I_o+ data(i,1)*[(data(i,3)^2+data(i,4)^2) -data(i,2)*data(i,3) ...
            -data(i,2)*data(i,4);-data(i,2)*data(i,3) (data(i,2)^2+data(i,4)^2) ...
            -data(i,3)*data(i,4); -data(i,2)*data(i,4) -data(i,3)*data(i,4) ...
            (data(i,2)^2+data(i,3)^2)];
end

I_G=I_o-I_p;

%% 9.8
C=[1 2 2];
Q=C/norm(C);

I_x=Q*I_o*Q';