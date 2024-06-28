classdef airColl3D_q1< DynSys
  properties
    params
    heading
    vu
    vd
    omega
  end % end properties
 
  methods
    function obj = airColl3D_q1(x,heading,vu,vd,omega,params)
      
      obj.heading = heading; %constant relative heading for maneuver
      obj.vu = vu;           %control speed
      obj.vd = vd;           %disturbance speed
      obj.omega = omega;     %angular speed
      obj.params = params;   
          
      if numel(x) ~= 3
        error('Initial state does not have right dimension!');
      end      
      
      % Process initial state
      obj.x = x;
      obj.xhist = x;
      
      obj.nx = 3;
      obj.nu = 1;
      obj.nd = 1;       
      
    end % end constructor        
  end % end methods
end % end class