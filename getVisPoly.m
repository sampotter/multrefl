function [K] = getVisPoly(obj, img, P1, f2)
    % assert(f1 ~= f2);
    if isrow(img), img = img'; end
    
    V = obj.verts;
    F = obj.faces;
    N = obj.normals;
    
    diam = 2*max(sqrt(sum((V - mean(V, 1)).^2, 2)));

    % P1 = V(F(f1, :), :)';
    P2 = V(F(f2, :), :)';

    p2 = P2(:, 1);
    n2 = N(f2, :)';
    t2 = (P2(:, 2) - p2)/norm(P2(:, 2) - p2);
    b2 = cross(t2, n2);
    B = [t2 b2 p2];
    
    D12 = P1 - img;
    D12 = D12./sqrt(sum(D12.^2, 1));
    
    m = size(D12, 2);

    alpha = zeros(m, 1);
    for i = 1:m
        [t, tf] = linePlaneIntersect(p2, n2, img, D12(:, i));
        assert(tf);
        alpha(i) = t;
    end
    
    % TODO: not at all sure if this is the correct thing to do here
    if any(alpha <= 0)
        warning('Found weird reflector arrangement...');
        K = [];
        return;
    end
    
    % NOTE: this calculation is either very unstable or wrong.  The
    % distance between the reprojected vectors and the originals is
    % ~1e-3 to ~1e-4, when there doesn't seem to be any reason it
    % shouldn't be close to machine precision.
    % 
    % UPDATE: seems to work, pretty sure it's just unstable. How to
    % fix this?
    tmp = B\(img*ones(1, m) + D12*diag(alpha));
    tmp = tmp./tmp(3, :);

    u1 = tmp(1, :)';
    v1 = tmp(2, :)';
    
    tmp = B\P2;
    tmp = tmp./tmp(3, :);
    
    u2 = tmp(1, :)';
    v2 = tmp(2, :)';

    tmp = intersect(polyshape(u1, v1), polyshape(u2, v2));
    tmp = tmp.Vertices;

    u3 = tmp(:, 1);
    v3 = tmp(:, 2);

    if size(tmp, 1) > 0
        K = B*[u3'; v3'; ones(1, length(u3))];
        s = svd(K);
        if s(3) < 1e-4
            warning('Found a degenerate cone?');
            K = [];
        end
    else
        K = [];
    end
end
