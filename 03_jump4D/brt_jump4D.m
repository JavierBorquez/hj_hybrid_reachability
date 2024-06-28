clc
clear
%% Grid (x,z,xdot,zdot,q)
grid_min = [-0.1; -0.1; -10; -10; 1]; % Lower corner of computation domain x z dx dz
grid_max = [4.1; 1.9; 10; 10; 3];     % Upper corner of computation domain
N = [42+1; 20+1; 20+1; 20+1; 3];      % .1 xz resolution .2dxdz resolution
%N = [84+1; 40+1; 40+1; 40+1; 3];;      % double resolution
g = createGrid(grid_min, grid_max, N);

%% target set
R = 0.25;
tar_pos = [3.5, 1.5, 0.0, 0.0, 1]; %xz center

% data0 = shapeCylinder(grid,ignoreDims,center,radius)
data0 = shapeCylinder(g, [3; 4; 5], tar_pos, R);
%ignoreDims=[3; 4; 5] makes the target appear on all discrete states
% and for all xy velocities

%% time vector
t0 = 0;
tMax = 1.0;
dt = 0.02;
tau = t0:dt:tMax;

%% problem parameters
% input bounds
uRange = 30; % 35N max
%dRange = 0;
% max height of robot's leg extension limit
leg_max = 0.5;

% control trying to min or max value function?
uMode = 'min'; %reach target set
dMode = 'max'; %

%% Pack problem parameters
params=[];
% Define dynamic system of a single discrete state
% Roundabout3D3q(x,heading,v,omega,params)
sys = DogJump4D([0;0;0;0;1],uRange,leg_max,params);

% Put grid and dynamic systems into schemeData
schemeData.grid = g;
schemeData.dynSys = sys;
schemeData.accuracy = 'high'; %set accuracy
schemeData.uMode = uMode;
schemeData.dMode = dMode;

% Define dynamic system of every single discrete state
schemeData.nq = 3;
schemeData.system_list{1} = DogJump4D_q1([0;0;0;0],uRange,leg_max,params);
schemeData.system_list{2} = DogJump4D_q2([0;0;0;0],uRange,leg_max,params);
schemeData.system_list{3} = DogJump4D_q3([0;0;0;0],uRange,leg_max,params);

%% characterize transitions
[schemeData.reset_map_q12, sys] = jump4D_transition_q12(g, sys);
[schemeData.reset_map_q21, sys] = jump4D_transition_q21(g, sys);
[schemeData.reset_map_q13, sys] = jump4D_transition_q13(g, sys);
[schemeData.reset_map_q23, sys] = jump4D_transition_q23(g, sys);

%% Compute value function
%HJIextraArgs.visualize = true; %show plot
HJIextraArgs.visualize.valueSet = 1;
HJIextraArgs.visualize.initialValueSet = 1;
HJIextraArgs.visualize.figNum = 1; %set figure number
HJIextraArgs.visualize.deleteLastPlot = true; %delete previous plot as you update
%HJIextraArgs.obstacleFunction = obstacle;

% uncomment if you want to see a 2D slice
HJIextraArgs.visualize.plotData.plotDims = [1 1 0 0 0]; %plot xz
HJIextraArgs.visualize.plotData.projpt = [0 0 1]; %project at dx=dz=0 and q1
%HJIextraArgs.visualize.viewAngle = [0,90]; % view 2D

%% calc brt

%[data, tau, extraOuts] = ...
% HJIPDE_hybrid_sys_solve(data0, tau, schemeData, compMethod, extraArgs)
[data, tau2, extraOuts] = ...
    HJIPDE_hybrid_sys_solve(data0, tau, schemeData, 'minJump4D', HJIextraArgs); 

pbaspect([4 2 1]);
yline(0);
yline(sys.l0,'-','l0');

%% Prepare for Save
dogJump_onlyReach_brt.data=data;
dogJump_onlyReach_brt.sys=sys;
dogJump_onlyReach_brt.g=g;
dogJump_onlyReach_brt.schemeData=schemeData;
dogJump_onlyReach_brt.tau2=tau2;