tic;
clear all;
close all;
clc;

% Parameters
a = 3.5*10^(-3);
j = 3*10^8; % A/sm^2
s = 2*pi*4.32; % (Hz*sm^2)/A
w_e = 2*pi*1.75*10^9; % rad/s
w_ex = 2*pi*27.5*10^12; % rad/s

% Integtation lenght
d = 0.01*10^(-12); % s
T = 100*10^(-12); % s
Per = T/d;

% Modeling
TSPAN = 0:d:T;
Y0 = [0.1 0];

[t,y] = ode45(@(t,y) [y(2);-w_ex*a*y(2)-(w_ex*w_e/2)*sin(2*y(1))+w_ex*j*s] , TSPAN , Y0); % differential equation solution for j

% Results
figure('Color', 'w');
plot(t,y(:,1));
grid on;
title('Phase vs. time'); xlabel('Time, s'); ylabel('Phase, rad');

figure('Color', 'w');
plot(t,y(:,2));
grid on;
title('Velocity vs. time'); xlabel('Time, s'); ylabel('Velocity, rad/s');

figure('Color', 'w');
plot(y(:,1),y(:,2));
grid on;
title('Phase portrait'); xlabel('Phase, rad'); ylabel('Velocity, rad/s');

toc;