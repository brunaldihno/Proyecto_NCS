%% ============================================================
%   0. Parámetros del sistema linealizado y V_i(t)
% =============================================================
g = 9.8;
l = 0.2;
m = 0.3;

A = [0 1; g/l 0];
B = [0; 1/(m*l)];
K = [-3.2 -0.2];
A_cl  = A + B * K;

Q = eye(2);
P = lyap(A_cl', Q);

Nt = size(x,1);
V = zeros(Nt, Nagents);

% ----- Calcular V_i(t) -----
for i = 1:Nagents
    base = (i-1)*5;
    theta_vec  = x(:, base + 1);
    thetad_vec = x(:, base + 2);

    for k = 1:Nt
        x2 = [theta_vec(k); thetad_vec(k)];
        V(k,i) = x2' * P * x2;
    end
end


%% ============================================================
%   1. FIGURA 1 – V_i(t) y líneas de transmisión (p_i: 1 → 0)
% =============================================================
figure;

% ---------- SUBPLOT 1: V_i(t) ----------
hold on; grid on;
colors = lines(Nagents);

for i = 1:Nagents
    plot(t, V(:,i), 'LineWidth', 1.4, 'Color', colors(i,:));
end

leg = arrayfun(@(i) sprintf('$V_{%d}(t)$', i), 1:Nagents, 'UniformOutput', false);
legend(leg, 'Interpreter','latex', 'Location','eastoutside');

xlabel('Tiempo $t$', 'Interpreter','latex');
ylabel('$V_i(t)$', 'Interpreter','latex');
title('Funciones de Lyapunov por agente', 'Interpreter','latex');

%% ============================================================
%   2. FIGURA 2 – Media y desviación estándar de V_i(t)
% =============================================================
V_mean = mean(V,2);
V_std  = std(V,0,2);

figure; hold on; grid on;

plot(t, V_mean, 'b', 'LineWidth', 2);
plot(t, V_mean + V_std, '--', 'LineWidth', 1.4);
plot(t, V_mean - V_std, '--', 'LineWidth', 1.4);

xlabel('Tiempo $t$', 'Interpreter','latex');
ylabel('$\mathrm{media}\ \pm\ \sigma$', 'Interpreter','latex');
title('Media y desviación estándar de $V_i(t)$', 'Interpreter','latex');


%% ============================================================
%   3. FIGURA 3 – τ_3 y τ_4
% =============================================================
% tau_3 y tau_4 están en las últimas dos columnas del estado
tau3 = x(:, end-1);
tau4 = x(:, end);

figure; hold on; grid on;

plot(t, tau3, 'LineWidth', 1.4);
plot(t, tau4, 'LineWidth', 1.4);

legend({'$\tau_3(t)$', '$\tau_4(t)$'}, 'Interpreter','latex');

xlabel('Tiempo $t$', 'Interpreter','latex');
ylabel('Valores', 'Interpreter','latex');
title('Timers $\tau_3$ y $\tau_4$', 'Interpreter','latex');


%% ============================================================
%   4. TABLA resumen (transmisiones, min Δt, max Δt)
% =============================================================
transmissions_count = zeros(Nagents,1);
min_dt = zeros(Nagents,1);
max_dt = zeros(Nagents,1);

for i = 1:Nagents

    col_p = (i-1)*5 + 5;
    p_vec = x(:, col_p);

    idx_transmit = find( (p_vec(1:end-1) == 1) & (p_vec(2:end) == 0) );
    transmissions_count(i) = length(idx_transmit);

    if length(idx_transmit) >= 2
        times_i = t(idx_transmit);
        dt_i = diff(times_i);
        min_dt(i) = min(dt_i);
        max_dt(i) = max(dt_i);
    else
        min_dt(i) = NaN;
        max_dt(i) = NaN;
    end
end

% Crear tabla
AgentID = (1:Nagents).';
Tsummary = table(AgentID, transmissions_count, min_dt, max_dt, ...
    'VariableNames', {'Agente','Transmisiones','Min_dt','Max_dt'});

disp('====================  TABLA RESUMEN POR AGENTE  ====================');
disp(Tsummary);
