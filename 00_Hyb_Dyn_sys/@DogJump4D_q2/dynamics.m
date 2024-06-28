function dx = dynamics(obj, ~, x, u, ~)
% DogJumpDynamics

% function dx = dynamics(t, x, u)

%% For reachable set computations
if iscell(x)    
    dx = cell(4,1);
    % dx
    dx{1} = x{3};
    % dz
    dx{2} = x{4};
    % ddx
    dx{3} = 0;
    % ddz
    dx{4} = (- 9.81);
end

%% For simulations
if isnumeric(x)
  error('not implemented!')
end

end
