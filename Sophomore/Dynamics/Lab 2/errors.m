function [ e1,e2,e3 ] = errors( h,ts,t,stdh1,stdh2,stdt1,stdt2,stdts )

g=9.81;

e1=sqrt(((1/h(2))/(2*((h(1)/h(2))^(.5)))*stdh1)^2 +(((-h(1)/(h(2)^2))/(2*((h(1)/h(2))^(.5))))*stdh2)^2);

e2=sqrt(((1/t(2))*stdt1)^2 + ((-t(1)/(t(2))^2)*stdt2)^2);

e3=sqrt((((2*((2*h(1))/g)^(.5))/((ts+((2*h(1))/g))^2))*stdts)^2+((((-2*ts)/(g*((2*h(1))/g))+2*g)/((ts+((2*h(1))/g))^2))*stdh1)^2);
end

