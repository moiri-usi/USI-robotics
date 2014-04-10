% initialize
clear;
clf;
load("-ascii", "ex03_data.csv");
% calculate mean vector
mean_vector = sum(ex03_data, 1)./length(ex03_data);
% claculate covariance matrix
E = cov(ex03_data);
%% manual caluclation of covariance matrix
%q_11 = 1 / (length(ex03_data) - 1) * sum((ex03_data(:, 1) - mean_vector(1)) .* (ex03_data(:, 1) - mean_vector(1)));
%q_21 = 1 / (length(ex03_data) - 1) * sum((ex03_data(:, 2) - mean_vector(2)) .* (ex03_data(:, 1) - mean_vector(1)));
%q_12 = 1 / (length(ex03_data) - 1) * sum((ex03_data(:, 1) - mean_vector(1)) .* (ex03_data(:, 2) - mean_vector(2)));
%q_22 = 1 / (length(ex03_data) - 1) * sum((ex03_data(:, 2) - mean_vector(2)) .* (ex03_data(:, 2) - mean_vector(2)));
%E = [q_11, q_12; q_21, q_22];
% calculate the inverso of the covarinace matrix
E_inv = inv(E);
% calculate the determinant of the covarinace matrix
E_det = det(E);
% the directions of the arrows correspond to the eigenvectors of the covariance matrix and their lengths to the square roots of the eigenvalues.
[eig_vects eig_vals] = eig(E);
vect1 = eig_vects(:, 1) * sqrt(eig_vals(1, 1));
vect2 = eig_vects(:, 2) * sqrt(eig_vals(2, 2));
% plot
scatter(ex03_data(:, 1), ex03_data(:, 2), 2, 'black', 'filled');
grid on;
hold on;
%compass(mean_vector(1), mean_vector(2), 'r');
quiver(mean_vector(1), mean_vector(2), vect1(1), vect1(2), 0, 'color', 'blue', 'linewidth', 4);
quiver(mean_vector(1), mean_vector(2), vect2(1), vect2(2), 0, 'color', 'blue', 'linewidth', 4);
scatter(mean_vector(1), mean_vector(2), 6, 'red', 'filled');
axis([0 10 0 15], 'equal');
print -deps -color ex03_graph.eps
print -dpng -color ex03_graph.png
