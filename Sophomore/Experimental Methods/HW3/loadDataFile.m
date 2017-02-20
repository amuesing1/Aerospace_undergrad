function [output] = loadDataFile(filename)
%Given a filename, parse individual sections
%Treat 'output' as a struct to load individual sections into

%Uses code from http://www.mathworks.com/help/matlab/import_export/import-text-data-files-with-low-level-io.html

%First, get a FILE* to work with
fid = fopen(filename);

% make sure the file is not empty
finfo = dir(filename);
fsize = finfo.bytes;

if (fsize > 0)
    %Read the file section by section, where each section is split up by a comment. The individual parsers take in a
    %FILE* and use the results of fgetl() to determine if the file
    %prematurely ended. Parsers are configured by datatype - the Matrix
    %parser reads things that look like matrices, with #cols >= # rows
    output.vector1 = loadMatrix(fid);
end

end
