function refs = computeRefs(obj, parent_ref, f, refl, nrefl)
    refs = [];

    if refl > nrefl, return; end
    
    nfaces = size(obj.faces, 1);

    keys = [];
    values = {};

    vindex = 1;
    for g = int32(setdiff(1:nfaces, f))
        K = getVisPoly(obj, parent_ref.img, parent_ref.vispoly, g);
        if isempty(K), continue; end
        
        keys = [keys; g];

        ref = struct;
        ref.img = reflectAcrossFace(obj, parent_ref.img, g);
        ref.vispoly = K;
        ref.refs = computeRefs(obj, ref, g, refl + 1, nrefl);

        values{vindex} = ref;
        vindex = vindex + 1;
    end
    
    if ~isempty(keys), refs = containers.Map(keys, values); end
end
