clc
clearvars
close all

method = input('What would you like to minimize?\n"Time" or "Fuel"?\n','s');
data = importdata('BestGuess.txt');
tic
if strcmp(method,'Time')
    x0 = data(2,:);
    x = fminsearch(@objectivefunction2,x0);
elseif strcmp(method,'Fuel')
    x0 = data(1,:);
    x = fminsearch(@objectivefunction1,x0);
else
    error('Not a vaild input');
end

[~,y,IE] = spacecraft_simulator(x(1),x(2));

filename='graph.gif';

s=animatedline('Color','b','LineStyle','--');
bs=animatedline('Color','b','Marker','d','MarkerSize',2);
m=animatedline('Color','r','LineStyle','--');
bm=animatedline('Color','r','Marker','o','MarkerSize',4);
e=animatedline(0,0,'Color','g','Marker','o','MarkerSize',16);
axis([0,3E8,0,4E8])
title('Earth, Moon, S/C Three Body Problem')
xlabel('Distance (m)')
ylabel('Distance (m)')
for i=1:length(y)
    addpoints(s,y(i,5),y(i,6))
    addpoints(bs,y(i,5),y(i,6))
    addpoints(m,y(i,7),y(i,8))
    addpoints(bm,y(i,7),y(i,8))
    drawnow
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if i == 1;
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    elseif rem(i,3)==0
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    else
        continue
    end
    clearpoints(bm)
    clearpoints(bs)
end
mf=animatedline(y(end,7),y(end,8),'Color','r','Marker','o','MarkerSize',4)
cs=animatedline(y(end,5),y(end,6),'Color','r','Marker','*','MarkerSize',4)
legend([s m e mf cs],'Spacecraft Path','Moon Path','Earth','Moon','Crash site')
frame = getframe(1);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,filename,'gif','WriteMode','append');


fprintf('The best delta V is dx=%3.4f m/s and dy=%3.4f m/s\n',x(1),x(2));
toc