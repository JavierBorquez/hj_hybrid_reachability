clear; clc; close all;

%% Grid
grid_min = [-15;-15;-0.1;1]; % Lower corner of computation domain
grid_max = [ 15; 15; 3.4;3]; % Upper corner of computation domain
N = [ 31;  31;  11; 3]; 
%N = [ 301;  301;  11; 3];
g = createGrid(grid_min, grid_max, N);

%% target set
R = 5;
% data0 = shapeCylinder(grid,ignoreDims,center,radius)
data0 = shapeCylinder(g, [3 4], [0; 0; 0; 1], R);
%ignoreDims=[3; 4] makes the target appear on all discrete states
% and for all z-timer

%% time vector
t0 = 0;
tMax = 5.0;
dt = 0.1;
tau = t0:dt:tMax;

%% problem parameters
vu = 3;
vd = 4;
omega = 1.0;
heading = 2*pi/3;

% control trying to min or max value function?
%uMode = 'max'; %escape target set
%dMode = 'min'; %enter target set
uMode = 'constant'; %
dMode = 'constant'; %

%% Pack problem parameters
params=[];
% Define dynamic system
% Roundabout3D3q(x,heading,v,omega,params)
sys = airColl3D_q1([0;0;0],heading,vu,vd,omega,params);

% Put grid and dynamic systems into schemeData
schemeData.grid = g;
schemeData.dynSys = sys;
schemeData.accuracy = 'high'; %set accuracy
schemeData.uMode = uMode;
schemeData.dMode = dMode;

schemeData.nq = 3;
schemeData.system_list{1} = airColl3D_q1([0;0;0],heading,vu,vd,omega,params);
schemeData.system_list{2} = airColl3D_q2([0;0;0],heading,vu,vd,omega,params);
schemeData.system_list{3} = airColl3D_q1([0;0;0],heading,vu,vd,omega,params);
%we can reuse mode one as mode 3 as the dynamics are identical

%% characterize transitions
[schemeData.reset_map_q12, sys.params] = airColl3D_transition_q12(g, sys.params);
[schemeData.reset_map_q23, sys.params] = airColl3D_transition_q23(g, sys.params);

%% Compute value function
%HJIextraArgs.visualize = true; %show plot
HJIextraArgs.visualize.valueSet = 1;
HJIextraArgs.visualize.initialValueSet = 1;
HJIextraArgs.visualize.figNum = 1; %set figure number
HJIextraArgs.visualize.deleteLastPlot = true; %delete previous plot as you update

% uncomment if you want to see a 2D slice
HJIextraArgs.visualize.plotData.plotDims = [1 1 0 0]; %plot xy
HJIextraArgs.visualize.plotData.projpt = [0 1]; %project at z=0 and q1
%HJIextraArgs.visualize.viewAngle = [0,90]; % view 2D

%% calc brt

%[data, tau, extraOuts] = ...
% HJIPDE_hybrid_sys_solve(data0, tau, schemeData, compMethod, extraArgs)
[data, tau2, extraOuts] = ...
    HJIPDE_hybrid_sys_solve(data0, tau, schemeData, 'minAirColl3D', HJIextraArgs);

%% Prepare for Save
% roundabout_brt.data=data;
% roundabout_brt.sys=sys;
% roundabout_brt.g=g;
% roundabout_brt.schemeData=schemeData;
% roundabout_brt.tau2=tau2;
