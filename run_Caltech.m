clear;
clc;

addpath('./dataset');
addpath('./metric');
addpath('./tool');

load('./dataset/caltech7.mat');
X{1} = centrist';
X{2} = garbor';
X{3} = gist';
X{4} = hog';
X{5} = lbp';
X{6} = wm';

nclass = length(unique(label));

opts.alpha = 0.3;
opts.beta = [1, 1];
opts.gamma = [0.01, 0.01];
opts.mu = 10;

W = method( X, opts );
group = SpectralClustering(W, nclass);
[ NMI, ARI, ACC, fscore, precision, recall ] = clustering_metric(label,group);