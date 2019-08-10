function [groups] = SpectralClustering2(A, n)
%SPECTRALCLUSTERING Executes spectral clustering algorithm
% A      data matrix, each column represents a sample
% NUMC   number of classes to be clustered
% *return group of classes

warning off;
N = size(A,1);
MAXiter = 1000; % Maximum number of iterations for KMeans 
REPlic = 20; % Number of replications for KMeans

% Normalized spectral clustering according to Ng & Jordan & Weiss
% using Normalized Symmetric Laplacian L = I - D^{-1/2} W D^{-1/2}

DN = diag( 1./sqrt(sum(A)+eps) );
LapN = speye(N) - DN * A * DN;
[uN,sN,vN] = svd(LapN);
kerN = vN(:,N-n+1:N);
kerNS = zeros(size(kerN));
for i = 1:N
kerNS(i,:) = kerN(i,:) ./ norm(kerN(i,:)+eps);
end
% groups = kmeans(kerNS,n,'maxiter',MAXiter,'replicates',REPlic,'EmptyAction','singleton');
groups = kmeans(kerNS,n,'maxiter',MAXiter,'replicates',REPlic,'EmptyAction','singleton','Start','sample');
end
