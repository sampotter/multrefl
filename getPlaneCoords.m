function uv = getPlaneCoords(t, b, p, x)
    tmp = [t b p]\x;
    tmp = tmp/tmp(3);
    uv = tmp(1:2);
end
