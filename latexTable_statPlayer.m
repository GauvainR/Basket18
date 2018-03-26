function [tot, mean, min, nbMj] = latexTable_statPlayer(statPlayer)

nbMatchs = length(statPlayer);
    
    tot.tpsdejeu = 0;
    tot.pts = 0;
    tot.tirs = 0;
    tot.troispts = 0;
    tot.deuxext = 0;
    tot.deuxint = 0;
    tot.lfreussis =0;
    tot.lftentes = 0;
    tot.lfconc = 0;
    tot.ftes = 0;
    tot.ptsmarq = 0;
    tot.ptsenc = 0;
    tot.ptsenc = 0;
    tot.anti = 0;
    tot.tech = 0;
    tot.disqua = 0;
    nbMatchsNonJoues = 0;
    
    for i = 1 : nbMatchs  
        if (statPlayer(i).tpsdejeu == 0 || isnan(statPlayer(i).tpsdejeu)) && statPlayer(i).pts == 0 && statPlayer(i).lftentes == 0 && statPlayer(i).ftes == 0 && isnan(statPlayer(i).ptsmarq)
           nbMatchsNonJoues= nbMatchsNonJoues + 1; 
           statPlayer(i).ptsmarq = 0;
           statPlayer(i).ptsenc = 0;
           statPlayer(i).ecart = 0;
        end 
            
        
        tot.tpsdejeu = tot.tpsdejeu + statPlayer(i).tpsdejeu;
        tot.pts = tot.pts + statPlayer(i).pts;
        tot.tirs = tot.tirs + statPlayer(i).tirs;
        tot.troispts = tot.troispts + statPlayer(i).troispts;
        tot.deuxext = tot.deuxext + statPlayer(i).deuxext;
        tot.deuxint = tot.deuxint + statPlayer(i).deuxint;
        tot.lfreussis = tot.lfreussis + statPlayer(i).lfreussis;
        tot.lftentes = tot.lftentes + statPlayer(i).lftentes;
        tot.lfconc = tot.lfconc + statPlayer(i).lfconc;
        tot.ftes = tot.ftes + statPlayer(i).ftes;
        tot.ptsmarq = tot.ptsmarq + statPlayer(i).ptsmarq;
        tot.ptsenc = tot.ptsenc + statPlayer(i).ptsenc;
        tot.anti = tot.anti + statPlayer(i).anti;
        tot.tech = tot.tech + statPlayer(i).tech;
        tot.disqua = tot.disqua + statPlayer(i).disqua;
        
        
    end
    
    tot.ecart = tot.ptsmarq - tot.ptsenc;
    tot.lfpct = tot.lfreussis / tot.lftentes*100;
    
    nbMj = (nbMatchs - nbMatchsNonJoues);
    
    mean.tpsdejeu = tot.tpsdejeu / nbMj;
    mean.pts = tot.pts / nbMj;
    mean.tirs = tot.tirs / nbMj;
    mean.troispts = tot.troispts / nbMj;
    mean.deuxext = tot.deuxext / nbMj;
    mean.deuxint = tot.deuxint / nbMj;
    mean.lfreussis = tot.lfreussis / nbMj;
    mean.lftentes = tot.lftentes / nbMj;
    mean.lfconc = tot.lfconc / nbMj;
    mean.ftes = tot.ftes / nbMj;
    mean.ptsmarq = tot.ptsmarq  / nbMj;
    mean.ptsenc = tot.ptsenc / nbMj;
    mean.anti = tot.anti / nbMj;
    mean.tech = tot.tech / nbMj;
    mean.disqua = tot.disqua / nbMj;
    
    mean.ecart = tot.ecart / nbMj;
    mean.lfpct = tot.lfpct;
    
    min.tpsdejeu = 40;
    min.pts = mean.pts * 40 /mean.tpsdejeu;
    min.tirs = mean.tirs * 40 /mean.tpsdejeu;
    min.troispts = mean.troispts * 40 /mean.tpsdejeu;
    min.deuxext = mean.deuxext * 40 /mean.tpsdejeu;
    min.deuxint = mean.deuxint * 40 /mean.tpsdejeu;
    min.lfreussis = mean.lfreussis * 40 /mean.tpsdejeu;
    min.lftentes = mean.lftentes * 40 /mean.tpsdejeu;
    min.lfconc = mean.lfconc * 40 /mean.tpsdejeu;
    min.ftes = mean.ftes * 40 /mean.tpsdejeu;
    min.ptsmarq = mean.ptsmarq * 40 /mean.tpsdejeu;
    min.ptsenc = mean.ptsenc * 40 /mean.tpsdejeu;
    
    min.ecart = mean.ecart * 40 /mean.tpsdejeu;
    min.lfpct = mean.lfpct;
    
end