function v = unifrnd(a, b, dim) 
    if not(exist('dim', 'var'))
        dim = [1, 1];
    end
    v = a + rand(dim) * (b - a);
end
