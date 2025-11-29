% ---------------------------------------------------------------------
% Parámetros del sistema
% ---------------------------------------------------------------------
global ETC_PARAMS
g     = 9.8;            % gravedad
l     = 0.2;            % largo del brazo
m     = 0.3;            % masa del péndulo
a     = g/l;         
b     = 1/(m*l);         
A     = [0 1;g/l 0];
B     = [0;1/(m*l)];
K     = [-3.2 -0.2];
A_cl  = A + B*K;
Q     = eye(2);
P     = lyap(A_cl', Q);
gamma = 0.9;           
T_r   = 0.01;            % tiempo de ocupación de red

ETC_PARAMS.a     = a;
ETC_PARAMS.b     = b;
ETC_PARAMS.K     = K(:)';
ETC_PARAMS.P     = P;
ETC_PARAMS.Q     = Q;
ETC_PARAMS.B     = B;
ETC_PARAMS.y     = gamma;
ETC_PARAMS.T_r   = T_r;

% ---------------------------------------------------------------------
% Definición de funciones de flujo y conjuntos híbridos
% ---------------------------------------------------------------------
f = @f;         % mapa de flujo
g = @g;         % mapa de salto
D = @D;         % conjunto de salto
C = @C;         % conjunto de flujo

% ---------------------------------------------------------------------
% Condiciones iniciales
% ---------------------------------------------------------------------
theta0       = 0.2;
theta_dot0   = 0.0;
u0           = K*[theta0; theta_dot0];
theta_m0     = 0.2;
theta_m_dot0 = 0.0;
p0           = 0;
q0           = 0;
tau1_0       = 0;
tau2_0       = 0; 
tau3_0       = 0;

x0 = [theta0; theta_dot0; u0; theta_m0; theta_m_dot0; p0; q0; tau1_0; tau2_0; tau3_0];

TSPAN = [0 10];   % tiempo de simulación
JSPAN = [0 10000]; % número de saltos máximo

[t, j, x] = HyEQsolver(f,g,C,D,x0,TSPAN,JSPAN);