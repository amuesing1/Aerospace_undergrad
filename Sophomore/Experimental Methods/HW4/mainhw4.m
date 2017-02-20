%Jeremy Muesing
%HW4
%Date 10/1/14



function [] = main(file)
%Creates a text file for nominal case, two histograms for deviation of
%pressure and volume.
%   takes input of the provided text file and runs input code to place
%   values into an array. The returned array runs once through the nominal
%   calcWork function provided which is printed into a text file called
%   nominal_case.txt. The input is then run through both the volume and
%   pressure changing calculations 100,000 times. The sum of the work in
%   each cycle is graphed to show the deviation from the 10% changing
%   values.
close all;

n=100000; %Number of runs

%input the file given into array Engineering Process: Given
    inputs = inputhw4(file);
%calculate the work in each process
    workn = calcWork(inputs);
%sum of the work for the cycle
    work_netn = sum(workn);
%placing each into kJ for ease of reading
    into_kj1 = workn./1000;
    into_kj2 = work_netn/1000;
%calculate net work for each cycle 100,000 times for both pressure and
%volume
for i=1:n
    workp = calcWorkp(inputs);
    work_netp(i) = sum(workp);
    workv = calcWorkv(inputs);
    work_netv(i) = sum(workv);
end
%print text file of the nominal case
fileID=fopen('nominal_case.txt','w');
fprintf(fileID,'%20s %20s %20s %20s %30s\r\n', 'Work process 1(kJ)','Work process 2(kJ)','Work process 3(kJ)','Work process 4(kJ)','Net work done by cycle(kJ)');
fprintf(fileID,'%15f %20f %20f %20f %25f ', into_kj1, into_kj2);
fclose(fileID);

%Plot a histogram of each of the results
figure(1)
hist(work_netp, 20);
xlabel('Work (J)');
ylabel('Number of simulations');
strTitle = sprintf('Histogram of Work Done Pressure Variation');
title(strTitle);
strMean = sprintf('Mean: %2.1f, std dev: %2.1f', mean(work_netp), std(work_netp));
legend(strMean);

figure(2)
hist(work_netv, 20);
xlabel('Work (J)');
ylabel('Number of simulations');
strTitle = sprintf('Histogram of Work Done Volume Variation');
title(strTitle);
strMean = sprintf('Mean: %2.1f, std dev: %2.1f', mean(work_netv), std(work_netv));
legend(strMean);
end

