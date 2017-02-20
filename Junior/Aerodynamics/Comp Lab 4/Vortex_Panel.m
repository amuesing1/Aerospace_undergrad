function [cl,Cp] = Vortex_Panel( X,Y,V_inf,alpha,x_upper,x_lower,x_whole,name )
c=1;
alphadeg=alpha;
alpha=(alpha*2*pi)/360;

for i=1:length(X)-1
    x(i)=(X(i+1)+X(i))/2;
    y(i)=(Y(i+1)+Y(i))/2;
    dx(i)=X(i+1)-X(i);
    dy(i)=Y(i+1)-Y(i);
    phi(i)=atan2(dy(i),dx(i));
    SINE(i) = sin(phi(i));
    COSINE(i) = cos(phi(i));
    RHS(i)=sin(phi(i)-alpha);
    S(i)=sqrt((X(i+1)-X(i))^2 + (Y(i+1) - Y(i))^2);
    
end
for i=1:length(X)-1
    for j=1:length(X)-1
%         A= -(x(i) - X(j))*cos(phi(j)) - (y(i) - Y(j))*sin(phi(j));
%         B=(x(i) - X(j))^2 + (y(i) - Y(j))^2;
%         C=sin(phi(i) - phi(j));
%         D=cos(phi(i)-phi(j));
%         E=(x(i)-X(j))*sin(phi(j))-(y(i)-Y(j))*cos(phi(j));
%         F=log(1+(S(j)^2+2*A*S(j))/B);
%         G=atan2((E*S(j)),(B+A*S(j)));
%         P=(x(i)-X(j))*sin(phi(i)-2*phi(j))+(y(i)-Y(j))*cos(phi(i)-2*phi(j));
%         Q=(x(i)-X(j))*cos(phi(i)-2*phi(j))+(y(i)-Y(j))*sin(phi(i)-2*phi(j));
        A = -(x(i) - X(j))*COSINE(j) - (y(i) - Y(j))*SINE(j);
        B = (x(i) - X(j))^2 + (y(i) - Y(j))^2;
        C = sin(phi(i) - phi(j));
        D = cos(phi(i) - phi(j));
        E = (x(i) - X(j))*SINE(j) - (y(i) - Y(j))*COSINE(j);
        F = log(1 + S(j)*(S(j) + 2*A)/B);
        G = atan2(E*S(j),B + A*S(j));
        P = (x(i) - X(j)) * sin(phi(i) - 2*phi(j)) ...
            + (y(i) - Y(j)) * cos(phi(i) - 2*phi(j));
        Q = (x(i) - X(j)) * cos(phi(i) - 2*phi(j)) ...
            - (y(i) - Y(j)) * sin(phi(i) - 2*phi(j));
        if i==j
            C_n1(i,j)=-1;
            C_n2(i,j)=1;
            C_t1(i,j)=pi/2;
            C_t2(i,j)=pi/2;
        else
        C_n2(i,j)=D+.5*Q*F/S(j)-(A*C+D*E)*G/S(j);
        C_n1(i,j)=.5*D*F+C*G-C_n2(i,j);
        C_t2(i,j)=C+.5*P*F/S(j)+(A*D-C*E)*G/S(j);
        C_t1(i,j)=.5*C*F-D*G-C_t2(i,j);
        end
    end
end
for i=1:length(X)-1
    An(i,1)=C_n1(i,1);
    At(i,1)=C_t1(i,1);
    An(i,length(X))=C_n2(i,length(X)-1);
    At(i,length(X))=C_t2(i,length(X)-1);
    An(length(X),1)=1;
    An(length(X),length(X))=1;
    RHS(length(X))=0;
    for j=2:length(X)-1
        An(i,j)=C_n1(i,j)+C_n2(i,j-1);
        An(length(X),j)=0;
        At(i,j)=C_t1(i,j)+C_t2(i,j-1);
    end
end
gamma=An\RHS';
for i=1:length(X)-1
    V(i)=cos(phi(i)-alpha);
    for j=1:length(X)
        V(i)=V(i)+At(i,j)*gamma(j);
        Cp(i)=1-V(i)^2;
    end
end
Gamma=0;
for j=1:length(V)
    Gamma=Gamma+V(j)*S(j);
end
Gamma=Gamma*V_inf;
cl=(2*Gamma)/(V_inf*max(X));

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