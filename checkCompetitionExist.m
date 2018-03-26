function [listeCompetition,sqlCompetition] = checkCompetitionExist(gamedata,listeCompetition,sqlCompetition)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%Cette fonction teste l'existence de la competition dans listeCompetition.%
%   on teste si le chpt existe, puis si poule associée au chpt existe.    %
%   Si exite pas on ajoute dans la bdd et dans la listeCompetition.       %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

doesCompetExist = false;
doesChptExist = false;

taille = size(listeCompetition);
for ligneListeCompetition = 1: taille(1)
    if strcmp(listeCompetition{ligneListeCompetition,1},gamedata.chpt)
        doesChptExist = true;
        if strcmp(listeCompetition{ligneListeCompetition,2},gamedata.poule)
            doesCompetExist = true;
        end
    end
end

if doesChptExist == false
    sqlCompetition = sprintf([sqlCompetition,'INSERT INTO chpt (categorie_id,nom_chpt)']);
    sqlCompetition = sprintf([sqlCompetition,'\n']);
    sqlCompetition = sprintf([sqlCompetition,'VALUES ((SELECT id_categorie FROM categorie WHERE nom_categorie=''',gamedata.cat,'''),''',gamedata.chpt,''');']);
    sqlCompetition = sprintf([sqlCompetition,'\n\n']);
end

if doesCompetExist == false
    listeCompetition{end+1,1}= gamedata.chpt;
    listeCompetition{end,2}= gamedata.poule;
    
    sqlCompetition = sprintf([sqlCompetition,'INSERT INTO competition (chpt_id,poule_id)']);
    sqlCompetition = sprintf([sqlCompetition,'\n']);
    sqlCompetition = sprintf([sqlCompetition,'VALUES ((SELECT id_chpt FROM chpt WHERE nom_chpt=''',gamedata.chpt,'''),(SELECT id_poule FROM poule WHERE nom_poule= ''',gamedata.poule,'''));']);
    sqlCompetition = sprintf([sqlCompetition,'\n\n']);
end

end
