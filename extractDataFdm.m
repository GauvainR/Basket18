function [data_fdm] = extractDataFdm



%extraction of number of license, name and num
%delete JC1 JC2 CTC and N etc before license
fdmtext = fileread('fdm.txt');
fdmtext = regexprep(fdmtext,'?','');
fdmtext = regexprep(fdmtext,'#','');
fdmtext = regexprep(fdmtext,'NREF ','');
fdmtext = regexprep(fdmtext,'SCTC ','');
fdmtext = regexprep(fdmtext,'CTC ','');
fdmtext = regexprep(fdmtext,'JC1AS ','');
fdmtext = regexprep(fdmtext,'JASHN ','');
fdmtext = regexprep(fdmtext,'SHN ','');
fdmtext = regexprep(fdmtext,'JC1A ','');
fdmtext = regexprep(fdmtext,'JC1 ','');
fdmtext = regexprep(fdmtext,'JC2 ','');
fdmtext = regexprep(fdmtext,'JT ','');
fdmtext = regexprep(fdmtext,'JAS ','');
fdmtext = regexprep(fdmtext,'JAS\nBC','');
fdmtext = regexprep(fdmtext,'N VT','VT');
fdmtext = regexprep(fdmtext,'N BC','VT'); % on change tout par VT pour éviter les doublons de joueurs
fdmtext = regexprep(fdmtext,'N OH','VT');
fdmtext = regexprep(fdmtext,'N RH','VT');
fdmtext = regexprep(fdmtext,'N JE','VT');
fdmtext = regexprep(fdmtext,'N ON','VT');
fdmtext = regexprep(fdmtext,'N RN','VT');
fdmtext = regexprep(fdmtext,'N LICENCE NON PRESENTEE','VT000000');
fdmtext = regexprep(fdmtext,'D VT','VT');
fdmtext = regexprep(fdmtext,'D BC','VT'); % on change tout par VT pour éviter les doublons de joueurs
fdmtext = regexprep(fdmtext,'D OH','VT');
fdmtext = regexprep(fdmtext,'D RH','VT');
fdmtext = regexprep(fdmtext,'D JE','VT');
fdmtext = regexprep(fdmtext,'D ON','VT');
fdmtext = regexprep(fdmtext,'D RN','VT');
fdmtext = regexprep(fdmtext,'D LICENCE NON PRESENTEE','VT000000');
fdmtext = regexprep(fdmtext,'DC VT','VT');
fdmtext = regexprep(fdmtext,'DC BC','VT'); % on change tout par VT pour éviter les doublons de joueurs
fdmtext = regexprep(fdmtext,'DC OH','VT');
fdmtext = regexprep(fdmtext,'DC RH','VT');
fdmtext = regexprep(fdmtext,'DC JE','VT');
fdmtext = regexprep(fdmtext,'DC ON','VT');
fdmtext = regexprep(fdmtext,'DC RN','VT');
fdmtext = regexprep(fdmtext,'DC LICENCE NON PRESENTEE','VT000000');
fdmtext = regexprep(fdmtext,'OC VT','VT');
fdmtext = regexprep(fdmtext,'OC BC','VT'); % on change tout par VT pour éviter les doublons de joueurs
fdmtext = regexprep(fdmtext,'OC OH','VT');
fdmtext = regexprep(fdmtext,'OC RH','VT');
fdmtext = regexprep(fdmtext,'OC JE','VT');
fdmtext = regexprep(fdmtext,'OC ON','VT');
fdmtext = regexprep(fdmtext,'OC RN','VT');
fdmtext = regexprep(fdmtext,'OC LICENCE NON PRESENTEE','VT000000');
fdmtext = regexprep(fdmtext,'TC VT','VT');
fdmtext = regexprep(fdmtext,'TC BC','VT'); % on change tout par VT pour éviter les doublons de joueurs
fdmtext = regexprep(fdmtext,'TC OH','VT');
fdmtext = regexprep(fdmtext,'TC RH','VT');
fdmtext = regexprep(fdmtext,'TC JE','VT');
fdmtext = regexprep(fdmtext,'TC ON','VT');
fdmtext = regexprep(fdmtext,'TC RN','VT');
fdmtext = regexprep(fdmtext,'TC LICENCE NON PRESENTEE','VT000000');
fdmtext = regexprep(fdmtext,'R VT','VT');
fdmtext = regexprep(fdmtext,'R BC','VT'); % on change tout par VT pour éviter les doublons de joueurs
fdmtext = regexprep(fdmtext,'R OH','VT');
fdmtext = regexprep(fdmtext,'R RH','VT');
fdmtext = regexprep(fdmtext,'R JE','VT');
fdmtext = regexprep(fdmtext,'R ON','VT');
fdmtext = regexprep(fdmtext,'R RN','VT');
fdmtext = regexprep(fdmtext,'SVT','VT'); %probleme feuille Besancon - Beaujolais basket. Apres enlever SCTC avant MARTIN C. il reste SVT donc lis pas le num de licence
fdmtext = regexprep(fdmtext,'R LICENCE NON PRESENTEE','VT000000');
fdmtext = regexprep(fdmtext,'LICENCE NON PRESENTEE','VT000000');

% %enlever les ' (M'BODJI) sinon probleme dans les strings
% data_fdm = strrep(data_fdm,'''',' ');
data_fdm = regexp(fdmtext, '^(?<licence>\D\D\d{5}\d+)\s+(?<nom>[^.\n]+[.\s][^0-9]+)\s+(?<num>\d+)(?<ftes>[^\n]+)', 'names', 'lineanchors');

%delete the lines with assistant coach into data_fdm
inddelete = 1;
todelete = [];
n = length(data_fdm);
for i = 1 : n
    data_fdm(i).licence(1:2) = 'VT';  % on remplace toutes les lettres de licences par VT pour éviter d'avoir des problemes avec le passage de Jeunes (BC) à seniors (VT) 
    test = regexp(data_fdm(i).nom, '^(?<licence>[^.\n]+)', 'names', 'lineanchors');
    if length(test) >= 2
        todelete(inddelete) = i;
        inddelete = inddelete+1;
    end
end
 
 if isempty(todelete) == 0
    for i = length(todelete) : -1 : 1
        data_fdm(todelete(i)) = [];
    end
 end
 
 


end
