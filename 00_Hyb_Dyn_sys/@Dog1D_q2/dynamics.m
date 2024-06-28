function dx = dynamics(obj, t, x, u, d)
% function dx = dynamics(t, x, u)
%     Dynamics of the Dog1D system on mode 2, crouch walking
%     dx{1} = x_dot;

%% For reachable set computations
if iscell(x)
    dx = cell(1,1);
    dx{1} = 1.*u{1};
end

%% For simulations
if isnumeric(x)
  error('not implemented!')
end

end
