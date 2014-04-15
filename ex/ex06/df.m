%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Università della Svizzera Italiana, Faculty of Informatics
% Simon Maurer
% Assignement 06 - Navigation
% April 9, 2014
% Octave v3.6.4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% function to search for a path from the start to the target position
% start:    start position (y, x) / (row, col)
% target:   target position (y, x) / (row, col)
% mat:      maze structure
% heu:      type of heuristic
%               'y': reduce first in y direction
%               'x': reduce first in x direction
%               'l': reduce first the longer distance
%               's': reduce first the shorter distance
% h:        figure reference. If omitted, de figure is not updated (optional)
% return:   mat:        updated maze structure, including the path (0.1 for each
%                       passage)
%           step_count: number of steps necessary to reach the target (inf if it
%                       is not possible to reach the target)
%           path:       the direct path (without backtracking) from the start
%                       position to the target position
%           path_tot:   the complete path (including backtracking) from the
%                       start position to the target position
function [mat step_count path path_tot] = df(start, target, mat, heu, h)
    global _north _west _south _east;
    now = start;                    % actual position (y, x)
    nodes = [];                     % nodes of the depth first tree
    path = start;                   % init position stack with start coord
    path_tot = start;               % init total position stack with start coord
    mat(start(1), start(2)) = 0.1;  % init start position with color
    backtrack = 0;                  % flag to switch to backtrack mode
    step_count = 0;                 % counter to get the final number of steps
    while (now(1) != target(1) || now(2) != target(2))
        % compute neighbor indicators for the actual position and cleanup nodes
        t_nodes = [nodes; now];
        nodes = [];
        % only keep nodes with valid path options
        for k=1:size(t_nodes)(1)
            neighbor = set_neighbor(t_nodes(k, :), mat);
            if sum(neighbor == 0) > 0
                % this node has at least one valid path option
                nodes = [nodes; t_nodes(k, :)];
            end
        end

        % check if all possible paths have been tested
        if (sum(size(nodes)) == 0)
            %printf('target is not reachable!\n');
            step_count = inf;
            return;
        end

        % compute distance to target
        dist = target - now;
        % configure heuristic
        dir = [_north _south; _west _east];
        if (heu == 'y') || ((heu == 'l') && (dist(1) >= dist(2))) || ...
                ((heu == 's') && (dist(1) <= dist(2)))
            ind1 = 1;
            ind2 = 2;
        elseif (heu == 'x') || ((heu == 's') && (dist(1) > dist(2))) || ...
                ((heu == 'l') && (dist(1) < dist(2)))
            ind1 = 2;
            ind2 = 1;
        end
        % the following comments are only valuable for heu == y
        if backtrack == 1
            % backtrack mode: go back to last node
            path = path(1:end-1, :);
            now = path(end, :);
            if (bt_target(1) == now(1)) && (bt_target(2) == now(2))
                % last node reached, swich back to normal mode
                backtrack = 0;
            end
        elseif (dist(ind1) > 0) && (neighbor(dir(ind1, 2)) == 0)
            % south is free, target is south -> move south
            now(ind1)++;
        elseif (dist(ind1) < 0) && (neighbor(dir(ind1, 1)) == 0)
            % north is free, target is north -> move north
            now(ind1)--;
        else
            % either reached y destination or cannot reach y destination on this
            % x-position -> move along x-axis
            if (dist(ind2) > 0) && (neighbor(dir(ind2, 2)) == 0)
                % east is free, target is east -> move east
                now(ind2)++;
            elseif (dist(ind2) < 0) && (neighbor(dir(ind2, 1)) == 0)
                % west is free, target is west -> move west
                now(ind2)--;
            elseif (neighbor(dir(ind1, 2)) == 0)
                % not possible to approach target -> move south
                now(ind1)++;
            elseif (neighbor(dir(ind1, 1)) == 0)
                % not possible to approach target -> move north
                now(ind1)--;
            elseif (neighbor(dir(ind2, 2)) == 0)
                % not possible to approach target -> move east
                now(ind2)++;
            elseif (neighbor(dir(ind2, 1)) == 0)
                % not possible to approach target -> move west
                now(ind2)--;
            else
                % no other movement possibility -> back to last node
                if (nodes(end, 1) != now(1)) || (nodes(end, 2) != now(2))
                    backtrack = 1; % switch to backtrack mode
                    bt_target = nodes(end, :); % set backtrack target
                end
            end
        end

        % update path with actual position (only when in normal mode)
        if backtrack == 0
            path = [path; now];
        end
        path_tot = [path_tot; now];

        % update step counter and image
        step_count++;
        mat(now(1), now(2)) += 0.1;
        if (exist('h', 'var') == 1)
            mat(target(1), target(2)) = 0;
            set(h, 'cdata', mat);
            pause(0.1);
        end
    end
end

