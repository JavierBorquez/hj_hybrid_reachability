%% get reset map mode ver
function [reset_map, sys] = dog1D_transition_q32(grid, sys)

% define state jump rules for all states, modify this based on your system
x1_post_f = @x_f1;
x2_post_f = @x_f2;

state_fcn_arr = {x1_post_f; x2_post_f};
sys.params.state_fcn_arr_q12 = state_fcn_arr;

N = grid.N; % grid num vector
% how many elements in grid, = N(1)*N(2)*N(3)
ind = 1:prod(N); 
% generate 3d indices https://www.mathworks.com/help/matlab/ref/ind2sub.html
% If It's a n-dims system, change to [I1, I2, I3, ... In], 
% and change following
[I1, I2] = ind2sub(N, ind); 

I1_reset = I1; % indectors for reset map dim1
I2_reset = I2; % dim2

for j = ind % loop through the reset map

    i_tmp = [I1(j); I2(j)];
    i_post = i_tmp;
    % check if this state satisify the state reset condition
    if resetmap_trigger_event(grid, i_tmp)
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
end
% reshape back to 1d indices
reset_map = sub2ind(N, I1_reset, I2_reset); 
end

% state jump rule for 1st dim, xpos
function x1_post = x_f1(x,grid)
  x1_post = x(1);
end

% state jump rule for 2nd dim, q config
function x2_post = x_f2(x,grid)
  x2_post = 2; 
end

function is_reset = resetmap_trigger_event(grid, i_t)
  % check if the state reset condition has been triggered for current index
  % 1 - reset event triggered, 0 - others
  is_reset = 0;
  % get state for this index
  x_ref = index2state(grid, i_t);
  % check based on current state
  if (x_ref(2)==3)  %if in q3 
    is_reset = 1;
  end  
end

function i_t = state2index(grid, x_t)
  % convert current state to grid indices
  i_t = round((x_t-grid.min)./grid.dx)+1;
  i_t=min([max([ones(grid.dim,1) i_t],[],2) grid.N],[],2); %keep inside index bounds
end

function x_t = index2state(grid, i_t)
% convert current grid index to state
x_t = (i_t-1).*grid.dx + grid.min;
end