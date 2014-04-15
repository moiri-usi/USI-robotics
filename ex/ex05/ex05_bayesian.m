%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Assignement 5.1.a - Bayes Localization                             %
%           GNU Octave 3.6.4                                                   %
%           Simon Maurer                                                       %
%           27.03.2014                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clf;
clear;
N = 10; % number of places
L = 3; % number of steps

% motion model
p_motion = zeros(N, N, L);
p_motion(:, :, 1) = eye(N);
p_motion(:, :, 2) = circshift(eye(N), 3);
p_motion(:, :, 3) = circshift(eye(N), 4);

p1 = 0.8; % P(see landmark|on landmark)
p2 = 0.4; % P(see landmark|not on landmark)

% robot sees a landmark
p_sensor(:, 1) = [p1; p2; p2; p1; p2; p2; p1; p2; p2; p2];
% robot sees a landmark
p_sensor(:, 2) = [p1; p2; p2; p1; p2; p2; p1; p2; p2; p2];
% robot does not see a landmark
p_sensor(:, 3) = [1-p1; 1-p2; 1-p2; 1-p1; 1-p2; 1-p2; 1-p1; 1-p2; 1-p2; 1-p2];

p = zeros(N, L+1);
p(:, 1) = ones(N, 1)/N; % uniform probability

for t=[1:L],
    eta = 0;
    for k=[1:N],
        pp = 0;
        % motion model
        for i=[1:N],
            pp += p_motion(k, i, t)*p(i, t);
        end;
        % sensor model
        p(k, t+1) = p_sensor(k, t)*pp;
        eta += p(k, t+1);
    end;
    % normalization
    for k=[1:N],
        p(k, t+1) /= eta;
    end;
end;
% plot
x = [0:N-1];
plot(x, p(:, 1), '--*k', x, p(:, 2), '--*b', x, p(:, 3), '--*g', ...
    x, p(:, 4), '--*r');
xlabel('Position');
ylabel('Probability')
title('Bayes Localization');
legend('init', 'step 1', 'step 2', 'step 3');
% save the graph
print -deps -color ex05_graph1.eps
print -dpng -color ex05_graph1.png
