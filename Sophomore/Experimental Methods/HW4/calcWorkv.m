%Jeremy Muesing
%HW4
%Date 10/1/14



function[WorkInEachProcess] = calcWorkv(inputs)
% This function calculates the work done for each process given the number
% of processes, the polytropic index and the pressure and voloume of each
% state. The work for each process is returned in the the variable
% WorkInEachProcess and the net work is returned in the variable
% NetWorkCycle. 
% This function assumes that all processes are polytropic.
%Engineering Process: Assumptions
numProcess = length(inputs);

for k = 1:(numProcess-1)
    % if the process is a constant volume (i.e. Polytropic == -1) there is 
    % no work done by the system otherwise we calculate the work done by 
    % the system using eq'n (2) on page 40 of 'Introduction to thermal 
    % systems engineering' by Moran if Polytropic = 1 otherwise eq'n (1) 
    % on page 39 of 'Introduction to thermal systems engineering' by Moran
    % is used.
    
    %the input of volume in the 3rd column is varried by 10%
    inputs(2,3)=inputs(2,3)+.1.*inputs(2,3).*randn(1);
    n = inputs(k,1);
    p1 = inputs(k,2);
    p2 = inputs(k+1,2);
    v1 = inputs(k,3);
    v2 = inputs(k+1,3);
    
    %Engineering Process: fundamental principles
        if n == -1
            WorkInEachProcess(k) = 0.0;
        elseif n == 1        
            WorkInEachProcess(k) = (p1*v1)*log(v2/v1);
        else
            WorkInEachProcess(k) = (p2*v2-p1*v1)/(1-n);
        end
end

% Work done for the last process is handled separately, since indexing
% breaks down at the final process, where we use the state properties in the
% final and initial states
n = inputs(k+1,1);
p1 = inputs(k+1,2);
p2 = inputs(1,2);
v1 = inputs(k+1,3);
v2 = inputs(1,3);
if n == -1
    WorkInEachProcess(k+1) = 0.0;
elseif n == 1   
    WorkInEachProcess(k+1) = (p1*v1)*log(v2/v1);
else
    WorkInEachProcess(k+1) = (p2*v2-p1*v1)/(1-n);
end

end