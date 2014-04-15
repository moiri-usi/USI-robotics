%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Università della Svizzera Italiana, Faculty of Informatics
% Simon Maurer
% Assignement 06 - Navigation
% April 9, 2014
% Octave v3.6.4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% function to compute the neigbor indicators at a given position
% pos: position of which the neighbor indicators are computed (y, x)
% mat: maze structure
% return: neighbor array
function [neighbor] = set_neighbor(pos, mat)
    global _north _west _south _east;
    try neighbor(_north) = mat(pos(1) - 1, pos(2)); % north
    catch neighbor(_north) = 1;
    end
    try neighbor(_south) = mat(pos(1) + 1, pos(2)); % south
    catch neighbor(_south) = 1;
    end
    try neighbor(_west) = mat(pos(1), pos(2) - 1); % west
    catch neighbor(_west) = 1;
    end
    try neighbor(_east) = mat(pos(1), pos(2) + 1); % east
    catch neighbor(_east) = 1;
    end
end
