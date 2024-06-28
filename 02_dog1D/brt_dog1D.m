clc
clear
%% Grid
xmin=-1;
xmax=11;
%last grid dimension corresponds to discrete states
grid_min = [xmin,1]; % Lower corner of computation domain
grid_max = [xmax,3];  % Upper corner of computation domain
N = [501, 3];        % Number of grid points per dimension
g = createGrid(grid_min, grid_max, N);

%% target set
R = 0.5;
% data0 = shapeCylinder(grid,ignoreDims,center,radius)
data0 = shapeCylinder(g, [2], [9.5], R);
%create target centered at x=9.5 with radius R
%ignoreDims=[2] makes the target appear on all discrete states
% as this time they're being held on the second dim of the grid

%% time vector
t0 = 0;
tMax = 3.0;
dt = 0.05;
tau = t0:dt:tMax;

%% problem parameters
% input bounds
uMax=1;
% control trying to min or max value function? (inside target is negative)
uMode = 'min'; %control wants to reach target set
dMode = 'max'; %unused as system has no disturbance

%% Pack problem parameters
params = [];
% Define dynamic system of a single discrete state
% Dog1D(x, uMax)
sys = Dog1D_q1([0;1],uMax,params);

% Put grid and dynamic systems into schemeData
schemeData.grid = g;
schemeData.dynSys = sys;
schemeData.accuracy = 'high'; %set accuracy
schemeData.uMode = uMode;
schemeData.dMode = dMode;

% Define dynamic system of every single discrete state
schemeData.nq = 3;
schemeData.system_list{1} = Dog1D_q1([0;1],uMax,params);
schemeData.system_list{2} = Dog1D_q2([0;1],uMax,params);
schemeData.system_list{3} = Dog1D_q3([0;1],uMax,params);

%% characterize transitions
[schemeData.reset_map_q12, sys] = dog1D_transition_q12(g, sys);
[schemeData.reset_map_q21, sys] = dog1D_transition_q21(g, sys);
[schemeData.reset_map_q13, sys] = dog1D_transition_q13(g, sys);
%[schemeData.reset_map_q32, sys] = dog1D_transition_q32(g, sys);
% 3to2 transition is not necessary

%% Compute value function
%HJIextraArgs.visualize = true; %show plot
HJIextraArgs.visualize.valueSet = 1;
HJIextraArgs.visualize.initialValueSet = 1;
HJIextraArgs.visualize.figNum = 1; %set figure number
HJIextraArgs.visualize.deleteLastPlot = true; %delete previous plot as you update

% uncomment if you want to see a 2D slice
HJIextraArgs.visualize.plotData.plotDims = [1 0]; %plot x
HJIextraArgs.visualize.plotData.projpt = [1]; %project at mode 1 
%HJIextraArgs.visualize.viewAngle = [0,90]; % view 2D

%[data, tau, extraOuts] = ...
% HJIPDE_hybrid_solve(data0, tau, schemeData, compMethod, extraArgs)
[data, tau2, ~] = ...
  HJIPDE_hybrid_sys_solve(data0, tau, schemeData, 'minDog1D', HJIextraArgs);

xlim([xmin,xmax])
xticks(xmin:1:xmax)
ylim([-1,2])
pbaspect([2 1 1])
