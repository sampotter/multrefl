function [tf] = inObj(obj, x)
    if iscolumn(x), x = x'; end
    tf = all(sum(obj.normals.*(x - obj.verts(obj.faces(:, 1), :)), ...
                 2) > 0);
end