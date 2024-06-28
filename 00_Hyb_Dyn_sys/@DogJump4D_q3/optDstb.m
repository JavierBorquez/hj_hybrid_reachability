function dOpt = optDstb(obj, ~, y, deriv, dMode, ~)
% dOpt = optDstb(obj, t, y, deriv, ~, ~)

if ~iscell(y)
  y = num2cell(y);
end

if ~iscell(deriv)
  deriv = num2cell(deriv);
end

% Determinant for sign of control
%det = deriv{1}.*cos(obj.theta_r) + deriv{2}.*sin(obj.theta_r);

% Max/Min Hamiltonian
if strcmp(dMode, 'max')
  %dOpt = (det>0)*obj.dMax;
  dOpt = 0;
else
  %dOpt = (det<0)*obj.dMax;
  dOpt = 0;
end

end