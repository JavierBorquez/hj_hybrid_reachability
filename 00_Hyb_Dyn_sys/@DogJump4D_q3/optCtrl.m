function uOpt = optCtrl(obj, t, y, deriv, uMode, ~)
% uOpt = optCtrl(obj, t, y, deriv, uMode, ~)
% DogJumpCtrl

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

if strcmp(uMode, 'max') % when control try to avoid target

  uOpt{1} = 0; %u in x dir 
  uOpt{2} = 0;%u in z dir

elseif strcmp(uMode, 'min') % when control try to reach target set
  
  uOpt{1} = 0;%u in x dir
  uOpt{2} = 0;%u in z dir

else
  error('Unknown uMode!')
end