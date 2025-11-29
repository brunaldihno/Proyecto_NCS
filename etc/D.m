function out = D(x)
    global ETC_PARAMS
    T_r   = ETC_PARAMS.T_r;
    K     = ETC_PARAMS.K;
    B     = ETC_PARAMS.B;
    P     = ETC_PARAMS.P;
    Q     = ETC_PARAMS.Q;
    y     = ETC_PARAMS.y;

    theta       = x(1);
    theta_dot   = x(2);
    theta_m     = x(4);
    theta_m_dot = x(5);
    p           = x(6);
    q           = x(7);
    tau1        = x(8);

    % vector de estado verdadero y error
    X = [theta; theta_dot];
    e = [theta_m; theta_m_dot] - X;

    % Condición 1: criterio ETM de Tabuada => el agente quiere mandar
    cond_request = (2*abs(X' * P * B * K * e) > 0.9 * (X' * Q * X)) && (p == 0);

    % Condición 2: si hay mensaje (p==1) y la red está libre (q==0) => se manda
    cond_send = (p == 1) && (q == 0);

    % Condición 3: si tau1 > T_r la red se libera
    cond_release = (tau1 > T_r);

    out = cond_request || cond_send || cond_release;
end
