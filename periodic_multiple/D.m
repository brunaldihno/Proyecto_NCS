function flag = D(x)
    % D.m - conjunto de salto: se produce salto si ocurre alguna de las 3 condiciones
    global PARAMS

    Nagents  = PARAMS.N;
    T_agents = PARAMS.T_agents;
    T_r      = PARAMS.T_r;

    % cond1: algun agente i con tau_i > T_i y p_i == 0
    cond1 = false;
    for i=1:Nagents
        base = (i-1)*5;
        if (x(base + 4) > T_agents(i)) && (x(base + 5) == 0)
            cond1 = true;
            break;
        end
    end

    % cond2: existe p_i == 1 y q == 0 (se puede mandar)
    q_pos = 5*Nagents + 1;
    q = x(q_pos);
    any_p = false;
    for i=1:Nagents
        if x((i-1)*5 + 5) == 1
            any_p = true; break;
        end
    end
    cond2 = (any_p) && (q == 0);

    % cond3: tau_net > T2 (liberar la red)
    tau_net_pos = q_pos + 1;
    cond3 = (x(tau_net_pos) > T_r);

    flag = cond1 || cond2 || cond3;
end
