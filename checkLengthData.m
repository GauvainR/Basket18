function [data_fdm,fdmtextcell] = checkLengthData(data_fdm,data_recap,fdmtextcell)

% cette fonction est compilé seulement si la longeur de data_fdm est
% differente de data_recap. C'est souvent du a un probleme d'un numero de
% licence dans la feuille de marque (numero inexistant ou manque un
% chiffre). On remplace alors le numero erroné par VT000000 et on re
% extrait les données de la fdm

% !!!!!!!!!!!! ATTENTION !!!!!!!!!!!!!!!!!!!!!!!!!!!
% je ne sais pas comment ca réagit si il y a plusieurs problemes sur le
% meme match

nbBoucle = 0;
% on effectue le test tant que les deux ne sont pas egaux ou que la boucle
% a tourné moins de 20 fois
while length(data_fdm) ~= length(data_recap) && nbBoucle < 20
    for i = 1 : length(data_fdm)
        % on cherche quand est ce que le numero du joueur ne correspond pas sur
        % chaque ligne
        if strcmp(data_recap(i).num , data_fdm(i).num) == 0 
    %% on cherche la ligne a laquelle il y a un probleme de licence
            strToSearch = [data_fdm(i-1).licence,' ',data_fdm(i-1).nom,' ',data_fdm(i-1).num];
            for k = 1 : length(fdmtextcell)
                % on cherche dans la fdm la ligne ou il y a le nom du joueur
                % avant le joueur qui n'est pas présent dans data_fdm
                if isempty(strfind(fdmtextcell{k},strToSearch)) == 0
                    % si on trouve la ligne, on note le numero de la ligne et
                    % on sort de la boucle for qui passe tout le fdmtextcell
                    if strcmp(fdmtextcell{k+1},'JAS') % si la ligne apres contient que JAS alors il fautr ajouter deux lignes pour tomber sur la bonne ligne a changer
                        ligneAChanger = k + 2;
                    else
                        ligneAChanger = k + 1;
                    end
                    break 
                end
            end
            break % on sort de la boucle for qui cherche ou est le probleme dans data_fdm et data_recap pour eviter les doublons
        end
    end
    
 %% on modifie la partie avant le nom pour la changer par VT000000
         % on note le nom du joueur manquant
        joueurManquant = strsplit(data_recap(i).nom,' ');
        nomJoueurManquant = joueurManquant{1};
        %si le nom ne contient qu'une lettre (ex: M Bodji) alors on prend
        %les deux premieres cellules
        if length(joueurManquant{1}) == 1
            nomJoueurManquant = [joueurManquant{1},' ',joueurManquant{2}];
        end
         % on cherche a quel indice commence le nom du joueur
         indiceNom = strfind(fdmtextcell{ligneAChanger}, nomJoueurManquant);
         % modification de la ligne
         str = fdmtextcell{ligneAChanger};
         if indiceNom == 1 % si il n'y a rien avant le nom du joueur
            fdmtextcell{ligneAChanger} = ['VT000000 ',fdmtextcell{ligneAChanger}];
         else % s'il y a qqc avant le noim du joueur on le remplace par VT000000
            fdmtextcell{ligneAChanger} = strrep(str,str(1:indiceNom-2),'VT000000');
         end
             
        %%
        % on ecrit a nouveau le fdm.txt
        textcell2txt('fdm.txt',fdmtextcell);

        % on re extrait les donnees de la fdm
        [data_fdm] = extractDataFdm;
        
        nbBoucle = nbBoucle + 1;
end


if length(data_recap) ~= length(data_fdm)
    disp('*********************************************************')
    disp(['Pour le match ',filename])
    input('La longueur de data_recap n''est pas la meme que data_fdm')
end

end