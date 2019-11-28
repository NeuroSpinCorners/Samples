tic;
clear all;
close all;
clc;

% parameters
a = 0.0035;
% j = 3*10^8; % A/cm^2
s = 2*pi*4.32; % (Hz*cm^2)/A
w_e = 2*pi*1.75*10^9; % rad/s
w_ex = 2*pi*27.5*10^12; % rad/s
kappa = 1.35*10^(-9); % V*s/m*rad

% Integration length
d = 0.1*10^(-13); % s
T = 1000*10^(-12); % s
Per = T/d;

% Modeling
jmin = 1.5*10^8;
jmax = 3*10^8;
N = 100;
dj = (jmax-jmin)/N;
j = jmin+dj:dj:jmax;

E1 = zeros(1,N);
E2 = zeros(1,N);

TSPAN = 0:d:T;
Y01 = [0.2 0];
Y02 = [pi 1.5*pi+0.1];

for i = 1:N
    [t1,y1] = ode45(@(t,y) [y(2); -w_ex*a*y(2)-0.5*w_ex*w_e*sin(2*y(1))+w_ex*(jmin+dj*i)*s] , TSPAN , Y01);
    [t2,y2] = ode45(@(t,y) [y(2); -w_ex*a*y(2)-0.5*w_ex*w_e*sin(2*y(1))+w_ex*(jmin+dj*i)*s] , TSPAN , Y02);
    E1(i) = mean(abs(hilbert(y1(:,2))))*kappa*10^(-2);
    E2(i) = mean(abs(hilbert(y2(:,2))))*kappa*10^(-2);
    
end;
 
% Results
figure('Color','w');
title('AC electric field vs. current density'); xlabel('Current density, 10^8 A/cm^2'); ylabel('AC electric field, V/cm');
hold on;
plot(j*10^(-8),E1, 'Color','r');
plot(j*10^(-8),E2, 'Color','b');
axis([1.5 3 0 30]);
grid on;
hold off;

toc;