function xdot = f(x)
% Dinámica de flujo para n agentes
% Estado: [for i=1..n: theta_i; theta_dot_i; u_i; theta_m_i; theta_mdot_i; p_i;
%          q; tau1; tau2; tau3]

    global ETC_PARAMS
    n = ETC_PARAMS.n;
    a = ETC_PARAMS.a;
    b = ETC_PARAMS.b;

    N = 6 * n + 4;
    xdot = zeros(N, 1);

    q = x(6*n + 1);    % q index
    % actualizar dinámica por agente
    for i = 1:n
        base = (i-1)*6;
        theta = x(base + 1);
        theta_dot = x(base + 2);
        u = x(base + 3);
        % theta_m, theta_mdot, p no cambian en flujo (ZOH)
        xdot(base + 1) = theta_dot;
        xdot(base + 2) = a * sin(theta) + b * u;
        xdot(base + 3) = 0;
        xdot(base + 4) = 0;
        xdot(base + 5) = 0;
        xdot(base + 6) = 0;
    end

    % timers / red
    xdot(6*n + 1) = 0;         % q no cambia por flujo (solo por saltos)
    xdot(6*n + 2) = q;         % tau1 aumenta mientras red ocupada (q==1)
    % tau2 aumenta si hay intención y la red ocupada
    p_vec = x(6*(1:n));
    % compute any(p)*q? original single used p*q; here use sum(p)>0 times q
    any_p = any(x(6:6:6*n) == 1);
    xdot(6*n + 3) = any_p * q;
    xdot(6*n + 4) = (1 - q);   % tau3 aumenta mientras red libre
end
