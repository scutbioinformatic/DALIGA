function AC = accuracyMeasure(gnd,res)
    res = bestMap(gnd,res);
    AC = length(find(gnd == res))/length(gnd);
end