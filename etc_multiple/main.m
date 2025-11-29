% main.m (multi-agente)
clearvars; close all; clc;
global ETC_PARAMS

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
% Parámetros ETC / red
% --------------------------
n_agents = 10;          % <<<<--- PON AQUÍ N (nº de agentes)
gamma    = 0.9;        % gamma usado en la condición 2|x'PBK e| > gamma x'Qx
T_r      = 0.01;       % tiempo de ocupacion de red (release)
rng(1);

% guardar en global
ETC_PARAMS.n     = n_agents;
ETC_PARAMS.a     = a;
ETC_PARAMS.b     = b;
ETC_PARAMS.K     = K(:)';   % fila
ETC_PARAMS.B     = B;
ETC_PARAMS.P     = P;
ETC_PARAMS.Q     = Q;
ETC_PARAMS.gamma = gamma;
ETC_PARAMS.T_r   = T_r;

% --------------------------
% condiciones iniciales (vector x0)
% --------------------------
x0_agents = zeros(6 * n_agents, 1);

% ejemplo de inicialización: pequeña perturbación en theta del primer agente
for i = 1:n_agents
    theta0 = 0.5;        % solo el agente 1 inicia con 0.2, los demás 0
    theta_dot0 = -0.1*i;
    u0 = K * [theta0; theta_dot0];
    theta_m0 = theta0;
    theta_mdot0 = theta_dot0;
    p0 = 0;
    base = (i-1)*6;
    x0_agents(base + 1) = theta0;
    x0_agents(base + 2) = theta_dot0;
    x0_agents(base + 3) = u0;
    x0_agents(base + 4) = theta_m0;
    x0_agents(base + 5) = theta_mdot0;
    x0_agents(base + 6) = p0;
end

q0 = 0;
tau1_0 = 0;
tau2_0 = 0;
tau3_0 = 0;

x0 = [x0_agents; q0; tau1_0; tau2_0; tau3_0];

% --------------------------
% HyEQ solver setup (func handles con 3 args)
% --------------------------
f = @f;
g = @g;
D = @D;
C = @C;

TSPAN = [0 100];
JSPAN = [0 100000];

% Ejecutar simulación
[t, j, x] = HyEQsolver(f, g, C, D, x0, TSPAN, JSPAN);
