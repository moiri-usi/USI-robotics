%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Assignement 5.1.b/c - Monte Carlo Localization                     %
%           GNU Octave 3.6.4                                                   %
%           Simon Maurer                                                       %
%           27.03.2014                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clf;
clear;
N = 1000; % number of particels
L = 3; % number of steps

p1 = 0.8; % P(see landmark|on landmark)
p2 = 0.4; % P(see landmark|not on landmark)

% robot sees a landmark
p_sensor(:, 1) = [p1; p2; p2; p1; p2; p2; p1; p2; p2; p2];
% robot sees a landmark
p_sensor(:, 2) = [p1; p2; p2; p1; p2; p2; p1; p2; p2; p2];
% robot does not see a landmark
p_sensor(:, 3) = [1-p1; 1-p2; 1-p2; 1-p1; 1-p2; 1-p2; 1-p1; 1-p2; 1-p2; 1-p2];

x = randint(1, N, [0 9]); % random particels
n = [0:9]; % possible places
p = zeros(length(n), L+1);
p(:, 1) = hist(x, length(n), 1);
u = [0 3 4]; % motion model

% Assignment 5.1.b - Monte Carlo Localization with perfect movement
for t=[1:L],
    % motion model
    for k=[1:N],
        x(k) += u(t);
        x(k) -= (x(k) > 9)*10;
    end;
    % sensor model
    eta = 0;
    for k=[1:N],
        omega(k) = p_sensor(x(k)+1, t);
        eta += omega(k);
    end;
    % normalization
    for k=[1:N],
        omega(k) /= eta;
    end;
    % init resampling
    M_x = [];
    M_w = [];
    delta = rand(1)/N;
    c = omega(1);
    i = 1;
    % resampling
    for k=[0:N-1],
        up = delta + k/N;
        while (up > c),
            i++;
            c += omega(i);
        end;
        M_x = [M_x x(i)];
        M_w = [M_w 1/N];
    end;
    x = M_x;
    omega = M_w;
    % save particle count at each position
    p(:, t+1) = hist(M_x, length(n), 1);
end;
% plot
subplot(2, 1, 1);
plot(n, p(:, 1), '--*k', n, p(:, 2), '--*b', n, p(:, 3), '--*g', n, p(:, 4), '--*r');
title('Monte Carlo Localization (exact movement)');
xlabel('Position');
ylabel('Probability')
legend('init', 'step 1', 'step 2', 'step 3');

% Assignment 5.1.c - Monte Carlo Localization with erroneous movement
p_move = 0.8; % probability that the robot is moving after a command
x = randint(1, N, [0 9]); % random initialization of particels
p(:, 1) = hist(x, length(n), 1);
for t=[1:L],
    % motion model
    for k=[1:N],
        if rand(1) < p_move,
            x(k) += u(t);
            x(k) -= (x(k) > 9)*10;
        end;
    end;
    % sensor model
    eta = 0;
    for k=[1:N],
        omega(k) = p_sensor(x(k)+1, t);
        eta += omega(k);
    end;
    % normalization
    for k=[1:N],
        omega(k) /= eta;
    end;
    % init resampling
    M_x = [];
    M_w = [];
    delta = rand(1)/N;
    c = omega(1);
    i = 1;
    % resampling
    for k=[0:N-1],
        up = delta + k/N;
        while (up > c),
            i++;
            c += omega(i);
        end;
        M_x = [M_x x(i)];
        M_w = [M_w 1/N];
    end;
    x = M_x;
    omega = M_w;
    % save particle count at each position
    p(:, t+1) = hist(M_x, length(n), 1);
end;
% plot
subplot(2, 1, 2);
plot(n, p(:, 1), '--*k', n, p(:, 2), '--*b', n, p(:, 3), '--*g', n, p(:, 4), '--*r');
title('Monte Carlo Localization (erroneous movement)');
xlabel('Position');
ylabel('Probability')
legend('init', 'step 1', 'step 2', 'step 3');
% save the graph
print -deps -color ex05_graph2.eps
print -dpng -color ex05_graph2.png
