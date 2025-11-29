function flag = D(x)
    global PARAMS
    T_s = PARAMS.T_s;
    T_r = PARAMS.T_r;
    cond1 = (x(4) >= T_s) && (x(5) == 0);
    cond2 = (x(5) == 1) && (x(6) == 0);
    cond3 = (x(7) >= T_r);
    flag = cond1 || cond2 || cond3;
end
