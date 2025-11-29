function xplus = g(x)

    global ETC_PARAMS
    T_r   = ETC_PARAMS.T_r;
    K     = ETC_PARAMS.K;
    B     = ETC_PARAMS.B;
    P     = ETC_PARAMS.P;
    Q     = ETC_PARAMS.Q;
    y     = ETC_PARAMS.y;


    % Desempaquetar
    theta       = x(1);
    theta_dot   = x(2);
    u           = x(3);
    theta_m     = x(4);
    theta_m_dot = x(5);
    p           = x(6);
    q           = x(7);
    tau1        = x(8);
    tau2        = x(9);
    tau3        = x(10);

    X = [theta; theta_dot];
    e = [theta_m; theta_m_dot] - X;

    % Evaluar condiciones (mismas que en D_etc)
    cond_request = (2*abs(X' * P * B * K * e) > y * (X' * Q * X)) && (p == 0);
    cond_send    = (p == 1) && (q == 0);
    cond_release = (tau1 > T_r);

    % Inicialmente, por defecto, no cambiar en el salto
    xplus = x;

    % Prioridad: envío efectivo (cond_send) debe ejecutarse antes que solo
    % marcar la intención (cond_request). Implementamos orden lógico:
    if cond_send
        % Se transmite: q = 1 (red ocupada), p = 0 (intención resuelta)
        % Actualizar medidas al estado verdadero x, y aplicar control u = K * X
        xplus(4) = X(1);   % theta_m := theta
        xplus(5) = X(2);   % theta_m_dot := theta_dot
        xplus(3) = K * X;  % u := K * x_state
        xplus(6) = 0;      % p := 0
        xplus(7) = 1;      % q := 1
        xplus(8) = 0;      % tau1 := 0 (comenzamos a contar ocupación)
        % tau2, tau3 se mantienen (solo análisis)
        return;
    end

    % Si llegó aquí no se ejecutó cond_send
    if cond_request
        % Se fija la intención de transmitir
        xplus(6) = 1;  % p := 1
        return;
    end

    if cond_release
        % Se libera la red
        xplus(7) = 0;  % q := 0
        xplus(8) = 0;  % tau1 := 0
        return;
    end

    % Si ninguna condición se cumple, por seguridad no cambiamos nada.
end
