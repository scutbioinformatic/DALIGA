clear;
clc;

addpath('./dataset');
addpath('./metric');
addpath('./tool');

load('./dataset/3-sources.mat');
X{1} = bbc;
X{2} = guardian;
X{3} = reuters;
label = truth;

nclass = length(unique(label));

opts.alpha = 0.3;
opts.beta = [1, 10];
opts.gamma = [0.001, 0.01];
opts.mu = 10;

W = method( X, opts );
group = SpectralClustering2(W, nclass);
[ NMI, ARI, ACC, fscore, precision, recall ] = clustering_metric(label,group);