% main.m (multi-agente)
clear; clc; close all;
global PARAMS

rng(1);

% --------------------------
% Parámetros físicos / control
% --------------------------
g     = 9.8;
l     = 0.2;
m     = 0.3;
a     = g / l;
b     = 1 / (m * l);

A     = [0 1; g/l 0];
B     = [0; 1/(m*l)];
K     = [-3.2 -0.2];   % 1x2

% closed-loop (para P)
A_cl  = A + B * K;
Q     = eye(2);
P     = lyap(A_cl', Q);

% --------------------------
% Parámetros
% --------------------------
T_r = 0.01;       % tiempo de ocupacion de red (release)
T_s = 0.05;

% guardar en global
PARAMS.a     = a;
PARAMS.b     = b;
PARAMS.K     = K(:)';   % fila
PARAMS.B     = B;
PARAMS.P     = P;
PARAMS.Q     = Q;
PARAMS.T_r   = T_r;
PARAMS.T_s   = T_s;


% --------------------------
% condiciones iniciales (vector x0)
% --------------------------
theta0 = 0.2;
thetadot0 = 0;
u0 = K*[theta0; thetadot0];
tau1_0 = 0;
p0 = 0;
q0 = 0;
tau2_0 = 0;
tau3_0 = 0;
tau4_0 = 0;
x0 = [theta0; thetadot0; u0; tau1_0; p0; q0; tau2_0; tau3_0; tau4_0];

% --------------------------
% HyEQ solver setup (func handles con 3 args)
% --------------------------
f = @f;
g = @g;
D = @D;
C = @C;

TSPAN = [0 10];
JSPAN = [0 10000];

% Ejecutar simulación
[t, j, x] = HyEQsolver(f, g, C, D, x0, TSPAN, JSPAN);