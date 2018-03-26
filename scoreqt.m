function [data_qt,data_mt,prolongations] = scoreqt(data_arbitre,data_fdm_visiteur,fdmtextcell)

% check s'il il y a écrit heure de fin de rencontre dans la feuille de
% marque
heureFinRencontre = find(~cellfun(@isempty,strfind(fdmtextcell,'Heure de fin de rencontre')));

if isempty(heureFinRencontre) == 1 % si Heure de fin de rencontre pas présent (ancienne feuille)

    % find line where the first license of visiteur is written. Because score at
    % quart-temps are written lines before
    
    % on cherche le numero de licence sans les deux premiere lettre pour
    % éviter confusions avec BC, VT etc. et le nom du joueur
    textToSearch = [data_fdm_visiteur(1).licence(3:end),' ',data_fdm_visiteur(1).nom];
    linenum = find(~cellfun(@isempty,strfind(fdmtextcell,textToSearch)));
    if length(linenum) > 1 % si le 1er joueur est aussi le coach
        linenum = linenum(1);
    end

    if isempty(linenum) == 1 % si la premiere licence est VT000000 on cherche la deuxieme licence visiteur
        textToSearch = [data_fdm_visiteur(2).licence(3:end),' ',data_fdm_visiteur(2).nom];
        linenum = find(~cellfun(@isempty,strfind(fdmtextcell, textToSearch))) - 1;
    end

    if isempty(linenum) == 1 % si deux premieres licences sont VT000000 alors on cherche 1er nom visiteur (probleme si qqn a le meme nom dans l'equipe domicile)
        linenum = find(~cellfun(@isempty,strfind(fdmtextcell,data_fdm_visiteur(1).nom)));
    end
    
    % on le remet la car si le premier joueur a une licence BC il ne sera
    % pas détecté et on cherchera donc avec le nom du joueur. Mais si le
    % joueur est aussi le coach ou bien si il a pris une technique, il
    % apparait dans la suite de la fdm. Il y aura donc deux linenum. On
    % prend la premiere.
    % !!!!! PROBLEME !!!! si un joueur dom a le meme nom. 
    % Pourra etre supprimé si on met la détection du 1er joueur dom avec
    % num de licence sans les deux premieres lettres
    if length(linenum) > 1
        linenum = linenum(1);
    end

    if fdmtextcell{linenum(1)-1}(1) == 'C' %check if line before is CLE OK
        %if it is CLE OK do this
        if isempty(strfind(fdmtextcell{linenum(1)-2},' ')) == 0 % check if prolongations, if not then do this:
            prolongations = 0;
            data_qt(1).domicile = fdmtextcell{linenum-5};
            data_qt(2).domicile = fdmtextcell{linenum-3};
            data_qt(3).domicile = fdmtextcell{linenum-4};

            %separation of score of qt4 and final
            scoredom = strsplit(fdmtextcell{linenum-2},' ');
            data_qt(4).domicile = scoredom{1,1};

            data_mt(1).domicile = num2str(str2double(data_qt(1).domicile) + str2double(data_qt(2).domicile));
            data_mt(2).domicile = num2str(str2double(data_mt(1).domicile) + str2double(data_qt(3).domicile) + str2double(data_qt(4).domicile));
        else % if there is a prolonbgation then do this:
            prolongations = 1;
            data_qt(1).domicile = fdmtextcell{linenum-7};
            data_qt(2).domicile = fdmtextcell{linenum-5};
            data_qt(3).domicile = fdmtextcell{linenum-6};
            data_qt(4).domicile = fdmtextcell{linenum-4};
            data_qt(5).domicile = fdmtextcell{linenum-3}; %prolong

            data_mt(2).domicile = fdmtextcell{linenum-2}; %score final
            data_mt(1).domicile = num2str(str2double(data_qt(1).domicile) + str2double(data_qt(2).domicile));
        end

    else % not CLE OK
        if isempty(strfind(fdmtextcell{linenum(1)-1},' ')) == 0 % check if prolongations, if not then do this:
            prolongations = 0;
            data_qt(1).domicile = fdmtextcell{linenum-4};
            data_qt(2).domicile = fdmtextcell{linenum-2};
            data_qt(3).domicile = fdmtextcell{linenum-3};

            %separation of score of qt4 and final
            scoredom = strsplit(fdmtextcell{linenum-1},' ');
            data_qt(4).domicile = scoredom{1,1};

            data_mt(1).domicile = num2str(str2double(data_qt(1).domicile) + str2double(data_qt(2).domicile));
            data_mt(2).domicile = num2str(str2double(data_mt(1).domicile) + str2double(data_qt(3).domicile) + str2double(data_qt(4).domicile));
        else % if there is a prolonbgation then do this:
            prolongations = 1;
            data_qt(1).domicile = fdmtextcell{linenum-6};
            data_qt(2).domicile = fdmtextcell{linenum-4};
            data_qt(3).domicile = fdmtextcell{linenum-5};
            data_qt(4).domicile = fdmtextcell{linenum-3};
            data_qt(5).domicile = fdmtextcell{linenum-2}; %prolong

            data_mt(2).domicile = fdmtextcell{linenum-1}; %score final
            data_mt(1).domicile = num2str(str2double(data_qt(1).domicile) + str2double(data_qt(2).domicile));
        end
    end



    %separation of name of referees
    referee = strsplit(data_arbitre.nom,'.');
    %remove empty cell ( the last one). If 2 referees I get 3 cells.
    referee = referee(~cellfun(@isempty,referee));
    data.un = [referee{1,1},'.'];

    %only if there are two referees
    if length(referee) > 1
    %remove whitespace at the first position of the name    
        referee{1,2}(1)=[];
    data.deux = [referee{1,2},'.'];

    %find line where the name of the referee is written because score qt are
    %before
    linenum = find(~cellfun(@isempty,strfind(fdmtextcell,referee{1,2})));

    elseif length(referee) == 1    
    %find line where the name of the referee is written because score qt are
    %before if there is only one referee
    linenum = find(~cellfun(@isempty,strfind(fdmtextcell,referee{1,1})));
    % linenum = find(~cellfun(@isempty,strfind(fdmtextcell,data.un))); 
    end

    %check if line before is CLE OK
    if fdmtextcell{linenum(1)-1}(1) == 'C' %pb car pas points apres arbitres
        if prolongations == 0
            data_qt(1).visiteur = fdmtextcell{linenum-5};
            data_qt(2).visiteur = fdmtextcell{linenum-3};
            data_qt(3).visiteur = fdmtextcell{linenum-6};
            data_qt(4).visiteur = fdmtextcell{linenum-4};
            data_mt(1).visiteur = num2str(str2double(data_qt(1).visiteur) + str2double(data_qt(2).visiteur));
            data_mt(2).visiteur = fdmtextcell{linenum-2};

        else % if there is a prolongation
            data_qt(1).visiteur = fdmtextcell{linenum-6};
            data_qt(2).visiteur = fdmtextcell{linenum-4};
            data_qt(3).visiteur = fdmtextcell{linenum-7};
            data_qt(4).visiteur = fdmtextcell{linenum-5};
            data_qt(5).visiteur = fdmtextcell{linenum-3};
            data_mt(1).visiteur = num2str(str2double(data_qt(1).visiteur) + str2double(data_qt(2).visiteur));
            data_mt(2).visiteur = fdmtextcell{linenum-2};
        end

    else
        if prolongations == 0
            data_qt(1).visiteur = fdmtextcell{linenum-4};
            data_qt(2).visiteur = fdmtextcell{linenum-2};
            data_qt(3).visiteur = fdmtextcell{linenum-5};
            data_qt(4).visiteur = fdmtextcell{linenum-3};
            data_mt(1).visiteur = num2str(str2double(data_qt(1).visiteur) + str2double(data_qt(2).visiteur));
            data_mt(2).visiteur = fdmtextcell{linenum-1};

        else % if there is a prolongation
            data_qt(1).visiteur = fdmtextcell{linenum-5};
            data_qt(2).visiteur = fdmtextcell{linenum-3};
            data_qt(3).visiteur = fdmtextcell{linenum-6};
            data_qt(4).visiteur = fdmtextcell{linenum-4};
            data_qt(5).visiteur = fdmtextcell{linenum-2};
            data_mt(1).visiteur = num2str(str2double(data_qt(1).visiteur) + str2double(data_qt(2).visiteur));
            data_mt(2).visiteur = fdmtextcell{linenum-1};
        end
    end
    
elseif isempty(heureFinRencontre) == 0 % si Heure de fin de rencontre présent (nouvelle feuille)
    
    %separation of name of referees
    referee = strsplit(data_arbitre.nom,'.');
    %remove empty cell ( the last one). If 2 referees I get 3 cells.
    referee = referee(~cellfun(@isempty,referee));
    data.un = [referee{1,1},'.'];

    %only if there are two referees
    if length(referee) > 1
        %remove whitespace at the first position of the name    
        referee{1,2}(1)=[];
        data.deux = [referee{1,2},'.'];

        %find line where the name of the referee is written because score qt are
        %before
        linenum = find(~cellfun(@isempty,strfind(fdmtextcell,referee{1,2})));

        elseif length(referee) == 1    
        %find line where the name of the referee is written because score qt are
        %before if there is only one referee
        linenum = find(~cellfun(@isempty,strfind(fdmtextcell,referee{1,1}))); 
    end

    if fdmtextcell{linenum(1)-1}(1) == 'C' %check if line before is CLE OK
        if isempty(strfind(fdmtextcell{linenum(1)-1},' ')) == 1
            prolongations = 1;
            data_qt(1).visiteur = fdmtextcell{linenum-6};
            data_qt(2).visiteur = fdmtextcell{linenum-4};
            data_qt(3).visiteur = fdmtextcell{linenum-7};
            data_qt(4).visiteur = fdmtextcell{linenum-5};
            data_mt(1).visiteur = num2str(str2double(data_qt(1).visiteur) + str2double(data_qt(2).visiteur));
            data_mt(2).visiteur = fdmtextcell{linenum-2};
        else
            prolongations = 0;
            data_qt(1).visiteur = fdmtextcell{linenum-4};
            data_qt(3).visiteur = fdmtextcell{linenum-5};
            data_qt(4).visiteur = fdmtextcell{linenum-3};
            
            scorevisit = strsplit(fdmtextcell{linenum(1)-2},' ');
            data_qt(2).visiteur = scorevisit{1,1};
          
            
            data_mt(1).visiteur = num2str(str2double(data_qt(1).visiteur) + str2double(data_qt(2).visiteur));
            data_mt(2).visiteur = num2str(str2double(data_mt(1).visiteur) + str2double(data_qt(3).visiteur) + str2double(data_qt(4).visiteur) );
            
        end
            
    else 
        if isempty(strfind(fdmtextcell{linenum(1)-1},' ')) == 1 %prolong
            prolongations = 1;
            data_qt(1).visiteur = fdmtextcell{linenum-5};
            data_qt(2).visiteur = fdmtextcell{linenum-3};
            data_qt(3).visiteur = fdmtextcell{linenum-6};
            data_qt(4).visiteur = fdmtextcell{linenum-4};
            data_qt(5).visiteur = fdmtextcell{linenum-2};
            
            data_mt(1).visiteur = num2str(str2double(data_qt(1).visiteur) + str2double(data_qt(2).visiteur));
            data_mt(2).visiteur = num2str(str2double(data_mt(1).visiteur) + str2double(data_qt(3).visiteur) + str2double(data_qt(4).visiteur) + str2double(data_qt(5).visiteur));

            
        else
            prolongations = 0;
            data_qt(1).visiteur = fdmtextcell{linenum-3};
            data_qt(3).visiteur = fdmtextcell{linenum-4};
            data_qt(4).visiteur = fdmtextcell{linenum-2};
            
            scorevisit = strsplit(fdmtextcell{linenum(1)-1},' ');
            data_qt(2).visiteur = scorevisit{1,1};
          
            
            data_mt(1).visiteur = num2str(str2double(data_qt(1).visiteur) + str2double(data_qt(2).visiteur));
            data_mt(2).visiteur = num2str(str2double(data_mt(1).visiteur) + str2double(data_qt(3).visiteur) + str2double(data_qt(4).visiteur) );
        end
    end
    
    
    
    % Partie pour domicile
    
    %find line where the first license of visiteur is written. Because score at
    %quart-temps are written lines before
    
    % on cherche le numero de licence sans les deux premiere lettre pour
    % éviter confusions avec BC, VT etc. et le nom du joueur
    textToSearch = [data_fdm_visiteur(1).licence(3:end),' ',data_fdm_visiteur(1).nom];
    linenum = find(~cellfun(@isempty,strfind(fdmtextcell,textToSearch)));
    
    if isempty(linenum) == 1 % si la premiere licence est VT000000 on cherche la deuxieme licence visiteur
        textToSearch = [data_fdm_visiteur(2).licence(3:end),' ',data_fdm_visiteur(2).nom];
        linenum = find(~cellfun(@isempty,strfind(fdmtextcell, textToSearch))) - 1;
    end
    
    if isempty(linenum) == 1 % si deux premieres licences sont VT000000 alors on cherche 1er nom visiteur (probleme si qqn a le meme nom dans l'equipe domicile)
        linenum = find(~cellfun(@isempty,strfind(fdmtextcell,data_fdm_visiteur(1).nom)));
    end
    % on vérifie si la ligne avant est un chiffre. Si c'est pas, deux
    % joueurs ont la meme licence et on est sur le mauvais
    if isnan(str2double(fdmtextcell{linenum(1)-1})) == 0 % pb: nom du joueur detecté en tant que 1er visiteur
        linenum = linenum(1);
    elseif isnan(str2double(fdmtextcell{linenum(2)-1})) == 0 % pb: nom du joueur detecté en tant que 1er visiteur
        linenum = linenum(2);
    elseif isnan(str2double(fdmtextcell{linenum(3)-1})) == 0 % pb: nom du joueur detecté en tant que 1er visiteur
        linenum = linenum(3);
    end

    
    

    if fdmtextcell{linenum(1)-1}(1) == 'C' %check if line before is CLE OK
        %if it is CLE OK do this
        if prolongations == 0 % check if prolongations, if not then do this:
            
            data_qt(1).domicile = fdmtextcell{linenum-6};
            data_qt(2).domicile = fdmtextcell{linenum-4};
            data_qt(3).domicile = fdmtextcell{linenum-5};
            data_qt(4).domicile = fdmtextcell{linenum-3};

            data_mt(1).domicile = num2str(str2double(data_qt(1).domicile) + str2double(data_qt(2).domicile));
            data_mt(2).domicile = num2str(str2double(data_mt(1).domicile) + str2double(data_qt(3).domicile) + str2double(data_qt(4).domicile));
        else % if there is a prolonbgation then do this:
            
%             data_qt(1).domicile = fdmtextcell{linenum-7};
%             data_qt(2).domicile = fdmtextcell{linenum-5};
%             data_qt(3).domicile = fdmtextcell{linenum-6};
%             data_qt(4).domicile = fdmtextcell{linenum-4};
%             data_qt(5).domicile = fdmtextcell{linenum-3}; %prolong
% 
%             data_mt(2).domicile = fdmtextcell{linenum-2}; %score final
%             data_mt(1).domicile = num2str(str2double(data_qt(1).domicile) + str2double(data_qt(2).domicile));
        end

    else % not CLE OK
        if prolongations == 0
            data_qt(1).domicile = fdmtextcell{linenum-5};
            data_qt(2).domicile = fdmtextcell{linenum-3};
            data_qt(3).domicile = fdmtextcell{linenum-4};
            data_qt(4).domicile = fdmtextcell{linenum-2};
            %separation of score of qt4 and final
            
            data_mt(1).domicile = num2str(str2double(data_qt(1).domicile) + str2double(data_qt(2).domicile));
            data_mt(2).domicile = num2str(str2double(data_mt(1).domicile) + str2double(data_qt(3).domicile) + str2double(data_qt(4).domicile));
         else % if there is a prolongation then do this:

            data_qt(1).domicile = fdmtextcell{linenum-6};
            data_qt(2).domicile = fdmtextcell{linenum-4};
            data_qt(3).domicile = fdmtextcell{linenum-5};
            data_qt(4).domicile = fdmtextcell{linenum-3};
            data_qt(5).domicile = fdmtextcell{linenum-2}; %prolong

            data_mt(1).domicile = num2str(str2double(data_qt(1).domicile) + str2double(data_qt(2).domicile));
            data_mt(2).domicile = num2str(str2double(data_mt(1).domicile) + str2double(data_qt(3).domicile) + str2double(data_qt(4).domicile) + str2double(data_qt(5).domicile)); %score final
        end
    end
    
end

% Verification si il n'y a pas d'espace dans les scores. S'il y en a un
% c'est qu'il y a un probleme et ca entrainera un probleme a l'insertion en
% base de donnees
if contains(data_qt(1).domicile,' ') || contains(data_qt(2).domicile,' ') || contains(data_qt(3).domicile,' ') || contains(data_qt(4).domicile,' ') || contains(data_qt(1).visiteur,' ') || contains(data_qt(2).visiteur,' ') || contains(data_qt(3).visiteur,' ') || contains(data_qt(4).visiteur,' ')
    disp(' ')
    disp('***************************************************************')
    disp('Probleme: il y a un espace dans les scores par quart-temps')
    input('!!! Arreter le programme (Ctrl+C) !!!')
end

if contains(data_mt(1).domicile, ' ') || contains(data_mt(2).domicile, ' ') || contains(data_mt(1).visiteur, ' ') || contains(data_mt(2).visiteur, ' ')
   disp(' ')
   disp('***************************************************************')
   disp('Probleme: il y a un espace dans les scores par mi-temps')
   disp('Ca peut etre du a des caracteres erronnés dans fdm.txt au-dessus des joueurs domicile')
   input('!!! Arreter le programme (Ctrl+C) !!!')
end

end