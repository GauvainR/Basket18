function [tdj_struct,histo_exploitable] = tdjHistorique(histotextcell,prolongations)

tdj_struct = [];

ligne_fin_periode1 = [];
for nbline = 1 : length(histotextcell)
    
    if isempty(regexp(histotextcell{nbline},'Fin de période','ONCE')) == 0 && isempty(ligne_fin_periode1)
        ligne_fin_periode1 = nbline;
        tempsFinPeriode1 = regexp(histotextcell{ligne_fin_periode1}, '(\d+[:]\d+)', 'match');
    end
    
end

if strcmp(tempsFinPeriode1,'0:00') == 0 % si le temps apres periode 2 est 0:00 les temps de jeu ne sont pas comptés
    evtApresMatch = false; % variable pour éviter qu'on calcule le temps de jeu si une disqualifiante a eu lieu apres le match
    i = 0; %pour compter l'entrée du 5 de base

    for nbline = 1 : length(histotextcell)

    % On insére tous les joueurs dans tdj_struct avec 0 min de tdj pour que
    % meme les joueurs qui n'ont pas joué soient présents
    if isempty(strfind(histotextcell{nbline},'a été ajouté')) == 0 
        if isempty(strfind(histotextcell{nbline-1},'Evénement annulé')) == 1 && isempty(strfind(histotextcell{nbline+1},'Remplacé par')) == 1 %check if in the line before there is not evenement annulé
            player = regexp(histotextcell{nbline}, '[AB]\d+', 'match');

            if isempty(player) == 0
                tdj_struct.([player{1,1}]).tdjtotal = 0;
            end
        end
    end

    % Prise du temps à l'entrée
    if isempty(strfind(histotextcell{nbline},'est entré sur le terrain de jeu')) == 0 
            if isempty(strfind(histotextcell{nbline-1},'Evénement annulé')) == 1 && isempty(strfind(histotextcell{nbline+1},'Remplacé par')) == 1 %check if in the line before there is not evenement annulé

                player = regexp(histotextcell{nbline}, '[AB]\d+', 'match');

                %si le joueur sort avant le début du match, tdj entrant est 0
                if isempty(strfind(histotextcell{nbline},'Avant match')) == 0
                    tdj_struct.([player{1,1}]).tempsentrant = 0;
                else
                    temps = regexp(histotextcell{nbline}, '(?<min>\d+):(?<sec>\d+)', 'names');
                    temps.min = str2double(temps.min);
                    temps.sec = str2double(temps.sec)/60;
                    temps = temps.min + temps.sec;

                    tdj_struct.([player{1,1}]).tempsentrant = temps;    
                end
            end
     end



    if isempty(strfind(histotextcell{nbline},'est sorti du terrain de jeu')) == 0 %
            if isempty(strfind(histotextcell{nbline-1},'Evénement annulé')) == 1 && isempty(strfind(histotextcell{nbline+1},'Remplacé par')) == 1 %check if in the line before there is not evenement annulé
                player = regexp(histotextcell{nbline}, '[AB]\d+', 'match');

                %si le joueur sort avant le début du match, tdj sorti est 0
                if isempty(strfind(histotextcell{nbline},'Avant match')) == 0
                    tdj_struct.([player{1,1}]).tempssortant = 0;

                else
                    temps = regexp(histotextcell{nbline}, '(?<min>\d+):(?<sec>\d+)', 'names');
                    temps.min = str2double(temps.min);
                    temps.sec = str2double(temps.sec)/60;
                    temps = temps.min + temps.sec;

                    tdj_struct.([player{1,1}]).tempssortant = temps;  
                end

                    tdjTotalExist = true;
                    try
                    tdj_struct.([player{1,1}]).tdjtotal;
                    catch
                    tdjTotalExist = false;
                    end


                    %ecart
                    if tdjTotalExist == 1
                        tdj_struct.([player{1,1}]).tdjtotal = tdj_struct.([player{1,1}]).tdjtotal + (tdj_struct.([player{1,1}]).tempssortant - tdj_struct.([player{1,1}]).tempsentrant);
                    elseif tdjTotalExist == 0
                        tdj_struct.([player{1,1}]).tdjtotal = tdj_struct.([player{1,1}]).tempssortant - tdj_struct.([player{1,1}]).tempsentrant;
                    end

            end

    end


        if isempty(strfind(histotextcell{nbline},'été disqualifié')) == 0 
            if isempty(strfind(histotextcell{nbline-1},'Evénement annulé')) == 1 && isempty(strfind(histotextcell{nbline+1},'Remplacé par')) == 1 %check if in the line before there is not evenement annulé
                player = regexp(histotextcell{nbline}, '[AB]\d+', 'match');
                doesEntDisq = false;
                if isempty(player) % l'entraineur a été disqualifié. On recherche si ent est au debut de la ligne
                    testDoesEntDisq = strfind(histotextcell{nbline},'Ent.');
                    if isempty(testDoesEntDisq) == 0
                        doesEntDisq = true;
                    end
                end

                if doesEntDisq == false % on calcule pas les temps de jeu si c'est l'enraineur qui est disqua
                    temps = regexp(histotextcell{nbline}, '(?<min>\d+):(?<sec>\d+)', 'names');
                    if isempty(temps) %si évènement annulé et remis à la fin dumatch (Cherbourg - Rennes NM2 Poule C evt 339)
                        indiceDernierChiffre = regexp(histotextcell{nbline}, '\d+');
                        nb_evt = histotextcell{nbline}(indiceDernierChiffre(end):end); % on recherche le numéro nde l'évènement
                        for nbline_evt = 1 : length(histotextcell) % On cherche à quelle ligne a lieu l'évènement
                            % si l'evenement a eu lieu pendant le match
                            if isempty(strfind(histotextcell{nbline_evt},[nb_evt,' Période'])) == 0 || isempty(strfind(histotextcell{nbline_evt},[nb_evt,' Prolongations'])) == 0
                                temps = regexp(histotextcell{nbline_evt}, '(?<min>\d+):(?<sec>\d+)', 'names');
                            % sinon on verifie si l'evenement a eu lieu apres le match    
                            elseif isempty(strfind(histotextcell{nbline},'Après match')) == 0
                                evtApresMatch = true;
                            end
                        end
                    end


                     if evtApresMatch == false % si evtApresMatch = true ca veut dire qu'il n'y a plus de gestion de temps de jeu a faire
                        temps.min = str2double(temps.min);
                        temps.sec = str2double(temps.sec)/60;
                        temps = temps.min + temps.sec;

                        tdj_struct.([player{1,1}]).tempssortant = temps;  

                            tdjTotalExist = true;
                            try
                            tdj_struct.([player{1,1}]).tdjtotal;
                            catch
                            tdjTotalExist = false;
                            end


                            %ecart
                            if tdjTotalExist == 1
                                tdj_struct.([player{1,1}]).tdjtotal = tdj_struct.([player{1,1}]).tdjtotal + (tdj_struct.([player{1,1}]).tempssortant - tdj_struct.([player{1,1}]).tempsentrant);
                            elseif tdjTotalExist == 0
                                tdj_struct.([player{1,1}]).tdjtotal = tdj_struct.([player{1,1}]).tempssortant - tdj_struct.([player{1,1}]).tempsentrant;
                            end
                     end
                end
            end
        end
    end % decompte des lignes de histotextcell

    %% Verification du temps de jeu total des équipes
    % calcul du tdj total pour les equipes
    player = fieldnames(tdj_struct);
    tdj_dom = 0;
    tdj_visit = 0;
    nb_joueur_dom_tdj_sup_zero = 0;
    nb_joueur_visit_tdj_sup_zero = 0;
    for i = 1 : length(player)
        if player{i}(1) == 'A'
            tdj_dom = tdj_dom + tdj_struct.(player{i}).tdjtotal;
            if tdj_struct.(player{i}).tdjtotal > 0
                nb_joueur_dom_tdj_sup_zero = nb_joueur_dom_tdj_sup_zero + 1;
            end
        elseif player{i}(1) == 'B'
            tdj_visit = tdj_visit + tdj_struct.(player{i}).tdjtotal;
            if tdj_struct.(player{i}).tdjtotal > 0
                nb_joueur_visit_tdj_sup_zero = nb_joueur_visit_tdj_sup_zero + 1;
            end
        end
    end
    
 % temps de jeu theorique 200 ou 225 si prolong
    if prolongations == 0
        tdj_theorique = 200;
    else % si il y a prolong on regarde si le tdj est plutot pres de 225 ou de 250 ou de 275
        une_prolong = tdj_dom - 225;
        deux_prolong = tdj_dom -250;
        trois_prolong = tdj_dom - 275;

        if abs(une_prolong) < abs(deux_prolong)
            tdj_theorique = 225;
        elseif abs(deux_prolong) < abs(trois_prolong)
            tdj_theorique = 250;
        else
            tdj_theorique = 275;
        end
    end
    
    

    if tdj_dom == 200
        tdj_dom_a_ajouter = 0;
    elseif abs(tdj_dom - tdj_theorique) < 15 % on laisse une marge d'erreur au marqueur de + ou - 10  
        tdj_dom_a_ajouter = (tdj_theorique - tdj_dom) / nb_joueur_dom_tdj_sup_zero; 
    else % les temps de jeu sont faussés
        tdj_struct = [];
        histo_exploitable = 0;
    end

    if isempty(tdj_struct) == 0 % si les temps de jeu n'ont pas été invalidés par l'equipe dom on passe a l'equipe visit
        if tdj_visit == 200
            tdj_visit_a_ajouter = 0;
        elseif abs(tdj_visit - tdj_theorique) < 15 % on laisse une marge d'erreur au marqueur de + ou - 10  
            tdj_visit_a_ajouter = (tdj_theorique - tdj_visit) / nb_joueur_visit_tdj_sup_zero;
        else % les temps de jeu sont faussés
            tdj_struct = [];
            histo_exploitable = 0;
        end
    end

    %% modification des temps de jeu
    if isempty(tdj_struct) == 0 % si les temps de jeu des deux equipes sont exploitables
        for i = 1 : length(player)
            if player{i}(1) == 'A'

                if tdj_struct.(player{i}).tdjtotal > 3 && (tdj_theorique/5) - tdj_struct.(player{i}).tdjtotal > abs(tdj_dom_a_ajouter)
                    tdj_struct.(player{i}).tdjtotal = tdj_struct.(player{i}).tdjtotal + tdj_dom_a_ajouter;
                end

            elseif player{i}(1) == 'B' && (tdj_theorique/5) - tdj_struct.(player{i}).tdjtotal > abs(tdj_visit_a_ajouter)

                if tdj_struct.(player{i}).tdjtotal > 3 && (tdj_theorique/5) - tdj_struct.(player{i}).tdjtotal > abs(tdj_visit_a_ajouter)
                    tdj_struct.(player{i}).tdjtotal = tdj_struct.(player{i}).tdjtotal + tdj_visit_a_ajouter;
                end

            end
        end
        histo_exploitable = 1;
    end

else
    histo_exploitable = 2; % 2 pour dire que c'est pas déterminé
    
end % test si 00:00 apres periode 2

end