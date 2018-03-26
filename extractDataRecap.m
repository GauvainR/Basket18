function [data_recap,gamedata] = extractDataRecap(gamedata)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Extrait les données du recap et les classe dans data_recap
%       Determine si le temps de jeu est présent dans le recap
%       (gamedata.tdj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%extraction of stats from recap.txt and store into data_recap
recaptext = fileread('recap.txt');
recaptext = strrep(recaptext,'''',' ');
data_recap = regexp(recaptext, '^(?<num>\d+)\s+(?<nom>\D*?)\s+(?<min>\d+)[:](?<sec>\d+)\s+(?<pts>\d+)\s+(?<tirs>\d+)\s+(?<troispts>\d+)\s+(?<deuxext>\d+)\s+(?<deuxint>\d+)\s+(?<lf>\d+)\s+(?<ftes>\d+)','names','lineanchors');
 % Détermine si le temps de jeu a été calculé ou pas
if isempty(data_recap) == 1 %si le temps de jeu n'a pas été calculé
    gamedata.tdj = 0; %set la variable à 0 si le tps de jeu pas calculé. Variable utilisée dans computestats pour différencier les stats with and without minutes
    data_recap = regexp(recaptext, '^(?<num>\d+)\s+(?<nom>\D*?)\s+(?<pts>\d+)\s+(?<tirs>\d+)\s+(?<troispts>\d+)\s+(?<deuxext>\d+)\s+(?<deuxint>\d+)\s+(?<lf>\d+)\s+(?<ftes>\d+)','names','lineanchors');
else
    gamedata.tdj = 1; % set la variable à 1 si le tdj est calculé. Utilisé dans computestats.m
end
    
% On enleve les "." des noms des joueurs sinon erreurs
for kk = 1 : length(data_recap)
    data_recap(kk).nom = strrep(data_recap(kk).nom,'.','');
    data_recap(kk).nom = strrep(data_recap(kk).nom,'Ç','');
end

end