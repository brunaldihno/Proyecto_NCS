function dx = f(x)
    global PARAMS

    a = PARAMS.a;
    b = PARAMS.b;
    % Dynamics en el flujo (continuous dynamics)
    theta = x(1);
    thetadot = x(2);
    u = x(3);
    % x = [theta; thetadot; u; tau1; p; q; tau2; tau3; tau4]
    dx = zeros(9,1);
    dx(1) = thetadot;                 % dot(theta)
    dx(2) = a * sin(theta) + b * u;           % dot(thetadot)
    dx(3) = 0;                        % dot(u)
    dx(4) = 1;                        % dot(tau1)
    dx(5) = 0;                        % dot(p) 
    dx(6) = 0;                        % dot(q)
    dx(7) = x(6);                     % dot(tau2) = q  
    dx(8) = x(5)*x(6);                % dot(tau3) = p*q 
    dx(9) = (1 - x(6));               % dot(tau4) = 1 - q 
end