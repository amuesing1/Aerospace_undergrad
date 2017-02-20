function lab3(input_file)
data=csvread(input_file,3,0);
    i=1;
    j=1;
    matrix=zeros(13,11);
    while j<=13
    while data(i)==j
        k=1;
        while k<=11
        matrix(j,k)=matrix(j,k)+data(i,k);
        k=k+1;
        end
        i=i+1;
    end
    j=j+1;
    end
matrix=matrix./10;
matrix(14,:)=matrix(1,:);

Cp=matrix(:,2)./(.5*matrix(:,11).*matrix(:,4).^2);

%scatter(matrix(:,9),Cp)

Cn=-trapz(matrix(:,9),Cp);
Ca=-trapz(matrix(:,10),Cp);

Cl=Cn*cosd(matrix(1,5))-Ca*sind(matrix(1,5));
Cd=Ca*cosd(matrix(1,5))-Cn*sind(matrix(1,5));
end

