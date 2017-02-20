function [ e ] = method3( t,h )
%method3

g=9.81;

if size(h)~=size(t)
    printf('Sizes do not match')
end

for i=1:10
    e(1,i)=(t(1,i)-sqrt((2*h(1,i))/g))/(t(1,i)+sqrt((2*h(1,i))/g));
end

