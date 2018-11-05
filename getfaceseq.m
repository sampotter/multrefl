function seq = getfaceseq(nfaces, nrefl)
    seq = randi(nfaces, nrefl, 1);
    while length(unique(seq)) ~= nrefl
        seq = randi(nfaces, nrefl, 1);
    end
end
