function obj = readobj(path, verbose)
    if nargin < 2, verbose = 0; end
    
    stats = statobj(path);

    V = zeros(stats.nverts, 3, 'double');
    N = zeros(stats.nnormals, 3, 'double');
    F = zeros(stats.nfaces, 3, 'int32');

    id = fopen(path);

    l = fgetl(id);
    vi = 1;
    fi = 1;
    ni = 1;
    while l ~= -1
        [tok, rem] = strtok(l);
        switch tok
          case '#'
            % Skip over comments
          case 'v'
            V(vi, :) = parsevector(rem, verbose);
            vi = vi + 1;
          case 'f'
            [v, vt, vn] = parseface(rem, verbose);
            if ~isempty(vt)
                if verbose
                    warning(['Found vt entry but currently ' ...
                             'unsupported']);
                end
            end
            F(fi, :) = v;
            if length(unique(vn)) > 1
                if verbose
                    warning(['Found varying vn but this is currently ' ...
                             'unsupported'])
                end
            end
            fi = fi + 1;
          case 'vn'
            N(ni, :) = parsevector(rem, verbose);
            ni = ni + 1;
          otherwise
            if verbose
                warning(sprintf('Unexpected line format: ''%s''', l))
            end
        end
        l = fgetl(id);
    end
    fclose(id);
    
    obj.verts = V;
    obj.normals = N;
    obj.faces = F;
end

function x = parsevector(s, verbose)
    [x, tf] = str2num(s);    
    if ~tf
        if verbose
            warning(sprintf('Failed to parse line as vector: ''%s''', s))
        end
    end
end

function [v, vt, vn] = parseface(s, verbose)
    v = [];
    vt = [];
    vn = [];
    toks = split(strip(s));
    if length(toks) ~= 3
        if verbose
            warning(['Malformed face string: ''%s'' (proceeding anyway and ' ...
                     'using the first three indices'], s)
        end
    end
    for k = 1:3
        inds = split(toks{k}, '/');
        if inds{1}, v =  [v;  str2num(inds{1})]; end
        if inds{2}, vt = [vt; str2num(inds{2})]; end
        if inds{3}, vn = [vn; str2num(inds{3})]; end
    end
end