N = 100;
a1 = 30;
a2 = 25;
x0 = 20;
xN = 40;
x = [x0:(xN-x0)/(N-1):xN];
x = fliplr(x);
y0 = 10;
yN = 10;
y = ones(1, N) * 10;
%y = [y0:(yN-y0)/(N-1):yN];
%y = fliplr(y);

theta12 = -acos((x.^2 + y.^2 - a1^2 - a2^2)/(2*a1*a2));
theta11 = atan(abs(y./x)) - asin(a2*sin(theta12)./sqrt(x.^2 + y.^2));
theta22 = acos((x.^2 + y.^2 - a1^2 - a2^2)/(2*a1*a2));
theta21 = atan(abs(y./x)) - asin(a2*sin(theta22)./sqrt(x.^2 + y.^2));

figure(1);
subplot(2, 2, 1);
plot(theta11*360/(2*pi));
title('Solution 1');
ylabel('\theta_1 [deg]');
grid on;
subplot(2, 2, 2);
plot(360 + theta12*360/(2*pi));
title('Solution 1');
ylabel('\theta_2 [deg]');
grid on;
subplot(2, 2, 3);
plot(360 + theta21*360/(2*pi));
title('Solution 2');
ylabel('\theta_1 [deg]');
grid on;
subplot(2, 2, 4);
plot(theta22*360/(2*pi));
title('Solution 2');
ylabel('\theta_2 [deg]');
grid on;

print -deps -color graph.eps
print -dpng -color graph.png
