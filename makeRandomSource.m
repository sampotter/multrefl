function [src] = makeRandomSource(obj)
    offset = min(obj.verts);
    scale = max(obj.verts) - offset;
    src = scale.*rand(1, 3) + offset;
    while ~inObj(obj, src)
        src = scale.*rand(1, 3) + offset;
    end
    src = src';
end
