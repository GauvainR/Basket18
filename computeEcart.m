function [ecart] = computeEcart(histotextcell,data_mt)

clear ecart;

    %initialize score domicile and visiteur to 0 
    scoredomicile = 0;
    scorevisiteur = 0;

    for nbline = 1 : length(histotextcell)
        if isempty(strfind(histotextcell{nbline},'2 points réussi')) == 0 %check if 2 points reussi is written on the line
            if isempty(strfind(histotextcell{nbline-1},'Evénement annulé')) == 1 && isempty(strfind(histotextcell{nbline+1},'Remplacé par')) == 1 %check if in the line before there is evenement annulé

                player = regexp(histotextcell{nbline}, '[AB]\d+', 'match');
                if player{1}(1) == 'A'
                    scoredomicile = scoredomicile + 2;               
                elseif player{1}(1) == 'B'
                    scorevisiteur = scorevisiteur + 2;
                end

            end
        end

        if isempty(strfind(histotextcell{nbline},'3 points réussi')) == 0 %check if 3 points reussi is written on the line
            if isempty(strfind(histotextcell{nbline-1},'Evénement annulé')) == 1 && isempty(strfind(histotextcell{nbline+1},'Remplacé par')) == 1 %check if in the line before there is evenement annulé

                player = regexp(histotextcell{nbline}, '[AB]\d+', 'match');
                if player{1}(1) == 'A'
                    scoredomicile = scoredomicile + 3;               
                elseif player{1}(1) == 'B'
                    scorevisiteur = scorevisiteur + 3;
                end
            end
        end

        if isempty(strfind(histotextcell{nbline},'Lancer franc réussi')) == 0 %check if lancer franc réussi is written on the line
            if isempty(strfind(histotextcell{nbline-1},'Evénement annulé')) == 1 && isempty(strfind(histotextcell{nbline+1},'Remplacé par')) == 1 %check if in the line before there is not evenement annulé

                player = regexp(histotextcell{nbline}, '[AB]\d+', 'match');
                if player{1}(1) == 'A'
                    scoredomicile = scoredomicile + 1;
                elseif player{1}(1) == 'B'
                    scorevisiteur = scorevisiteur + 1;
                end
            end
        end


        if isempty(strfind(histotextcell{nbline},'est entré sur le terrain de jeu')) == 0 %check if lancer franc réussi is written on the line
            if isempty(strfind(histotextcell{nbline-1},'Evénement annulé')) == 1 && isempty(strfind(histotextcell{nbline+1},'Remplacé par')) == 1 %check if in the line before there is not evenement annulé
                player = regexp(histotextcell{nbline}, '[AB]\d+', 'match');

                if player{1}(1) == 'A'
                    ecart.([player{1,1}]).ecartentrant = scoredomicile - scorevisiteur;
                    ecart.([player{1,1}]).ptsmarqentrant = scoredomicile;
                    ecart.([player{1,1}]).ptsencentrant = scorevisiteur;
                elseif player{1}(1) == 'B'
                    ecart.([player{1,1}]).ecartentrant = scorevisiteur - scoredomicile;
                    ecart.([player{1,1}]).ptsmarqentrant = scorevisiteur;
                    ecart.([player{1,1}]).ptsencentrant = scoredomicile;
                end

            end
        end

        if isempty(strfind(histotextcell{nbline},'est sorti du terrain de jeu')) == 0 %check if lancer franc réussi is written on the line
            if isempty(strfind(histotextcell{nbline-1},'Evénement annulé')) == 1 && isempty(strfind(histotextcell{nbline+1},'Remplacé par')) == 1 %check if in the line before there is not evenement annulé
                player = regexp(histotextcell{nbline}, '[AB]\d+', 'match');

                    ecartTotalExist = true;
                    try
                    ecart.([player{1,1}]).ecarttotal;
                    catch
                    ecartTotalExist = false;
                    end

                    ptsencExist = true;
                    try
                      ecart.([player{1,1}]).ptsenctotal;
                    catch
                        ptsencExist = false;
                    end 

                    ptsmarqExist = true;
                    try
                      ecart.([player{1,1}]).ptsmarqtotal;
                    catch
                        ptsmarqExist = false;
                    end  

               if player{1}(1) == 'A'
                    %calcul des scores quand joueur sort
                    ecart.([player{1,1}]).ecartsortant = scoredomicile - scorevisiteur;
                    ecart.([player{1,1}]).ptsmarqsortant = scoredomicile;
                    ecart.([player{1,1}]).ptsencsortant = scorevisiteur;

                    %ecart
                    if ecartTotalExist == 1
                        ecart.([player{1,1}]).ecarttotal = ecart.([player{1,1}]).ecarttotal + (ecart.([player{1,1}]).ecartsortant - ecart.([player{1,1}]).ecartentrant);
                    elseif ecartTotalExist == 0
                        ecart.([player{1,1}]).ecarttotal = ecart.([player{1,1}]).ecartsortant - ecart.([player{1,1}]).ecartentrant;
                    end

                    %points encaisses
                    if ptsencExist == 1
                        ecart.([player{1,1}]).ptsenctotal = ecart.([player{1,1}]).ptsenctotal + (ecart.([player{1,1}]).ptsencsortant - ecart.([player{1,1}]).ptsencentrant);
                    elseif ptsencExist == 0
                        ecart.([player{1,1}]).ptsenctotal = ecart.([player{1,1}]).ptsencsortant - ecart.([player{1,1}]).ptsencentrant;
                    end

                    %points marques
                    if ptsmarqExist == 1
                        ecart.([player{1,1}]).ptsmarqtotal = ecart.([player{1,1}]).ptsmarqtotal + (ecart.([player{1,1}]).ptsmarqsortant - ecart.([player{1,1}]).ptsmarqentrant);
                    elseif ptsmarqExist == 0
                        ecart.([player{1,1}]).ptsmarqtotal = ecart.([player{1,1}]).ptsmarqsortant - ecart.([player{1,1}]).ptsmarqentrant;
                    end

                elseif player{1}(1) == 'B'
                    ecart.([player{1,1}]).ecartsortant = scorevisiteur - scoredomicile;
                    ecart.([player{1,1}]).ptsmarqsortant = scorevisiteur;
                    ecart.([player{1,1}]).ptsencsortant = scoredomicile;

                    %ecart
                    if ecartTotalExist == 1
                        ecart.([player{1,1}]).ecarttotal = ecart.([player{1,1}]).ecarttotal + (ecart.([player{1,1}]).ecartsortant - ecart.([player{1,1}]).ecartentrant);
                    elseif ecartTotalExist == 0
                        ecart.([player{1,1}]).ecarttotal = ecart.([player{1,1}]).ecartsortant - ecart.([player{1,1}]).ecartentrant;
                    end

                    %points encaisses
                    if ptsencExist == 1
                        ecart.([player{1,1}]).ptsenctotal = ecart.([player{1,1}]).ptsenctotal + (ecart.([player{1,1}]).ptsencsortant - ecart.([player{1,1}]).ptsencentrant);
                    elseif ptsencExist == 0
                        ecart.([player{1,1}]).ptsenctotal = ecart.([player{1,1}]).ptsencsortant - ecart.([player{1,1}]).ptsencentrant;
                    end

                    %points marques
                    if ptsmarqExist == 1
                        ecart.([player{1,1}]).ptsmarqtotal = ecart.([player{1,1}]).ptsmarqtotal + (ecart.([player{1,1}]).ptsmarqsortant - ecart.([player{1,1}]).ptsmarqentrant);
                    elseif ptsmarqExist == 0
                        ecart.([player{1,1}]).ptsmarqtotal = ecart.([player{1,1}]).ptsmarqsortant - ecart.([player{1,1}]).ptsmarqentrant;
                    end 

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

                if doesEntDisq == false % on calcule pas l'ecart si c'est l'enraineur qui est disqua
                        ecartTotalExist = true;
                        try
                        ecart.([player{1,1}]).ecarttotal;
                        catch
                        ecartTotalExist = false;
                        end

                        ptsencExist = true;
                        try
                          ecart.([player{1,1}]).ptsenctotal;
                        catch
                        ptsencExist = false;
                        end 

                        ptsmarqExist = true;
                        try
                          ecart.([player{1,1}]).ptsmarqtotal;
                        catch
                        ptsmarqExist = false;
                        end  

                    if player{1}(1) == 'A'
                        %calcul des scores quand joueur sort
                        ecart.([player{1,1}]).ecartsortant = scoredomicile - scorevisiteur;
                        ecart.([player{1,1}]).ptsmarqsortant = scoredomicile;
                        ecart.([player{1,1}]).ptsencsortant = scorevisiteur;

                        %ecart
                        if ecartTotalExist == 1
                            ecart.([player{1,1}]).ecarttotal = ecart.([player{1,1}]).ecarttotal + (ecart.([player{1,1}]).ecartsortant - ecart.([player{1,1}]).ecartentrant);
                        elseif ecartTotalExist == 0
                            ecart.([player{1,1}]).ecarttotal = ecart.([player{1,1}]).ecartsortant - ecart.([player{1,1}]).ecartentrant;
                        end

                        %points encaisses
                        if ptsencExist == 1
                            ecart.([player{1,1}]).ptsenctotal = ecart.([player{1,1}]).ptsenctotal + (ecart.([player{1,1}]).ptsencsortant - ecart.([player{1,1}]).ptsencentrant);
                        elseif ptsencExist == 0
                            ecart.([player{1,1}]).ptsenctotal = ecart.([player{1,1}]).ptsencsortant - ecart.([player{1,1}]).ptsencentrant;
                        end

                        %points marques
                        if ptsmarqExist == 1
                            ecart.([player{1,1}]).ptsmarqtotal = ecart.([player{1,1}]).ptsmarqtotal + (ecart.([player{1,1}]).ptsmarqsortant - ecart.([player{1,1}]).ptsmarqentrant);
                        elseif ptsmarqExist == 0
                            ecart.([player{1,1}]).ptsmarqtotal = ecart.([player{1,1}]).ptsmarqsortant - ecart.([player{1,1}]).ptsmarqentrant;
                        end

                    elseif player{1}(1) == 'B'
                        ecart.([player{1,1}]).ecartsortant = scorevisiteur - scoredomicile;
                        ecart.([player{1,1}]).ptsmarqsortant = scorevisiteur;
                        ecart.([player{1,1}]).ptsencsortant = scoredomicile;

                        %ecart
                        if ecartTotalExist == 1
                            ecart.([player{1,1}]).ecarttotal = ecart.([player{1,1}]).ecarttotal + (ecart.([player{1,1}]).ecartsortant - ecart.([player{1,1}]).ecartentrant);
                        elseif ecartTotalExist == 0
                            ecart.([player{1,1}]).ecarttotal = ecart.([player{1,1}]).ecartsortant - ecart.([player{1,1}]).ecartentrant;
                        end

                        %points encaisses
                        if ptsencExist == 1
                            ecart.([player{1,1}]).ptsenctotal = ecart.([player{1,1}]).ptsenctotal + (ecart.([player{1,1}]).ptsencsortant - ecart.([player{1,1}]).ptsencentrant);
                        elseif ptsencExist == 0
                            ecart.([player{1,1}]).ptsenctotal = ecart.([player{1,1}]).ptsencsortant - ecart.([player{1,1}]).ptsencentrant;
                        end

                        %points marques
                        if ptsmarqExist == 1
                            ecart.([player{1,1}]).ptsmarqtotal = ecart.([player{1,1}]).ptsmarqtotal + (ecart.([player{1,1}]).ptsmarqsortant - ecart.([player{1,1}]).ptsmarqentrant);
                        elseif ptsmarqExist == 0
                            ecart.([player{1,1}]).ptsmarqtotal = ecart.([player{1,1}]).ptsmarqsortant - ecart.([player{1,1}]).ptsmarqentrant;
                        end 

                    end
                end
            end
        end    
    end

%% Vérification des écarts
        ptsmarq_dom_reel = 5 * str2double(data_mt(2).domicile);
        ptsmarq_visit_reel = 5 * str2double(data_mt(2).visiteur);
        
        player = fieldnames(ecart);
        ptsmarq_dom = 0;
        ptsmarq_visit = 0;

        for i = 1 : length(player)
            if player{i}(1) == 'A'
                ptsmarq_dom = ptsmarq_dom + ecart.(player{i}).ptsmarqtotal;
            elseif player{i}(1) == 'B'
                ptsmarq_visit = ptsmarq_visit + ecart.(player{i}).ptsmarqtotal;
            end
        end

        % on laisse une marge d'erreur de 10%
        if abs(ptsmarq_dom - ptsmarq_dom_reel) < 0.1 * ptsmarq_dom_reel  && abs(ptsmarq_visit - ptsmarq_visit_reel) < 0.1 * ptsmarq_visit_reel 
            % on peut modifier les ecarts ici poour qu'ils collent
            % parfaitement
        else % si les ecarts sont supérieurs a 20
            ecart = [];
        end

end