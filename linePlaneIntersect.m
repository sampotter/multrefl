function [t, tf] = linePlaneIntersect(p, n, o, d)
    if abs(n'*d) < eps
        if abs(n'*(o - p)) < eps
            t = 0;
            tf = true;
        else
            t = nan;
            tf = false;
        end
    else
        t = (n'*(p - o))/(n'*d);
        tf = true;
    end
end
