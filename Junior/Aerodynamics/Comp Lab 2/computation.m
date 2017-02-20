function [Stream, Potential, Pressure] = computation(c,alpha,V_inf,p_inf,rho_inf,n,xmin,xmax,ymin,ymax,nx,ny)
    deltax=c/n;
    i=1;
    %finding strength and circulation at every point along the arifoil
    point=linspace(0,c,n);
    for i=1:n-1
        xc(i)=(point(i)+point(i+1))/2;
        theta(i)=acos(1-(2*xc(i)/c));
        strength(i) = 2*alpha*V_inf*((1+cos(theta(i)))/(sin(theta(i))));
        Gamma(i) = strength(i)*deltax;
    end
    yc=0;
    %setting up fucntions to be run over every point in domain
    theta_fun = @(x,xc,y,yc) atan2(-(y-yc),-(x-xc));
    radius_fun = @(x,xc,y,yc) sqrt((x-xc).^2 + (y-yc).^2);
    i=1;
    xspot=1;
    % finding pressure, stream and potentail at every point in the domain
    for x=linspace(xmin,xmax,nx)
        yspot=1;
        for y=linspace(ymin,ymax,ny)
            for i=1:length(xc)
                psi_vortex(i)=(Gamma(i)/(2*pi))*log(radius_fun(x,xc(i),y,yc));
                phi_vortex(i)=(-Gamma(i)/(2*pi))*theta_fun(x,xc(i),y,yc);
                %finding components of velocity
                u(i)=(Gamma(i)*(y-yc))/(2*pi*((x-xc(i))^2)*(((y-yc)^2)/((x-xc(i))^2)+1));
                v(i)=(-Gamma(i)/(2*pi*((x-xc(i)))*((((y-yc)^2)/((x-xc(i))^2)) + 1)));
            end
            psi_uniform=V_inf*(y*cos(alpha)-x*sin(alpha));
            phi_uniform=V_inf*(x*cos(alpha)+y*sin(alpha));
            %adding uniform to vortex for x and y portions of velocity
            u_vel(yspot,xspot)=sum(u)+V_inf*cos(alpha);
            v_vel(yspot,xspot)=sum(v)+V_inf*sin(alpha);
            %adding uniform and vortex flow
            Potential(yspot,xspot)=phi_uniform+sum(phi_vortex);
            Stream(yspot,xspot)=psi_uniform+sum(psi_vortex);
            %magnitude of velocity
            Velocity=sqrt(u_vel(yspot,xspot)^2+v_vel(yspot,xspot)^2);
            Cp=1-(Velocity/V_inf)^2;
            Pressure(yspot,xspot)=Cp*.5*rho_inf*V_inf^2+p_inf;
            yspot=yspot+1;
        end
        xspot=xspot+1;
    end
end

