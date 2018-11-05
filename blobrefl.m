clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SETUP

% Read blob.obj file and extract vertices, faces, and normals

stats = statobj('blob.obj');
obj = readobj('blob.obj');

V = obj.verts;
F = obj.faces;
N = obj.normals;

lb = min(V, [], 1);
ub = max(V, [], 1);

% For plotregion:
A = N;
b = sum(N.*V(F(:, 1), :), 2);

% Choose number of reflections to compute and pick a random sequence
% of faces

nfaces = size(F, 1);
nrefl = 4;

values = {};
for f = int32(1:nfaces), values{f} = struct; end

% Create first level of reflection trie
refs = containers.Map(int32(1:nfaces), values);

% Place a source in the blob uniformly at random
src = makeRandomSource(obj);

% TODO: I'm just storing the cones as sets of points which, when
% combined with their origin, form a cone. I need to switch this over
% to writing the cones as a matrix inequality, e.g. Ax >= b. I need
% this for both plotting purposes, and also evaluation.

for f = int32(1:nfaces)
    fprintf('f = %d\n', f);

    ref = refs(f);
    ref.img = reflectAcrossFace(obj, src, f);
    ref.vispoly = V(F(f, :), :)';
    tmp = computeRefs(obj, ref, f, 2, nrefl);
    if ~isempty(tmp), ref.refs = tmp; end
    refs(f) = ref;
end

count = countRefs(refs);
total = nfaces*(nfaces - 1)^(nrefl - 1);
fprintf('sparsity = %d/%d = %g\n', count, total, count/total);
