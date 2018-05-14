function [gamedata] = modifNomsEquipes(gamedata)
%% domicile
gamedata.domicilewithspace = strrep(gamedata.domicile,'IE - ','');
gamedata.domicilewithspace = strrep(gamedata.domicilewithspace,'''',' ');
gamedata.domicilewithspace = strrep(gamedata.domicilewithspace,'EN - ','');
gamedata.domicilewithspace = strrep(gamedata.domicilewithspace,'Ent. ','');
gamedata.domicilewithspace = strrep(gamedata.domicilewithspace,'E. ','');
gamedata.domicilewithspace = strrep(gamedata.domicilewithspace,'-',' ');
gamedata.domicilewithspace = strrep(gamedata.domicilewithspace,'/',' ');
gamedata.domicilewithspace = strrep(gamedata.domicilewithspace,'Ç','C');
gamedata.domicilewithspace = strrep(gamedata.domicilewithspace,'.','');

%supprime l'espace a la fin du nom de l'equipe
while strcmp(gamedata.domicilewithspace(end),' ')
    gamedata.domicilewithspace = gamedata.domicilewithspace(1:end-1);
end
    
    
gamedata.domicilewithspace = strrep(gamedata.domicilewithspace,'BASKET CLUBS','BC');
gamedata.domicilewithspace = strrep(gamedata.domicilewithspace,'BASKET CLUB','BC');
gamedata.domicilewithspace = strrep(gamedata.domicilewithspace,'SOCIETE SPORTIVE','SS');
gamedata.domicilewithspace = strrep(gamedata.domicilewithspace,'ASSOCIATION SPORTIVE','AS');
gamedata.domicilewithspace = strrep(gamedata.domicilewithspace,'BASKET BALL','BB');
gamedata.domicilewithspace = strrep(gamedata.domicilewithspace,'ATHLETIQUE CLUB','AC');
gamedata.domicilewithspace = strrep(gamedata.domicilewithspace,'UNION SPORTIVE','US');
gamedata.domicilewithspace = strrep(gamedata.domicilewithspace,'SAINT ','ST ');
gamedata.domicilewithspace = strrep(gamedata.domicilewithspace,'SAINTE','STE');
gamedata.domicilewithspace = strrep(gamedata.domicilewithspace,'ATHLETIC CLUB','AC');
gamedata.domicilewithspace = strrep(gamedata.domicilewithspace,'AMICALE LAIQUE','AL');
gamedata.domicilewithspace = strrep(gamedata.domicilewithspace,' ESPOIR','');


claim = gamedata.domicilewithspace;
gamedata.domicilewithoutspace = strrep(claim, ' ', '_');
gamedata.domicilewithoutspace = strrep(gamedata.domicilewithoutspace, '___', '_');
gamedata.domicilewithoutspace = strrep(gamedata.domicilewithoutspace, '__', '_');
gamedata.domicilewithoutspace = strrep(gamedata.domicilewithoutspace, '(', '');
gamedata.domicilewithoutspace = strrep(gamedata.domicilewithoutspace, ')', '');
gamedata.domicilewithoutspace = strrep(gamedata.domicilewithoutspace,'.','');
gamedata.domicilewithunderscore = gamedata.domicilewithoutspace;

claim = strrep(gamedata.domicilewithunderscore,'.','');

if isempty(regexp(claim,'[A-Z_0-9]+_\d') ) == 0 % si le nom d'equipe finit par _+digit alors on enleve les deux derniers caracteres car ca doit etre le numero de l'equipe
    claim = claim(1:end-2);
%     claim = strrep(claim,'1','');
%     claim = strrep(claim,'2','');
%     claim = strrep(claim,'3','');
%     claim = strrep(claim,'4','');
%     claim = strrep(claim,'5','');
%     claim = strrep(claim,'6','');
%     claim = strrep(claim,'7','');
end
gamedata.clubdom = strrep(claim,'-',''); 
%remove the underscore of the end. ex: ABC_LTB_1 -> ABC_LTB_. Problem for
%club classification
while gamedata.clubdom(end) == '_'
   gamedata.clubdom(end) = '';
end

%% visteur
%Delete figures and space of the name of the team to obtain name of the
%club
gamedata.visiteurwithspace = strrep(gamedata.visiteur,'IE - ','');
gamedata.visiteurwithspace = strrep(gamedata.visiteurwithspace,'''',' ');
gamedata.visiteurwithspace = strrep(gamedata.visiteurwithspace,'EN - ','');
gamedata.visiteurwithspace = strrep(gamedata.visiteurwithspace,'Ent. ','');
gamedata.visiteurwithspace = strrep(gamedata.visiteurwithspace,'E. ','');
gamedata.visiteurwithspace = strrep(gamedata.visiteurwithspace,'-',' ');
gamedata.visiteurwithspace = strrep(gamedata.visiteurwithspace,'/',' ');
gamedata.visiteurwithspace = strrep(gamedata.visiteurwithspace,'Ç','C');
gamedata.visiteurwithspace = strrep(gamedata.visiteurwithspace,'.','');

gamedata.visiteurwithspace = strrep(gamedata.visiteurwithspace,'BASKET CLUBS','BC');
gamedata.visiteurwithspace = strrep(gamedata.visiteurwithspace,'BASKET CLUB','BC');
gamedata.visiteurwithspace = strrep(gamedata.visiteurwithspace,'SOCIETE SPORTIVE','SS');
gamedata.visiteurwithspace = strrep(gamedata.visiteurwithspace,'ASSOCIATION SPORTIVE','AS');
gamedata.visiteurwithspace = strrep(gamedata.visiteurwithspace,'BASKET BALL','BB');
gamedata.visiteurwithspace = strrep(gamedata.visiteurwithspace,'ATHLETIQUE CLUB','AC');
gamedata.visiteurwithspace = strrep(gamedata.visiteurwithspace,'UNION SPORTIVE','US');
gamedata.visiteurwithspace = strrep(gamedata.visiteurwithspace,'SAINT ','ST ');
gamedata.visiteurwithspace = strrep(gamedata.visiteurwithspace,'SAINTE','STE');
gamedata.visiteurwithspace = strrep(gamedata.visiteurwithspace,'ATHLETIC CLUB','AC');
gamedata.visiteurwithspace = strrep(gamedata.visiteurwithspace,'AMICALE LAIQUE','AL');
gamedata.visiteurwithspace = strrep(gamedata.visiteurwithspace,' ESPOIR','');

%supprime l'espace a la fin du nom de l'equipe
while strcmp(gamedata.visiteurwithspace(end),' ')
    gamedata.visiteurwithspace = gamedata.visiteurwithspace(1:end-1);
end

claim = gamedata.visiteurwithspace;
gamedata.visiteurwithoutspace = strrep(claim, ' ', '_');
gamedata.visiteurwithoutspace = strrep(gamedata.visiteurwithoutspace, '___', '_');
gamedata.visiteurwithoutspace = strrep(gamedata.visiteurwithoutspace, '__', '_');
gamedata.visiteurwithoutspace = strrep(gamedata.visiteurwithoutspace, '(', '');
gamedata.visiteurwithoutspace = strrep(gamedata.visiteurwithoutspace, ')', '');
gamedata.visiteurwithoutspace = strrep(gamedata.visiteurwithoutspace,'.','');
gamedata.visiteurwithunderscore = gamedata.visiteurwithoutspace;
gamedata.visiteurwithoutspace = strrep(gamedata.visiteurwithoutspace,'IE-','');
gamedata.visiteurwithoutspace = strrep(gamedata.visiteurwithoutspace,'EN-','');
claim = strrep(gamedata.visiteurwithunderscore,'.','');
if isempty(regexp(claim,'[A-Z_0-9]+_\d') ) == 0 % si le nom d'equipe finit par _+digit alors on enleve les deux derniers caracteres car ca doit etre le numero de l'equipe
    claim = claim(1:end-2);
%     claim = strrep(claim,'1','');
%     claim = strrep(claim,'2','');
%     claim = strrep(claim,'3','');
%     claim = strrep(claim,'4','');
%     claim = strrep(claim,'5','');
%     claim = strrep(claim,'6','');
%     claim = strrep(claim,'7','');
end
gamedata.clubvisit = strrep(claim,'-','');

%remove the underscore of the end. ex: ABC_LTB_1 -> ABC_LTB_. Problem for
%club classification
while gamedata.clubvisit(end) == '_'
   gamedata.clubvisit(end) = '';
end

end