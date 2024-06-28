classdef DogJump4D_q3< DynSys
  properties
    params
    M
    uMax
    l0
    g

  end % end properties
 
  methods
    function obj = DogJump4D_q3(x,uMax,l0,params)
      
      obj.params = params;
      obj.M = 1;
      obj.uMax = uMax;
      obj.l0 = l0;
      obj.g = 10;
          
      if numel(x) ~= 4
        error('Initial state does not have right dimension!');
      end      
      
      % Process initial state
      obj.x = x;
      obj.xhist = x;
      
      obj.nx = 4;
      obj.nu = 2;
      obj.nd = 0;       
      
    end % end constructor        
  end % end methods
end % end class