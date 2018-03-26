function [sqlEquipes,nomEquipe,stats,ajouterEquipeBDD] = checkTeamNumero(gamedata,stats,sqlEquipes,numeroEquipeATester,nomEquipeATester,season)

% On vérifie que les numéros d'équipes des équipes déja enregistrées pour
% ce championnat ne correspondent pas a l'equipe que l'on teste. 
% Cette fonction a été rajoutée car les noms d'équipes ont été changées en
% novembre 2017 sur la PNM. (ex: SCHILTIGHIEIM AU -> AUS). Cela entrainait
% des doublons dans les équipes sur le site.

ajouterEquipeBDD = true;

doesChptExist = true;
try
stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]);
catch
doesChptExist = false;
end

% si le chpt n'existe pas ca sert a rien de verifier les noms d'equipes car
% il n'y en a pas
if doesChptExist == true
    nomsEquipes = fieldnames(stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]));
    
    for i = 1 : length(nomsEquipes)
        numeroStructureStats = stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).(nomsEquipes{i}).numeroEquipe;
        %on vérifie si la longueur du numero dde l'equipe est la meme. Si
        %pas la meme on va avoir une erreur lors comparaison.
        if length(numeroStructureStats) == length(numeroEquipeATester)
            
            %si les deux numéros sont les memes alors on demande si les
            %équipes sont bien les memes
            if strcmp(numeroStructureStats,numeroEquipeATester)
                disp(' ')
                disp('************************************************')
                disp('Est-ce la meme équipe?');
                disp('Equipe de structure stats puis equipe du match que l''on traite.');
                disp([nomsEquipes{i},' et']);
                disp(nomEquipeATester);
                disp(' ')
                prompt = '1:oui 2:non 3:oui+changement de nom ---> ';
                reponseInput = input(prompt);
                
                if reponseInput == 1
                    nomEquipe = nomsEquipes{i};
                    ajouterEquipeBDD = false;
                    
                elseif reponseInput == 3
                    % on garde le meme nom d'equipe, mais on le modifie
                    % dans la structure stats et dans la table
                    nomEquipe = nomEquipeATester;
                    ajouterEquipeBDD = false;
                    
                    sqlEquipes = sprintf([sqlEquipes,'UPDATE equipes SET nom_equipe=''',nomEquipe,''' ']);
                    sqlEquipes = sprintf([sqlEquipes,'WHERE comite_id= (SELECT id_comite FROM comite WHERE nom_comite= ''',gamedata.comite,''') AND nom_equipe=''',nomsEquipes{i},''' AND saison_id=(SELECT id_saison FROM saison WHERE annee=',season,') AND  competition_id=(SELECT id_competition FROM competition WHERE (chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt= ''',gamedata.chpt,''') AND poule_id=(SELECT id_poule FROM poule WHERE nom_poule=''',gamedata.poule,''')));']);
                    sqlEquipes = sprintf([sqlEquipes,'\n\n']);
                    
                    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).(nomEquipe) = stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).(nomsEquipes{i});
                    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]) = rmfield(stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]),nomsEquipes{i});
                elseif reponseInput == 2
                    nomEquipe = nomEquipeATester;
                    ajouterEquipeBDD = true;
                    
                end
            end
        end
    end
end

% pour éviter l'erreur sur l'output si le chpt n'existe pas ou equipe pas
% encore définie
if exist('nomEquipe') == 0
    nomEquipe = nomEquipeATester;
end

if ajouterEquipeBDD == true
    sqlEquipes = sprintf([sqlEquipes,'INSERT INTO equipes (comite_id,nom_equipe,saison_id,competition_id) ']);
    sqlEquipes = sprintf([sqlEquipes,'VALUES ((SELECT id_comite FROM comite WHERE nom_comite= ''',gamedata.comite,'''),''',nomEquipe,''',(SELECT id_saison FROM saison WHERE annee=',season,'),(SELECT id_competition FROM competition WHERE (chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt= ''',gamedata.chpt,''') AND poule_id=(SELECT id_poule FROM poule WHERE nom_poule=''',gamedata.poule,'''))));']);
    sqlEquipes = sprintf([sqlEquipes,'\n\n']);
end

end
                
            