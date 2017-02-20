function [ output, retval] = loadMatrix( fid )
%Parse a data file for a matrix (could be up to nxn)
%We're looking for a max nxn matrix (works for matrices where rows < cols)
%Comments lead with a #

%Algorithm: 
% Skip lines until we see a first vector line
% Count elements, determine size of force matrix as n
% Read n-1 lines as row vectors (checking for EOF)
% Return a matrix with each row vector vercatted together
shouldEnd = 0;
retval = 0;
colCount = 0;
firstFound = 0;
rowsToRead = 0;

while ~shouldEnd
    %Read a line
    n = fgetl(fid);
    if (n == -1) %at eof
           shouldEnd = 1;
           break;
    end
    
    %Check for data, comments begin with '#'
    if (n(1)== '#')
        continue;
    end
    
    %Parse the line
    theLine = sscanf(n, '%d')';
    
 
        
    if (firstFound == 0)
        %For the first line only
        rowsToRead = size(theLine,2) - 1;
        colCount = size(theLine,2);
        output = ones(1, colCount);
        firstFound = 1;
    end
    
    output = vertcat(output, theLine);
    
    if (rowsToRead == 0)
        shouldEnd = 1;
    end
    rowsToRead = rowsToRead - 1;
end

%Strip off the initial seed row
output = output(2:end, :);

end

