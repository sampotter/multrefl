function in = inblob(x, V, F, N)
    if iscolumn(x), x = x'; end
    in = all(sum(N.*(x - V(F(:, 1), :)), 2) > 0);    
end
