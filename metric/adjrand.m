function ari = adjrand(P1,P2)

% ADJRAND   Adjusted Rand Index to Compare Two Partitions
%
%   ARI = ADJRAND(P1,P2) returns the adjusted rand index for partitions
%   P1 and P2 for the same data set. Each of these partitions 
%   are vectors with an index to the group number. For example, 
%   this could be the output from KMEANS or CLUSTER.
%

if length(P1) ~= length(P2)
    error('Input vectors must be the same length.')
    return
end
uP1 = unique(P1);
uP2 = unique(P2);
g1 = length(uP1);
g2 = length(uP2);
n = length(P1);

% Now find the matching matrix M
M = zeros(g1,g2);
I = 0; 
for i = uP1(:)'
    I = I + 1;
    J = 0;
    for j = uP2(:)'
        J = J + 1;
        indI = find(P1 == i);
        indJ = find(P2 == j);
        M(I,J) = length(intersect(indI,indJ));
    end
end

nc2 = nchoosek(n,2);
if g1>1 & g2>1
    % The neither one is a vector, so it is ok to just do the transpose.
    nidot = sum(M);
    njdot = sum(M');
elseif g1==1
    % Then M only has one row. No need to get column totals.
    nidot = M;
    njdot = sum(M);
else
    % Then M has one column. No need to get row totals.
    nidot = sum(M);
    njdot = M;
end

% NOw get the stuff needed for the index.
for i = 1:g1
    for j = 1:g2
        if M(i,j) > 1
            nijc2(i,j) = nchoosek(M(i,j),2);
        else
            nijc2(i,j) = 0;
        end
    end
end
for i = 1:length(nidot)
    if nidot(i) > 1
        nidotc2(i) = nchoosek(nidot(i),2);
    else
        nidotc2(i) = 0;
    end
end
for i = 1:length(njdot)
    if njdot(i) > 1
        njdotc2(i) = nchoosek(njdot(i),2);
    else
        njdotc2(i) = 0;
    end
end
% Now calculate the index.
N = sum(sum(nijc2)) - sum(nidotc2)*sum(njdotc2)/nc2;
D = (sum(nidotc2) + sum(njdotc2))/2 - sum(nidotc2)*sum(njdotc2)/nc2;
ari = N/D;

