function [totfautes] = totfautes(data_fautes_domicile,data_fautes_visiteur,data_fautes_coach)

% declaration des structures pour domicile
totfautes.domicile.anti = 0;
totfautes.domicile.tech = 0;
totfautes.domicile.disqua = 0;
totfautes.domicile.lfconc = 0;

for k = 1 : numel(data_fautes_domicile)
    totfautes.domicile.anti = totfautes.domicile.anti + data_fautes_domicile(k).nbanti;
    totfautes.domicile.tech = totfautes.domicile.tech + data_fautes_domicile(k).nbtech;
    totfautes.domicile.disqua = totfautes.domicile.disqua + data_fautes_domicile(k).nbdisqua;
    totfautes.domicile.lfconc = totfautes.domicile.lfconc + data_fautes_domicile(k).lfconc;
end
%à enlever dans le total des fautes provoquées
totfautes.domicile.asoustraire = totfautes.domicile.tech + totfautes.domicile.disqua;

totfautes.domicile.tech = totfautes.domicile.tech + data_fautes_coach(1).B1 + data_fautes_coach(1).C1;
totfautes.domicile.disqua = totfautes.domicile.disqua + data_fautes_coach(1).D2;
totfautes.domicile.lfconc = totfautes.domicile.lfconc + data_fautes_coach(1).B1 + data_fautes_coach(1).C1 + data_fautes_coach(1).D2*2;

% declaration des structures pour visiteur
totfautes.visiteur.anti = 0;
totfautes.visiteur.tech = 0;
totfautes.visiteur.disqua = 0;
totfautes.visiteur.lfconc = 0;

for k = 1 : numel(data_fautes_visiteur)
    totfautes.visiteur.anti = totfautes.visiteur.anti + data_fautes_visiteur(k).nbanti;
    totfautes.visiteur.tech = totfautes.visiteur.tech + data_fautes_visiteur(k).nbtech;
    totfautes.visiteur.disqua = totfautes.visiteur.disqua + data_fautes_visiteur(k).nbdisqua;
    totfautes.visiteur.lfconc = totfautes.visiteur.lfconc + data_fautes_visiteur(k).lfconc;
end
%à enlever dans le total des fautes provoquées
totfautes.visiteur.asoustraire = totfautes.visiteur.tech + totfautes.visiteur.disqua;

totfautes.visiteur.tech = totfautes.visiteur.tech + data_fautes_coach(2).B1 + data_fautes_coach(2).C1;
totfautes.visiteur.disqua = totfautes.visiteur.disqua + data_fautes_coach(2).D2;
totfautes.visiteur.lfconc = totfautes.visiteur.lfconc + data_fautes_coach(2).B1 + data_fautes_coach(2).C1 + data_fautes_coach(2).D2*2;
end
