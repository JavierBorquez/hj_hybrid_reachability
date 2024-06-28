function dx = dynamics(obj, t, x, u, d)
% function dx = dynamics(t, x, u)
%     dx{1} = xr_dot;
%     dx{2} = yr_dot;
%     th_dot not needed
%     dx{3} = z_dot;

vu=obj.vu;
vd=obj.vd;
heading=obj.heading;
omega=obj.omega;

%% For reachable set computations
if iscell(x)
    dx = cell(3,1);
    dx{1} = -u + d.*cos(heading);
    dx{2} =      d.*sin(heading);
    dx{3} = 0;
end

%% For simulations
if isnumeric(x)
  error('not implemented!')
end

end
