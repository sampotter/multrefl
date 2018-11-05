function wireframe(obj)
    V = obj.verts;
    F = obj.faces;
    hold on;
    scatter3(V(:, 1), V(:, 2), V(:, 3), 10, 'k', 'filled');
    for i = 1:size(F, 1)
        f = F(i, :);
        xy = V([f(1) f(2)], :);
        yz = V([f(2) f(3)], :);
        zx = V([f(3) f(1)], :);
        plot3(xy(:, 1), xy(:, 2), xy(:, 3), 'k');
        plot3(yz(:, 1), yz(:, 2), yz(:, 3), 'k');
        plot3(zx(:, 1), zx(:, 2), zx(:, 3), 'k');
    end
end