function [sqlMatchs] = computeStatsMatch(gamedata,data_coach,arbitres,data_qt,sqlMatchs,datesql,season)

numRencontre = num2str(gamedata.numrencontre);
    while length(numRencontre) < 6
        numRencontre = ['0',numRencontre];
    end

    

sqlMatchs = sprintf([sqlMatchs, 'INSERT INTO matchs (saison_id, date_du_match, numero_match, equipedom_id, equipevisit_id,qt1_dom,qt2_dom,qt3_dom,qt4_dom,qt1_visit,qt2_visit,qt3_visit,qt4_visit,arbitre1,coach_dom,coach_visit,comite_id)']);
sqlMatchs = sprintf([sqlMatchs,'\n']);
sqlMatchs = sprintf([sqlMatchs, 'VALUES ((SELECT id_saison FROM saison WHERE annee=',season,'),''',datesql,''',',numRencontre,',']);
sqlMatchs = sprintf([sqlMatchs,'(SELECT id_equipes FROM equipes WHERE (nom_equipe=''',gamedata.domicilewithoutspace,''' AND saison_id = (SELECT id_saison FROM saison WHERE annee=',season,') AND comite_id = (SELECT id_comite FROM comite WHERE nom_comite=''',gamedata.comite,''') AND competition_id = (SELECT id_competition FROM competition WHERE (chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt= ''',gamedata.chpt,''') AND poule_id=(SELECT id_poule FROM poule WHERE nom_poule=''',gamedata.poule,'''))))),']);
sqlMatchs = sprintf([sqlMatchs,'(SELECT id_equipes FROM equipes WHERE (nom_equipe=''',gamedata.visiteurwithoutspace,''' AND saison_id = (SELECT id_saison FROM saison WHERE annee=',season,') AND comite_id = (SELECT id_comite FROM comite WHERE nom_comite=''',gamedata.comite,''') AND competition_id = (SELECT id_competition FROM competition WHERE (chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt= ''',gamedata.chpt,''') AND poule_id=(SELECT id_poule FROM poule WHERE nom_poule=''',gamedata.poule,'''))))),']);
sqlMatchs = sprintf([sqlMatchs,data_qt(1).domicile,',',data_qt(2).domicile,',',data_qt(3).domicile,',',data_qt(4).domicile,',',data_qt(1).visiteur,',',data_qt(2).visiteur,',',data_qt(3).visiteur,',',data_qt(4).visiteur,',''',arbitres{1},''',''',data_coach(1).nom,''',''',data_coach(2).nom,''',','(SELECT id_comite FROM comite WHERE nom_comite=''',gamedata.comite,'''));']);
sqlMatchs = sprintf([sqlMatchs,'\n\n']);


if length(arbitres) > 1
    sqlMatchs = sprintf([sqlMatchs,'UPDATE matchs SET arbitre2 =''',arbitres{2},''' WHERE ((numero_match=',numRencontre,') AND (comite_id = (SELECT id_comite FROM comite WHERE nom_comite= ''',gamedata.comite,''')) AND (saison_id = (SELECT id_saison FROM saison WHERE annee=',season,')));']);
    sqlMatchs = sprintf([sqlMatchs,'\n\n']);
end

if length(data_qt) > 4
    sqlMatchs = sprintf([sqlMatchs,'UPDATE matchs SET qt5_dom =',data_qt(5).domicile,', qt5_visit=',data_qt(5).visiteur,' WHERE ((numero_match=',numRencontre,') AND (comite_id = (SELECT id_comite FROM comite WHERE nom_comite= ''',gamedata.comite,''')) AND (saison_id = (SELECT id_saison FROM saison WHERE annee=',season,')));']);
    sqlMatchs = sprintf([sqlMatchs,'\n\n']);
end

end