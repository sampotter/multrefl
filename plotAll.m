function plotAll(obj, src, refs)
    data.V = obj.verts;
    data.F = obj.faces;
    data.N = obj.normals;
    data.nfaces = size(data.F, 1);
    data.lb = min(data.V, [], 1);
    data.ub = max(data.V, [], 1);
    data.A = data.N;
    data.b = sum(data.N.*data.V(data.F(:, 1), :), 2);
    data.colors = {'r', 'g', 'b', 'm', 'y'};
    
    for f = 1:data.nfaces
        ref = refs(f);
        P = ref.vispoly;
        img = ref.img;

        imgs = [src img];
        
        lb2 = min(imgs', [], 1);
        ub2 = max(imgs', [], 1);
        lb_ = min(data.lb, lb2);
        ub_ = max(data.ub, ub2);

        clf;
        view(45, 45);
        wireframe(obj);

        for i = 1:size(imgs, 2), point3(imgs(:, i), data.colors{i}); end
        tmp = [P P(:, 1)];
        plot3(tmp(1, :), tmp(2, :), tmp(3, :), 'k', 'LineWidth', 2);
        [AK, bK] = coneToLMI(img, P);
        plotregion([data.A; AK], [data.b; bK], lb_', ub_', 'g');
        xlim([lb_(1) ub_(1)]);
        ylim([lb_(2) ub_(2)]);
        zlim([lb_(3) ub_(3)]);
        daspect([1 1 1]);
        while ~waitforbuttonpress(), ; end

        if isfield(ref, 'refs') & ~isempty(ref.refs)
            plotRec(obj, data, f, imgs, ref.refs);
        end
    end
end

function plotRec(obj, data, f, pimgs, refs)
    for f = cell2mat(refs.keys)
        ref = refs(f);
        if iscell(ref), ref = ref{1}; end % :-(
        img = ref.img;
        imgs = [pimgs img];
        lb = min(data.lb, min(imgs', [], 1));
        ub = max(data.ub, max(imgs', [], 1));
        clf;
        view(45, 45);
        wireframe(obj);
        for i = 1:size(imgs, 2), point3(imgs(:, i), data.colors{i}); end
        tmp = data.V(data.F(f, :), :)'; tmp = [tmp tmp(:, 1)];
        plot3(tmp(1, :), tmp(2, :), tmp(3, :), 'k', 'LineWidth', 2);
        P = ref.vispoly; tmp = [P P(:, 1)];
        plot3(tmp(1, :), tmp(2, :), tmp(3, :), 'k', 'LineWidth', 2);
        [AK, bK] = coneToLMI(img, P);
        plotregion([data.A; AK], [data.b; bK], lb', ub', data.colors{i});
        xlim([lb(1) ub(1)]);
        ylim([lb(2) ub(2)]);
        zlim([lb(3) ub(3)]);
        daspect([1 1 1]);
        while ~waitforbuttonpress(), ; end
        if isfield(ref, 'refs') & ~isempty(ref.refs)
            plotRec(obj, data, f, imgs, ref.refs);
        end
    end
end
