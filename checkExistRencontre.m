function [existRencontre] = checkExistRencontre(gamedata,stats)

numRencontre = str2double(gamedata.numrencontre);

    
doesTeamExist = true;
try
stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe;
catch
doesTeamExist = false;
end

if doesTeamExist == 1
    
   
   l = size(stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs);
   %Check if the match is already stored in the array
   for nbexist = 1 : l(2)
   checkexist(nbexist) = stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([gamedata.domicilewithoutspace]).equipe.matchs(nbexist).numrencontre;
   end
   
   existnumrencontre = find((checkexist == str2double(gamedata.numrencontre)),1);
   
   if isempty(existnumrencontre) == 1
       existRencontre = false;
   else
       existRencontre = true;
   end
   
else % si l'equipe n'existe pas alors la rencontre n'existe pas
    
    existRencontre = false;
end

end