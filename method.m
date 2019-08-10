function [ B1 ] = method( X, opts )
% Low-rank sparse metric learning for multi-view subspace clustering
% X    -- cell, multi-view data points
% X{i} -- i-th view matrix, row for sample, column for feature
% opts -- parameter settings

% Enhong Zhuo, 2019

num_views = length(X);
n = size(X{1},1);

% setting default parameters
num_iter = 100;
mu = 10;
max_mu = 1e6;
rho = 1.5;
alpha = 0.5;
beta = [1, 1];
gamma = [0.01 0.01];
err_thr = 1e-5;

if ~exist('opts', 'var')
    opts = [];
else
    if ~isstruct(opts)
        error('Parameter error: opts is not a structure.');
    end
end

if isfield(opts, 'alpha');      alpha = opts.alpha;	end
if isfield(opts, 'beta');      beta = opts.beta;	end
if isfield(opts, 'gamma');      gamma = opts.gamma;	end
if isfield(opts, 'mu');         mu = opts.mu;	end
if isfield(opts, 'max_mu');     max_mu = opts.max_mu;	end
if isfield(opts, 'rho');        rho = opts.rho;	end
if isfield(opts, 'num_iter');   num_iter = opts.num_iter;	end
if isfield(opts, 'err_thr');	err_thr = opts.err_thr;	end

alpha = repmat({alpha}, 1, num_views);

A1 = repmat({zeros(n,n)}, 1, num_views);
A2 = repmat({zeros(n,n)}, 1, num_views);
A3 = repmat({zeros(n,n)}, 1, num_views);
A4 = repmat({zeros(n,n)}, 1, num_views);

B1 = zeros(n,n);
B2 = zeros(n,n);
B3 = zeros(n,n);

K = repmat({zeros(n,n)}, 1, num_views);

Lambda1 = repmat({zeros(n,n)}, 1, num_views);
Lambda2= repmat({zeros(n,n)}, 1, num_views);
Lambda3 = repmat({zeros(n,n)}, 1, num_views);
Lambda4 = zeros(n,n);
Lambda5 = zeros(n,n);

mu = mu * ones(5,1);

for v = 1:num_views
    K{v} = X{v} * X{v}';
end

iter = 0;
err = ones(num_views*3+2,1);

while iter < num_iter && max(err) > err_thr
    
    iter = iter + 1;
    temp = zeros(n);
    for v = 1:num_views
        
        A1{v} = (K{v}+mu(1)*A2{v}+mu(2)*A3{v}+mu(3)*A4{v}-Lambda1{v}-Lambda2{v}-Lambda3{v}) / (K{v}+sum(mu(1:3))*eye(n));
        
        
        A2{v} = A1{v} + (alpha{v}*(B1'+B1)+Lambda1{v})/mu(1); 
        A3{v} = SVthresh(A1{v}+Lambda2{v}/mu(2), beta(1)/mu(2));
        A4{v} = wthresh(A1{v}+Lambda3{v}/mu(3), 's', beta(2)/mu(3));
        A4{v} = A4{v} - diag(diag(A4{v}));
        

        Lambda1{v} = Lambda1{v} + mu(1)*(A1{v}-A2{v});
        Lambda2{v} = Lambda2{v} + mu(2)*(A1{v}-A3{v});
        Lambda3{v} = Lambda3{v} + mu(3)*(A1{v}-A4{v});
        
        temp = temp + alpha{v}*(A2{v}'+A2{v});
        
        err((v-1)*3+1) = norm(A1{v}-A2{v},'inf');
        err((v-1)*3+2) = norm(A1{v}-A3{v},'inf');
        err((v-1)*3+3) = norm(A1{v}-A4{v},'inf');
        
    end
    
    B1 = (temp + mu(4)*B2 + mu(5)*B3 - Lambda4 - Lambda5) / sum(mu(4:5));
    B2 = SVthresh(B1+Lambda4/mu(4), gamma(1)/mu(4));
    B3 = wthresh(B1+Lambda5/mu(5), 's', gamma(2)/mu(5));
    
    Lambda4 = Lambda4 + mu(4)*(B1-B2);
    Lambda5 = Lambda5 + mu(5)*(B1-B3);
    
    err(num_views*3+1) = norm(B1-B2,'inf');
    err(num_views*3+2) = norm(B1-B3,'inf');
    
    mu = min(rho*mu,max_mu);

end

end


