function [A] = pairings(N,M)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
A=zeros(2,N,M);
top=linspace(1,N,N);
for i=1:M
    A(:,:,i)=[top;randperm(N)];
    % Don't pair students with themselves
    while isempty(find(A(1,:,i)==A(2,:,i)))==0
            A(2,:,i)=randperm(N);
    end
    for j=1:M
        if i~=j
            while isempty(find(A(2,:,i)==A(2,:,j)))==0
                if i>j
                    A(2,:,i)=randperm(N);
                    while isempty(find(A(1,:,i)==A(2,:,i)))==0
                        A(2,:,i)=randperm(N);
                    end
                elseif j>i
                    A(2,:,j)=randperm(N);
                    while isempty(find(A(1,:,i)==A(2,:,i)))==0
                        A(2,:,i)=randperm(N);
                    end
                end
            end
        end
    end
end

end

