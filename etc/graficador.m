% correr despues del main

% -----------------------------------------------------------
% 1) TODAS LAS SEÑALES EN EL MISMO GRÁFICO
% -----------------------------------------------------------
figure;
plot(t, x, 'LineWidth', 1.2);
grid on;
xlabel('Tiempo [s]');
ylabel('Estados');
title('Todas las señales del estado');
legend(arrayfun(@(k) sprintf('x_%d',k), 1:size(x,2), 'UniformOutput', false));

% -----------------------------------------------------------
% 2) θ, θ̇, u
% -----------------------------------------------------------
figure;
hold on;
plot(t, x(:,1), 'LineWidth', 1.4);
plot(t, x(:,2), 'LineWidth', 1.4);
plot(t, x(:,3), 'LineWidth', 1.4);
hold off;
grid on;

xlabel('Tiempo [s]', 'Interpreter','latex');
ylabel('$\theta,\ \dot{\theta},\ u$', 'Interpreter','latex');
title('$\theta,\ \dot{\theta}\ \mathrm{y}\ u$', 'Interpreter','latex');

legend({'$\theta$','$\dot{\theta}$','$u$'}, 'Interpreter','latex');

% -----------------------------------------------------------
% 3) Función de Lyapunov e intsantes de transmisión
% -----------------------------------------------------------
% ===========================================================
% SUBPLOT 2: Función de Lyapunov
% ===========================================================

% Matriz (A+BK)
A_cl = [0 1; -4.3333 -3.3333];

% Resolver la ecuación de Lyapunov: A'P + PA = -I
Q = eye(2);
P = lyap(A_cl', Q);

% Calcular V(t) = x(1:2)^T * P * x(1:2)
V = zeros(length(t),1);
for k = 1:length(t)
    Xk = x(k,1:2).';
    V(k) = Xk' * P * Xk;
end

figure;

subplot(2,1,1);
plot(t, V, 'LineWidth', 1.5);
grid on;
xlabel('Tiempo [s]');
ylabel('V(x)');
title('Función de Lyapunov V(x)=x^T P x');


p = x(:,6);

transmisiones = [];
for k = 1:length(p)-1
    if p(k) == 1 && p(k+1) == 0
        transmisiones = [transmisiones; t(k)];
    end
end



subplot(2,1,2);
plot(t, zeros(size(t)), 'w');  % plot vacío para tener el eje
hold on;

for k = 1:length(transmisiones)
    xline(transmisiones(k), 'r', 'LineWidth', 1.4);
end

hold off;
grid on;
xlabel('Tiempo [s]');
title('Instantes de transmisión (p: 1 → 0)');