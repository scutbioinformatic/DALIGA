clear;
clc;

addpath('./dataset');
addpath('./metric');
addpath('./tool');

load('./dataset/uci.mat');
X{1} = fou';
X{2} = fac';
X{3} = kar';

nclass = length(unique(label));

opts.alpha = 0.7;
opts.beta = [0.01, 0.01];
opts.gamma = [1, 0.01];
opts.mu = 10;

W = method( X, opts );
group = SpectralClustering2(W, nclass);
[ NMI, ARI, ACC, fscore, precision, recall ] = clustering_metric(label,group);