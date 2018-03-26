function [stats,nblfmanque_domicile,nblfmanque_visiteur,nbfautescoach,sqlJoueurs,sqlEquipes,sqlStatsJoueurs,sqlStatsEquipes,listeJoueurs,listeJoueursSansLicence,infosJoueurs] = computeStats(data_recap_domicile,data_recap_visiteur,data_fdm_domicile,data_fdm_visiteur,gamedata,data_fautes_domicile,data_fautes_visiteur,lfmanque,data_coach,stats,data_fautes_coach,totfautes,ecart,cinqdomicile,cinqvisiteur,sqlJoueurs,sqlEquipes,sqlStatsJoueurs,sqlStatsEquipes,tdj_struct,season,listeJoueurs,listeJoueursSansLicence)
annee_en_cours = 2000 + str2double(season)-1; %utilisé pour le calcul des ages

% initialisation des structures qui contiennent les infos joueurs pour la
% fonction de calcul des ecarts par 5
infosJoueurs.domicile = [];
infosJoueurs.domicile.nom = [];
infosJoueurs.domicile.numLicence = [];
infosJoueurs.domicile.numero = [];

infosJoueurs.visiteur = [];
infosJoueurs.visiteur.nom = [];
infosJoueurs.visiteur.numLicence = [];
infosJoueurs.visiteur.numero = [];

numRencontre_struct_stats = str2double(gamedata.numrencontre);
numRencontre = num2str(gamedata.numrencontre);
    while length(numRencontre) < 6
        numRencontre = ['0',numRencontre];
    end
    
%nombre de fautes coach
nbfautescoach.domicile = data_fautes_coach(1).B1 + data_fautes_coach(1).C1 + data_fautes_coach(1).D2;
nbfautescoach.visiteur = data_fautes_coach(2).B1 + data_fautes_coach(2).C1 + data_fautes_coach(2).D2;

%nb de lancers francs manqués
nblfmanque_domicile = length(find(cellfun(@(s) any(s == 'A'), lfmanque)));
nblfmanque_visiteur = length(find(cellfun(@(s) any(s == 'B'), lfmanque)));

%% Compute stats for the team domicile
 %check if the file for the team exists
   %check if ABCL.joueurs.licence exist. Exist -> 1 Doesn't exist -> 0   
doesTeamExist = true;
try
stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe;
catch
doesTeamExist = false;
stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).numeroEquipe = gamedata.numeroDom;
end

%compute stats for the team domicile
C = textread('recap.txt','%s','delimiter','\n');
%find line where the first name of visiteur is written. Because score at
%quart-temps are written lines before
linenum = find(~cellfun(@isempty,strfind(C,[data_coach(1).fautes,data_coach(1).nom])));
if gamedata.tdj == 1 %si tdj calculé
    data_tot_domicile = regexp(C{linenum-6},'^(?<tpsdejeu>\d+[:]\d+)\s(?<pts>\d+)\s(?<tirs>\d+)\s(?<troispts>\d+)\s(?<deuxext>\d+)\s(?<deuxint>\d+)\s(?<lfreussis>\d+)\s(?<ftes>\d+)','names','lineanchors'); 
else %si tdj pas calculé
    data_tot_domicile = regexp(C{linenum-6},'^(?<pts>\d+)\s(?<tirs>\d+)\s(?<troispts>\d+)\s(?<deuxext>\d+)\s(?<deuxint>\d+)\s(?<lfreussis>\d+)\s(?<ftes>\d+)','names','lineanchors');
end
pts_cinq_domicile = regexp(C{linenum-5},'^(?<ptscinq>\d+)','names','lineanchors');
pts_banc_domicile = regexp(C{linenum-4},'^(?<ptsbanc>\d+)','names','lineanchors');


%find line where the first name of visiteur is written. Because score at
%quart-temps are written lines before
linenum = find(~cellfun(@isempty,strfind(C,[data_coach(2).fautes,data_coach(2).nom])));
if gamedata.tdj == 1 %si tdj calculé
    data_tot_visiteur = regexp(C{linenum-6},'^(?<tpsdejeu>\d+[:]\d+)\s(?<pts>\d+)\s(?<tirs>\d+)\s(?<troispts>\d+)\s(?<deuxext>\d+)\s(?<deuxint>\d+)\s(?<lfreussis>\d+)\s(?<ftes>\d+)','names','lineanchors'); 
else %si tdj pas calculé
    data_tot_visiteur = regexp(C{linenum-6},'^(?<pts>\d+)\s(?<tirs>\d+)\s(?<troispts>\d+)\s(?<deuxext>\d+)\s(?<deuxint>\d+)\s(?<lfreussis>\d+)\s(?<ftes>\d+)','names','lineanchors'); 
end
pts_cinq_visiteur = regexp(C{linenum-5},'^(?<ptscinq>\d+)','names','lineanchors');
pts_banc_visiteur = regexp(C{linenum-4},'^(?<ptsbanc>\d+)','names','lineanchors');


% Stockage dans variables des stats equipe domicile
ptsm = str2double(data_tot_domicile.pts);
ptse = str2double(data_tot_visiteur.pts);
ptscinq = str2double(pts_cinq_domicile.ptscinq);
ptsbanc = str2double(pts_banc_domicile.ptsbanc);
pctptscinq = (str2double(pts_cinq_domicile.ptscinq)/str2double(data_tot_domicile.pts))*100;
tirs = str2double(data_tot_domicile.tirs);
trois = str2double(data_tot_domicile.troispts);
deuxext = str2double(data_tot_domicile.deuxext);
deuxint = str2double(data_tot_domicile.deuxint);
lfr = str2double(data_tot_domicile.lfreussis);
lft = str2double(data_tot_domicile.lfreussis) + nblfmanque_domicile;
lfp = (str2double(data_tot_domicile.lfreussis)/(str2double(data_tot_domicile.lfreussis) + nblfmanque_domicile))*100;
lfc = str2double(data_tot_visiteur.lfreussis) + nblfmanque_visiteur;
fautes = str2double(data_tot_domicile.ftes) + nbfautescoach.domicile;
fautesprov = str2double(data_tot_visiteur.ftes) - totfautes.domicile.asoustraire;



 %fill stats for players namewithoutspace in struct stats.clubs
if doesTeamExist == 1
    l = size(stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs);
    
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs(l(2)+1).numrencontre = numRencontre_struct_stats;    
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs(l(2)+1).nomrencontre = ['vs. ',gamedata.visiteurwithspace];
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs(l(2)+1).pts = ptsm;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs(l(2)+1).ptsencaisses = ptse;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs(l(2)+1).ptscinq = ptscinq;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs(l(2)+1).ptsbanc = ptsbanc;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs(l(2)+1).pctptscinq = pctptscinq;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs(l(2)+1).tirs = tirs;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs(l(2)+1).troispts = trois;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs(l(2)+1).deuxext = deuxext;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs(l(2)+1).deuxint = deuxint;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs(l(2)+1).lfreussis = lfr;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs(l(2)+1).lftentes = lft;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs(l(2)+1).lfpct = lfp;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs(l(2)+1).lfconc = lfc;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs(l(2)+1).ftes = fautes;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs(l(2)+1).ftesprov = fautesprov;
else
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs.numrencontre = numRencontre_struct_stats;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs.nomrencontre = ['vs. ',gamedata.visiteurwithspace];
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs.pts = ptsm;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs.ptsencaisses = ptse;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs.ptscinq = ptscinq;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs.ptsbanc = ptsbanc;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs.pctptscinq = pctptscinq;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs.tirs = tirs;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs.troispts = trois;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs.deuxext = deuxext;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs.deuxint = deuxint;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs.lfreussis = lfr;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs.lftentes = lft;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs.lfpct = lfp;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs.lfconc = lfc;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs.ftes = fautes;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs.ftesprov = fautesprov;

end

%sort structure
Afields = fieldnames(stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs);
Acell = struct2cell(stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs);
sz = size(Acell);
Acell = reshape(Acell,sz(1),[]);
Acell = Acell';
Acell = sortrows(Acell,1);
Acell = reshape(Acell',sz);
stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs = cell2struct(Acell,Afields,1);


    sqlStatsEquipes = sprintf([sqlStatsEquipes, 'INSERT INTO stats_equipes (matchs_id,equipes_id,saison_id,ptsm,ptse,pts5,tirs,trois,deuxext,deuxint,lfr,lft,fautes,lfc,fautesprov)']);
    sqlStatsEquipes = sprintf([sqlStatsEquipes,'\n']);
    sqlStatsEquipes = sprintf([sqlStatsEquipes, 'VALUES ((SELECT id_matchs FROM matchs INNER JOIN equipes ON id_equipes=equipedom_id INNER JOIN competition ON id_competition=competition_id WHERE (numero_match=',numRencontre,' AND matchs.comite_id=(SELECT id_comite FROM comite WHERE nom_comite=''',gamedata.comite,''') AND chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt=''',gamedata.chpt,''') AND matchs.saison_id = (SELECT id_saison FROM saison WHERE annee=',season,'))),']);
    sqlStatsEquipes = sprintf([sqlStatsEquipes,'(SELECT id_equipes FROM equipes WHERE (nom_equipe=''',gamedata.domicilewithoutspace,''' AND saison_id = (SELECT id_saison FROM saison WHERE annee=',season,') AND comite_id = (SELECT id_comite FROM comite WHERE nom_comite=''',gamedata.comite,''') AND competition_id = (SELECT id_competition FROM competition WHERE (chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt= ''',gamedata.chpt,''') AND poule_id=(SELECT id_poule FROM poule WHERE nom_poule=''',gamedata.poule,'''))))),']);
    sqlStatsEquipes = sprintf([sqlStatsEquipes,'(SELECT id_saison FROM saison WHERE annee=',season,'),']);
    sqlStatsEquipes = sprintf([sqlStatsEquipes,num2str(ptsm),',',num2str(ptse),',',num2str(ptscinq),',',num2str(tirs),',',num2str(trois),',',num2str(deuxext),',',num2str(deuxint),',',num2str(lfr),',',num2str(lft),',',num2str(fautes),',',num2str(lfc),',',num2str(fautesprov),');']);
    sqlStatsEquipes = sprintf([sqlStatsEquipes,'\n\n']);


%% Compute stats for the team visiteur
   %check if ABCL.joueurs.licence exist. Exist -> 1 Doesn't exist -> 0   
doesTeamExist = true;
try
stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe;
catch
doesTeamExist = false;
stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).numeroEquipe = gamedata.numeroVisit;
end

%compute stats for the team visiteur
clear linenum;

nblfmanque_visiteur = length(find(cellfun(@(s) any(s == 'B'), lfmanque)));

% Stockage dans variables des stats equipe domicile
ptsm = str2double(data_tot_visiteur.pts);
ptse = str2double(data_tot_domicile.pts);
ptscinq = str2double(pts_cinq_visiteur.ptscinq);
ptsbanc = str2double(pts_banc_visiteur.ptsbanc);
pctptscinq = (str2double(pts_cinq_visiteur.ptscinq)/str2double(data_tot_visiteur.pts))*100;
tirs = str2double(data_tot_visiteur.tirs);
trois = str2double(data_tot_visiteur.troispts);
deuxext = str2double(data_tot_visiteur.deuxext);
deuxint = str2double(data_tot_visiteur.deuxint);
lfr = str2double(data_tot_visiteur.lfreussis);
lft = str2double(data_tot_visiteur.lfreussis) + nblfmanque_visiteur;
lfp = (str2double(data_tot_visiteur.lfreussis)/(str2double(data_tot_visiteur.lfreussis) + nblfmanque_visiteur))*100;
lfc = str2double(data_tot_domicile.lfreussis) + nblfmanque_domicile;
fautes = str2double(data_tot_visiteur.ftes) + nbfautescoach.visiteur;
fautesprov = str2double(data_tot_domicile.ftes) - totfautes.visiteur.asoustraire;


 %fill stats for players namewithoutspace in struct stats.clubs
if doesTeamExist == 1
    l = size(stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs);
    
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs(l(2)+1).numrencontre = numRencontre_struct_stats;    
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs(l(2)+1).nomrencontre = ['@. ',gamedata.domicilewithspace];
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs(l(2)+1).pts = ptsm;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs(l(2)+1).ptsencaisses = ptse;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs(l(2)+1).ptscinq = ptscinq;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs(l(2)+1).ptsbanc = ptsbanc;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs(l(2)+1).pctptscinq = pctptscinq;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs(l(2)+1).tirs = tirs;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs(l(2)+1).troispts = trois;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs(l(2)+1).deuxext = deuxext;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs(l(2)+1).deuxint = deuxint;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs(l(2)+1).lfreussis = lfr;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs(l(2)+1).lftentes = lft;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs(l(2)+1).lfpct = lfp;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs(l(2)+1).lfconc = lfc;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs(l(2)+1).ftes = fautes;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs(l(2)+1).ftesprov = fautesprov;
   
else
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs.numrencontre = numRencontre_struct_stats;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs.nomrencontre = ['@. ',gamedata.domicilewithspace];
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs.pts = ptsm;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs.ptsencaisses = ptse;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs.ptscinq = ptscinq;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs.ptsbanc = ptsbanc;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs.pctptscinq = pctptscinq;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs.tirs = tirs;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs.troispts = trois;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs.deuxext = deuxext;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs.deuxint = deuxint;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs.lfreussis = lfr;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs.lftentes = lft;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs.lfpct = lfp;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs.lfconc = lfc;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs.ftes = fautes;
      stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs.ftesprov = fautesprov;
end

    %sort structure
    Afields = fieldnames(stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs);
    Acell = struct2cell(stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs);
    sz = size(Acell);
    Acell = reshape(Acell,sz(1),[]);
    Acell = Acell';
    Acell = sortrows(Acell,1);
    Acell = reshape(Acell',sz);
    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs = cell2struct(Acell,Afields,1);


    sqlStatsEquipes = sprintf([sqlStatsEquipes, 'INSERT INTO stats_equipes (matchs_id,equipes_id,saison_id,ptsm,ptse,pts5,tirs,trois,deuxext,deuxint,lfr,lft,fautes,lfc,fautesprov)']);
    sqlStatsEquipes = sprintf([sqlStatsEquipes,'\n']);
    sqlStatsEquipes = sprintf([sqlStatsEquipes, 'VALUES ((SELECT id_matchs FROM matchs INNER JOIN equipes ON id_equipes=equipedom_id INNER JOIN competition ON id_competition=competition_id WHERE (numero_match=',numRencontre,' AND matchs.comite_id=(SELECT id_comite FROM comite WHERE nom_comite=''',gamedata.comite,''') AND chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt=''',gamedata.chpt,''') AND matchs.saison_id = (SELECT id_saison FROM saison WHERE annee=',season,'))),']);
    sqlStatsEquipes = sprintf([sqlStatsEquipes,'(SELECT id_equipes FROM equipes WHERE (nom_equipe=''',gamedata.visiteurwithoutspace,''' AND saison_id = (SELECT id_saison FROM saison WHERE annee=',season,') AND comite_id = (SELECT id_comite FROM comite WHERE nom_comite=''',gamedata.comite,''') AND competition_id = (SELECT id_competition FROM competition WHERE (chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt= ''',gamedata.chpt,''') AND poule_id=(SELECT id_poule FROM poule WHERE nom_poule=''',gamedata.poule,'''))))),']);
    sqlStatsEquipes = sprintf([sqlStatsEquipes,'(SELECT id_saison FROM saison WHERE annee=',season,'),']);
    sqlStatsEquipes = sprintf([sqlStatsEquipes,num2str(ptsm),',',num2str(ptse),',',num2str(ptscinq),',',num2str(tirs),',',num2str(trois),',',num2str(deuxext),',',num2str(deuxint),',',num2str(lfr),',',num2str(lft),',',num2str(fautes),',',num2str(lfc),',',num2str(fautesprov),');']);
    sqlStatsEquipes = sprintf([sqlStatsEquipes,'\n\n']);

    
%% Stats pour joueurs de team domicile

for i = 1 : numel(data_recap_domicile) - 1 %-1 pour enlever la ligne total 

namewithoutspace = strrep(data_recap_domicile(i).nom,' ','_');
namewithoutspace = strrep(namewithoutspace,'-','_');
namewithoutspace = strrep(namewithoutspace,',','_');
namewithoutspace = strrep(namewithoutspace,'/','_');
namewithoutspace = strrep(namewithoutspace,'___','_');
namewithoutspace = strrep(namewithoutspace,'__','_');

namewithoutspace_raccourci = strrep(data_fdm_domicile(i).nom,' ','_');
namewithoutspace_raccourci = strrep(namewithoutspace_raccourci,'-','_');
namewithoutspace_raccourci = strrep(namewithoutspace_raccourci,',','_');
namewithoutspace_raccourci = strrep(namewithoutspace_raccourci,'/','_');
namewithoutspace_raccourci = strrep(namewithoutspace_raccourci,'___','_');
namewithoutspace_raccourci = strrep(namewithoutspace_raccourci,'__','_');
namewithoutspace_raccourci = strrep(namewithoutspace_raccourci,'.','');
namewithoutspace_raccourci = strrep(namewithoutspace_raccourci,'_(CAP)','');
namewithoutspace_raccourci = strrep(namewithoutspace_raccourci,'_(*CAP)','');
     
    % equipes et numero du joueur domicile sous forme A12
    numeroJoueur = str2double(data_recap_domicile(i).num);
    codeJoueur = ['A',num2str(numeroJoueur)];
    
    % est ce que le joueur est dans le 5?
    if any(strcmp(cinqdomicile,codeJoueur),1) % check si une valeur est differente de 0 dans l'array de comparaison du code joueur avec le cinq de base
        cinqMajeur = 'true';
    else
        cinqMajeur = 'false';
    end
    
    %compute number of missed free throws
    nblfmanque_joueur = length(find(count(lfmanque,(codeJoueur))));
    
    %ecart, points marques et points encaisses du joueur
    doesVarExist = true;
    try
    ecart.(codeJoueur);
    catch
    doesVarExist = false;
    end
    if doesVarExist == 1
        ecartjoueurdomicile = ecart.(codeJoueur).ecarttotal;
        ptsmarqjoueurdomicile = ecart.(codeJoueur).ptsmarqtotal;
        ptsencjoueurdomicile = ecart.(codeJoueur).ptsenctotal;
    else 
        ecartjoueurdomicile = NaN;
        ptsmarqjoueurdomicile = NaN;
        ptsencjoueurdomicile = NaN;
    end

    
  %check if ABCL.joueurs.licence exist. Exist -> 1 Doesn't exist -> 0   
doesPlayerExist = true;
try
    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace);
catch
    doesPlayerExist = false;
end

% Détermination du numero de licence
if strcmp(data_fdm_domicile(i).licence,'VT000000')==0 % si num licence fdm pas egal a VT000000 alors il est valide
    numLicence = data_fdm_domicile(i).licence;
    
    if doesPlayerExist == true %si joueur esxiste dans stats.mat on verifie sa licence
        licenceSaved = stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).licence;
        if strcmp(licenceSaved(1:2),'AA') % si le numero commence par AA on le change dans la structure
            stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).licence = data_fdm_domicile(i).licence;
            
            % On supprime l'entrée pour ce joueur dans la structure
            % jouerusSansLicence
            sizeListeJoueursSansLicence = size(listeJoueursSansLicence);
            for ligne = sizeListeJoueursSansLicence(1) : -1 : 1
                if strcmp(listeJoueursSansLicence{ligne,2},licenceSaved) % on supprime la ligne
                    listeJoueursSansLicence(ligne,:) = [];
                end
            end
            
            % on vérifie si le joueur existe dans listeJoueurs. Possible si
            % le joueur a participé a une autre competition ou a joué une
            % autre année
[doesJoueursListeJoueursExist,namewithoutspace,listeJoueurs,stats,doesPlayerExist,sqlJoueurs] = checkListeJoueurs(data_fdm_domicile(i).licence,strrep(data_recap_domicile(i).nom,' ','_'),gamedata.domicilewithoutspace,listeJoueurs,gamedata,namewithoutspace,stats,sqlJoueurs);

            if doesJoueursListeJoueursExist == true
                % update tous les joueurs_id des table
                sqlJoueurs = sprintf([sqlJoueurs,'UPDATE jointure_joueurs_equipes SET joueurs_id=(SELECT id_joueurs FROM joueurs WHERE licence=''',numLicence,''' AND nom_joueur=''',namewithoutspace,''')']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'WHERE joueurs_id=(SELECT id_joueurs FROM joueurs WHERE licence=''',licenceSaved,''' AND nom_joueur=''',namewithoutspace,''');']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'UPDATE stats_joueurs SET joueurs_id=(SELECT id_joueurs FROM joueurs WHERE licence=''',numLicence,''' AND nom_joueur=''',namewithoutspace,''')']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'WHERE joueurs_id=(SELECT id_joueurs FROM joueurs WHERE licence=''',licenceSaved,''' AND nom_joueur=''',namewithoutspace,''');']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'UPDATE ecart_cinq SET joueur_1=(SELECT id_joueurs FROM joueurs WHERE licence=''',numLicence,''' AND nom_joueur=''',namewithoutspace,''')']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'WHERE joueur_1=(SELECT id_joueurs FROM joueurs WHERE licence=''',licenceSaved,''' AND nom_joueur=''',namewithoutspace,''');']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'UPDATE ecart_cinq SET joueur_2=(SELECT id_joueurs FROM joueurs WHERE licence=''',numLicence,''' AND nom_joueur=''',namewithoutspace,''')']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'WHERE joueur_2=(SELECT id_joueurs FROM joueurs WHERE licence=''',licenceSaved,''' AND nom_joueur=''',namewithoutspace,''');']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'UPDATE ecart_cinq SET joueur_3=(SELECT id_joueurs FROM joueurs WHERE licence=''',numLicence,''' AND nom_joueur=''',namewithoutspace,''')']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'WHERE joueur_3=(SELECT id_joueurs FROM joueurs WHERE licence=''',licenceSaved,''' AND nom_joueur=''',namewithoutspace,''');']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'UPDATE ecart_cinq SET joueur_4=(SELECT id_joueurs FROM joueurs WHERE licence=''',numLicence,''' AND nom_joueur=''',namewithoutspace,''')']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'WHERE joueur_4=(SELECT id_joueurs FROM joueurs WHERE licence=''',licenceSaved,''' AND nom_joueur=''',namewithoutspace,''');']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'UPDATE ecart_cinq SET joueur_5=(SELECT id_joueurs FROM joueurs WHERE licence=''',numLicence,''' AND nom_joueur=''',namewithoutspace,''')']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'WHERE joueur_5=(SELECT id_joueurs FROM joueurs WHERE licence=''',licenceSaved,''' AND nom_joueur=''',namewithoutspace,''');']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n\n']);
                
                % on supprime la ligne de joueurs ou licence =AA
                sqlJoueurs = sprintf([sqlJoueurs,'DELETE FROM joueurs WHERE (licence=''',licenceSaved,''' AND nom_joueur=''',namewithoutspace,''');']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n\n']);
            else
                %on update la table joueurs 
                adn2 = numLicence(3:4); %on prend les 2 et 3e caracteres de la licence(rpz adn)
                if str2double(adn2) > 20  % si chiffres adn >20, c'est l'année 1900, sinon c'est 2000
                    adn = ['19',num2str(adn2)];
                else
                    adn = ['20',num2str(adn2)];
                end


                sqlJoueurs = sprintf([sqlJoueurs,'UPDATE joueurs SET licence=''',numLicence,''', adn=',adn,' WHERE (licence=''',licenceSaved,''' AND nom_joueur=''',namewithoutspace,''');']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n\n']);
                % et on insère le joueur dans listeJoueurs
                if strcmp(numLicence,'AA') == 0
                    listeJoueurs{end+1,1}= data_fdm_domicile(i).licence;
                    listeJoueurs{end,2}= namewithoutspace;
                end
            end  
            
        elseif strcmp(numLicence,licenceSaved) == 0
            numLicence = licenceSaved; % On met que le numero de licence du joueur est celui sauvé. Cela evite le probleme de si la personne se trompe en rentrant le numero
            %par contre probleme si le numero entré est pas le bon. On
            %ecrit alors un ,message dans le fichier erreur.txt pour dire
            %qu'il faudra verifier quand il y aura des donnees en plus pour
            %ce joueur
            erreur = ['Verifier la licence du joueur ',namewithoutspace,' du comité ',gamedata.comite,' de l''équipe ',gamedata.domicilewithoutspace,' du championnat ',gamedata.chpt,' de la poule ',gamedata.poule,'.'];
            erreur = [erreur,'\n'];
            erreur = [erreur,'Son numéro de licence a été différent sur deux matchs différents.'];
            erreur = [erreur,'\n'];
            erreur = [erreur,'!!!!!!!!!!!!! PENSER A CHANGER DANS TABLE JOUEURS ET DANS STRUCTURE STATS.MAT ET DANS LISTEJOUEURS !!!!!!!!!!!!!!'];
            erreur = [erreur,'\n\n'];
            fid = fopen('aVerifier.txt','A');
            fprintf(fid,'%s\n',erreur);
            fclose(fid); 
        end
    end
    
    
else %sinon le num de la fdm est VT000000
    if doesPlayerExist == true 
        licenceSaved = stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).licence;
        if strcmp(licenceSaved(1:2),'AA')==0 %si debut num licence enregistré dans la structure est different de AA alors c'est le bon numero de licence
            numLicence = licenceSaved;
        else %si licence fdm est VT000000 et licence stats.mat est AA
            numLicence = licenceSaved;
        end
    else %si le joueur n'existe pas on le rentre dans la structure joueursSansLicence
        if isempty(listeJoueursSansLicence)
            id = 1;
            listeJoueursSansLicence{1,1} = id;
        else
            id=listeJoueursSansLicence{end,1} + 1;
            listeJoueursSansLicence{end+1,1} = id;
        end

        idString = num2str(id);
        while length(idString) < 6
            idString = ['0',idString];
        end

        listeJoueursSansLicence{end,2} = ['AA',idString];
        listeJoueursSansLicence{end,3} = namewithoutspace;
        listeJoueursSansLicence{end,4} = gamedata.domicilewithoutspace;

        numLicence = ['AA',idString];

    end
end


%annee de naissance
if strcmp(numLicence(1:2),'AA') == 1
    adn = '0000';
    age = NaN;
   
else
    adn2 = numLicence(3:4); %on prend les 2 et 3e caracteres de la licence(rpz adn)
    if str2double(adn2) > 20  % si chiffres adn >20, c'est l'année 1900, sinon c'est 2000
        adn = ['19',num2str(adn2)];
    else
        adn = ['20',num2str(adn2)];
    end
    age = annee_en_cours - str2double(adn); %age au 31/12 de la saison en cours
end


%Si le joueur n'existe pas, on regarde s'il existe dans listeJoueurs
if doesPlayerExist == false
[doesJoueursListeJoueursExist,namewithoutspace,listeJoueurs,stats,doesPlayerExist,sqlJoueurs] = checkListeJoueurs(data_fdm_domicile(i).licence,strrep(data_recap_domicile(i).nom,' ','_'),gamedata.domicilewithoutspace,listeJoueurs,gamedata,namewithoutspace,stats,sqlJoueurs);
    
     if doesJoueursListeJoueursExist == false

            % le joueur est nouveau alors on créé son nom dans la base de donnée
            sqlJoueurs = sprintf([sqlJoueurs, 'INSERT INTO joueurs (licence, nom_joueur, nom_joueur_raccourci, adn)']);
            sqlJoueurs = sprintf([sqlJoueurs,'\n']);
            sqlJoueurs = sprintf([sqlJoueurs, 'VALUES (''',numLicence,''',''',namewithoutspace,''',''',namewithoutspace_raccourci,''',',adn,');']);
            sqlJoueurs = sprintf([sqlJoueurs,'\n\n']);

            if strcmp(numLicence(1:2),'AA') == 0
                listeJoueurs{end+1,1}= data_fdm_domicile(i).licence;
                listeJoueurs{end,2}= namewithoutspace;
            end  
    end        
end

% on insere le joueur dans la structure qui répertorie les joueurs pour le
% calcul des ecarts par 5
infosJoueurs.domicile.nom{end+1} = namewithoutspace;
infosJoueurs.domicile.numLicence{end+1} = numLicence;
infosJoueurs.domicile.numero{end+1} = numeroJoueur;


% Si le joueur n'existe pas encore dans structure stats, il faut faire
% requete de jointure entre joueurs et equipes
if doesPlayerExist == false
    sqlJoueurs = sprintf([sqlJoueurs,'INSERT INTO jointure_joueurs_equipes (joueurs_id,equipes_id)']);
    sqlJoueurs = sprintf([sqlJoueurs,'\n']);
    sqlJoueurs = sprintf([sqlJoueurs,'VALUES ((SELECT id_joueurs FROM joueurs WHERE (nom_joueur=''',namewithoutspace,''' AND licence=''',numLicence,''')),']);
    sqlJoueurs = sprintf([sqlJoueurs,'(SELECT id_equipes FROM equipes WHERE (nom_equipe=''',gamedata.domicilewithoutspace,''' AND saison_id = (SELECT id_saison FROM saison WHERE annee=',season,') AND comite_id = (SELECT id_comite FROM comite WHERE nom_comite= ''',gamedata.comite,''') AND competition_id = (SELECT id_competition FROM competition WHERE (chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt= ''',gamedata.chpt,''') AND poule_id=(SELECT id_poule FROM poule WHERE nom_poule=''',gamedata.poule,'''))))));']);
    sqlJoueurs = sprintf([sqlJoueurs,'\n\n']);
end

    % On regarde si le temps de jeu est calculé
    if gamedata.tdj == 1 %si tdj calculé
    tdj = str2double(data_recap_domicile(i).min)+(str2double(data_recap_domicile(i).sec)/60);
   elseif isempty(tdj_struct) %si tdj pas calculé
    tdj = NaN;
   else %les temps de jeu sont dans la structure tdj_struct
       tdj = tdj_struct.(codeJoueur).tdjtotal; % si erreur pb tdj_struct
    end
   
    % On stocke les stats dans variables pour faciliter requete
    
    numeroJoueur = numeroJoueur;
    points = str2double(data_recap_domicile(i).pts);
    tirs = str2double(data_recap_domicile(i).tirs);
    trois = str2double(data_recap_domicile(i).troispts);
    deuxext = str2double(data_recap_domicile(i).deuxext);
    deuxint = str2double(data_recap_domicile(i).deuxint);
    lfr = str2double(data_recap_domicile(i).lf);
    lft = str2double(data_recap_domicile(i).lf) + nblfmanque_joueur;
    lfp = (str2double(data_recap_domicile(i).lf) / (str2double(data_recap_domicile(i).lf)+nblfmanque_joueur))*100;
    fautes = str2double(data_recap_domicile(i).ftes);
    lfc = data_fautes_domicile(i).lfconc;
    anti = data_fautes_domicile(i).nbanti;
    tech = data_fautes_domicile(i).nbtech;
    disqua = data_fautes_domicile(i).nbdisqua;
    

%fill stats for players namewithoutspace in struct stats.clubs
if doesPlayerExist == 1
   l = size(stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs);
   
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).numrencontre = numRencontre_struct_stats;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).nomrencontre = ['vs. ',gamedata.visiteurwithspace];
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).tpsdejeu = tdj;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).pts = points;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).tirs = tirs;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).troispts = trois;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).deuxext = deuxext;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).deuxint = deuxint;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).lfreussis = lfr;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).lftentes = lft;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).lfpct = lfp;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).ftes = fautes;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).ptsmarq = ptsmarqjoueurdomicile;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).ptsenc = ptsencjoueurdomicile;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).ecart = ecartjoueurdomicile;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).lfconc = lfc;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).anti = anti;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).tech = tech;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).disqua = disqua;
        
    % on update age et adn du joueur dans la structure stats
    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).adn = adn;
    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).age = age;
    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).licence = numLicence;

   
else % Le joueur n'existe pas encore dans la structure stats
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs.numrencontre = numRencontre_struct_stats;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs.nomrencontre = ['vs. ',gamedata.visiteurwithspace];   
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs.tpsdejeu = tdj;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs.pts = points;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs.tirs = tirs;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs.troispts = trois;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs.deuxext = deuxext;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs.deuxint = deuxint;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs.lfreussis = lfr;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs.lftentes = lft;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs.lfpct = lfp;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs.ftes = fautes;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs.ptsmarq = ptsmarqjoueurdomicile;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs.ptsenc = ptsencjoueurdomicile;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs.ecart = ecartjoueurdomicile;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs.lfconc = lfc;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs.anti = anti;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs.tech = tech;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs.disqua = disqua;
   
      
    % Ajout de adn et age dans structure stats. Le sql est fait plus loin
    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).adn = adn;
    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).age = age;
    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).licence = numLicence;
  
end 
 
% On insere les stats du joueur dans la table pour ce match
    if isnan(tdj)
        tdj = 'NULL';
    else
        tdj = num2str(tdj);
    end
    
    sqlStatsJoueurs = sprintf([sqlStatsJoueurs, 'INSERT INTO stats_joueurs (matchs_id,joueurs_id,saison_id,tdj,points,tirs,trois,deuxext,deuxint,lfr,lft,fautes,lfc,ecartplus,ecartmoins,5majeur,numero_joueur)']);
    sqlStatsJoueurs = sprintf([sqlStatsJoueurs,'\n']);
    sqlStatsJoueurs = sprintf([sqlStatsJoueurs, 'VALUES ((SELECT id_matchs FROM matchs INNER JOIN equipes ON id_equipes=equipedom_id INNER JOIN competition ON id_competition=competition_id WHERE (numero_match=',numRencontre,' AND matchs.comite_id=(SELECT id_comite FROM comite WHERE nom_comite=''',gamedata.comite,''') AND chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt=''',gamedata.chpt,''' AND matchs.saison_id = (SELECT id_saison FROM saison WHERE annee=',season,')))),']);
    sqlStatsJoueurs = sprintf([sqlStatsJoueurs,'(SELECT id_joueurs FROM joueurs WHERE (nom_joueur=''',namewithoutspace,''' AND licence=''',numLicence,''')),']);
    sqlStatsJoueurs = sprintf([sqlStatsJoueurs,'(SELECT id_saison FROM saison WHERE annee=',season,'),']);
    sqlStatsJoueurs = sprintf([sqlStatsJoueurs,tdj,',',num2str(points),',',num2str(tirs),',',num2str(trois),',',num2str(deuxext),',',num2str(deuxint),',',num2str(lfr),',',num2str(lft),',',num2str(fautes),',',num2str(lfc),',',strrep(num2str(ptsmarqjoueurdomicile),'NaN','NULL'),',',strrep(num2str(ptsencjoueurdomicile),'NaN','NULL'),',',cinqMajeur,',',num2str(numeroJoueur),');']);
    sqlStatsJoueurs = sprintf([sqlStatsJoueurs,'\n\n']);

%sort structure 
Afields = fieldnames(stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs);
Acell = struct2cell(stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs);
sz = size(Acell);
Acell = reshape(Acell,sz(1),[]);
Acell = Acell';
Acell = sortrows(Acell,1);
Acell = reshape(Acell',sz);
stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).matchs = cell2struct(Acell,Afields,1);

   
    %structure for stats par match    
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace])(i).numero = numeroJoueur;
   if isempty(find(ismember(cinqdomicile, codeJoueur),1)) == 0 %check si joueur est dans le 5
    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace])(i).nomjoueur = [data_recap_domicile(i).nom,' *'];
   else
   	stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace])(i).nomjoueur = data_recap_domicile(i).nom;
   end
   if gamedata.tdj == 1 %si tdj calculé
    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace])(i).tpsdejeu = [data_recap_domicile(i).min,':',data_recap_domicile(i).sec];
   elseif isempty(tdj_struct) %si tdj pas calculé
    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace])(i).tpsdejeu = '-';
   else
    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace])(i).tpsdejeu = num2str(tdj_struct.(codeJoueur).tdjtotal,'%3.1f'); % si erreur pb tdj_struct
   end   
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace])(i).pts = str2double(data_recap_domicile(i).pts);
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace])(i).tirs = str2double(data_recap_domicile(i).tirs);
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace])(i).troispts = str2double(data_recap_domicile(i).troispts);
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace])(i).deuxext = str2double(data_recap_domicile(i).deuxext);
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace])(i).deuxint = str2double(data_recap_domicile(i).deuxint);
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace])(i).lfreussis = str2double(data_recap_domicile(i).lf);
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace])(i).lftentes = str2double(data_recap_domicile(i).lf) + nblfmanque_domicile;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace])(i).lfpct = (str2double(data_recap_domicile(i).lf) / (str2double(data_recap_domicile(i).lf)+nblfmanque_domicile))*100;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace])(i).ftes = str2double(data_recap_domicile(i).ftes);
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace])(i).ptsmarq = ptsmarqjoueurdomicile;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace])(i).ptsenc = ptsencjoueurdomicile;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace])(i).ecart = ecartjoueurdomicile;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace])(i).lfconc = data_fautes_domicile(i).lfconc;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace])(i).age = stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).joueurs.(namewithoutspace).age;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace])(i).anti = data_fautes_domicile(i).nbanti;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace])(i).tech = data_fautes_domicile(i).nbtech;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace])(i).disqua = data_fautes_domicile(i).nbdisqua;

end

%% Compute stats for the players of team visiteur

 %organize stats for the team visiteur
 for i = 1 : numel(data_recap_visiteur) - 1
     
    namewithoutspace = strrep(data_recap_visiteur(i).nom,' ','_');
    namewithoutspace = strrep(namewithoutspace,'-','_');
    namewithoutspace = strrep(namewithoutspace,',','_');
    namewithoutspace = strrep(namewithoutspace,'/','_');
    namewithoutspace = strrep(namewithoutspace,'___','_');
    namewithoutspace = strrep(namewithoutspace,'__','_');
    
    namewithoutspace_raccourci = strrep(data_fdm_visiteur(i).nom,' ','_'); %pb: une licence erronee
    namewithoutspace_raccourci = strrep(namewithoutspace_raccourci,'-','_');
    namewithoutspace_raccourci = strrep(namewithoutspace_raccourci,',','_');
    namewithoutspace_raccourci = strrep(namewithoutspace_raccourci,'/','_');
    namewithoutspace_raccourci = strrep(namewithoutspace_raccourci,'___','_');
    namewithoutspace_raccourci = strrep(namewithoutspace_raccourci,'__','_');
    namewithoutspace_raccourci = strrep(namewithoutspace_raccourci,'.','');
    namewithoutspace_raccourci = strrep(namewithoutspace_raccourci,'_(CAP)','');
    namewithoutspace_raccourci = strrep(namewithoutspace_raccourci,'_(*CAP)','');
     
    numeroJoueur = str2double(data_recap_visiteur(i).num);
    codeJoueur = ['B',num2str(numeroJoueur)];
     
     % est ce que le joueur est dans le 5?
    if any(strcmp(cinqvisiteur,codeJoueur),1) % check si une valeur est differente de 0 dans l'array de comparaison du code joueur avec le cinq de base
        cinqMajeur = 'true';
    else
        cinqMajeur = 'false';
    end
     
         %compute number of missed free throws
    nblfmanque_joueur = length(find(count(lfmanque,(codeJoueur))));
    
    %ecart, points marques et points encaisses du joueur
    doesVarExist = true;
    try
    ecart.(codeJoueur);
    catch
    doesVarExist = false;
    end
    if doesVarExist == 1
        ecartjoueurvisiteur = ecart.(codeJoueur).ecarttotal;
        ptsmarqjoueurvisiteur = ecart.(codeJoueur).ptsmarqtotal;
        ptsencjoueurvisiteur = ecart.(codeJoueur).ptsenctotal;
    else 
        ecartjoueurvisiteur = NaN;
        ptsmarqjoueurvisiteur = NaN;
        ptsencjoueurvisiteur = NaN;
    end


  %check if ABCL.joueurs.licence exist. Exist -> 1 Doesn't exist -> 0   
doesPlayerExist = true;
try
stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace);
catch
doesPlayerExist = false;
end

% Détermination du numero de licence  
if strcmp(data_fdm_visiteur(i).licence,'VT000000')==0 % si num licence fdm pas egal a VT000000 alors il est valide
    numLicence = data_fdm_visiteur(i).licence;
    
    if doesPlayerExist == true %si joueur esxiste dans stats.mat on verifie sa licence
        licenceSaved = stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).licence;
        if strcmp(licenceSaved(1:2),'AA') % si le numero commence par AA on le change dans la structure
            stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).licence = data_fdm_visiteur(i).licence;
            
            % On supprime l'entrée pour ce joueur dans la structure
            % jouerusSansLicence
            sizeListeJoueursSansLicence = size(listeJoueursSansLicence);
            for ligne = sizeListeJoueursSansLicence(1) : -1 : 1
                if strcmp(listeJoueursSansLicence{ligne,2},licenceSaved) % on supprime la ligne
                    listeJoueursSansLicence(ligne,:) = [];
                end
            end
            
            % on vérifie si le joueur existe dans listeJoueurs. Possible si
            % le joueur a participé a une autre competition ou a joué une
            % autre année
            [doesJoueursListeJoueursExist,namewithoutspace,listeJoueurs,stats,doesPlayerExist,sqlJoueurs] = checkListeJoueurs(data_fdm_visiteur(i).licence,strrep(data_recap_visiteur(i).nom,' ','_'),gamedata.visiteurwithoutspace,listeJoueurs,gamedata,namewithoutspace,stats,sqlJoueurs);

            
            if doesJoueursListeJoueursExist == true
                
                 % update tous les joueurs_id des table
                sqlJoueurs = sprintf([sqlJoueurs,'UPDATE jointure_joueurs_equipes SET joueurs_id=(SELECT id_joueurs FROM joueurs WHERE licence=''',numLicence,''' AND nom_joueur=''',namewithoutspace,''')']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'WHERE joueurs_id=(SELECT id_joueurs FROM joueurs WHERE licence=''',licenceSaved,''' AND nom_joueur=''',namewithoutspace,''');']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'UPDATE stats_joueurs SET joueurs_id=(SELECT id_joueurs FROM joueurs WHERE licence=''',numLicence,''' AND nom_joueur=''',namewithoutspace,''')']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'WHERE joueurs_id=(SELECT id_joueurs FROM joueurs WHERE licence=''',licenceSaved,''' AND nom_joueur=''',namewithoutspace,''');']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'UPDATE ecart_cinq SET joueur_1=(SELECT id_joueurs FROM joueurs WHERE licence=''',numLicence,''' AND nom_joueur=''',namewithoutspace,''')']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'WHERE joueur_1=(SELECT id_joueurs FROM joueurs WHERE licence=''',licenceSaved,''' AND nom_joueur=''',namewithoutspace,''');']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'UPDATE ecart_cinq SET joueur_2=(SELECT id_joueurs FROM joueurs WHERE licence=''',numLicence,''' AND nom_joueur=''',namewithoutspace,''')']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'WHERE joueur_2=(SELECT id_joueurs FROM joueurs WHERE licence=''',licenceSaved,''' AND nom_joueur=''',namewithoutspace,''');']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'UPDATE ecart_cinq SET joueur_3=(SELECT id_joueurs FROM joueurs WHERE licence=''',numLicence,''' AND nom_joueur=''',namewithoutspace,''')']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'WHERE joueur_3=(SELECT id_joueurs FROM joueurs WHERE licence=''',licenceSaved,''' AND nom_joueur=''',namewithoutspace,''');']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'UPDATE ecart_cinq SET joueur_4=(SELECT id_joueurs FROM joueurs WHERE licence=''',numLicence,''' AND nom_joueur=''',namewithoutspace,''')']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'WHERE joueur_4=(SELECT id_joueurs FROM joueurs WHERE licence=''',licenceSaved,''' AND nom_joueur=''',namewithoutspace,''');']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'UPDATE ecart_cinq SET joueur_5=(SELECT id_joueurs FROM joueurs WHERE licence=''',numLicence,''' AND nom_joueur=''',namewithoutspace,''')']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n']);
                sqlJoueurs = sprintf([sqlJoueurs,'WHERE joueur_5=(SELECT id_joueurs FROM joueurs WHERE licence=''',licenceSaved,''' AND nom_joueur=''',namewithoutspace,''');']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n\n']);
                
                % on supprime la ligne de joueurs ou licence =AA
                sqlJoueurs = sprintf([sqlJoueurs,'DELETE FROM joueurs WHERE (licence=''',licenceSaved,''' AND nom_joueur=''',namewithoutspace,''');']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n\n']);
            else
                %on update la table joueurs 
                adn2 = numLicence(3:4); %on prend les 2 et 3e caracteres de la licence(rpz adn)
                if str2double(adn2) > 20  % si chiffres adn >20, c'est l'année 1900, sinon c'est 2000
                    adn = ['19',num2str(adn2)];
                else
                    adn = ['20',num2str(adn2)];
                end
                
                
                sqlJoueurs = sprintf([sqlJoueurs,'UPDATE joueurs SET licence=''',numLicence,''', adn=',adn,' WHERE (licence=''',licenceSaved,''' AND nom_joueur=''',namewithoutspace,''');']);
                sqlJoueurs = sprintf([sqlJoueurs,'\n\n']);
                % et on insère le joueur dans listeJoueurs
                if strcmp(numLicence(1:2),'AA') == 0
                    listeJoueurs{end+1,1}= data_fdm_visiteur(i).licence;
                    listeJoueurs{end,2}= namewithoutspace; 
                end
                
            end
        elseif strcmp(numLicence,licenceSaved) == 0
            numLicence = licenceSaved; % On met que le numero de licence du joueur est celui sauvé. Cela evite le probleme de si la personne se trompe en rentrant le numero
            %par contre probleme si le numero entré est pas le bon. On
            %ecrit alors un ,message dans le fichier erreur.txt pour dire
            %qu'il faudra verifier quand il y aura des donnees en plus pour
            %ce joueur
            erreur = ['Verifier la licence du joueur ',namewithoutspace,' du comité ',gamedata.comite,' de l''équipe ',gamedata.visiteurwithoutspace,' du championnat ',gamedata.chpt,' de la poule ',gamedata.poule,'.'];
            erreur = [erreur,'\n'];
            erreur = [erreur,'Son numéro de licence a été différent sur deux matchs différents.'];
            erreur = [erreur,'\n'];
            erreur = [erreur,'!!!!!!!!!!!!! PENSER A CHANGER DANS TABLE JOUEURS ET DANS STRUCTURE STATS.MAT ET DANS LISTEJOUEURS !!!!!!!!!!!!!!'];
            erreur = [erreur,'\n\n'];
            fid = fopen('aVerifier.txt','A');
            fprintf(fid,'%s\n',erreur);
            fclose(fid);
        end
    end
    
else %sinon le num de la fdm est VT000000
        if doesPlayerExist == true 
            licenceSaved = stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).licence;
            if strcmp(licenceSaved(1:2),'AA')==0 %si debut num licence enregistré dans la structure est different de AA alors c'est le bon numero de licence
                numLicence = licenceSaved;
            else %si licence fdm est VT000000 et licence stats.mat est AA
                numLicence = licenceSaved;
            end
        else %si le joueur n'existe pas on le rentre dans la structure joueursSansLicence
            if isempty(listeJoueursSansLicence)
                id = 1;
                listeJoueursSansLicence{1,1} = id;
            else
                id=listeJoueursSansLicence{end,1} + 1;
                listeJoueursSansLicence{end+1,1} = id;
            end

            idString = num2str(id);
            while length(idString) < 6
                idString = ['0',idString];
            end

            listeJoueursSansLicence{end,2} = ['AA',idString];
            listeJoueursSansLicence{end,3} = namewithoutspace;
            listeJoueursSansLicence{end,4} = gamedata.visiteurwithoutspace;

            numLicence = ['AA',idString];
        end
end


%annee de naissance
if strcmp(numLicence(1:2),'AA') == 1
    adn = '0000';
    age = NaN;
   
else
    adn2 = numLicence(3:4); %on prend les 2 et 3e caracteres de la licence(rpz adn)
    if str2double(adn2) > 20  % si chiffres adn >20, c'est l'année 1900, sinon c'est 2000
        adn = ['19',num2str(adn2)];
    else
        adn = ['20',num2str(adn2)];
    end
    age = annee_en_cours - str2double(adn); %age au 31/12 de la saison en cours
end

%Si le joueur n'existe pas, on regarde s'il existe dans listeJoueurs
if doesPlayerExist == false

[doesJoueursListeJoueursExist,namewithoutspace,listeJoueurs,stats,doesPlayerExist,sqlJoueurs] = checkListeJoueurs(data_fdm_visiteur(i).licence,strrep(data_recap_visiteur(i).nom,' ','_'),gamedata.visiteurwithoutspace,listeJoueurs,gamedata,namewithoutspace,stats,sqlJoueurs);
    
    if doesJoueursListeJoueursExist == false

            % le joueur est nouveau alors on créé son nom dans la base de donnée
            sqlJoueurs = sprintf([sqlJoueurs, 'INSERT INTO joueurs (licence, nom_joueur, nom_joueur_raccourci, adn)']);
            sqlJoueurs = sprintf([sqlJoueurs,'\n']);
            sqlJoueurs = sprintf([sqlJoueurs, 'VALUES (''',numLicence,''',''',namewithoutspace,''',''',namewithoutspace_raccourci,''',',adn,');']);
            sqlJoueurs = sprintf([sqlJoueurs,'\n\n']);

            if strcmp(numLicence(1:2),'AA') == 0
                listeJoueurs{end+1,1}= data_fdm_visiteur(i).licence;
                listeJoueurs{end,2}= namewithoutspace;
            end
        
    end        
end

% on insere le joueur dans la structure qui répertorie les joueurs pour le
% calcul des ecarts par 5
infosJoueurs.visiteur.nom{end+1} = namewithoutspace;
infosJoueurs.visiteur.numLicence{end+1} = numLicence;
infosJoueurs.visiteur.numero{end+1} = numeroJoueur;


% Si le joueur n'existe pas encore dans structure stats, il faut faire
% requete de jointure entre joueurs et equipes
if doesPlayerExist == false
    sqlJoueurs = sprintf([sqlJoueurs,'INSERT INTO jointure_joueurs_equipes (joueurs_id,equipes_id)']);
    sqlJoueurs = sprintf([sqlJoueurs,'\n']);
    sqlJoueurs = sprintf([sqlJoueurs,'VALUES ((SELECT id_joueurs FROM joueurs WHERE (nom_joueur=''',namewithoutspace,''' AND licence=''',numLicence,''')),']);
    sqlJoueurs = sprintf([sqlJoueurs,'(SELECT id_equipes FROM equipes WHERE (nom_equipe=''',gamedata.visiteurwithoutspace,''' AND saison_id = (SELECT id_saison FROM saison WHERE annee=',season,') AND comite_id = (SELECT id_comite FROM comite WHERE nom_comite= ''',gamedata.comite,''') AND competition_id = (SELECT id_competition FROM competition WHERE (chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt= ''',gamedata.chpt,''') AND poule_id=(SELECT id_poule FROM poule WHERE nom_poule=''',gamedata.poule,'''))))));']);
    sqlJoueurs = sprintf([sqlJoueurs,'\n\n']);
end

    % On regarde si le temps de jeu est calculé
    if gamedata.tdj == 1 %si tdj calculé
    tdj = str2double(data_recap_visiteur(i).min)+(str2double(data_recap_visiteur(i).sec)/60);
   elseif isempty(tdj_struct) %si tdj pas calculé
    tdj = NaN;
   else %les temps de jeu sont dans la structure tdj_struct
       tdj = tdj_struct.(codeJoueur).tdjtotal; % si erreur pb tdj_struct
    end
   
    % On stocke les stats dans variables pour faciliter requete
    
    numeroJoueur = str2double(data_recap_visiteur(i).num);
    points = str2double(data_recap_visiteur(i).pts);
    tirs = str2double(data_recap_visiteur(i).tirs);
    trois = str2double(data_recap_visiteur(i).troispts);
    deuxext = str2double(data_recap_visiteur(i).deuxext);
    deuxint = str2double(data_recap_visiteur(i).deuxint);
    lfr = str2double(data_recap_visiteur(i).lf);
    lft = str2double(data_recap_visiteur(i).lf) + nblfmanque_joueur;
    lfp = (str2double(data_recap_visiteur(i).lf) / (str2double(data_recap_visiteur(i).lf)+nblfmanque_joueur))*100;
    fautes = str2double(data_recap_visiteur(i).ftes);
    lfc = data_fautes_visiteur(i).lfconc;
    anti = data_fautes_visiteur(i).nbanti;
    tech = data_fautes_visiteur(i).nbtech;
    disqua = data_fautes_visiteur(i).nbdisqua;

     %fill stats for players namewithoutspace in struct stats.clubs
if doesPlayerExist == 1
   l = size(stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs);
    
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).numrencontre = numRencontre_struct_stats;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).nomrencontre = ['@ ',gamedata.domicilewithspace];
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).tpsdejeu = tdj;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).pts = points;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).tirs = tirs;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).troispts = trois;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).deuxext = deuxext;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).deuxint = deuxint;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).lfreussis = lfr;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).lftentes = lft;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).lfpct = lfp;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).ftes = fautes;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).ptsmarq = ptsmarqjoueurvisiteur;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).ptsenc = ptsencjoueurvisiteur;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).ecart = ecartjoueurvisiteur;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).lfconc = lfc;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).anti = anti;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).tech = tech;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs(l(2)+1).disqua = disqua;
   
   %annee de naissance
   if strcmp(stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).adn,'0000') == 1   
        stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).adn = adn;
        stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).age = age;
        stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).licence = numLicence;
   end
   
   
else
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs.numrencontre = str2double(gamedata.numrencontre);
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs.nomrencontre = ['@ ',gamedata.domicilewithspace];
   if gamedata.tdj == 1 %si tdj calculé
    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs.tpsdejeu = str2double(data_recap_visiteur(i).min)+(str2double(data_recap_visiteur(i).sec)/60);
   elseif isempty(tdj_struct) %si tdj pas calculé
    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs.tpsdejeu = NaN;
   else
    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs.tpsdejeu = tdj_struct.(codeJoueur).tdjtotal;
   end
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs.pts = str2double(data_recap_visiteur(i).pts);
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs.tirs = str2double(data_recap_visiteur(i).tirs);
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs.troispts = str2double(data_recap_visiteur(i).troispts);
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs.deuxext = str2double(data_recap_visiteur(i).deuxext);
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs.deuxint = str2double(data_recap_visiteur(i).deuxint);
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs.lfreussis = str2double(data_recap_visiteur(i).lf);
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs.lftentes = str2double(data_recap_visiteur(i).lf) + nblfmanque_joueur;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs.lfpct = (str2double(data_recap_visiteur(i).lf) / (str2double(data_recap_visiteur(i).lf)+nblfmanque_joueur))*100;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs.ftes = str2double(data_recap_visiteur(i).ftes);
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs.ptsmarq = ptsmarqjoueurvisiteur;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs.ptsenc = ptsencjoueurvisiteur;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs.ecart = ecartjoueurvisiteur;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs.lfconc = data_fautes_visiteur(i).lfconc; %Erreur ici: probleme dans data_recap ou data_fdm sur le nb de joueurs
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs.anti = data_fautes_visiteur(i).nbanti;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs.tech = data_fautes_visiteur(i).nbtech;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs.disqua = data_fautes_visiteur(i).nbdisqua;
   
    
        stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).adn = adn;
        stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).age = age;
        stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).licence = numLicence;
        
end 

% On insere stats du joueur pour ce match dans table stats_joueurs
    if isnan(tdj)
        tdj = 'NULL';
    else
        tdj = num2str(tdj);
    end
    
    sqlStatsJoueurs = sprintf([sqlStatsJoueurs, 'INSERT INTO stats_joueurs (matchs_id,joueurs_id,saison_id,tdj,points,tirs,trois,deuxext,deuxint,lfr,lft,fautes,lfc,ecartplus,ecartmoins,5majeur,numero_joueur)']);
    sqlStatsJoueurs = sprintf([sqlStatsJoueurs,'\n']);
    sqlStatsJoueurs = sprintf([sqlStatsJoueurs, 'VALUES ((SELECT id_matchs FROM matchs INNER JOIN equipes ON id_equipes=equipedom_id INNER JOIN competition ON id_competition=competition_id WHERE (numero_match=',numRencontre,' AND matchs.comite_id=(SELECT id_comite FROM comite WHERE nom_comite=''',gamedata.comite,''') AND chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt=''',gamedata.chpt,''' AND matchs.saison_id = (SELECT id_saison FROM saison WHERE annee=',season,')))),']);
    sqlStatsJoueurs = sprintf([sqlStatsJoueurs,'(SELECT id_joueurs FROM joueurs WHERE (nom_joueur=''',namewithoutspace,''' AND licence=''',numLicence,''')),']);
    sqlStatsJoueurs = sprintf([sqlStatsJoueurs,'(SELECT id_saison FROM saison WHERE annee=',season,'),']);
    sqlStatsJoueurs = sprintf([sqlStatsJoueurs,tdj,',',num2str(points),',',num2str(tirs),',',num2str(trois),',',num2str(deuxext),',',num2str(deuxint),',',num2str(lfr),',',num2str(lft),',',num2str(fautes),',',num2str(lfc),',',strrep(num2str(ptsmarqjoueurvisiteur),'NaN','NULL'),',',strrep(num2str(ptsencjoueurvisiteur),'NaN','NULL'),',',cinqMajeur,',',num2str(numeroJoueur),');']);
    sqlStatsJoueurs = sprintf([sqlStatsJoueurs,'\n\n']);    

   
  %sort structure 
Afields = fieldnames(stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs);
Acell = struct2cell(stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs);
sz = size(Acell);
Acell = reshape(Acell,sz(1),[]);
Acell = Acell';
Acell = sortrows(Acell,1);
Acell = reshape(Acell',sz);
stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).matchs = cell2struct(Acell,Afields,1);

   %structure for stats par match

   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.((['at',gamedata.domicilewithoutspace]))(i).numero = str2double(data_recap_visiteur(i).num);
   if isempty(find(ismember(cinqvisiteur, codeJoueur),1)) == 0 %check si joueur dans le 5
       stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.((['at',gamedata.domicilewithoutspace]))(i).nomjoueur = [data_recap_visiteur(i).nom,' *'];
   else
       stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.((['at',gamedata.domicilewithoutspace]))(i).nomjoueur = data_recap_visiteur(i).nom;
   end
   if gamedata.tdj == 1 %si tdj calculé
    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.((['at',gamedata.domicilewithoutspace]))(i).tpsdejeu = [data_recap_visiteur(i).min,':',data_recap_visiteur(i).sec];
   elseif isempty(tdj_struct) %si tdj pas calculé
    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.((['at',gamedata.domicilewithoutspace]))(i).tpsdejeu = '-';
   else
    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.((['at',gamedata.domicilewithoutspace]))(i).tpsdejeu = num2str(tdj_struct.(codeJoueur).tdjtotal,'%3.1f');
   end
   
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.((['at',gamedata.domicilewithoutspace]))(i).pts = str2double(data_recap_visiteur(i).pts);
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.((['at',gamedata.domicilewithoutspace]))(i).tirs = str2double(data_recap_visiteur(i).tirs);
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.((['at',gamedata.domicilewithoutspace]))(i).troispts = str2double(data_recap_visiteur(i).troispts);
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.((['at',gamedata.domicilewithoutspace]))(i).deuxext = str2double(data_recap_visiteur(i).deuxext);
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.((['at',gamedata.domicilewithoutspace]))(i).deuxint = str2double(data_recap_visiteur(i).deuxint);
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.((['at',gamedata.domicilewithoutspace]))(i).lfreussis = str2double(data_recap_visiteur(i).lf);
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.((['at',gamedata.domicilewithoutspace]))(i).lftentes = str2double(data_recap_visiteur(i).lf) + nblfmanque_visiteur;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.((['at',gamedata.domicilewithoutspace]))(i).lfpct = (str2double(data_recap_visiteur(i).lf) / (str2double(data_recap_visiteur(i).lf)+nblfmanque_visiteur))*100;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.(['at',gamedata.domicilewithoutspace])(i).ftes = str2double(data_recap_visiteur(i).ftes);
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.(['at',gamedata.domicilewithoutspace])(i).ptsmarq = ptsmarqjoueurvisiteur;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.(['at',gamedata.domicilewithoutspace])(i).ptsenc = ptsencjoueurvisiteur;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.(['at',gamedata.domicilewithoutspace])(i).ecart = ecartjoueurvisiteur;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.(['at',gamedata.domicilewithoutspace])(i).lfconc = data_fautes_visiteur(i).lfconc;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.(['at',gamedata.domicilewithoutspace])(i).age = stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).joueurs.(namewithoutspace).age;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.(['at',gamedata.domicilewithoutspace])(i).anti = data_fautes_visiteur(i).nbanti;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.(['at',gamedata.domicilewithoutspace])(i).tech = data_fautes_visiteur(i).nbtech;
   stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.(['at',gamedata.domicilewithoutspace])(i).disqua = data_fautes_visiteur(i).nbdisqua;
   
 end 
     
clear linenum;

%% Partie pour calculer les ages, le nb anti, tech, disqua de l'equipe depuis la partie parmatch

% pour l'equipe domicile
age = nanmean(cat(1,stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).parmatch.(['vs',gamedata.visiteurwithoutspace]).age));
anti = nansum(cat(1,data_fautes_domicile.nbanti));
tech = nansum(cat(1,data_fautes_domicile.nbtech));
disqua = nansum(cat(1,data_fautes_domicile.nbdisqua));

% on cherche a quelle ligne est le numero du match. Obligé de faire ca car
% si le match est en retard, le numero de rencontre ne sera pas le plus
% grand et le match est alors reclassé à une ligne plus haute que la
% derniere. 
for ii = 1 : length(stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs)
    if str2double(gamedata.numrencontre) == stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs(ii).numrencontre
        ligneMatch = ii;
    end
end

stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs(ligneMatch).age = age;
stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs(ligneMatch).anti = anti;
stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs(ligneMatch).tech = tech;
stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs(ligneMatch).disqua = disqua;

sqlStatsEquipes = sprintf([sqlStatsEquipes, 'UPDATE stats_equipes SET age=',strrep(num2str(age),'NaN','NULL'),',antisportive=',num2str(anti),',technique=',num2str(tech),',disqualifiante=',num2str(disqua),' WHERE (matchs_id=(SELECT id_matchs FROM matchs INNER JOIN equipes ON id_equipes=equipedom_id INNER JOIN competition ON id_competition=competition_id WHERE (numero_match=',numRencontre,' AND matchs.comite_id=(SELECT id_comite FROM comite WHERE nom_comite=''',gamedata.comite,''') AND chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt=''',gamedata.chpt,''') AND matchs.saison_id = (SELECT id_saison FROM saison WHERE annee=',season,'))) AND saison_id = (SELECT id_saison FROM saison WHERE annee=',season,') AND equipes_id= (SELECT id_equipes FROM equipes WHERE (nom_equipe=''',gamedata.domicilewithoutspace,''' AND saison_id = (SELECT id_saison FROM saison WHERE annee=',season,') AND comite_id = (SELECT id_comite FROM comite WHERE nom_comite=''',gamedata.comite,''') AND competition_id = (SELECT id_competition FROM competition WHERE (chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt= ''',gamedata.chpt,''') AND poule_id=(SELECT id_poule FROM poule WHERE nom_poule=''',gamedata.poule,'''))))));']);
sqlStatsEquipes = sprintf([sqlStatsEquipes, '\n\n']);

% pour l'équipe visiteur
age = nanmean(cat(1,stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).parmatch.(['at',gamedata.domicilewithoutspace]).age));
anti = nansum(cat(1,data_fautes_visiteur.nbanti));
tech = nansum(cat(1,data_fautes_visiteur.nbtech));
disqua = nansum(cat(1,data_fautes_visiteur.nbdisqua));

% on cherche a quelle ligne est le numero du match. Obligé de faire ca car
% si le match est en retard, le numero de rencontre ne sera pas le plus
% grand et le match est alors reclassé à une ligne plus haute que la
% derniere. 
for ii = 1 : length(stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs)
    if str2double(gamedata.numrencontre) == stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs(ii).numrencontre
        ligneMatch = ii;
    end
end

stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs(ligneMatch).age = age;
stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs(ligneMatch).anti = anti;
stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs(ligneMatch).tech = tech;
stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).equipe.matchs(ligneMatch).disqua = disqua; 

sqlStatsEquipes = sprintf([sqlStatsEquipes, 'UPDATE stats_equipes SET age=',strrep(num2str(age),'NaN','NULL'),',antisportive=',num2str(anti),',technique=',num2str(tech),',disqualifiante=',num2str(disqua),' WHERE (matchs_id=(SELECT id_matchs FROM matchs INNER JOIN equipes ON id_equipes=equipedom_id INNER JOIN competition ON id_competition=competition_id WHERE (numero_match=',numRencontre,' AND matchs.comite_id=(SELECT id_comite FROM comite WHERE nom_comite=''',gamedata.comite,''') AND chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt=''',gamedata.chpt,''') AND matchs.saison_id = (SELECT id_saison FROM saison WHERE annee=',season,'))) AND saison_id = (SELECT id_saison FROM saison WHERE annee=',season,') AND equipes_id= (SELECT id_equipes FROM equipes WHERE (nom_equipe=''',gamedata.visiteurwithoutspace,''' AND saison_id = (SELECT id_saison FROM saison WHERE annee=',season,') AND comite_id = (SELECT id_comite FROM comite WHERE nom_comite=''',gamedata.comite,''') AND competition_id = (SELECT id_competition FROM competition WHERE (chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt= ''',gamedata.chpt,''') AND poule_id=(SELECT id_poule FROM poule WHERE nom_poule=''',gamedata.poule,'''))))));']);
sqlStatsEquipes = sprintf([sqlStatsEquipes, '\n\n']);

end