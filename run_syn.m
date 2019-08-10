clear;
clc;

addpath('./dataset');
addpath('./metric');
addpath('./tool');

load('./dataset/syn500.mat');

nclass = length(unique(label));

opts.alpha = 0.5;
opts.beta = [1, 0.001];
opts.gamma = [1, 0.001];
opts.mu = 10;

W = method( X, opts );
group = SpectralClustering2(W, nclass);
[ NMI, ARI, ACC, fscore, precision, recall ] = clustering_metric(label,group);
