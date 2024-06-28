function dOpt = optDstb(obj, ~, y, deriv, dMode, ~)
% dOpt = optDstb(obj, t, y, deriv, ~, ~)

if ~iscell(y)
  y = num2cell(y);
end

if ~iscell(deriv)
  deriv = num2cell(deriv);
end

% Max/Min Hamiltonian
if strcmp(dMode, 'max')
  dOpt = 0;
else
  dOpt = 0;
end

end