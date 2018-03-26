 function [gamedata] = numeroEquipe(gamedata,fdmtextcell)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%   Cette fonction sert à déterminer les numéros informatique des clubs.  %
%   Permet ensuite de déterminer si une équipe existe déja.               %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% equipe domicile
% recherche des indices ou il y a le nom de l'equipe
   index = [];
   ii = 1;
   for ligne = 1: length(fdmtextcell)
       if strcmp(fdmtextcell{ligne,1},gamedata.domicile)
            index(ii) = ligne;
            ii = ii+1;
       end
   end
   
   numeroSplit = regexp(fdmtextcell{index(1)+2},'\s','split');
   numeroDom = '';
   for i = 1 : length(numeroSplit)
       if length(numeroSplit{i}) == 1
           numeroDom = [numeroDom,numeroSplit{i}];
       end
   end
   if isempty(numeroDom)
       numeroDom = '0000000';
   end
   gamedata.numeroDom = numeroDom;
%    numeroDom = regexp(fdmtextcell{index(1)+2},'^(?<num>[\d\s]+)','names','lineanchors');
%    gamedata.numeroDom = strrep(numeroDom.num,' ','');
   
   
%% équipe visiteur

% recherche des indices ou il y a le nom de l'equipe
   index = [];
   ii = 1;
   for ligne = 1: length(fdmtextcell)
       if strcmp(fdmtextcell{ligne,1},gamedata.visiteur)
            index(ii) = ligne;
            ii = ii+1;
       end
   end
   
   numeroSplit = regexp(fdmtextcell{index(1)+2},'\s','split');
   numeroVisit = '';
   for i = 1 : length(numeroSplit)
       if length(numeroSplit{i}) == 1
           numeroVisit = [numeroVisit,numeroSplit{i}];
       end
   end
   
   if isempty(numeroVisit)
       numeroVisit = '0000000';
   end
   gamedata.numeroVisit = numeroVisit;
%    numeroVisit = regexp(fdmtextcell{index(1)+2},'^(?<num>[\d\s]+)','names','lineanchors');
%    gamedata.numeroVisit = strrep(numeroVisit.num,' ','');
   
end