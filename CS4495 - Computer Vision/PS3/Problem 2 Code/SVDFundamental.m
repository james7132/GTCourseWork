function [ F ] = SVDFundamental( CoordsA, CoordsB )
    F_estimate = LeastSquaresFundamental(CoordsA, CoordsB);
    [U, D, V] = svd(F_estimate);
    temp = diag(D);
    i = find(temp == min(temp));
    D(i,i) = 0;
    F = U * D * transpose(V);
    F = F / sqrt(sumsqr(F));
    rank(F)
end

