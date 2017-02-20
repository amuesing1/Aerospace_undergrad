function [ e ] = method1( h )
%Method1

for i=2:3
    for j=1:10
        e(i-1,j)=(h(i,j)/h(i-1,j))^(.5);
    end
end

end

