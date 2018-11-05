function [y] = reflectAcrossFace(obj, x, f)
    p = obj.verts(obj.faces(f, 1), :)';
    n = obj.normals(f, :)';
    Rc = 2*n*n';
    R = eye(3) - Rc;
    y = R*x + Rc*p;
end
