function count = countRefs(refs)
    count = 0;
    for f = cell2mat(refs.keys)
        if isfield(refs(f), 'refs') & ~isempty(refs(f).refs)
            count = count + countRefs(refs(f).refs);
        else
            count = count + 1;
        end
    end
end
