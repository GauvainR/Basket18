function [gamedata,sqlEquipes,sqlClubs,listeClubs,stats] = checkTeamExist(gamedata,stats,sqlEquipes,sqlClubs,listeClubs,season)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%   Cette fonction teste l'existence de l'équipe. Si l'équipe existe pas  %
%   on teste si le nom d'equipe avec numero ou sans numero existe.        %
%   Vérification nécessaire pour éviter qu'une équipe soit splitée        %
%   dans la base de données                                               %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Pour l'équipe domicile

doesTeamExist = true;
try
stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]);
catch
doesTeamExist = false;
end

if doesTeamExist == false
    try
    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace,'_1']);
    gamedata.domicilewithoutspace = [gamedata.domicilewithoutspace,'_1'];
    catch
        try
        stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace,'_2']);
        gamedata.domicilewithoutspace = [gamedata.domicilewithoutspace,'_2'];
        catch
            try
            stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace,'_3']);
            gamedata.domicilewithoutspace = [gamedata.domicilewithoutspace,'_3'];
            catch
                try
                stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace,'_4']);
                gamedata.domicilewithoutspace = [gamedata.domicilewithoutspace,'_4'];
                catch
                    try
                    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace,'_5']);
                    gamedata.domicilewithoutspace = [gamedata.domicilewithoutspace,'_5'];
                    catch
                        try % Si nom d'equipe est ABC_LUTTERBACH_1 on cherche si ABC_LUTTERBACH existe 
                        stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace(1:end-2)]); 
                        gamedata.domicilewithoutspace = gamedata.domicilewithoutspace(1:end-2);
                        catch % Si on arrive la le nom d'équipe n'existe pas
                              gamedata.domicilewithoutspace = gamedata.domicilewithoutspace; % pour le principe

                              [sqlEquipes,gamedata.domicilewithoutspace,stats,ajouterEquipeBDD] = checkTeamNumero(gamedata,stats,sqlEquipes,gamedata.numeroDom,gamedata.domicilewithoutspace,season);
                              gamedata.domicilewithspace = strrep(gamedata.domicilewithoutspace,'_',' ');
                              
                              % Partie pour le club seulement si on a
                              % ajouté l'equipe dans bdd
                              if ajouterEquipeBDD
                                [gamedata.clubdom,gamedata.numeroDom,listeClubs,sqlClubs] = checkClubExist(gamedata.clubdom,gamedata.numeroDom,listeClubs,sqlClubs,season,gamedata,gamedata.domicilewithoutspace);
                              end
                        end
                    end
                end
            end
        end
    end
else % si la team existe on verifie que le numero d'equipe correspond. Parfois mauvais numero d'equipe donné en debut de saison, il vaut alors mieux le changer
     numeroStructureStats = stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).numeroEquipe;
        %on vérifie si la longueur du numero dde l'equipe est la meme. Si
        %pas la meme on va avoir une erreur lors comparaison.
        if length(numeroStructureStats) == length(gamedata.numeroDom)
            %si les deux numéros sont pas les memes alors on demande si il
            %faut changer le numero d'equipe dans la structure stats
            if strcmp(numeroStructureStats,gamedata.numeroDom) == 0
                if strcmp(gamedata.numeroDom(1:2), '00') % si le numero commence par 00 on ne change pas le numero de la structure stats
                    numeroAChanger = 2;
                    
                elseif strcmp(gamedata.numeroDom(1:2), '00') == 0 && strcmp(numeroStructureStats(1:2), '00')
                % si le numero de la structure stats commence par 00 et que
                % celui de la feuille actuellement traitée ne commence pas
                % par 0 alors on change le numero de la structure stats
                numeroAChanger = 1;
                
                else % sinon on demande
                    disp(' ')
                    disp('************************************************')
                    disp('Numero d''equipes differents alors que l''equipe est la meme');
                    disp([gamedata.domicilewithoutspace,' vs ',gamedata.visiteurwithoutspace]);
                    disp(['Le num de la structure stats est ',numeroStructureStats])
                    disp(['Le num de la feuille traitée est ',gamedata.numeroDom])
                    numeroAChanger = input('Changer le numero de la structure stats? oui:1 non:2 ==> ');
                end
                
                if numeroAChanger == 1
                    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).numeroEquipe = gamedata.numeroDom;
                    
                    sqlClubs = sprintf([sqlClubs,'UPDATE club SET numero_club=''',gamedata.numeroDom,''', ligue=''',gamedata.numeroDom(1:2),''', comite=''',gamedata.numeroDom(3:4),'''']);
                    sqlClubs = sprintf([sqlClubs,'WHERE nom_club=''',gamedata.clubdom,''';']);
                    sqlClubs = sprintf([sqlClubs,'\n\n']);
                    
                    [listeClubs] = modifNumeroClubsListeClubs(gamedata.clubdom,gamedata.numeroDom,listeClubs);
                end
            end
        else % si la longueur des numeros d'equipes est differente
            disp(' ')
            disp('************************************************')
            disp('Numero d''equipes differents alors que l''equipe est la meme');
            disp([gamedata.domicilewithoutspace,' vs ',gamedata.visiteurwithoutspace]);
            disp(['Le num de la structure stats est ',numeroStructureStats])
            disp(['Le num de la feuille traitée est ',gamedata.numeroDom])
            numeroAChanger = input('Changer le numero de la structure stats? oui:1 non:2 ==> ');

            if numeroAChanger == 1
                stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).numeroEquipe = gamedata.numeroDom;
            end
        end

end

%% Pour l'équipe visiteur
doesTeamExist = true;
try
stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]);
catch
doesTeamExist = false;
end

if doesTeamExist == false
    try
    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace,'_1']);
    gamedata.visiteurwithoutspace = [gamedata.visiteurwithoutspace,'_1'];
    catch
        try
        stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace,'_2']);
        gamedata.visiteurwithoutspace = [gamedata.visiteurwithoutspace,'_2'];
        catch
            try
            stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace,'_3']);
            gamedata.visiteurwithoutspace = [gamedata.visiteurwithoutspace,'_3'];
            catch
                try
                stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace,'_4']);
                gamedata.visiteurwithoutspace = [gamedata.visiteurwithoutspace,'_4'];
                catch
                    try
                    stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace,'_5']);
                    gamedata.visiteurwithoutspace = [gamedata.visiteurwithoutspace,'_5'];
                    catch
                        try % Si nom d'equipe est ABC_LUTTERBACH_1 on cherche si ABC_LUTTERBACH existe 
                        stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace(1:end-2)]); 
                        gamedata.visiteurwithoutspace = [gamedata.visiteurwithoutspace(1:end-2)];
                        catch % Si on arrive la le nom d'équipe n'existe pas
                            gamedata.visiteurwithoutspace = gamedata.visiteurwithoutspace; % pour le principe
                            [sqlEquipes,gamedata.visiteurwithoutspace,stats,ajouterEquipeBDD] = checkTeamNumero(gamedata,stats,sqlEquipes,gamedata.numeroVisit,gamedata.visiteurwithoutspace,season);
                            gamedata.visiteurwithspace = strrep(gamedata.visiteurwithoutspace,'_',' ');
                            
                            % Partie pour le club seulement si on a
                            % ajouté l'equipe dans bdd
                            if ajouterEquipeBDD 
                                [gamedata.clubvisit,gamedata.numeroVisit,listeClubs,sqlClubs] = checkClubExist(gamedata.clubvisit,gamedata.numeroVisit,listeClubs,sqlClubs,season,gamedata,gamedata.visiteurwithoutspace);
                            end
                        end
                    end
                end
            end
        end
    end
else % si la team existe on verifie que le numero d'equipe correspond. Parfois mauvais numero d'equipe donné en debut de saison, il vaut alors mieux le changer
 numeroStructureStats = stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).numeroEquipe;
    %on vérifie si la longueur du numero dde l'equipe est la meme. Si
    %pas la meme on va avoir une erreur lors comparaison.
    if length(numeroStructureStats) == length(gamedata.numeroVisit)
        %si les deux numéros sont pas les memes alors on demande si il
        %faut changer le numero d'equipe dans la structure stats
        if strcmp(numeroStructureStats,gamedata.numeroVisit) == 0
           
            if strcmp(gamedata.numeroVisit(1:2), '00') % si le numero commence par 00 on ne change pas le numero de la structure stats
                numeroAChanger = 2;
                
            elseif strcmp(gamedata.numeroVisit(1:2), '00') == 0 && strcmp(numeroStructureStats(1:2), '00')
                % si le numero de la structure stats commence par 00 et que
                % celui de la feuille actuellement traitée ne commence pas
                % par 0 alors on change le numero de la structure stats
                numeroAChanger = 1;
                
            else % sinon on demande

                disp(' ')
                disp('************************************************')
                disp('Numero d''equipes differents alors que l''equipe est la meme: ');
                disp(['match: ',gamedata.visiteurwithoutspace,' @ ',gamedata.domicilewithoutspace]);
                disp(['Le num de la structure stats est ',numeroStructureStats])
                disp(['Le num de la feuille traitée est ',gamedata.numeroVisit])
                numeroAChanger = input('Changer le numero de la structure stats? oui:1 non:2 ==> ');
            end

            if numeroAChanger == 1
                stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).numeroEquipe = gamedata.numeroVisit;
                
                sqlClubs = sprintf([sqlClubs,'UPDATE club SET numero_club=''',gamedata.numeroVisit,''', ligue=''',gamedata.numeroVisit(1:2),''', comite=''',gamedata.numeroVisit(3:4),'''']);
                sqlClubs = sprintf([sqlClubs,'WHERE nom_club=''',gamedata.clubvisit,''';']);
                sqlClubs = sprintf([sqlClubs,'\n\n']);
                
                [listeClubs] = modifNumeroClubsListeClubs(gamedata.clubvisit,gamedata.numeroVisit,listeClubs);
            end
        end
    else % si la longueur des numeros d'equipes est differente
        disp(' ')
        disp('************************************************')
        disp('Numero d''equipes differents alors que l''equipe est la meme: ');
        disp(['match: ',gamedata.visiteurwithoutspace,' @ ',gamedata.domicilewithoutspace]);
        disp(['Le num de la structure stats est ',numeroStructureStats])
        disp(['Le num de la feuille traitée est ',gamedata.numeroVisit])
        numeroAChanger = input('Changer le numero de la structure stats? oui:1 non:2 ==> ');

        if numeroAChanger == 1
            stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.visiteurwithoutspace]).numeroEquipe = gamedata.numeroVisit;
        end
    end
end

end