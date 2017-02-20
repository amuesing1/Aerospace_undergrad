function[omega, theta, theta_deg, v_actual, emptyfile] = loadfile(volts)

% Defaults
omega = []; theta = []; v_actual = []; theta_deg = [];

filename = sprintf('Lab3_%d.txt',volts);
    if exist(filename)
        emptyfile = false;
        v = load(filename);
        rev=v(1,2)/360;
        theta_total=v(:,2)-360*floor(rev);
        i=1;
        while theta_total(i) < (theta_total(1) +7*360)
            theta_deg(i) = theta_total(i);
            omega(i) = v(i,4)*(pi/180);
            theta(i) = v(i,2)*(pi/180);
            v_actual(i) = v(i,5)/1000;
            i=i+1;
        end
    else
        emptyfile = true;
        disp('File does not exist. Yet globals are still awesome.')
    end
end