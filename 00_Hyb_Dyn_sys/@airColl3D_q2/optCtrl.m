function uOpt = optCtrl(obj, t, y, deriv, uMode, ~)
% uOpt = optCtrl(obj, t, y, deriv, uMode, ~)

if ~iscell(y)
  y = num2cell(y);
end

if ~iscell(deriv)
  deriv = num2cell(deriv);
end

uOpt = cell(obj.nu, 1);

% Max/Min Hamiltonian
if strcmp(uMode, 'max') %goes max speed or half speed depending on gradient
  uOpt = (deriv{1}<0)*(obj.vu) + (deriv{1}>0)*(obj.vu)*0.5;
elseif strcmp(uMode, 'min')
  uOpt = (deriv{1}>0)*(obj.vu) + (deriv{1}<0)*(obj.vu)*0.5;
elseif strcmp(uMode, 'constant')
  uOpt = obj.vu;
else
    error('selected uMode not implemented!')
end

end