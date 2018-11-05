function stats = statobj(path)
    stats = struct;
    stats.nverts = 0;
    stats.nfaces = 0;
    stats.nnormals = 0;
    stats.usevn = 0;
    stats.usefn = 0;

    id = fopen(path);

    l = fgetl(id);
    while l ~= -1
        [tok, rem] = strtok(l);
        switch tok
          case 'v'
            stats.nverts = stats.nverts + 1;
          case 'f'
            stats.nfaces = stats.nfaces + 1;
            loc = strfind(rem, '//');
            if loc
                stats.usefn = 1;
            end
          case 'vn'
            stats.nnormals = stats.nnormals + 1;
        end
        l = fgetl(id);
    end
    
    if stats.nnormals > 0 && ~stats.usevn && ~stats.usefn
        if stats.nverts == stats.nnormals
            stats.usevn = 1;
        else
            warning([
                'Found normals but couldn''t decide whether they ' ...
                'were face or vertex normals']);
        end
    end
    
    fclose(id);
end
