function [indexA, indexB] = getOrder(A, B)

d = zeros(size(A,3), size(B,3));
for i = 1:size(A,3)
    for j = 1:size(B,3)
        d(i,j) = sum(sum(abs(A(:,:,i) - B(:,:,j))));
    end
end

indexA = 1:size(A,3);
[ans, indexB] = min(d');
