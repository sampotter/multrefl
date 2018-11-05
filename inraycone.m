function in = inraycone(x, o, T)
    if iscolumn(x), x = x'; end
    if iscolumn(o), o = o'; end

    v1 = T(1, :);
    v2 = T(2, :);
    v3 = T(3, :);

    n12 = cross(v1 - o, v2 - o);
    n12 = n12/norm(n12);
    
    n23 = cross(v2 - o, v3 - o);
    n23 = n23/norm(n23);

    n31 = cross(v3 - o, v1 - o);
    n31 = n31/norm(n31);
    
    N = [n12; n23; n31];
    in = all(sum(N.*(x - o), 2) > 0);
end
