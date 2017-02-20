function [ e ] = method2( t )
%method2

for i=2
    for j=1:10
        e(i-1,j)=t(i,j)/t(i-1,j); 
    end
end

end

