function ca=cacode(svnum)
%function ca=cacode(svnum);
%  function to generate any of the 32 GPS C/A codes
%
% Input Arguments:
% svnum - the Satellite's PRN number
%
% Output Argument
% ca - a 1023 element vector containing the desired output sequence
%
% DM Akos - AA272d - Spring 2000

% the g2s vector holds the appropriate shift of the g2 code to generate
% the C/A code (ex. for SV#19 - use a G2 shift of g2shift(19,1)=471)
g2s = [5;6;7;8;17;18;139;140;141;251;252;254;255;256;257;258;469;470;471; ...
       472;473;474;509;512;513;514;515;516;859;860;861;862;145;52;886;1012;130];

g2shift=g2s(svnum,1);
           
% Generate G1 code
     %   load shift register
          reg = -1*ones(1,10);
     %
     for i = 1:1023,
         g1(i) = reg(10);
         save1 = reg(3)*reg(10);
         reg(1,2:10) = reg(1:1:9);
         reg(1) = save1;
     end,
%
% Generate G2 code
%
     %   load shift register
           reg = -1*ones(1,10);
     %
     for i = 1:1023,
         g2(i) = reg(10);
         save2 = reg(2)*reg(3)*reg(6)*reg(8)*reg(9)*reg(10);
         reg(1,2:10) = reg(1:1:9);
         reg(1) = save2;
     end,
     %
     %    Shift G2 code
     %
     g2tmp(1,1:g2shift)=g2(1,1023-g2shift+1:1023);
     g2tmp(1,g2shift+1:1023)=g2(1,1:1023-g2shift);
     %
     g2 = g2tmp;
%
%  Form single sample C/A code by multiplying G1 and G2 point by point
%
ca = g1.*g2;
