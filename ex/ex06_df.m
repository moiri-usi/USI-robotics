%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Università della Svizzera Italiana, Faculty of Informatics
% Simon Maurer
% Assignement 06 - Navigation
% April 9, 2014
% Octave v3.6.4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load data
clear;
clf;

% initialize variables
load ex06_environment.mat;
start = [1, 1];                 % start cooridinates (y, x)
target = [10, 20];              % target coordinates (y, x)
%% another maze to test (overwrite given maze)
%start = [1, 1];                 % start cooridinates (y, x)
%target = [3, 1];                % target coordinates (y, x)
%mat = [
%    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
%    1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0;
%    0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0;
%    0 1 0 1 0 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0;
%    0 1 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 0;
%    0 1 0 1 0 1 0 1 0 0 0 0 0 0 0 0 0 0 1 0;
%    0 1 0 1 0 1 0 1 1 1 1 1 1 1 1 1 1 0 1 0;
%    0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0;
%    0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0;
%    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
%];
% the following declarations are used to increase the readability of the code
global _north = 1;
global _west = 2;
global _south = 3;
global _east = 4;

% initialize image
[r, c] = size(mat);
figure(1);
h = imagesc((1:c)+0.5,(1:r)+0.5,mat);
color_grad = fliplr([0.1:0.1:0.7])';
color = [1 1 1; [ones(7, 1) color_grad color_grad];0 0 1; 0 1 0; 0 0 0;];
colormap(color);
axis equal;

% compute path
[mat_res step_count path, path_tot] = df(start, target, mat, h);

% add start and target position to the image and print out the step counter
mat_res(start(1), start(2)) = 0.8;
mat_res(target(1), target(2)) = 0.9;
if (sum(sum(mat_res == 0)) == 0)
    colormap(color(2:end, :));
end
set(h, 'cdata', mat_res);
if step_count == inf
    printf('target is not reachable!\n');
else
    printf('%d steps are necessary to move from (%d, %d) to (%d, %d)\n', ...
        step_count, start(2), start(1), target(2), target(1));
end

% save the final image
print -deps -color ex06_graph.eps
print -dpng -color ex06_graph.png

%% plot the direct path and the complete path
%figure(2);
%subplot(2, 1, 1);
%plot(path(:,2), -path(:,1));
%axis equal;
%title('Direct Path');
%subplot(2, 1, 2);
%plot(path_tot(:,2), -path_tot(:,1));
%axis equal;
%title('Complete Path');
