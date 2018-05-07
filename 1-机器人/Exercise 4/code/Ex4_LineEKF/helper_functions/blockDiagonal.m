function M = blockDiagonal(R)
% create a block diagonal matrix from a 3 dimensional input matrix

nRows = size(R,1);
nCols = size(R,2);
nBlocks =  size(R,3);

M = zeros(nBlocks*nRows, nBlocks*nCols);
for i = 0 : nBlocks-1
    M(i*nRows+1 : (i+1)*nRows, i*nCols+1 : (i+1)*nCols) = R(:,:,i+1);
end