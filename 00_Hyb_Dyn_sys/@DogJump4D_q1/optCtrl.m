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

  uOpt{1} = (deriv{3}>=0)*obj.uMax*0.5; %u in x dir 
  uOpt{2} = (deriv{4}>=0)*obj.uMax;%u in z dir

elseif strcmp(uMode, 'min') % when control try to reach target set
  
  uOpt{1} = (deriv{3}>=0)*-1*obj.uMax*0 + (deriv{3}<0)*obj.uMax*0.5;%u in x dir
  %uOpt{2} = (deriv{4}>=0)*-1*obj.uMax + (deriv{4}<0)*obj.uMax;%u in z dir

  %uOpt{1} = (deriv{3}>=0)*0 + (deriv{3}<0)*obj.uMax;%u in x dir
  uOpt{2} = (deriv{4}>=0)*0 + (deriv{4}<0)*obj.uMax;%u in z dir

else
  error('Unknown uMode!')
end