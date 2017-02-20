function parth(uncer_A,uncer_B,sigma_A,sigma_B,sigma_C)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here
uncer_line=uncer_A+uncer_B;
uncer_poly=sigma_A*2+sigma_B+sigma_C;

fileID = fopen('parth.txt','w');
crap='uncertainty with line = %1f\r\n';
fprintf(fileID,crap,uncer_line);
crap='uncertainty with quadratic = %1f';
fprintf(fileID,crap,uncer_poly);
fclose(fileID);
end

