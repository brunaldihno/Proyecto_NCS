function out = D(x)
% Conjunto de salto: true si debe saltar
    global ETC_PARAMS
    n = ETC_PARAMS.n;
    P = ETC_PARAMS.P;
    Q = ETC_PARAMS.Q;
    B = ETC_PARAMS.B;
    gamma = ETC_PARAMS.gamma;
    T_r = ETC_PARAMS.T_r;

    theta_idx = 1:6:(6*n-5);
    theta_dot_idx = 2:6:(6*n-4);

    q = x(6*n + 1);
    tau1 = x(6*n + 2);

    % evaluar cond_request para cada agente
    cond_request = false(n,1);
    for i = 1:n
        base = (i-1)*6;
        Xi = [x(base+1); x(base+2)];
        Xm = [x(base+4); x(base+5)];
        ei = Xm - Xi;
        scalar = 2 * abs( Xi.' * P * B * ETC_PARAMS.K * ei );
        rhs = gamma * ( Xi.' * Q * Xi );
        cond_request(i) = ( scalar > rhs ) && ( x(base+6) == 0 );
    end

    % cond_send: existe p_i==1 y q==0
    p_vec = x(6:6:6*n)';
    cond_send = (q == 0) && any(p_vec == 1);

    % cond_release
    cond_release = (tau1 > T_r) && (q == 1);

    out = any(cond_request) || cond_send || cond_release;
end
