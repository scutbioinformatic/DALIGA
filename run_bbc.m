clear;
clc;

addpath('./dataset');
addpath('./metric');
addpath('./tool');

load('./dataset/bbc.mat');
X{1} = X{1}';
X{2} = X{2}';
X{3} = X{3}';
label = truth;

nclass = length(unique(label));

opts.alpha = 0.5;
opts.beta = [1, 1];
opts.gamma = [0.1, 0.01];
opts.mu = 100;

W = method( X, opts );
group = SpectralClustering(W, nclass);
[ NMI, ARI, ACC, fscore, precision, recall ] = clustering_metric(label,group);