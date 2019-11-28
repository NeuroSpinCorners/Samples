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

% Integration length
d = 0.1*10^(-13);
T = 200*10^(-11);
Fs = 1/d;

% Modeling
jmin = 0*10^8;
jmax = 3*10^8;
N = 100;
dj = (jmax-jmin)/N;
j = jmin+dj:dj:jmax;

fres = zeros(1,N);

TSPAN = 0:d:T;
Y0 = [0.2 0];

parfor i=1:N
    [ts,ys] = ode45(@(t,y) [y(2); -w_ex*a*y(2)-0.5*w_ex*w_e*sin(2*y(1))+w_ex*(jmin+dj*i)*s] , TSPAN , Y0);
    S = fft(ys(:,2));
    L = length(ys(:,2));
    P1 = abs(S/L);
    P2 = P1(1:L/2+1);
    P2(1) = 0;
    P2(2:end-1) = 2*P2(2:end-1);
    f = Fs*(0:(L/2))/L;
    [Pres,Ires] = max(P2);
    fres(i) = Ires*Fs/L;
end;

% Results
figure('Color','w');
title('Frequency vs. current density'); xlabel('Current density, 10^8 A/cm^2'); ylabel('Frequency, GHz');
plot(j*10^(-8),fres*10^(-9));
axis([0 3 0 800]);
grid on;

toc;