%% get reset map mode ver
function [reset_map, sys] = dog_jump_onlyReach_transition_q12(grid, sys)

% define state jump rules for all states, modify this based on your system
x1_post_f = @x_f1;
x2_post_f = @x_f2;
x3_post_f = @x_f3;
x4_post_f = @x_f4;
x5_post_f = @x_f5;

state_fcn_arr = {x1_post_f; x2_post_f; x3_post_f; x4_post_f; x5_post_f};
sys.params.state_fcn_arr_q12 = state_fcn_arr;%%<----------------dont forget to rename

N = grid.N; % grid num vector
% how many elements in grid, = N(1)*N(2)*N(3)
ind = 1:prod(N); 
% generate 3d indices https://www.mathworks.com/help/matlab/ref/ind2sub.html
% If It's a n-dims system, change to [I1, I2, I3, ... In], 
% and change following
[I1, I2, I3, I4, I5] = ind2sub(N, ind); 

I1_reset = I1; % indectors for reset map dim1
I2_reset = I2; % dim2
I3_reset = I3;
I4_reset = I4;
I5_reset = I5;

for j = ind % loop through the reset map

    i_tmp = [I1(j); I2(j); I3(j); I4(j); I5(j)];
    i_post = i_tmp;

    % check if this state satisify the state reset condition
    if resetmap_trigger_event(grid, i_tmp, sys)
        x_tmp = index2state(grid,i_tmp);
        x_post = x_tmp;
        % if so, calculate states after state jumping
        for k = 1:length(state_fcn_arr)
            x_post(k) = state_fcn_arr{k}(x_tmp,grid);
        end
        % convert back to corresponding grid indices
        i_post = state2index(grid, x_post);
    end

    I1_reset(j) = i_post(1);
    I2_reset(j) = i_post(2);
    I3_reset(j) = i_post(3);
    I4_reset(j) = i_post(4);
    I5_reset(j) = i_post(5);
end
% reshape back to 1d indices
reset_map = sub2ind(N, I1_reset, I2_reset, I3_reset, I4_reset, I5_reset); 
end

% state jump rule for 1st dim, x
function x1_post = x_f1(x,~)
  x1_post = x(1);
end

% state jump rule for 2nd dim, z
function x2_post = x_f2(x,~)
  x2_post = x(2);
end

% state jump rule for 3rd dim, dx
function x3_post = x_f3(x,~)
  x3_post = x(3);
end

% state jump rule for 4th dim, dz
function x4_post = x_f4(x,~)
  x4_post = x(4);
end

% state jump rule for 5th dim, q config
function x5_post = x_f5(~,~)
  x5_post = 2;
end

function is_reset = resetmap_trigger_event(grid, i_t, sys)
  % check if the state reset condition has been triggered for current index
  % 1 - reset event triggered, 0 - others
  is_reset = 0;
  eps = 1e-5;
  % get state for this index
  x_ref = index2state(grid, i_t);
  % check based on current state
  if (x_ref(5)==1 && x_ref(2)>sys.l0)  
    is_reset = 1;
  end
  
end

function i_t = state2index(grid, x_t)
  % convert current state to grid indices
  i_t = ceil((x_t-grid.min)./grid.dx)+1;
  i_t=min([max([ones(grid.dim,1) i_t],[],2) grid.N],[],2); %keep inside index bounds
end

function x_t = index2state(grid, i_t)
% convert current grid index to state
x_t = (i_t-1).*grid.dx + grid.min;
end