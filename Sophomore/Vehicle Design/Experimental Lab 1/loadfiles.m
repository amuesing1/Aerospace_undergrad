function [ data,counter,existy ] = loadfiles( group,clean,wind,counter )
 if group<10
        filename = sprintf('Group0%d_%s_%s.csv',group,clean{:},wind{:});
    if exist(filename)
        data = csvread(filename,5,2);
        counter=counter+1;
        existy=1;
    else
        disp('File does not exist. Moving onto next file.')
        data=[];
        counter=counter;
        existy=0;
    end
 else
filename = sprintf('Group%d_%s_%s.csv',group,clean{:},wind{:});
    if exist(filename)
        data = csvread(filename,5,2);
        counter=counter+1;
        existy=1;
    else
        disp('File does not exist. Moving onto next file.')
        data=[];
        counter=counter;
        existy=0;
    end
 end
end