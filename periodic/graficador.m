%% === FIGURA 1: Todos los estados ===
N  = size(x,2);       % número de estados

figure; hold on; grid on;
colors = lines(N);    % distinto color para cada curva

for k = 1:N
    plot(t, x(:,k), 'LineWidth', 1.5, 'Color', colors(k,:));
end

% Etiquetas automáticas
leg = cell(1,N);
for k = 1:N
    leg{k} = ['x_' num2str(k)];
end

legend(leg, 'Location', 'bestoutside');
xlabel('Tiempo t');
ylabel('Estados x_i');
title('Evolución de todas las variables de estado');


%% === FIGURA 2: Solo x1, x2 y x3 ===
figure; hold on; grid on;

plot(t, x(:,1), 'LineWidth', 1.5);
plot(t, x(:,2), 'LineWidth', 1.5);
plot(t, x(:,3), 'LineWidth', 1.5);

xlabel('Tiempo [s]', 'Interpreter','latex');
ylabel('$\theta,\ \dot{\theta},\ u$', 'Interpreter','latex');
title('$\theta,\ \dot{\theta}\ \mathrm{y}\ u$', 'Interpreter','latex');

legend({'$\theta$','$\dot{\theta}$','$u$'}, 'Interpreter','latex');

%% === FIGURA 3: Lyapunov + Momentos de salto ===

p = x(:,5);   % p es el quinto estado

% --- Cálculo de la función de Lyapunov ---
V = zeros(length(t),1);
for i = 1:length(t)
    xi = [x(i,1); x(i,2)];
    V(i) = xi' * P * xi;
end

figure;

%% --- Subplot 1: Función de Lyapunov ---
subplot(2,1,1);
plot(t, V, 'LineWidth', 1.8);
grid on;
xlabel('Tiempo [s]');
ylabel('V(x)');
title('Función de Lyapunov V(x)=x^T P x');

%% --- Subplot 2: Momentos de salto (x5 = 1 → 0) ---
subplot(2,1,2); hold on; grid on;

% Detectar cambios de p = x(5) de 1 → 0
saltos = find(diff(p) == -1);

for k = 1:length(saltos)
    xline(t(saltos(k)), 'LineWidth', 1.4, 'Color','r');
end

xlabel('Tiempo [s]');
ylabel('Saltos');
title('Momentos de salto', 'Interpreter','latex');

