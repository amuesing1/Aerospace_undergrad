function [ data,counter,existance ] = read_data(groups,tests,counter )

filename = sprintf('Group%d_test%d.txt',groups,tests);
if exist(filename)
    data=load(filename);
    counter=counter+1;
    existance=1;
else
    disp('File does not exist');
    data=[];
    counter=counter;
    existance=0;
end

end

