clf;
clear;
load ex04_commands.csv;
load ex04_sensed.csv;
load ex04_states.csv;
% kalmann-filter
dim = 1;
A = 0.9;
B = 0.3;
H = 1;
Q = 0.01;
R = 0.1;
x_kal = zeros(1, 1000);
x = 0;
P = 0;
for n=[1:1000],
    x = A*x + B*ex04_commands(n);
    P = A*P*A' + Q;
    K = P*H'*inv(H*P*H' + R);
    x = x + K*(ex04_sensed(n) - H*x);
    P = (eye(dim) - K*H)*P;
    x_kal(n) = x;
end
e_kal = meansq(ex04_states - x_kal)
% moving averages
x_av1 = (cumsum(ex04_sensed) - [zeros(1,1), cumsum(ex04_sensed(1:end-1))])/1;
e_av1 = meansq(ex04_states - x_av1)
x_av2 = (cumsum(ex04_sensed) - [zeros(1,2), cumsum(ex04_sensed(1:end-2))])/2;
e_av2 = meansq(ex04_states - x_av2)
x_av3 = (cumsum(ex04_sensed) - [zeros(1,3), cumsum(ex04_sensed(1:end-3))])/3;
e_av3 = meansq(ex04_states - x_av3)
x_av4 = (cumsum(ex04_sensed) - [zeros(1,4), cumsum(ex04_sensed(1:end-4))])/4;
e_av4 = meansq(ex04_states - x_av4)

t = [1:1000];
subplot(3, 2, 1);
plot(t, x_kal);
%plot(t, ex04_states, 'r', t, x_kal, 'b');
title('kalman filter');
%legend('real', 'filter', 'location', 'southeast');
subplot(3, 2, 3);
plot(t, x_av1);
%plot(t, ex04_states, 'r', t, x_av1, 'b');
title('moving average 1');
%legend('real', 'filter', 'location', 'southeast');
subplot(3, 2, 4);
plot(t, x_av2);
%plot(t, ex04_states, 'r', t, x_av2, 'b');
title('moving average 2');
%legend('real', 'filter', 'location', 'southeast');
subplot(3, 2, 5);
plot(t, x_av3);
%plot(t, ex04_states, 'r', t, x_av3, 'b');
title('moving average 3');
%legend('real', 'filter', 'location', 'southeast');
subplot(3, 2, 6);
plot(t, x_av4);
%plot(t, ex04_states, 'r', t, x_av4, 'b');
title('moving average 4');
%legend('real', 'filter', 'location', 'southeast');
print -deps -color ex04_graph.eps
print -dpng -color ex04_graph.png
