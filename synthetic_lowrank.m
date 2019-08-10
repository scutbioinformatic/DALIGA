function [ X, label ] = synthetic_lowrank( N, view )
% synthetic data
% N -- number of data points
% view -- number of views

% Enhong Zhuo, 2019

T_class1 = [1,1;1,2;2,1];
T_class2 = [3,1;4,1;4,2];

for v = 1:view
    
    m = randperm(10,1);
    
    P1 = rand(2,m);
    P2 = rand(2,m);

    TP1 = T_class1 * P1;
    TP2 = T_class2 * P2;

    C1 = rand(floor(N/2),3);
    C2 = rand(ceil(N/2),3);

    A = C1 * TP1;
    B = C2 * TP2;
    
    X{v} = [A;B];
    X{v} = X{v} + randn(size(X{v}));
    
end

label = [ones(1,floor(N/2)), 2*ones(1,ceil(N/2))]';

end

