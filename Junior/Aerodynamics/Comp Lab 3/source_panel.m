function [Cp] = source_panel( X,Y,V_inf,alpha )

alpha=(alpha*2*pi)/360;

for i=2:length(X)
    x(i-1)=(X(i)+X(i-1))/2;
    y(i-1)=(Y(i)+Y(i-1))/2;
    dx(i-1)=x(i-1)*2;
    dy(i-1)=y(i-1)*2;
    phi(i-1)=atan2(dy(i-1),dx(i-1));
    beta(i-1)=phi(i-1)+pi/2-alpha;
    
end
for i=1:length(X)-1
    b(i,1)=-V_inf*cos(beta(i));
    for j=1:length(X)-1
        A=-(x(i)-X(j))*cos(phi(j))-(y(i)-Y(j))*sin(phi(j));
        B=(x(i)-X(j))^2+(y(i)-Y(j))^2;
        C=sin(phi(i)-phi(j));
        D=(y(i)-Y(j))*cos(phi(i))-(x(i)-X(j))*sin(phi(i));
        E=sqrt(B-A^2);
        Sj=sqrt((X(j+1)-X(j))^2+(Y(j+1)-Y(j))^2);
        I(i,j)=(C/2)*log((Sj^2+2*A*Sj+B)/B)+((D-A*C)/E)*(atan((Sj+A)/E)-atan(A/E));
        ds(i,j)=((D-A*C)/(2*E))*log((Sj^2+2*A*Sj+B)/B)-C*(atan((Sj+A)/E)-atan(A/E));
        if (i)==j
            matrixA(i,j)=1/2;
        elseif 1 == isreal(I(i,j)) && 0==isnan(I(i,j))
            matrixA(i,j)=I(i,j)/(2*pi);
        else
            I(i,j)=0.25;
            ds(i,j)=0.25;
            matrixA(i,j)=I(i,j)/(2*pi);
        end
    end
end
for i=1:length(matrixA)
    for j=1:length(matrixA)
        if matrixA(i,j)<-1000
            matrixA(i,j)=-1000;
        end
        if matrixA(i,j)>1000
            matrixA(i,j)=1000;
        end
    end
end


x=matrixA\b;


for i=1:length(X)-1
    source=0;
    for j=1:length(X)-1
        if i==j
            source=source;
        else
        source=source+(x(j)/(2*pi))*ds(i,j);
        end
    end
    Vi(i)=V_inf*sin(beta(i))+source;

    Cp(i)=1-(Vi(i)/V_inf).^2;
end

end