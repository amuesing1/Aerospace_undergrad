function [time,theta,omega] = read_data(trial,balance,class)
%Lab 4 - 2003 Dynamics & Systems
%Chad Eberl
%Jeremy Muesing
%Josh Mellin

%Purpose:  This is code for lab 4 for ASEN 2003

%Summary: Reads data file into matlab and outputs necessary variables for analysis
%   Inputs: balance tells whether or not the wheel was balanced.  If
%       balance = 1, then the wheel was balanced.  If balance = 0, then the
%       wheel was unbalanced.  Trial is what trial number we are reading in.
%       Class tells whether this is class data or not.  1 means class data,
%       2 means our data.

%   Outputs: time [sec], theta [rad], and omega [rad/sec] from the data
%       file that was read

if class == 1
    str1 = strcat('balanced_',num2str(trial));
    str1 = strcat(str1,'_class');
    
    str2 = strcat('unbalanced_',num2str(trial));
    str2 = strcat(str2,'_class');
else
    str1 = strcat('balanced_',num2str(trial));
    str2 = strcat('unbalanced_',num2str(trial));
end
    
if balance == 1
    filename = [str1 '.txt'];
    if ~exist(filename)
        disp('file does not exist')
    end
else 
    filename = [str2 '.txt'];
    if ~exist(filename)
        disp('file does not exist')
    end
end

data = load(filename);

%assign the columns to their respective variables
time = data(:,1);
theta = data(:,2);
omega = data(:,3);

%Clip the data for the radians going from .5 to 15
start = find(theta > .5);
stop = find(theta > 15) - 1;

time = time(start:stop);
theta = theta(start:stop);
omega = omega(start:stop);

end