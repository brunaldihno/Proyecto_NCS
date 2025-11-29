function dx = f(x)
    global PARAMS
    Nagents = PARAMS.N;
    a = PARAMS.a;
    b = PARAMS.b;
    % Prealoc
    n = 5*Nagents + 4;
    dx = zeros(n,1);
    % agentes
    for ii = 1:Nagents
        base = (ii-1)*5;
        theta   = x(base + 1);
        thetad  = x(base + 2);
        u_i     = x(base + 3);
        tau_i   = x(base + 4);
        p_i     = x(base + 5);

        dx(base + 1) = thetad;                    % dot theta
        dx(base + 2) = a*sin(theta) + b * u_i;    % dot thetadot
        dx(base + 3) = 0;                         % dot u_i
        dx(base + 4) = 1;                         % dot tau_i
        dx(base + 5) = 0;                         % dot p_i
    end
    % variables de red
    q_pos = 5*Nagents + 1;
    tau_net_pos = q_pos + 1;
    tau3_pos = q_pos + 2;
    tau4_pos = q_pos + 3;

    q = x(q_pos);
    sum_p = 0;
    
    for ii = 1:Nagents
        p_i = x((ii-1)*5 + 5);
        sum_p = sum_p + p_i;
    end
    
    any_p = (sum_p > 0);   % <-- al menos un agente quiere transmitir
    
    dx(q_pos) = 0;
    dx(tau_net_pos) = q;             % dot tau_net = q
    dx(tau3_pos) = q * any_p;        % tau3 = q * any(p)
    dx(tau4_pos) = 1 - q;            % tau4 = 1 - q

end