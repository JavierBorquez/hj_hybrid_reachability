function dOpt = optDstb(obj, ~, y, deriv, dMode, ~)
% dOpt = optDstb(obj, t, y, deriv, ~, ~)

if ~iscell(y)
  y = num2cell(y);
end

if ~iscell(deriv)
  deriv = num2cell(deriv);
end

% Determinant for sign of control
det = deriv{1}.*cos(obj.heading) + deriv{2}.*sin(obj.heading);

dOpt = cell(obj.nd, 1);
% Max/Min Hamiltonian
if strcmp(dMode, 'max')%goes max speed or half speed depending on gradient
  dOpt = (det>0)*obj.vd + (det<0)*obj.vd*0.5;
elseif strcmp(dMode, 'min')
  dOpt = (det<0)*obj.vd + (det>0)*obj.vd*0.5;  
elseif strcmp(dMode, 'constant')
  dOpt = obj.vd;
else
    error('selected dMode not implemented!')
end

end