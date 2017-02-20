close all
clear all
clc

% constraints for types of oils per crude
Cons(1,1) = .1; Cons(2,1) = .3; Cons(3,1) = .2; Cons(4,1) = .25;
Cons(1,2) = .6; Cons(2,2) = .2; Cons(3,2) = .1; Cons(4,2) = 0;
Cons(1,3) = .35; Cons(2,3) = .25; Cons(3,3) = .28; Cons(4,3) = 0;
Cons(1,4) = .25; Cons(2,4) = .29; Cons(3,4) = .2; Cons(4,4) = .15;

% profit margin for each oil
P=[-5 -3 -6 -8];

% creating profit vector for each crude (A & B)
Profit=0;
for i=1:4
    Profit=Profit+P(i).*Cons(i,:);
end

% uperlimit vector (C)
uplim(1,1) = 25000;
uplim(2,1) = 30000;
uplim(3,1) = 30000;
uplim(4,1) = 35000;

% lower limit vector (D)
lowlim(1,1) = 0;
lowlim(2,1) = 0;
lowlim(3,1) = 0;
lowlim(4,1) = 0;

% constraints of each type of oil (E)
Conso(1,1) = 35000;
Conso(2,1) = 20000;
Conso(3,1) = 25000;
Conso(4,1) = 4000;

[CrudeOpt,POpt] = linprog (Profit,Cons,Conso,[],[],lowlim,uplim);


fileID = fopen('HW7output1.txt','w');
fprintf(fileID,'# of barrels of Crude 1 = %.f\n',CrudeOpt(1));
fprintf(fileID,'# of barrels of Crude 2 = %.f\n',CrudeOpt(2));
fprintf(fileID,'# of barrels of Crude 3 = %.f\n',CrudeOpt(3));
fprintf(fileID,'# of barrels of Crude 4 = %.f\n',CrudeOpt(4));
fprintf(fileID,'Maximum Profit = $%.f\n',-POpt);
fclose(fileID);