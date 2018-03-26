function [fdmtextcell,recaptextcell,histotextcell] = modifTextFiles(fdmtextcell,recaptextcell,histotextcell)
%% recaptextcell
for ii = 26 : -1 : 1 % on supprime les 26 premieres lignes qui sont inutiles
    recaptextcell(ii) = [];
end

% On remplace les É de tous les fichiers pour éviter problèmes
    recaptextcell = regexprep(recaptextcell,'É','E');
    recaptextcell = regexprep(recaptextcell,'''',' ');
    recaptextcell = regexprep(recaptextcell,'µ','');
    
%% histotextcell    
    histotextcell = regexprep(histotextcell,'É','E');
    histotextcell = regexprep(histotextcell,'µ','');

%% fdmtextcell    
for ii = 290 : -1 : 1 % on supprime les lignes de 300 à 1 qui sont inutiles pour la suite
    fdmtextcell(ii) = [];
end

fdmtextcell = regexprep(fdmtextcell,'É','E');
fdmtextcell = regexprep(fdmtextcell,'''',' ');
fdmtextcell(strcmp(fdmtextcell(:), 'CLE OK'), :) = [];
fdmtextcell = regexprep(fdmtextcell,'µ','');

%% Ecriture dans les fichiers txt
textcell2txt('recap.txt',recaptextcell);
textcell2txt('histo.txt',histotextcell);
textcell2txt('fdm.txt',fdmtextcell);

end