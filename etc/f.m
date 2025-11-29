function xdot = f(x)
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

    % Parámetros
    global ETC_PARAMS
    a = ETC_PARAMS.a;
    b = ETC_PARAMS.b;

    % Dinámica
    xdot = zeros(10,1);
    xdot(1) = theta_dot;    % dimámica del pendulo invertido
    xdot(2) = a * theta + b * u;
    xdot(3) = 0;            % u se mantiene en ZOH entre transmisiones
    xdot(4) = 0;            
    xdot(5) = 0;            
    xdot(6) = 0;            
    xdot(7) = 0;             
    xdot(8) = q;            % tau1 aumenta mientras red ocupada (q==1)
    xdot(9) = p * q;        % tau2 aumenta si hay un mensaje y la red está ocupada
    xdot(10)= (1 - q);      % tau3 aumenta mientras red libre
end
