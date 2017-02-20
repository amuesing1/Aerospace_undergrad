function [Cp] = Source_Panel(X,Y,V_inf,alpha,x_upper,x_lower,x_whole,name)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:                          %
%                                 %
% X = Boundary Points, x-location %
% Y = Boundary Points, y-location %
% V_inf = Free Speed              %
% alpha = AOA                     %
% option = Plot Option            %
%          Angle = Cp vs. theta   %
%          XoverC = Cp vs. x/c    %
%                                 %
% Output:                         %
%                                 %
% Plots!                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c=1;
alphadeg=alpha;
%%%%%%%%%%%%%%%%%%%%%%
% Convert to Radians %
%%%%%%%%%%%%%%%%%%%%%%

alpha = alpha*pi/180;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Determine the Number of Panels %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = max(size(X,1),size(X,2))-1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Intra-Panel Relationships:                                  %
%                                                             %
% Determine the Control Points, Panel Sizes, and Panel Angles %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:N
    x(i) = 0.5*(X(i)+X(i+1));
    y(i) = 0.5*(Y(i)+Y(i+1));    
    S(i) = sqrt((X(i+1)-X(i))^2+(Y(i+1)-Y(i))^2);    
    phi(i) = atan2((Y(i+1)-Y(i)),(X(i+1)-X(i)));
    beta(i) = phi(i)+pi/2-alpha;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inter-Panel Relationships:             %
%                                        %
% Determine the Integrals between Panels %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:N
    for j = 1:N
        A = -(x(i)-X(j))*cos(phi(j)) - (y(i)-Y(j))*sin(phi(j));
        B = (x(i)-X(j))^2 + (y(i)-Y(j))^2;
        C = sin(phi(i)-phi(j));
        D = (y(i)-Y(j))*cos(phi(i)) - (x(i)-X(j))*sin(phi(i));
        E = (x(i)-X(j))*sin(phi(j)) - (y(i)-Y(j))*cos(phi(j)); 
        %E = sqrt(B-A^2);
        
        if i == j
            In(i,j) = pi;
            Is(i,j) = 0;
        else
            In(i,j) = C*log((S(j)^2+2*A*S(j)+B)/B)/2 + (D-A*C)*(atan((S(j)+A)/E)-atan(A/E))/E;
            
            Is(i,j) = (D-A*C)/(2*E)*log((S(j)^2+2*A*S(j)+B)/B) - C*(atan((S(j)+A)/E)-atan(A/E));
        end
    end
end
             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Construct the Linear System %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

K = zeros(N,N);
F = zeros(N,1);

for i = 1:N
    for j = 1:N
        K(i,j) = In(i,j)/(2*pi);  
    end
    F(i) = -V_inf*cos(beta(i));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve the Linear System %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

lambda = K\F;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Postprocess for Coefficient of Pressure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Vi = zeros(N,1);

for i = 1:N
    Vi(i) = V_inf*sin(beta(i));
    for j = 1:N
        Vi(i) = Vi(i) + lambda(j)*Is(i,j)/(2*pi);
    end
    Cp(i) = 1 - (Vi(i)/V_inf)^2;
end
% figure
% plot(fliplr(x_upper)/c,Cp(1:length(x_upper)),'LineWidth',2)
% hold on
% plot(x_lower(2:end)/c,Cp(length(x_upper):length(x_whole)-1))
% set(gca,'YDir','Reverse')
% xlim([0 c])
% ylim([-1.5 1.5])
% xlabel('x/c')
% ylabel('C_p')
% title(sprintf('NACA %s Airfoil Pressure \\alpha=%d',name,alphadeg))
% legend('Upper Pressure', 'Lower Pressure')
end
