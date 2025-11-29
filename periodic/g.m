function xplus = g(x)
    global PARAMS

    T_s = PARAMS.T_s;
    T_r = PARAMS.T_r;
    K = PARAMS.K;
    % x = [theta; thetadot; u; tau1; p; q; tau2; tau3; tau4]
    xplus = x; % por defecto no cambia
    theta = x(1);
    thetadot = x(2);

    % Prioridad: enviar si p==1 y red libre
    if (x(5) == 1) && (x(6) == 0)
        % se manda el mensaje
        xplus(6) = 1;      % q = 1 (red ocupada)
        xplus(5) = 0;      % p = 0 (intención resuelta)
        xplus(4) = 0;      % tau1 = 0 (reset timer de petición)
        % Ley de control que se aplica al mandar (puedes cambiarla)
        % Por defecto: u = -Kp*theta - Kd*thetadot
        xplus(3) = K*[x(1); x(2)];
        return
    end

    % Si tau2 excede T2 -> red se libera
    if x(7) >= T_r
        xplus(7) = 0;   % tau2 = 0
        xplus(6) = 0;   % q = 0 (red libre)
        return
    end

    % Si tau1 excede T1 -> se pone p = 1 (intención de transmitir)
    if x(4) >= T_s
        xplus(5) = 1;   % p = 1
        return
    end

    % Si llega aquí, no hay salto aplicable (por seguridad devolvemos x)
end