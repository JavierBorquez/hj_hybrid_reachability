classdef Dog1D_q2< DynSys
  properties
    params
    uMax
  end % end properties
 
  methods
    function obj = Dog1D_q2(x,uMax,params)
      
      obj.uMax = uMax;
      obj.params = params;   
          
      if numel(x) ~= 2
        error('Initial state does not have right dimension!');
      end      
      
      % Process initial state
      obj.x = x;
      obj.xhist = x;      
      obj.nx = 1;
      obj.nu = 1;
      obj.nd = 0;       
      
    end % end constructor        
  end % end methods
end % end class