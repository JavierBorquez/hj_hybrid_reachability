function uOpt = optCtrl(obj, t, y, deriv, uMode, ~)
% uOpt = optCtrl(obj, t, y, deriv, uMode, ~)

if ~(strcmp(uMode, 'max') || strcmp(uMode, 'min'))
  error('uMode must be ''max'' or ''min''!')
end

if ~iscell(y)
  y = num2cell(y);
end

if ~iscell(deriv)
  deriv = num2cell(deriv);
end

uOpt = cell(obj.nu, 1);

% Max/Min Hamiltonian
if strcmp(uMode, 'max')
  uOpt{1} = (deriv{1}>=0)*obj.uMax;
else
  uOpt{1} = (deriv{1}<=0)*obj.uMax;
end


end