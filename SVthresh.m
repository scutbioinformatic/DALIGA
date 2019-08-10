function [ thresh_X ] = SVthresh( X, thresh )
% Singular value thresholding

% Enhong Zhuo, 2019

[U, S, V] = svd(X);
S_thresh = S - thresh;
S_thresh = max(S_thresh, 0);
thresh_X = U * S_thresh * V';

end

