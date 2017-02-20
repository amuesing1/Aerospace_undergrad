function [Cp] = Source_Panel(X,Y,V_inf,alpha)

alpha = (2*pi*alpha)/360;

%% Define the Panels

Panel_Number = length(X) - 1;

for i = 2:(Panel_Number + 1)
    x(i-1) = (X(i) + X(i-1))/2;
    y(i-1) = (Y(i) + Y(i-1))/2;
    dx(i-1) = X(i) - X(i-1);
    dy(i-1) = Y(i) - Y(i-1);
    PHI(i-1) = atan2(dy(i-1),dx(i-1));
    Beta(i-1) = PHI(i-1) + pi/2 - alpha;
end

%% Make the A Matrix

% For each i panel, find the I values with respect to every j panel
for i = 1:Panel_Number
    for j = 1:Panel_Number
        if i == j
            a(i,j) = 1/2;
        else
        S = sqrt((X(j+1)-X(j))^2 + (Y(j+1) - Y(j))^2);
        A = -(x(i) - X(j))*cos(PHI(j)) - (y(i) - Y(j))*sin(PHI(j));
        B = (x(i) - X(j))^2 + (y(i) - Y(j))^2;
        C = sin(PHI(i) - PHI(j));
        D = (y(i) - Y(j))*cos(PHI(i)) - (x(i) - X(j))*sin(PHI(i));
        E = (x(i) - X(j))*sin(PHI(j)) - (y(i) - Y(j))*cos(PHI(j));
        Piece_1 = log((S^2 + 2*A*S + B)/B);
        Piece_2 = (atan((S+A)/E) - atan(A/E));
        if 1 == isreal(Piece_1) && 1 == isreal(Piece_2)
            I(i,j) = (C/2)*Piece_1 + ((D-A*C)/E) * ...
            Piece_2;
            Partial_Mess(i,j) = ((D-A*C)/(2*E))*Piece_1 - ...
            C * Piece_2;
        else
            I(i,j) = 0.25;
            Partial_Mess(i,j) = 0.25;
        end
            a(i,j) = I(i,j)/(2*pi);
        end
    end
end

%% Get the b matrix
b = (-V_inf * cos(Beta))';

%% Make sure there are no infinite values
for i = 1:length(a)
    for j = 1:length(a)
        if a(i,j) < -10000
            a(i,j) = -10000;
        end
        if a(i,j) > 10000
            a(i,j) = 10000;
        end
    end
end

%% Solve for the x matrix (Lambda values)
Lambda = inv(a)*b;
Lambda = Lambda';

%% Solve for the velocity
for i = 1:Panel_Number
    Summation = 0;
    for j = 1:Panel_Number
        if i == j
            Summation = Summation;
        else
            Summation = Summation + (Lambda(j)/(2*pi))*Partial_Mess(i,j);
        end
    end
    Vi(i) = V_inf*sin(Beta(i)) + Summation;
    
    Cp(i) = 1 - (Vi(i)/V_inf)^2;
end

end