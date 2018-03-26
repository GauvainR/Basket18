function [lfmanque] = computeLFManque(histotextcell)

%d�tecte toutes les lignes avec Lancer franc manqu�
linenum = find(~cellfun(@isempty,strfind(histotextcell,'Lancer franc manqu�')));

if isempty(linenum) == 0
    % pre allocation de la matrice lfmanque
%     lfmanque = zeros(1,length(linenum));
    for i = 1 : length(linenum)
        %check si la ligne d'avant est evenement annul� ou la ligne d'apres
        %est remplac� par. Si c'est le cas il ne faut pas le prenmdre en compte
        if isempty(strfind(histotextcell{linenum(i)-1},'Ev�nement annul�')) == 1  && isempty(strfind(histotextcell{linenum(i)+1},'Remplac� par')) == 1 
            lfmanque(i) = regexp(histotextcell{linenum(i)}, '[AB]\d+', 'match');
        end
    end
end

%On supprime les cellules vides qu'il peut y avoir dans lfmanque(si il y a
%des Evenements annul�s
 lfmanque = lfmanque(~cellfun('isempty',lfmanque));

end