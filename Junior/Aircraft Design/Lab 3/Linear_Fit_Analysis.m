% Chris Choate
% ASEN 3128
% Linear_Fit_Analysis.m
% Created 2/20/2016

% Height Variation
Pz = polyfit(aircraft_state_array.time,aircraft_state_array.data(:,3),1);
Lz = Pz(1)*aircraft_state_array.time+Pz(2);
Rz = max(abs(Lz-aircraft_state_array.data(:,3)));
peaksz = [0,0];
k = 1;

for j = 3:length(aircraft_state_array.time)
    if  abs(Lz(j)-aircraft_state_array.data(j,3)) > Rz*0.10
        timezsettle = (aircraft_state_array.time(j));
    end
    if aircraft_state_array.data(j,3)-aircraft_state_array.data(j-1,3) <0 && aircraft_state_array.data(j-1,3)-aircraft_state_array.data(j-2,3) >0
        peaksz(k) = aircraft_state_array.time(j);
        k = k+1;
    end
end

% Forward Velocity Variation
Pu = polyfit(aircraft_state_array.time,aircraft_state_array.data(:,7),1);
Lu = Pu(1)*aircraft_state_array.time+Pu(2);
Ru = max(abs(Lu-aircraft_state_array.data(:,7)));
peaksu = [0,0];
k = 1;

for j = 3:length(aircraft_state_array.time)
    if  abs(Lu(j)-aircraft_state_array.data(j,7)) > Ru(j)*0.1
        timeusettle = (aircraft_state_array.time(j));
    end
    if aircraft_state_array.data(j,7)-aircraft_state_array.data(j-1,7) <0 && aircraft_state_array.data(j-1,7)-aircraft_state_array.data(j-2,7) >0
        peaksu(k) = aircraft_state_array.time(j);
        k = k+1;
    end
end

% Vertical Velocity Variation
Pw = polyfit(aircraft_state_array.time,aircraft_state_array.data(:,9),1);
Lw = Pw(1)*aircraft_state_array.time+Pw(2);
Rw = max(abs(Lw-aircraft_state_array.data(:,9)));
peaksw = [0,0];
k = 1;

for j = 3:length(aircraft_state_array.time)
    if  abs(Lw(j)-aircraft_state_array.data(j,9)) > Rw*0.10
        timewsettle = (aircraft_state_array.time(j));
    end
    if aircraft_state_array.data(j,9)-aircraft_state_array.data(j-1,9) <0 && aircraft_state_array.data(j-1,9)-aircraft_state_array.data(j-2,9) >0
        peaksw(k) = aircraft_state_array.time(j);
        k = k+1;
    end
end

% X-Axis Rotation Variation
Pp = polyfit(aircraft_state_array.time,aircraft_state_array.data(:,10),1);
Lp = Pp(1)*aircraft_state_array.time+Pp(2);
Rp = max(abs(Lp-aircraft_state_array.data(:,10)));
peaksp = [0,0];
k = 1;

for j = 3:length(aircraft_state_array.time)
    if  abs(Lp(j)-aircraft_state_array.data(j,10)) > Rp*0.10
        timepsettle = (aircraft_state_array.time(j));
    end
    if aircraft_state_array.data(j,10)-aircraft_state_array.data(j-1,10) <0 && aircraft_state_array.data(j-1,10)-aircraft_state_array.data(j-2,10) >0
        peaksp(k) = aircraft_state_array.time(j);
        k = k+1;
    end
end

% Y-Axis Rotation Variation
Pq = polyfit(aircraft_state_array.time,aircraft_state_array.data(:,11),1);
Lq = Pq(1)*aircraft_state_array.time+Pq(2);
Rq = max(abs(Lq-aircraft_state_array.data(:,11)));
peaksq = [0,0];
k = 1;

for j = 3:length(aircraft_state_array.time)
    if  abs(Lq(j)-aircraft_state_array.data(j,11)) > Rq*0.10
        timeqsettle = (aircraft_state_array.time(j));
    end
    if aircraft_state_array.data(j,11)-aircraft_state_array.data(j-1,11) <0 && aircraft_state_array.data(j-1,11)-aircraft_state_array.data(j-2,11) >0
        peaksq(k) = aircraft_state_array.time(j);
        k = k+1;
    end
end

% Z-Axis Rotation Variation
Pr = polyfit(aircraft_state_array.time,aircraft_state_array.data(:,12),1);
Lr = Pr(1)*aircraft_state_array.time+Pr(2);
Rr = max(abs(Lr-aircraft_state_array.data(:,12)));
peaksr = [0,0];
k = 1;

for j = 3:length(aircraft_state_array.time)
    if  abs(Lr(j)-aircraft_state_array.data(j,12)) > Rr*0.10
        timersettle = (aircraft_state_array.time(j));
    end
    if aircraft_state_array.data(j,12)-aircraft_state_array.data(j-1,12) <0 && aircraft_state_array.data(j-1,12)-aircraft_state_array.data(j-2,12) >0
        peaksr(k) = aircraft_state_array.time(j);
        k = k+1;
    end
end

% Calculate Periods
perz = diff(peaksz);
peru = diff(peaksu);
perw = diff(peaksw);
perp = diff(peaksp);
perq = diff(peaksq);
perr = diff(peaksr);