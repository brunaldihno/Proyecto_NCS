function xplus = g(x)
    % g.m - Mapa de salto para N agentes (envío, activación de p, liberación de red)
    global PARAMS

    Nagents  = PARAMS.N;
    T_agents = PARAMS.T_agents;
    T_r      = PARAMS.T_r;
    K        = PARAMS.K; 

    xplus = x;
    % indices
    q_pos = 5*Nagents + 1;
    tau_net_pos = q_pos + 1;

    q = x(q_pos);
    tau_net = x(tau_net_pos);

    % 1) Prioridad 1: envío si hay p==1 y q==0
    % Buscar todos los agentes con p==1
    waiting = false(1,Nagents);
    for i=1:Nagents
        p_i = x((i-1)*5 + 5);
        waiting(i) = (p_i == 1);
    end

    if (q == 0) && any(waiting)
        waiting_agents = find(waiting);   % indices de agentes en true
    
        % --- elegir uno aleatorio ---
        k = waiting_agents(randi(length(waiting_agents)));
    
        % aplicar el envío del agente k
        base = (k-1)*5;
    
        xplus(q_pos) = 1;              % tau_r = 1
        xplus(base + 5) = 0;           % p_k = 0
        xplus(base + 4) = 0;           % tau_k = 0
    
        theta_k   = x(base + 1);
        thetad_k  = x(base + 2);
    
        % calcular control u_k
        xplus(base + 3) = K * [theta_k; thetad_k];
    
        return
    end


    % 2) Prioridad 2: liberación de la red por tau_net
    if tau_net > T_r
        xplus(tau_net_pos) = 0;
        xplus(q_pos) = 0;
        return
    end

    % 3) Activación de intención p_i si tau_i > T_i y p_i == 0
    % Para consistencia activamos p_i para TODOS los agentes que cumplan
    any_activated = false;
    for i=1:Nagents
        base = (i-1)*5;
        tau_i = x(base + 4);
        p_i = x(base + 5);
        if (tau_i > T_agents(i)) && (p_i == 0)
            xplus(base + 5) = 1; % p_i = 1
            any_activated = true;
            % NOTA: no reseteamos tau_i aquí (dejar que se resetee solo al enviar)
        end
    end
    if any_activated
        return
    end

    % si no aplicó nada, devolver x tal cual
end
