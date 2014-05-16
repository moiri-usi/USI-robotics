%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Università della Svizzera Italiana, Faculty of Informatics
% Simon Maurer
% Assignement 09 - Katana FK
% May 16, 2014
% Octave v3.8.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialization of variables
x = zeros(4, 1);
x(4) = 1;
a2 = 190;
a3 = 139;
a4 = 147.3;
a5 = 166;
d     = shiftdim([0    0    0     0  a4+a5], -1);
a     = shiftdim([0    0    a2    a3 0    ], -1);
alpha = shiftdim([0    pi/2 0     0  -pi/2], -1);

% angles of a)
theta = shiftdim([0    0    0     0  0    ], -1);
T = [
    cos(theta)             -sin(theta)            zeros(1, 1, 5) a;
    sin(theta).*cos(alpha) cos(theta).*cos(alpha) -sin(alpha)    -sin(alpha).*d;
    sin(theta).*sin(alpha) cos(theta).*sin(alpha) cos(alpha)     cos(alpha).*d;
    zeros(1, 1, 5)         zeros(1, 1, 5)         zeros(1, 1, 5) ones(1, 1, 5)
];
coord_a = T(:, :, 1) * T(:, :, 2) * T(:, :, 3) * T(:, :, 4) * T(:, :, 5) * x

% angles of b)
theta = shiftdim([0    pi/4 -pi/4 pi 0    ], -1);
T = [
    cos(theta)             -sin(theta)            zeros(1, 1, 5) a;
    sin(theta).*cos(alpha) cos(theta).*cos(alpha) -sin(alpha)    -sin(alpha).*d;
    sin(theta).*sin(alpha) cos(theta).*sin(alpha) cos(alpha)     cos(alpha).*d;
    zeros(1, 1, 5)         zeros(1, 1, 5)         zeros(1, 1, 5) ones(1, 1, 5)
];
coord_b = T(:, :, 1) * T(:, :, 2) * T(:, :, 3) * T(:, :, 4) * T(:, :, 5) * x

% angles of c)
theta = shiftdim([pi/4 pi/4 -pi/4 pi 0    ], -1);
T = [
    cos(theta)             -sin(theta)            zeros(1, 1, 5) a;
    sin(theta).*cos(alpha) cos(theta).*cos(alpha) -sin(alpha)    -sin(alpha).*d;
    sin(theta).*sin(alpha) cos(theta).*sin(alpha) cos(alpha)     cos(alpha).*d;
    zeros(1, 1, 5)         zeros(1, 1, 5)         zeros(1, 1, 5) ones(1, 1, 5)
];
coord_c = T(:, :, 1) * T(:, :, 2) * T(:, :, 3) * T(:, :, 4) * T(:, :, 5) * x

% angles of d)
theta = shiftdim([0    pi/2 -pi/2 pi 0    ], -1);
T = [
    cos(theta)             -sin(theta)            zeros(1, 1, 5) a;
    sin(theta).*cos(alpha) cos(theta).*cos(alpha) -sin(alpha)    -sin(alpha).*d;
    sin(theta).*sin(alpha) cos(theta).*sin(alpha) cos(alpha)     cos(alpha).*d;
    zeros(1, 1, 5)         zeros(1, 1, 5)         zeros(1, 1, 5) ones(1, 1, 5)
];
coord_d = T(:, :, 1) * T(:, :, 2) * T(:, :, 3) * T(:, :, 4) * T(:, :, 5) * x

% angles of e)
theta = shiftdim([pi/4 pi/2 -pi/2 pi 0    ], -1);
T = [
    cos(theta)             -sin(theta)            zeros(1, 1, 5) a;
    sin(theta).*cos(alpha) cos(theta).*cos(alpha) -sin(alpha)    -sin(alpha).*d;
    sin(theta).*sin(alpha) cos(theta).*sin(alpha) cos(alpha)     cos(alpha).*d;
    zeros(1, 1, 5)         zeros(1, 1, 5)         zeros(1, 1, 5) ones(1, 1, 5)
];
coord_e = T(:, :, 1) * T(:, :, 2) * T(:, :, 3) * T(:, :, 4) * T(:, :, 5) * x
