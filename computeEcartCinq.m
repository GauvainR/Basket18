function [sqlEcartCinq] = computeEcartCinq(histotextcell,infosJoueurs,gamedata,season,histo_exploitable)

clear ecartDom;
clear ecartVisit;

% load('histotextcell.mat'); % a supprimer c'etait la pour le test au debut
joueursEnJeu_dom = [];
joueursEnJeu_visit = [];

%initialize score domicile and visiteur to 0 
scoredomicile = 0;
scorevisiteur = 0;

% initialise tdj dom et visit
tdjDom = [];
tdjVisit = [];

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
    
   
    
   %% entré sur le terrain de jeu 
    if isempty(strfind(histotextcell{nbline},'est entré sur le terrain de jeu')) == 0 
        if isempty(strfind(histotextcell{nbline-1},'Evénement annulé')) == 1 && isempty(strfind(histotextcell{nbline+1},'Remplacé par')) == 1 %check if in the line before there is not evenement annulé
            player = regexp(histotextcell{nbline}, '[AB]\d+', 'match');
            
            if player{1}(1) == 'A'
                numJoueur = str2double(player{1}(2:end));
                joueursEnJeu_dom{end+1} = numJoueur;
                [joueursEnJeu_dom] = suppDoublons(joueursEnJeu_dom);
                
                if length(joueursEnJeu_dom) == 5 % si il y a 5 joueurs sur le terrain 
                    % on classe par le numero du joueur
                    joueursEnJeu_dom = joueursEnJeu_dom';
                    joueursEnJeu_dom = sortrows(joueursEnJeu_dom);
                    joueursEnJeu_dom = joueursEnJeu_dom';
                    
                    % le a est juste la pour faire un nom de field valide
                    nomCinqDom = ['a_',num2str(joueursEnJeu_dom{1}),'_',num2str(joueursEnJeu_dom{2}),'_',num2str(joueursEnJeu_dom{3}),'_',num2str(joueursEnJeu_dom{4}),'_',num2str(joueursEnJeu_dom{5}),'_'];
                    ecartDom.(nomCinqDom).ecartentrant = scoredomicile - scorevisiteur;
                    ecartDom.(nomCinqDom).ptsmarqentrant = scoredomicile;
                    ecartDom.(nomCinqDom).ptsencentrant = scorevisiteur;
                    
                        %si le joueur sort avant le début du match, tdj entrant est 0
                    if isempty(strfind(histotextcell{nbline},'Avant match')) == 0
                        tdjDom.(nomCinqDom).tempsentrant = 0;
                    else

                        % temps de jeu
                        temps = regexp(histotextcell{nbline}, '(?<min>\d+):(?<sec>\d+)', 'names');
                        temps.min = str2double(temps.min);
                        temps.sec = str2double(temps.sec)/60;
                        temps = temps.min + temps.sec;
                        tdjDom.(nomCinqDom).tempsentrant = temps;
                    end
                    
                end
            end
                
                
            if player{1}(1) == 'B'
                numJoueur = str2double(player{1}(2:end));
                joueursEnJeu_visit{end+1} = numJoueur;
                [joueursEnJeu_visit] = suppDoublons(joueursEnJeu_visit);
                
                if length(joueursEnJeu_visit) == 5 % si il y a 5 joueurs sur le terrain 
                    % on classe par le numero du joueur
                    joueursEnJeu_visit = joueursEnJeu_visit';
                    joueursEnJeu_visit = sortrows(joueursEnJeu_visit);
                    joueursEnJeu_visit = joueursEnJeu_visit';
                    
                    nomCinqVisit = ['b_',num2str(joueursEnJeu_visit{1}),'_',num2str(joueursEnJeu_visit{2}),'_',num2str(joueursEnJeu_visit{3}),'_',num2str(joueursEnJeu_visit{4}),'_',num2str(joueursEnJeu_visit{5}),'_'];
                    ecartVisit.(nomCinqVisit).ecartentrant = scorevisiteur - scoredomicile;
                    ecartVisit.(nomCinqVisit).ptsmarqentrant = scorevisiteur;
                    ecartVisit.(nomCinqVisit).ptsencentrant = scoredomicile;
                    
                    % temps de jeu
                    %si le joueur sort avant le début du match, tdj entrant est 0
                    if isempty(strfind(histotextcell{nbline},'Avant match')) == 0
                        tdjVisit.(nomCinqVisit).tempsentrant = 0;
                    else
                        temps = regexp(histotextcell{nbline}, '(?<min>\d+):(?<sec>\d+)', 'names');
                        temps.min = str2double(temps.min);
                        temps.sec = str2double(temps.sec)/60;
                        temps = temps.min + temps.sec;
                        tdjVisit.(nomCinqVisit).tempsentrant = temps;
                    end
                end
            end
        end
    end
    
    %% Sorti du terrain de jeu
    if isempty(strfind(histotextcell{nbline},'est sorti du terrain de jeu')) == 0 
        if isempty(strfind(histotextcell{nbline-1},'Evénement annulé')) == 1 && isempty(strfind(histotextcell{nbline+1},'Remplacé par')) == 1 %check if in the line before there is not evenement annulé
            player = regexp(histotextcell{nbline}, '[AB]\d+', 'match');
   
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Ecart %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
            % On verifie s'il y avait 5 joueurs sur le terrain quand il est
            % sorti. Si pas 5 joueurs on ne fait pas la suite
            if player{1}(1) == 'A'
                if length(joueursEnJeu_dom) == 5 || length(joueursEnJeu_dom) == 6
                    
                    ecartTotalExist = true;
                    try
                    ecartDom.(nomCinqDom).ecarttotal;
                    catch
                    ecartTotalExist = false;
                    end

                    ptsencExist = true;
                    try
                      ecartDom.(nomCinqDom).ptsenctotal;
                    catch
                        ptsencExist = false;
                    end 

                    ptsmarqExist = true;
                    try
                      ecartDom.(nomCinqDom).ptsmarqtotal;
                    catch
                        ptsmarqExist = false;
                    end

                    %calcul des scores quand joueur sort
                    ecartDom.(nomCinqDom).ecartsortant = scoredomicile - scorevisiteur;
                    ecartDom.(nomCinqDom).ptsmarqsortant = scoredomicile;
                    ecartDom.(nomCinqDom).ptsencsortant = scorevisiteur;

                    %ecart
                    if ecartTotalExist == 1
                        ecartDom.(nomCinqDom).ecarttotal = ecartDom.(nomCinqDom).ecarttotal + (ecartDom.(nomCinqDom).ecartsortant - ecartDom.(nomCinqDom).ecartentrant);
                    elseif ecartTotalExist == 0
                        ecartDom.(nomCinqDom).ecarttotal = ecartDom.(nomCinqDom).ecartsortant - ecartDom.(nomCinqDom).ecartentrant;
                    end
                    
                    %points encaisses
                    if ptsencExist == 1
                        ecartDom.(nomCinqDom).ptsenctotal = ecartDom.(nomCinqDom).ptsenctotal + (ecartDom.(nomCinqDom).ptsencsortant - ecartDom.(nomCinqDom).ptsencentrant);
                    elseif ptsencExist == 0
                        ecartDom.(nomCinqDom).ptsenctotal = ecartDom.(nomCinqDom).ptsencsortant - ecartDom.(nomCinqDom).ptsencentrant;
                    end
                    
                    %points marques
                    if ptsmarqExist == 1
                        ecartDom.(nomCinqDom).ptsmarqtotal = ecartDom.(nomCinqDom).ptsmarqtotal + (ecartDom.(nomCinqDom).ptsmarqsortant - ecartDom.(nomCinqDom).ptsmarqentrant);
                    elseif ptsmarqExist == 0
                        ecartDom.(nomCinqDom).ptsmarqtotal = ecartDom.(nomCinqDom).ptsmarqsortant - ecartDom.(nomCinqDom).ptsmarqentrant;
                    end
                
                
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% tdj %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %si le joueur sort avant le début du match, tdj sorti est 0
                if isempty(strfind(histotextcell{nbline},'Avant match')) == 0
                    tdjDom.(nomCinqDom).tempssortant = 0;

                else
                    temps = regexp(histotextcell{nbline}, '(?<min>\d+):(?<sec>\d+)', 'names');
                    temps.min = str2double(temps.min);
                    temps.sec = str2double(temps.sec)/60;
                    temps = temps.min + temps.sec;

                    tdjDom.(nomCinqDom).tempssortant = temps;  
                end   
                
                    tdjTotalExist = true;
                    try
                    tdjDom.(nomCinqDom).tdjtotal;
                    catch
                    tdjTotalExist = false;
                    end


                    %ecart
                    if tdjTotalExist == 1
                        tdjDom.(nomCinqDom).tdjtotal = tdjDom.(nomCinqDom).tdjtotal + tdjDom.(nomCinqDom).tempssortant - tdjDom.(nomCinqDom).tempsentrant;  
                    elseif tdjTotalExist == 0
                        tdjDom.(nomCinqDom).tdjtotal = tdjDom.(nomCinqDom).tempssortant - tdjDom.(nomCinqDom).tempsentrant;  
                    end
                    
                
                end % end du if length joueur en jeu = 5 ou 6
                
            
            elseif player{1}(1) == 'B'
                if length(joueursEnJeu_visit) == 5 || length(joueursEnJeu_visit) == 6
%%%%%%%%%%%%%%%%%%%%%%%%% Ecart %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                    
                    ecartTotalExist = true;
                    try
                    ecartVisit.(nomCinqVisit).ecarttotal;
                    catch
                    ecartTotalExist = false;
                    end

                    ptsencExist = true;
                    try
                      ecartVisit.(nomCinqVisit).ptsenctotal;
                    catch
                        ptsencExist = false;
                    end 

                    ptsmarqExist = true;
                    try
                      ecartVisit.(nomCinqVisit).ptsmarqtotal;
                    catch
                        ptsmarqExist = false;
                    end

                    %calcul des scores quand joueur sort
                    ecartVisit.(nomCinqVisit).ecartsortant = scorevisiteur - scoredomicile;
                    ecartVisit.(nomCinqVisit).ptsmarqsortant = scorevisiteur;
                    ecartVisit.(nomCinqVisit).ptsencsortant = scoredomicile;

                    %ecart
                    if ecartTotalExist == 1
                        ecartVisit.(nomCinqVisit).ecarttotal = ecartVisit.(nomCinqVisit).ecarttotal + (ecartVisit.(nomCinqVisit).ecartsortant - ecartVisit.(nomCinqVisit).ecartentrant);
                    elseif ecartTotalExist == 0
                        ecartVisit.(nomCinqVisit).ecarttotal = ecartVisit.(nomCinqVisit).ecartsortant - ecartVisit.(nomCinqVisit).ecartentrant;
                    end
                    %points encaisses
                    if ptsencExist == 1
                        ecartVisit.(nomCinqVisit).ptsenctotal = ecartVisit.(nomCinqVisit).ptsenctotal + (ecartVisit.(nomCinqVisit).ptsencsortant - ecartVisit.(nomCinqVisit).ptsencentrant);
                    elseif ptsencExist == 0
                        ecartVisit.(nomCinqVisit).ptsenctotal = ecartVisit.(nomCinqVisit).ptsencsortant - ecartVisit.(nomCinqVisit).ptsencentrant;
                    end
                    %points marques
                    if ptsmarqExist == 1
                        ecartVisit.(nomCinqVisit).ptsmarqtotal = ecartVisit.(nomCinqVisit).ptsmarqtotal + (ecartVisit.(nomCinqVisit).ptsmarqsortant - ecartVisit.(nomCinqVisit).ptsmarqentrant);
                    elseif ptsmarqExist == 0
                        ecartVisit.(nomCinqVisit).ptsmarqtotal = ecartVisit.(nomCinqVisit).ptsmarqsortant - ecartVisit.(nomCinqVisit).ptsmarqentrant;
                    end
                
                
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% tdj %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %si le joueur sort avant le début du match, tdj sorti est 0
                    if isempty(strfind(histotextcell{nbline},'Avant match')) == 0
                        tdjVisit.(nomCinqVisit).tempssortant = 0;

                    else
                        temps = regexp(histotextcell{nbline}, '(?<min>\d+):(?<sec>\d+)', 'names');
                        temps.min = str2double(temps.min);
                        temps.sec = str2double(temps.sec)/60;
                        temps = temps.min + temps.sec;

                        tdjVisit.(nomCinqVisit).tempssortant = temps;  
%                         tdjVisit.(nomCinqVisit).tdjtotal = tdjVisit.(nomCinqVisit).tempssortant - tdjVisit.(nomCinqVisit).tempsentrant;  
                    end

                    tdjTotalExist = true;
                        try
                        tdjVisit.(nomCinqVisit).tdjtotal;
                        catch
                        tdjTotalExist = false;
                        end


                        %ecart
                        if tdjTotalExist == 1
                            tdjVisit.(nomCinqVisit).tdjtotal = tdjVisit.(nomCinqVisit).tdjtotal + tdjVisit.(nomCinqVisit).tempssortant - tdjVisit.(nomCinqVisit).tempsentrant;  
                        elseif tdjTotalExist == 0
                            tdjVisit.(nomCinqVisit).tdjtotal = tdjVisit.(nomCinqVisit).tempssortant - tdjVisit.(nomCinqVisit).tempsentrant;  
                        end
                end
                
            end
 %% suppression des joueurs en jeu          
            if player{1}(1) == 'A'
                %suppression du joueur des joueurs en jeu
                    for ii = length(joueursEnJeu_dom): -1 : 1
                        if joueursEnJeu_dom{ii} == str2double(player{1}(2:end))
                            joueursEnJeu_dom(ii) = [];
                        end
                    end
                    
                if length(joueursEnJeu_dom) == 5 % si on a 5 joueurs apres qu'un joueur est sorti
                    % on classe par le numero du joueur
                    joueursEnJeu_dom = joueursEnJeu_dom';
                    joueursEnJeu_dom = sortrows(joueursEnJeu_dom);
                    joueursEnJeu_dom = joueursEnJeu_dom';
                    
                    % le a est juste la pour faire un nom de field valide
                    nomCinqDom = ['a_',num2str(joueursEnJeu_dom{1}),'_',num2str(joueursEnJeu_dom{2}),'_',num2str(joueursEnJeu_dom{3}),'_',num2str(joueursEnJeu_dom{4}),'_',num2str(joueursEnJeu_dom{5}),'_'];
                    ecartDom.(nomCinqDom).ecartentrant = scoredomicile - scorevisiteur;
                    ecartDom.(nomCinqDom).ptsmarqentrant = scoredomicile;
                    ecartDom.(nomCinqDom).ptsencentrant = scorevisiteur;
                    
                    %%%%%%%%%%%%%% tdj %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %si le joueur sort avant le début du match, tdj entrant est 0
                    if isempty(strfind(histotextcell{nbline},'Avant match')) == 0
                        tdjDom.(nomCinqDom).tempsentrant = 0;
                    else

                        % temps de jeu
                        temps = regexp(histotextcell{nbline}, '(?<min>\d+):(?<sec>\d+)', 'names');
                        temps.min = str2double(temps.min);
                        temps.sec = str2double(temps.sec)/60;
                        temps = temps.min + temps.sec;
                        tdjDom.(nomCinqDom).tempsentrant = temps;
                    end
                    
                end
                    
            elseif player{1}(1) == 'B'
            %suppression du joueur des joueurs en jeu
                for ii = length(joueursEnJeu_visit): -1 : 1
                    if joueursEnJeu_visit{ii} == str2double(player{1}(2:end))
                        joueursEnJeu_visit(ii) = [];
                    end
                end
                
                if length(joueursEnJeu_visit) == 5 % si on a 5 joueurs apres qu'un joueur est sorti
                    % on classe par le numero du joueur
                    joueursEnJeu_visit = joueursEnJeu_visit';
                    joueursEnJeu_visit = sortrows(joueursEnJeu_visit);
                    joueursEnJeu_visit = joueursEnJeu_visit';
                    
                    nomCinqVisit = ['b_',num2str(joueursEnJeu_visit{1}),'_',num2str(joueursEnJeu_visit{2}),'_',num2str(joueursEnJeu_visit{3}),'_',num2str(joueursEnJeu_visit{4}),'_',num2str(joueursEnJeu_visit{5}),'_'];
                    ecartVisit.(nomCinqVisit).ecartentrant = scorevisiteur - scoredomicile;
                    ecartVisit.(nomCinqVisit).ptsmarqentrant = scorevisiteur;
                    ecartVisit.(nomCinqVisit).ptsencentrant = scoredomicile;
                    
                    %%%%%%%%%%%%%%%%% tdj %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %si le joueur sort avant le début du match, tdj entrant est 0
                    if isempty(strfind(histotextcell{nbline},'Avant match')) == 0
                        tdjVisit.(nomCinqVisit).tempsentrant = 0;
                    else

                        % temps de jeu
                        temps = regexp(histotextcell{nbline}, '(?<min>\d+):(?<sec>\d+)', 'names');
                        temps.min = str2double(temps.min);
                        temps.sec = str2double(temps.sec)/60;
                        temps = temps.min + temps.sec;
                        tdjVisit.(nomCinqVisit).tempsentrant = temps;
                    end
                end
            end
        end
    end    
                    
    %% disqualifié
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
            
                   % On verifie s'il y avait 5 joueurs sur le terrain quand il est
                % sorti. Si pas 5 joueurs on ne fait pas la suite
                if player{1}(1) == 'A'
                    if length(joueursEnJeu_dom) == 5 || length(joueursEnJeu_dom) == 6

                        ecartTotalExist = true;
                        try
                        ecartDom.(nomCinqDom).ecarttotal;
                        catch
                        ecartTotalExist = false;
                        end

                        ptsencExist = true;
                        try
                          ecartDom.(nomCinqDom).ptsenctotal;
                        catch
                            ptsencExist = false;
                        end 

                        ptsmarqExist = true;
                        try
                          ecartDom.(nomCinqDom).ptsmarqtotal;
                        catch
                            ptsmarqExist = false;
                        end

                        %calcul des scores quand joueur sort
                        ecartDom.(nomCinqDom).ecartsortant = scoredomicile - scorevisiteur;
                        ecartDom.(nomCinqDom).ptsmarqsortant = scoredomicile;
                        ecartDom.(nomCinqDom).ptsencsortant = scorevisiteur;

                        %ecart
                        if ecartTotalExist == 1
                            ecartDom.(nomCinqDom).ecarttotal = ecartDom.(nomCinqDom).ecarttotal + (ecartDom.(nomCinqDom).ecartsortant - ecartDom.(nomCinqDom).ecartentrant);
                        elseif ecartTotalExist == 0
                            ecartDom.(nomCinqDom).ecarttotal = ecartDom.(nomCinqDom).ecartsortant - ecartDom.(nomCinqDom).ecartentrant;
                        end

                        %points encaisses
                        if ptsencExist == 1
                            ecartDom.(nomCinqDom).ptsenctotal = ecartDom.(nomCinqDom).ptsenctotal + (ecartDom.(nomCinqDom).ptsencsortant - ecartDom.(nomCinqDom).ptsencentrant);
                        elseif ptsencExist == 0
                            ecartDom.(nomCinqDom).ptsenctotal = ecartDom.(nomCinqDom).ptsencsortant - ecartDom.(nomCinqDom).ptsencentrant;
                        end

                        %points marques
                        if ptsmarqExist == 1
                            ecartDom.(nomCinqDom).ptsmarqtotal = ecartDom.(nomCinqDom).ptsmarqtotal + (ecartDom.(nomCinqDom).ptsmarqsortant - ecartDom.(nomCinqDom).ptsmarqentrant);
                        elseif ptsmarqExist == 0
                            ecartDom.(nomCinqDom).ptsmarqtotal = ecartDom.(nomCinqDom).ptsmarqsortant - ecartDom.(nomCinqDom).ptsmarqentrant;
                        end

                         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% tdj %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %si le joueur sort avant le début du match, tdj sorti est 0
                        if isempty(strfind(histotextcell{nbline},'Avant match')) == 0
                            tdjDom.(nomCinqDom).tempssortant = 0;

                        else
                            temps = regexp(histotextcell{nbline}, '(?<min>\d+):(?<sec>\d+)', 'names');
                            temps.min = str2double(temps.min);
                            temps.sec = str2double(temps.sec)/60;
                            temps = temps.min + temps.sec;

                            tdjDom.(nomCinqDom).tempssortant = temps;  

                            tdjTotalExist = true;
                            try
                            tdjDom.(nomCinqDom).tdjtotal;
                            catch
                            tdjTotalExist = false;
                            end


                            %tdj
                            if tdjTotalExist == 1
                                tdjDom.(nomCinqDom).tdjtotal = tdjDom.(nomCinqDom).tdjtotal + tdjDom.(nomCinqDom).tempssortant - tdjDom.(nomCinqDom).tempsentrant;  
                            elseif tdjTotalExist == 0
                                tdjDom.(nomCinqDom).tdjtotal = tdjDom.(nomCinqDom).tempssortant - tdjDom.(nomCinqDom).tempsentrant;  
                            end

                        end
                    end



                elseif player{1}(1) == 'B'
                    if length(joueursEnJeu_visit) == 5 || length(joueursEnJeu_visit) == 6
                        ecartTotalExist = true;
                        try
                        ecartVisit.(nomCinqVisit).ecarttotal;
                        catch
                        ecartTotalExist = false;
                        end

                        ptsencExist = true;
                        try
                          ecartVisit.(nomCinqVisit).ptsenctotal;
                        catch
                            ptsencExist = false;
                        end 

                        ptsmarqExist = true;
                        try
                          ecartVisit.(nomCinqVisit).ptsmarqtotal;
                        catch
                            ptsmarqExist = false;
                        end

                        %calcul des scores quand joueur sort
                        ecartVisit.(nomCinqVisit).ecartsortant = scorevisiteur - scoredomicile;
                        ecartVisit.(nomCinqVisit).ptsmarqsortant = scorevisiteur;
                        ecartVisit.(nomCinqVisit).ptsencsortant = scoredomicile;

                        %ecart
                        if ecartTotalExist == 1
                            ecartVisit.(nomCinqVisit).ecarttotal = ecartVisit.(nomCinqVisit).ecarttotal + (ecartVisit.(nomCinqVisit).ecartsortant - ecartVisit.(nomCinqVisit).ecartentrant);
                        elseif ecartTotalExist == 0
                            ecartVisit.(nomCinqVisit).ecarttotal = ecartVisit.(nomCinqVisit).ecartsortant - ecartVisit.(nomCinqVisit).ecartentrant;
                        end
                        %points encaisses
                        if ptsencExist == 1
                            ecartVisit.(nomCinqVisit).ptsenctotal = ecartVisit.(nomCinqVisit).ptsenctotal + (ecartVisit.(nomCinqVisit).ptsencsortant - ecartVisit.(nomCinqVisit).ptsencentrant);
                        elseif ptsencExist == 0
                            ecartVisit.(nomCinqVisit).ptsenctotal = ecartVisit.(nomCinqVisit).ptsencsortant - ecartVisit.(nomCinqVisit).ptsencentrant;
                        end
                        %points marques
                        if ptsmarqExist == 1
                            ecartVisit.(nomCinqVisit).ptsmarqtotal = ecartVisit.(nomCinqVisit).ptsmarqtotal + (ecartVisit.(nomCinqVisit).ptsmarqsortant - ecartVisit.(nomCinqVisit).ptsmarqentrant);
                        elseif ptsmarqExist == 0
                            ecartVisit.(nomCinqVisit).ptsmarqtotal = ecartVisit.(nomCinqVisit).ptsmarqsortant - ecartVisit.(nomCinqVisit).ptsmarqentrant;
                        end

                         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% tdj %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %si le joueur sort avant le début du match, tdj sorti est 0
                        if isempty(strfind(histotextcell{nbline},'Avant match')) == 0
                            tdjVisit.(nomCinqVisit).tempssortant = 0;

                        else
                            temps = regexp(histotextcell{nbline}, '(?<min>\d+):(?<sec>\d+)', 'names');
                            temps.min = str2double(temps.min);
                            temps.sec = str2double(temps.sec)/60;
                            temps = temps.min + temps.sec;

                            tdjVisit.(nomCinqVisit).tempssortant = temps;  

                            tdjTotalExist = true;
                            try
                            tdjVisit.(nomCinqVisit).tdjtotal;
                            catch
                            tdjTotalExist = false;
                            end


                            %ecart
                            if tdjTotalExist == 1
                                tdjVisit.(nomCinqVisit).tdjtotal = tdjVisit.(nomCinqVisit).tdjtotal + tdjVisit.(nomCinqVisit).tempssortant - tdjVisit.(nomCinqVisit).tempsentrant;  
                            elseif tdjTotalExist == 0
                                tdjVisit.(nomCinqVisit).tdjtotal = tdjVisit.(nomCinqVisit).tempssortant - tdjVisit.(nomCinqVisit).tempsentrant;  
                            end

                        end
                    end
                end 
            
            
                if player{1}(1) == 'A'
                    %suppression du joueur des joueurs en jeu
                        for ii = length(joueursEnJeu_dom): -1 : 1
                            if joueursEnJeu_dom{ii} == str2double(player{1}(2:end))
                                joueursEnJeu_dom(ii) = [];
                            end
                        end

                    if length(joueursEnJeu_dom) == 5 % si on a 5 joueurs apres qu'un joueur est sorti
                        % on classe par le numero du joueur
                        joueursEnJeu_dom = joueursEnJeu_dom';
                        joueursEnJeu_dom = sortrows(joueursEnJeu_dom);
                        joueursEnJeu_dom = joueursEnJeu_dom';

                        % le a est juste la pour faire un nom de field valide
                        nomCinqDom = ['a_',num2str(joueursEnJeu_dom{1}),'_',num2str(joueursEnJeu_dom{2}),'_',num2str(joueursEnJeu_dom{3}),'_',num2str(joueursEnJeu_dom{4}),'_',num2str(joueursEnJeu_dom{5}),'_'];
                        ecartDom.(nomCinqDom).ecartentrant = scoredomicile - scorevisiteur;
                        ecartDom.(nomCinqDom).ptsmarqentrant = scoredomicile;
                        ecartDom.(nomCinqDom).ptsencentrant = scorevisiteur;

                            %si le joueur sort avant le début du match, tdj entrant est 0
                        if isempty(strfind(histotextcell{nbline},'Avant match')) == 0
                            tdjDom.(nomCinqDom).tempsentrant = 0;
                        else

                            % temps de jeu
                            temps = regexp(histotextcell{nbline}, '(?<min>\d+):(?<sec>\d+)', 'names');
                            temps.min = str2double(temps.min);
                            temps.sec = str2double(temps.sec)/60;
                            temps = temps.min + temps.sec;
                            tdjDom.(nomCinqDom).tempsentrant = temps;
                        end
                    end

                elseif player{1}(1) == 'B'
                %suppression du joueur des joueurs en jeu
                    for ii = length(joueursEnJeu_visit): -1 : 1
                        if joueursEnJeu_visit{ii} == str2double(player{1}(2:end))
                            joueursEnJeu_visit(ii) = [];
                        end
                    end

                    if length(joueursEnJeu_visit) == 5 % si on a 5 joueurs apres qu'un joueur est sorti
                        % on classe par le numero du joueur
                        joueursEnJeu_visit = joueursEnJeu_visit';
                        joueursEnJeu_visit = sortrows(joueursEnJeu_visit);
                        joueursEnJeu_visit = joueursEnJeu_visit';

                        nomCinqVisit = ['b_',num2str(joueursEnJeu_visit{1}),'_',num2str(joueursEnJeu_visit{2}),'_',num2str(joueursEnJeu_visit{3}),'_',num2str(joueursEnJeu_visit{4}),'_',num2str(joueursEnJeu_visit{5}),'_'];
                        ecartVisit.(nomCinqVisit).ecartentrant = scorevisiteur - scoredomicile;
                        ecartVisit.(nomCinqVisit).ptsmarqentrant = scorevisiteur;
                        ecartVisit.(nomCinqVisit).ptsencentrant = scoredomicile;

                            %si le joueur sort avant le début du match, tdj entrant est 0
                        if isempty(strfind(histotextcell{nbline},'Avant match')) == 0
                            tdjVisit.(nomCinqVisit).tempsentrant = 0;
                        else

                            % temps de jeu
                            temps = regexp(histotextcell{nbline}, '(?<min>\d+):(?<sec>\d+)', 'names');
                            temps.min = str2double(temps.min);
                            temps.sec = str2double(temps.sec)/60;
                            temps = temps.min + temps.sec;
                            tdjVisit.(nomCinqVisit).tempsentrant = temps;
                        end
                    end                   
                end
            end
        end
    end   

end

%% sql pour l'equipe domicile 
if histo_exploitable == 0
    tdjDom = [];
    tdjVisit = [];
    tdj='NULL';
end

sqlEcartCinq = [];
listeCinq = fieldnames(ecartDom);

for i = 1 : length(listeCinq)
    nomCinq = listeCinq{i};

    listeJoueursCinq = strsplit(nomCinq,'_');
    %on cherche les indices qui correspondent aux numeros des joueurs pour
    %retrouver leurs noms
    index = [];
        kk = 1; 
    for colListe = 2 : length(listeJoueursCinq)-1
        for col = 1 : length(infosJoueurs.domicile.numero)
            if infosJoueurs.domicile.numero{col} == str2double(listeJoueursCinq{colListe})
                 index(kk) = col;
                 kk = kk+1;
            end
        end
    end

    nomJoueursPourSql = [infosJoueurs.domicile.nom(index(1)),infosJoueurs.domicile.nom(index(2)),infosJoueurs.domicile.nom(index(3)),infosJoueurs.domicile.nom(index(4)),infosJoueurs.domicile.nom(index(5))];
    nomJoueursPourSql = sort(nomJoueursPourSql);

    %on cherche les indices qui correspondent aux numeros des joueurs pour
    %retrouver leurs noms
    index = [];
        kk = 1; 
    for colListe = 1 : length(nomJoueursPourSql)
        for col = 1: length(infosJoueurs.domicile.numero)
            if strcmp(infosJoueurs.domicile.nom{col},nomJoueursPourSql{colListe})
                 index(kk) = col;
                 kk = kk+1;
            end
        end
    end
    
    % on met le temps de jeu dans variabe tdj si tdjDom et Visit ne sont
    % pas nuls
    if isempty(tdjDom) == 0
        tdj = num2str(tdjDom.(nomCinq).tdjtotal);
    end

    sqlEcartCinq = sprintf([sqlEcartCinq,'INSERT INTO ecart_cinq (stats_equipes_id,joueur_1,joueur_2,joueur_3,joueur_4,joueur_5,tdj,ptsm,ptse) ']);
    sqlEcartCinq = sprintf([sqlEcartCinq,'VALUES ((SELECT id_stats_equipes FROM stats_equipes ']);
    sqlEcartCinq = sprintf([sqlEcartCinq,'WHERE equipes_id= (SELECT id_equipes FROM equipes WHERE (nom_equipe=''',gamedata.domicilewithoutspace,''' AND saison_id = (SELECT id_saison FROM saison WHERE annee=',season,') AND comite_id = (SELECT id_comite FROM comite WHERE nom_comite=''',gamedata.comite,''') AND competition_id = (SELECT id_competition FROM competition WHERE (chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt= ''',gamedata.chpt,''') AND poule_id=(SELECT id_poule FROM poule WHERE nom_poule=''',gamedata.poule,'''))))) ']);
    sqlEcartCinq = sprintf([sqlEcartCinq,'AND matchs_id=(SELECT id_matchs FROM matchs INNER JOIN equipes ON id_equipes=equipedom_id INNER JOIN competition ON id_competition=competition_id WHERE (numero_match=',num2str(gamedata.numrencontre),' AND matchs.comite_id=(SELECT id_comite FROM comite WHERE nom_comite=''',gamedata.comite,''') AND chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt=''',gamedata.chpt,''') AND matchs.saison_id = (SELECT id_saison FROM saison WHERE annee=',season,')))),']);
    sqlEcartCinq = sprintf([sqlEcartCinq,'(SELECT id_joueurs FROM joueurs WHERE licence=''',infosJoueurs.domicile.numLicence{index(1)},''' AND nom_joueur=''',infosJoueurs.domicile.nom{index(1)},'''),']);
    sqlEcartCinq = sprintf([sqlEcartCinq,'(SELECT id_joueurs FROM joueurs WHERE licence=''',infosJoueurs.domicile.numLicence{index(2)},''' AND nom_joueur=''',infosJoueurs.domicile.nom{index(2)},'''),']);
    sqlEcartCinq = sprintf([sqlEcartCinq,'(SELECT id_joueurs FROM joueurs WHERE licence=''',infosJoueurs.domicile.numLicence{index(3)},''' AND nom_joueur=''',infosJoueurs.domicile.nom{index(3)},'''),']);
    sqlEcartCinq = sprintf([sqlEcartCinq,'(SELECT id_joueurs FROM joueurs WHERE licence=''',infosJoueurs.domicile.numLicence{index(4)},''' AND nom_joueur=''',infosJoueurs.domicile.nom{index(4)},'''),']);
    sqlEcartCinq = sprintf([sqlEcartCinq,'(SELECT id_joueurs FROM joueurs WHERE licence=''',infosJoueurs.domicile.numLicence{index(5)},''' AND nom_joueur=''',infosJoueurs.domicile.nom{index(5)},'''),']);
    sqlEcartCinq = sprintf([sqlEcartCinq,tdj,',',num2str(ecartDom.(nomCinq).ptsmarqtotal),',',num2str(ecartDom.(nomCinq).ptsenctotal),');']);
    sqlEcartCinq = sprintf([sqlEcartCinq,'\n']);
end

%% sql pour equipe visiteur

listeCinq = fieldnames(ecartVisit);

for i = 1 : length(listeCinq)
        nomCinq = listeCinq{i};

    listeJoueursCinq = strsplit(nomCinq,'_');
    %on cherche les indices qui correspondent aux numeros des joueurs pour
    %retrouver leurs noms
    index = [];
        kk = 1; 
    for colListe = 2 : length(listeJoueursCinq)-1
        for col = 1: length(infosJoueurs.visiteur.numero)
            if infosJoueurs.visiteur.numero{col} == str2double(listeJoueursCinq{colListe})
                 index(kk) = col;
                 kk = kk+1;
            end
        end
    end

    nomJoueursPourSql = [infosJoueurs.visiteur.nom(index(1)),infosJoueurs.visiteur.nom(index(2)),infosJoueurs.visiteur.nom(index(3)),infosJoueurs.visiteur.nom(index(4)),infosJoueurs.visiteur.nom(index(5))];
    nomJoueursPourSql = sort(nomJoueursPourSql);

    %on cherche les indices qui correspondent aux numeros des joueurs pour
    %retrouver leurs noms
    index = [];
        kk = 1; 
    for colListe = 1 : length(nomJoueursPourSql)
        for col = 1: length(infosJoueurs.visiteur.numero)
            if strcmp(infosJoueurs.visiteur.nom{col},nomJoueursPourSql{colListe})
                 index(kk) = col;
                 kk = kk+1;
            end
        end
    end

    % on met le temps de jeu dans variabe tdj si tdjDom et Visit ne sont
    % pas nuls
    if isempty(tdjVisit) == 0
        tdj = num2str(tdjVisit.(nomCinq).tdjtotal);
    end

    sqlEcartCinq = sprintf([sqlEcartCinq,'INSERT INTO ecart_cinq (stats_equipes_id,joueur_1,joueur_2,joueur_3,joueur_4,joueur_5,tdj,ptsm,ptse) ']);
    sqlEcartCinq = sprintf([sqlEcartCinq,'VALUES ((SELECT id_stats_equipes FROM stats_equipes ']);
    sqlEcartCinq = sprintf([sqlEcartCinq,'WHERE equipes_id= (SELECT id_equipes FROM equipes WHERE (nom_equipe=''',gamedata.visiteurwithoutspace,''' AND saison_id = (SELECT id_saison FROM saison WHERE annee=',season,') AND comite_id = (SELECT id_comite FROM comite WHERE nom_comite=''',gamedata.comite,''') AND competition_id = (SELECT id_competition FROM competition WHERE (chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt= ''',gamedata.chpt,''') AND poule_id=(SELECT id_poule FROM poule WHERE nom_poule=''',gamedata.poule,'''))))) ']);
    sqlEcartCinq = sprintf([sqlEcartCinq,'AND matchs_id=(SELECT id_matchs FROM matchs INNER JOIN equipes ON id_equipes=equipedom_id INNER JOIN competition ON id_competition=competition_id WHERE (numero_match=',num2str(gamedata.numrencontre),' AND matchs.comite_id=(SELECT id_comite FROM comite WHERE nom_comite=''',gamedata.comite,''') AND chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt=''',gamedata.chpt,''') AND matchs.saison_id = (SELECT id_saison FROM saison WHERE annee=',season,')))),']);
    sqlEcartCinq = sprintf([sqlEcartCinq,'(SELECT id_joueurs FROM joueurs WHERE licence=''',infosJoueurs.visiteur.numLicence{index(1)},''' AND nom_joueur=''',infosJoueurs.visiteur.nom{index(1)},'''),']);
    sqlEcartCinq = sprintf([sqlEcartCinq,'(SELECT id_joueurs FROM joueurs WHERE licence=''',infosJoueurs.visiteur.numLicence{index(2)},''' AND nom_joueur=''',infosJoueurs.visiteur.nom{index(2)},'''),']);
    sqlEcartCinq = sprintf([sqlEcartCinq,'(SELECT id_joueurs FROM joueurs WHERE licence=''',infosJoueurs.visiteur.numLicence{index(3)},''' AND nom_joueur=''',infosJoueurs.visiteur.nom{index(3)},'''),']);
    sqlEcartCinq = sprintf([sqlEcartCinq,'(SELECT id_joueurs FROM joueurs WHERE licence=''',infosJoueurs.visiteur.numLicence{index(4)},''' AND nom_joueur=''',infosJoueurs.visiteur.nom{index(4)},'''),']);
    sqlEcartCinq = sprintf([sqlEcartCinq,'(SELECT id_joueurs FROM joueurs WHERE licence=''',infosJoueurs.visiteur.numLicence{index(5)},''' AND nom_joueur=''',infosJoueurs.visiteur.nom{index(5)},'''),']);
    sqlEcartCinq = sprintf([sqlEcartCinq,tdj,',',num2str(ecartVisit.(nomCinq).ptsmarqtotal),',',num2str(ecartVisit.(nomCinq).ptsenctotal),');']);
    sqlEcartCinq = sprintf([sqlEcartCinq,'\n']);
end
fid = fopen('sqlecart.sql','A');
    fprintf(fid,'%s\n',sqlEcartCinq);
    fclose(fid);
    
end



