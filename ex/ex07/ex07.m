clf;
clear;
%[IMG1 MAP1 ALPHA1] = imread('circles.jpg');
%figure(3);
%imshow(IMG1, MAP1);
%[X Y BUTTONS] = ginput();

load('data.mat');
center = [X(1) Y(1)];
radius = sqrt((X(2:end) - center(1)).^2 + (Y(2:end) - center(2)).^2);
radius_real = [0:radius(end)/length(radius):radius(end)]';
radius = [0;radius];
%draw distortion graph
figure(1);
plot(radius_real, radius);
title('distorion graph');
xlabel('original pixel distance');
ylabel('stretched pixel distance');

% correct distance
[IMG2 MAP2 ALPHA2] = imread('house.jpg');
max_x = round(size(IMG2)(2)/2);
max_y = round(size(IMG2)(1)/2);
d = sqrt((repmat([1:max_x], max_y, 1).^2)+(repmat([1:max_y]', 1, max_x).^2));
dp = interp1(radius, radius_real, d, 'cubic', 'extrap');
x = repmat([1:max_x], max_y, 1) .* dp./d;
x = round(x/max(max(x))*max_x);
x = [...
    -fliplr(flipud(x))+max(max(x))+2 flipud(x)+max(max(x));...
    -fliplr(x)+max(max(x))+2 x+max(max(x))];
y = repmat([1:max_y]', 1, max_x) .* dp./d;
y = round(y/max(max(y))*max_y);
y = [...
    -fliplr(flipud(y))+max(max(y))+2 -flipud(y)+max(max(y))+2;...
    fliplr(y)+max(max(y)) y+max(max(y))];
for m=[1:3],
    IMG2_c = IMG2(:, :, m);
    IMG3_c = zeros(max(max(y)), max(max(x)));
    for n=[1:prod(size(IMG2_c))],
        IMG3_c(y(n), x(n)) = IMG2_c(n);
    end
    IMG3(:, :, m) = IMG3_c;
end
figure(2);
%subplot(1, 2, 1);
%imshow(IMG2);
%subplot(1, 2, 2);
imshow(uint8(IMG3));
title('corrected image');
