function [ NMI, ARI, ACC, fscore, precision, recall ] = clustering_metric( gnd, res )

NMI = nmi(gnd,res);
ARI = adjrand(gnd,res);
ACC = accuracyMeasure(gnd,res);
[fscore, precision, recall] = fprMeasure(gnd,res);

end
