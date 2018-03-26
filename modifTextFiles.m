function [fdmtextcell,recaptextcell,histotextcell] = modifTextFiles(fdmtextcell,recaptextcell,histotextcell)
%% recaptextcell
for ii = 26 : -1 : 1 % on supprime les 26 premieres lignes qui sont inutiles
    recaptextcell(ii) = [];
end

% On remplace les � de tous les fichiers pour �viter probl�mes
    recaptextcell = regexprep(recaptextcell,'�','E');
    recaptextcell = regexprep(recaptextcell,'''',' ');
    recaptextcell = regexprep(recaptextcell,'�','');
    
%% histotextcell    
    histotextcell = regexprep(histotextcell,'�','E');
    histotextcell = regexprep(histotextcell,'�','');

%% fdmtextcell    
for ii = 290 : -1 : 1 % on supprime les lignes de 300 � 1 qui sont inutiles pour la suite
    fdmtextcell(ii) = [];
end

fdmtextcell = regexprep(fdmtextcell,'�','E');
fdmtextcell = regexprep(fdmtextcell,'''',' ');
fdmtextcell(strcmp(fdmtextcell(:), 'CLE OK'), :) = [];
fdmtextcell = regexprep(fdmtextcell,'�','');

%% Ecriture dans les fichiers txt
textcell2txt('recap.txt',recaptextcell);
textcell2txt('histo.txt',histotextcell);
textcell2txt('fdm.txt',fdmtextcell);

end