load ex06_environment.mat;
[r, c] = size(mat);
%mat(7, 10) = 1;
target = [10, 20];
%mat = [
%    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
%    0 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0;
%    0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0;
%    0 1 0 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0;
%    0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0;
%    0 1 0 1 0 1 0 1 0 0 0 0 0 0 0 0 0 0 1 0;
%    0 1 0 1 0 1 0 1 1 1 1 1 1 1 1 1 1 0 1 0;
%    0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0;
%    0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0;
%    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
%];
mat(start(1), start(2)) = 0.1;
h = imagesc((1:c)+0.5,(1:r)+0.5,mat);
color = fliplr([0.1:0.1:0.7])';
colormap([1 1 1; [ones(7, 1) color color];0 0 1; 0 1 0; 0 0 0;]);
axis equal;

neighbor = [0, 0, 0, 0];
last_neighbor = [0, 0, 0, 0];
heuristic = [0, 0, 0, 0];
_north = 1;
_west = 2;
_south = 3;
_east = 4;
now = start;
prob_red_long = 0.01;
prob_approach_targ = 0.02;
prob_follow_obj = 0.02;
step_count = 0;

while (now(1) != target(1) || now(2) != target(2))
    % set neighbor
    try neighbor(_north) = mat(now(1) - 1, now(2)); % north
    catch neighbor(_north) = 1;
    end
    try neighbor(_south) = mat(now(1) + 1, now(2)); % south
    catch neighbor(_south) = 1;
    end
    try neighbor(_west) = mat(now(1), now(2) - 1); % west
    catch neighbor(_west) = 1;
    end
    try neighbor(_east) = mat(now(1), now(2) + 1); % east
    catch neighbor(_east) = 1;
    end
    heuristic = 1 - neighbor;
    dist = target - now;
    % prioritize to reduce longer distance
    if abs(dist(1)) <= abs(dist(2))
        heuristic(_east) *= (1 + prob_red_long);
        heuristic(_west) *= (1 + prob_red_long);
    else
        heuristic(_south) *= (1 + prob_red_long);
        heuristic(_north) *= (1 + prob_red_long);
    end
    % proritice to move towards the target
    if dist(2) > 0
        % go east
        heuristic(_east) *= (1 + prob_approach_targ);
    else
        % go west
        heuristic(_west) *= (1 + prob_approach_targ);
    end
    if dist(1) > 0
        % go south
        heuristic(_south) *= (1 + prob_approach_targ);
    else
        % go north
        heuristic(_north) *= (1 + prob_approach_targ);
    end
    % prioritize to follow objects
    if (last_neighbor(_north) == 1) && (neighbor(_north) == 0)
        heuristic(_north) *= (1 + prob_follow_obj);
    end
    if (last_neighbor(_south) == 1) && (neighbor(_south) == 0)
        heuristic(_south) *= (1 + prob_follow_obj);
    end
    if (last_neighbor(_east) == 1) && (neighbor(_east) == 0)
        heuristic(_east) *= (1 + prob_follow_obj);
    end
    if (last_neighbor(_west) == 1) && (neighbor(_west) == 0)
        heuristic(_west) *= (1 + prob_follow_obj);
    end
    last_neighbor = neighbor;

    % normalize
    heuristic /= sum(heuristic);
    [val direction] = max(heuristic);
    if direction == _north
        now(1)--;
    elseif direction ==_south
        now(1)++;
    elseif direction == _west
        now(2)--;
    elseif direction == _east
        now(2)++;
    end

    mat(now(1), now(2)) += 0.1;
    step_count++;
    set(h, 'cdata', mat);
    pause(0.1);

end
mat(start(1), start(2)) = 0.8;
mat(target(1), target(2)) = 0.9;
set(h, 'cdata', mat);
step_count
