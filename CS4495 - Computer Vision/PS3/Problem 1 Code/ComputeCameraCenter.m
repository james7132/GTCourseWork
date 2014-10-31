function [ C ] = ComputeCameraCenter( M )
    [size_r, size_c] = size(M)
    if size_r ~= 3 && size_c ~= 4
        throw(MException('Size Error', 'M must be a 4x3 matrix'));
    end
    Q = M(:, 1:3);
    m_4 = M(:, 4);
    C = -inv(Q) * m_4;
end

