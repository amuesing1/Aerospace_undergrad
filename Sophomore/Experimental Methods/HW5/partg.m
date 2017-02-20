function partg(t,y,A,B,x)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

    z=linspace(-2,2);
    plot(t,y,'*')
    hold on
    plot(z,A+B*z,'r')
    hold on
    plot(z,x(1)+x(2)*z+x(3)*z.^2,'g')
title('Linear and Quadratic Fits to Data');
xlabel('t');
ylabel('y');
legend_stuff = sprintf('y=%1f+%1f t =red\r\n y = %1f + %1f t + %1f t^2 =green', A,B,x(1),x(2),x(3));
legend(legend_stuff);
end

