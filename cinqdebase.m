function [cinqdomicile,cinqvisiteur] = cinqdebase(gamedata)
% open file to read
% fid = fopen( 'histo.txt', 'r' );

histocinq = textread('histo.txt','%s','delimiter','\n');

cinqdomicile = [];
cinqvisiteur = [];


if isequal(gamedata.chpt(1:2),'U9') || isequal(gamedata.chpt(1:3) ,'U11')
    for nbline = 1 : length(histocinq)
        if length(cinqdomicile) < 4 || length(cinqvisiteur) < 4
            if isempty(strfind(histocinq{nbline},'est entré sur le terrain de jeu')) == 0 %check if est entré sur le terrain de jeu is written on the line
                if isempty(strfind(histocinq{nbline-1},'Evénement annulé')) == 1 && isempty(strfind(histocinq{nbline+1},'Remplacé par')) == 1 %check if in the line before there is evenement annulé           
                    player = regexp(histocinq{nbline}, '[AB]\d+', 'match');
                    
                    if player{1}(1) == 'A'
                        index = length(cinqdomicile) + 1;
                        cinqdomicile{index,1} = player{1,1};               
                    elseif player{1}(1) == 'B'
                        index = length(cinqvisiteur) + 1;
                        cinqvisiteur{index,1} = player{1,1};  
                    end
                end
            end
        end
    end
    
else
    for nbline = 1 : length(histocinq)
        if length(cinqdomicile) < 5 || length(cinqvisiteur) < 5
            if isempty(strfind(histocinq{nbline},'est entré sur le terrain de jeu')) == 0 %check if est entré sur le terrain de jeu is written on the line
                if isempty(strfind(histocinq{nbline-1},'Evénement annulé')) == 1 && isempty(strfind(histocinq{nbline+1},'Remplacé par')) == 1 %check if in the line before there is evenement annulé
                    player = regexp(histocinq{nbline}, '[AB]\d+', 'match');
            
                    if player{1}(1) == 'A'
                        index = length(cinqdomicile) + 1;
                        cinqdomicile{index,1} = player{1,1};               
                    elseif player{1}(1) == 'B'
                        index = length(cinqvisiteur) + 1;
                        cinqvisiteur{index,1} = player{1,1};  
                    end
                end
            end
        end
        
        if isempty(strfind(histocinq{nbline},'est sorti du terrain de jeu')) == 0 && isempty(strfind(histocinq{nbline},'Avant match')) == 0
            player = regexp(histocinq{nbline}, '[AB]\d+', 'match');
            
            if player{1}(1) == 'A'
                index = find(strcmp(cinqdomicile, player));
                cinqdomicile(index) = [];               
            elseif player{1}(1) == 'B'
                index = find(strcmp(cinqdomicile, player));
                cinqvisiteur(index) = [];  
            end
        end
                    
    end
    
end %fin du if
end

