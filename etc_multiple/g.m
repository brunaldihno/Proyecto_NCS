function xplus = g(x)
% Mapa de salto multi-agente
    global ETC_PARAMS
    n = ETC_PARAMS.n;
    K = ETC_PARAMS.K;
    B = ETC_PARAMS.B;
    P = ETC_PARAMS.P;
    Q = ETC_PARAMS.Q;
    gamma = ETC_PARAMS.gamma;
    T_r = ETC_PARAMS.T_r;

    xplus = x;

    q = x(6*n + 1);
    tau1 = x(6*n + 2);

    Xs = zeros(2, n);
    es = zeros(2, n);
    cond_request = false(n,1);
    for i = 1:n
        base = (i-1)*6;
        Xi = [x(base+1); x(base+2)];
        Xm = [x(base+4); x(base+5)];
        ei = Xm - Xi;
        Xs(:,i) = Xi;
        es(:,i) = ei;
        % evaluación trigger Lyapunov-based: 2*|X' P B K e| > gamma * X' Q X
        scalar = 2 * abs( (Xi.' ) * P * B * K * ei );
        rhs = gamma * ( Xi.' * Q * Xi );
        cond_request(i) = ( scalar > rhs ) && ( x(base+6) == 0 ); % p_i == 0 required
    end

    % cond_send: q==0 y existe p_i==1
    p_vec = x(6:6:6*n)';   % vector p entries
    inds_p = find(p_vec == 1);
    cond_send = (q == 0) && (~isempty(inds_p));

    % cond_release: tau1 > T_r
    cond_release = (tau1 > T_r) && (q == 1);

    % PRIORIDAD:
    % 1) si cond_send -> elegir aleatoriamente uno de inds_p y hacer la transmisión
    if cond_send
        % elegir aleatorio
        idx = inds_p( randi(length(inds_p)) );
        base = (idx-1)*6;
        % actualizar medidas al estado verdadero x (del propio agente)
        xplus(base + 4) = x(base + 1);   % theta_m := theta
        xplus(base + 5) = x(base + 2);   % theta_m_dot := theta_dot
        % actualizar control u = K * X
        Xi = [ x(base+1); x(base+2) ];
        xplus(base + 3) = K * Xi;
        % reset p_i, set q = 1, reset tau1
        xplus(base + 6) = 0;
        xplus(6*n + 1) = 1;   % q := 1
        xplus(6*n + 2) = 0;   % tau1 := 0
        return;
    end

    % 2) si no se envía, pero algún agente desea enviar (cond_request true),
    %    entonces cada agente que cumpla pone su p_i = 1 (intención)
    if any(cond_request)
        for i = 1:n
            if cond_request(i)
                base = (i-1)*6;
                xplus(base + 6) = 1;
            end
        end
        return;
    end

    % 3) Si cond_release: liberar red
    if cond_release
        xplus(6*n + 1) = 0;   % q := 0
        xplus(6*n + 2) = 0;   % tau1 := 0
        return;
    end

    % si llega aquí, no se hace nada
end
