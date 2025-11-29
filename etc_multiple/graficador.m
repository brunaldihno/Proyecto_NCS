colors = lines(n_agents);

% === Inicializar ===
V = cell(n_agents,1);
saltos = cell(n_agents,1);

% === Procesar por agente ===
for i = 1:n_agents

    idx = (i-1)*6 + (1:6);

    x1 = x(:,idx(1));     % theta_i
    x2 = x(:,idx(2));     % theta_dot_i
    xm1 = x(:,idx(4));
    xm2 = x(:,idx(5));
    p = x(:,idx(6));

    % ---- Funcion de Lyapunov ----
    V{i} = zeros(length(t),1);
    for k = 1:length(t)
        V{i}(k) = [x1(k); x2(k)]' * P * [x1(k); x2(k)];
    end

    % ---- Tiempos de salto ----
    saltos{i} = [];
    for k = 1:length(p)-1
        if p(k)==0 && p(k+1)==1   % trigger
            saltos{i} = [saltos{i}; t(k)];
        end
    end

end

% ============================================================
% FIGURA 1: SUBPLOT con Lyapunov y tiempos de salto
% ============================================================
figure;

% ------- Subplot 1: funciones de Lyapunov -------
subplot(2,1,1);
hold on; grid on;
for i = 1:n_agents
    plot(t, V{i}, 'LineWidth', 1.4, 'Color', colors(i,:));
end
title('Funciones de Lyapunov V_i(t)');
xlabel('Tiempo [s]');
ylabel('V_i(t)');

% ============================================================
% FIGURA 2: Promedio y desviación estándar de V_i(t)
% ============================================================
figure; hold on; grid on;

V_matrix = zeros(length(t), n_agents);
for i = 1:n_agents
    V_matrix(:,i) = V{i};
end

mu = mean(V_matrix,2);
sigma = std(V_matrix,0,2);

plot(t, mu, 'LineWidth', 2);
plot(t, mu+sigma, '--', 'LineWidth', 1.4);
plot(t, mu-sigma, '--', 'LineWidth', 1.4);

xlabel('Tiempo [s]');
ylabel('V(t)');
title('Promedio y desviación estándar de V_i(t)');
legend({'media','media + sd','media - sd'});

% ============================================================
% FIGURA 3: timers tau2 y tau3
% Las columnas están después de los agentes: 
% x = [ agentes(6*n) , q , tau1 , tau2 , tau3 ]
% ============================================================

tau2 = x(:, 6*n_agents + 3);
tau3 = x(:, 6*n_agents + 4);

figure; hold on; grid on;
plot(t, tau2, 'LineWidth', 1.6);
plot(t, tau3, 'LineWidth', 1.6);
xlabel('Tiempo [s]');
ylabel('\tau');
title('Timers \tau_2 y \tau_3');
legend({'\tau_2', '\tau_3'});


% ============================================================
% TABLA DE ESTADÍSTICAS POR AGENTE
% ============================================================

nombres = strings(n_agents,1);
n_trans = zeros(n_agents,1);
min_dt  = zeros(n_agents,1);
max_dt  = zeros(n_agents,1);

for i = 1:n_agents
    nombres(i) = "Agente " + i;

    tiempos = saltos{i};
    n_trans(i) = length(tiempos);

    if length(tiempos) >= 2
        dt = diff(tiempos);
        min_dt(i) = min(dt);
        max_dt(i) = max(dt);
    else
        min_dt(i) = NaN;
        max_dt(i) = NaN;
    end
end

T = table(nombres, n_trans, min_dt, max_dt);
disp(' ');
disp('==============================================');
disp('      ESTADÍSTICAS DE LOS AGENTES');
disp('==============================================');
disp(T);