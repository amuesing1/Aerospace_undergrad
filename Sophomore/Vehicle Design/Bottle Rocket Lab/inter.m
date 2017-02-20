function [F, dmrdt] = inter(t)
global thrust dmdt
time = thrust(:, 1);
Fs = thrust(:, 2);

t_i = time(1);
t_f = time(end);

if (t_i < t) && (t < t_f)
	% If data is within provided thrust data, interpolate
	% Find nearest time value
	id = find(time < t, 1, 'last');
	% Grab the values of time and force surrounding desired value
	t_floor = time(id);
	t_ceil = time(id +1);
	F_floor = Fs(id);
	F_ceil = Fs(id +1);
	% Calculate slope
	dt = t_ceil - t_floor;
	dF = F_ceil - F_floor;
	m = dF/dt;
	% Use linear interpolation to find value
	F = m*(t-t_floor) + F_floor;
	dmrdt = dmdt;
else
	% Outside provided thrust values. Assume zero
	F = 0;
	dmrdt = 0;
end
end