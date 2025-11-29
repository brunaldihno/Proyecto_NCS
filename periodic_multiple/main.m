% main.m
% Simulación HyEQ para N agentes compartiendo una red
clear; clc; close all;
global PARAMS

rng(1);

% -------------------------
% Parámetros físicos y control
% -------------------------
g = 9.8;
l = 0.2;
m = 0.3;
a = g/l;
b = 1/(m*l);
A = [0 1; g/l 0];
B = [0; 1/(m*l)];
K = [-3.2 -0.2];

A_cl  = A + B * K;
Q     = eye(2);
P     = lyap(A_cl', Q);

PARAMS.a = a;
PARAMS.b = b;
PARAMS.K = K;

% -------------------------
% Parámetros de red y agentes
% -------------------------
Nagents = 10;
T_agents = ones(Nagents,1)*0.05;
T_r = 0.01;  
PARAMS.T_r = T_r;
PARAMS.N = Nagents;
PARAMS.T_agents = T_agents;
% -------------------------
% Estado inicial
% -------------------------
x0 = zeros(5*Nagents + 4,1);
for i = 1:Nagents
    idx = (i-1)*5 + 1;
    x0(idx)   = 0.2;          % theta_i(0)
    x0(idx+1) = -0.1*i;       % thetadot_i
    x0(idx+2) = K*[x0(idx); x0(idx+1)] ;  % u_i
    x0(idx+3) = 0;             % tau_i(0)
    x0(idx+4) = 0;             % p_i(0)
end
% variables de red
pos_q       = 5*Nagents + 1;
pos_tau_net = pos_q + 1;
pos_tau3    = pos_q + 2;
pos_tau4    = pos_q + 3;

x0(pos_q)       = 0;
x0(pos_tau_net) = 0;
x0(pos_tau3)    = 0;
x0(pos_tau4)    = 0;

% -------------------------
% Definición de flujo f(x)
% -------------------------
f = @f;
C = @C;
g = @g;
D = @D;

% -------------------------
% Simulación HyEQ
% -------------------------
TSPAN = [0 100];
JSPAN = [0 100000];

% Si tienes HyEQ instala, descomenta la línea siguiente:
[t, j, x] = HyEQsolver(f, g, C, D, x0, TSPAN, JSPAN);