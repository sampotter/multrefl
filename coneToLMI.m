function [A, b] = coneToLMI(x, K)
    m = size(K, 2);
    A = zeros(m, 3);
    b = zeros(m, 1);
    J = [2:m 1];
    for i = 1:m
        j = J(i);
        v = cross(K(:, i) - x, K(:, j) - x);
        v = v/norm(v);
        A(i, :) = v';
        b(i) = A(i, :)*x;
    end
end
