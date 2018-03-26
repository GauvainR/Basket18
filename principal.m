%  tic

% Definition de la saison ( A changer chaque annee)
season = '18';

%Message d'erreur
messageErreur = '';

% % % %search in the folder pdffile files which begin by Feuille and by
% % % %Recapitulatif and by Historique and store them in structure fdm and recap
recap = rdir('pdffiles\**\Recapitulatif*');
fdm = rdir('pdffiles\**\Feuille*');
histo = rdir('pdffiles\**\Historique*');

if length(recap) ~= length(fdm) || length(recap) ~= length (histo) || length(histo) ~= length(fdm)
    disp('**************************************************************************')
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
    input('STOP le nombre de fichiers recap/histo/fdm n''est pas le meme')
end

disp([num2str(length(recap)),' matchs à traiter']);

%load the file with all the stats of all the teams
 load('stats.mat');
 load('listeCompetition.mat');
 load('listeJoueurs.mat');
 load('listeJoueursSansLicence.mat');
 load('listeClubs.mat');

%Fichier sqltotal vide pour pouvoir juste faire "a+" pour chaque match
fid = fopen('sqltotal.sql','w');
fprintf(fid,'%s\n','');
fclose(fid);

fid = fopen('sqlecart.sql','w');
fprintf(fid,'%s\n','');
fclose(fid);
 
  for nbfile = 1 : length(recap)
      tic
clearvars -except nbfile recap fdm histo stats season messageErreur listeCompetition listeJoueurs listeJoueursSansLicence listeClubs
 sqlJoueurs = sprintf('');
 sqlEquipes = sprintf('');
 sqlStatsJoueurs = sprintf('');
 sqlStatsEquipes = sprintf('');
 sqlMatchs = sprintf('');
 sqlCompetition = sprintf('');
 sqlEcartCinq = sprintf(''); 
 sqlClubs = sprintf('');
 
%nbfile determine the row in recap to determine which file opening
nbfile

%declare the name of pdf Recapitulatif to open for the pdftotext
filename = recap(nbfile).name;

% si c'est un match a probleme on load les 
if contains(filename,'matchsAProbleme')
    [filepath,name,ext] = fileparts(filename);
    copyfile([filepath,'\recap.txt'],'recap.txt');
    copyfile([filepath,'\histo.txt'],'histo.txt');
    copyfile([filepath,'\fdm.txt'],'fdm.txt');
else
    %extract a string pdfstr which contain the text
    [pdfstr] = pdftotext(filename);
    % write pdfstr in the file recap.txt
    fid = fopen('recap.txt','w');
    fprintf(fid,'%s',pdfstr);
    fclose(fid); %close recap.txt

    %declare the name of pdf to open for the pdftotext
    filename = fdm(nbfile).name;
    %extract a string pdfstr which contain the text
    [pdfstr] = pdftotext(filename);
    % write pdfstr in the file fdm.txt
    fid = fopen('fdm.txt','w');
    fprintf(fid,'%s',pdfstr);
    fclose(fid); %close fdm.txt

    %declare the name of pdf Recapitulatif to open for the pdftotext
    filename = histo(nbfile).name; %si ca s'arrete la, il manque un fichier historique
    %extract a string pdfstr which contain the text
    [pdfstr] = pdftotext(filename);
    % write pdfstr in the file recap.txt
    fid = fopen('histo.txt','w');
    fprintf(fid,'%s',pdfstr);
    fclose(fid); %close histo.txt
end

fdmtextcell = textread('fdm.txt','%s','delimiter','\n');
recaptextcell = textread('recap.txt','%s','delimiter','\n');
histotextcell = textread('histo.txt','%s','delimiter','\n');

[dateok,datesql,messageErreur] = dateDuMatch(histotextcell,messageErreur);

if dateok == 1
    
% modification et reécriture des fichiers textes
[fdmtextcell,recaptextcell,histotextcell] = modifTextFiles(fdmtextcell,recaptextcell,histotextcell);

[lfmanque] = computeLFManque(histotextcell);

% nom du championnat + numero rencontre + poule 
[gamedata] = donneesRencontre(fdmtextcell);

%determine si 'SM' 'SF' 'JM' 'JF' 'MI' ou 'CO'
[gamedata] = categorie(gamedata);

%Determine 5 de base
[cinqdomicile,cinqvisiteur] = cinqdebase(gamedata);

%On vérifie si le chpt existe et poule associée existe
[listeCompetition,sqlCompetition] = checkCompetitionExist(gamedata,listeCompetition,sqlCompetition);

%extraire les données de la feuille de marque
[data_fdm] = extractDataFdm;

%extraire les données du recap
[data_recap,gamedata] = extractDataRecap(gamedata);


%check data_fdm == data_recap et modif si différent
if length(data_fdm) ~= length(data_recap)
    [data_fdm,fdmtextcell] = checkLengthData(data_fdm,data_recap,fdmtextcell);
end

% donnees des coachs ( a mettre dans une fonction
recaptext = fileread('recap.txt');
recaptext = strrep(recaptext,'''',' ');
data_coach_1 = regexp(recaptext, '^(?<fautes>\d[A-Z][A-Z -]+)','names','lineanchors');
data_coach(1).fautes = data_coach_1(1).fautes(1);
data_coach(2).fautes = data_coach_1(2).fautes(1);
data_coach(1).nom = data_coach_1(1).fautes(2:end);
data_coach(2).nom = data_coach_1(2).fautes(2:end);


% find the row where name of team are written
%domicile
nomscoachsrecap = regexp(recaptext, '^(?<nomscoach>\d[A-Z][A-Z -]+)','names','lineanchors');
linenum = find(~cellfun(@isempty,strfind(recaptextcell,nomscoachsrecap(1).nomscoach)));
gamedata.domicile = recaptextcell{linenum+1};
%stats des mi-temps
data_recap_team.domicile.premiere = regexp(recaptextcell{linenum-3}, '^(?<pts>\d+)\s+(?<tirs>\d+)\s+(?<troispts>\d+)\s+(?<deuxext>\d+)\s+(?<deuxint>\d+)\s+(?<lf>\d+)\s+(?<ftes>\d+)', 'names', 'lineanchors');
data_recap_team.domicile.deuxieme = regexp(recaptextcell{linenum-2}, '^(?<pts>\d+)\s+(?<tirs>\d+)\s+(?<troispts>\d+)\s+(?<deuxext>\d+)\s+(?<deuxint>\d+)\s+(?<lf>\d+)\s+(?<ftes>\d+)', 'names', 'lineanchors');

%visiteur
linenum = find(~cellfun(@isempty,strfind(recaptextcell,nomscoachsrecap(2).nomscoach)));
gamedata.visiteur = recaptextcell{linenum+1};
%find results of both half time
data_recap_team.visiteur.premiere = regexp(recaptextcell{linenum-3}, '^(?<pts>\d+)\s+(?<tirs>\d+)\s+(?<troispts>\d+)\s+(?<deuxext>\d+)\s+(?<deuxint>\d+)\s+(?<lf>\d+)\s+(?<ftes>\d+)', 'names', 'lineanchors');
data_recap_team.visiteur.deuxieme = regexp(recaptextcell{linenum-2}, '^(?<pts>\d+)\s+(?<tirs>\d+)\s+(?<troispts>\d+)\s+(?<deuxext>\d+)\s+(?<deuxint>\d+)\s+(?<lf>\d+)\s+(?<ftes>\d+)', 'names', 'lineanchors');

% détermination des numéros informatiques des équipes
[gamedata] = numeroEquipe(gamedata,fdmtextcell);

% modification des noms d'équipes
[gamedata] = modifNomsEquipes(gamedata);

% On vérifie si l'équipe existe. Si existe pas si equipe avec numéro existe
[gamedata,sqlEquipes,sqlClubs,listeClubs,stats] = checkTeamExist(gamedata,stats,sqlEquipes,sqlClubs,listeClubs,season);

% % Check si la rencontre a déja été traitée
[existRencontre] = checkExistRencontre(gamedata,stats);
% % Si elle n'existe pas on effectue la suite
if existRencontre == false
    
     % remove all lines with JAS. Could cause problem for following steps
deleteJAS = regexp(fdmtextcell, '^(?<JAS>[J][A][S])','names','lineanchors');
for i = length(deleteJAS) : -1 : 1
    if isempty(deleteJAS{i,1}) == 0
        fdmtextcell(i) = [];
    end
end

deleteJC1A = regexp(fdmtextcell,'^(?<JC1A>[J][C][1][A])','names','lineanchors');
for i = length(deleteJC1A) : -1 : 1
    if isempty(deleteJC1A{i,1}) == 0
        fdmtextcell(i) = [];
    end
end

    %find fautes made by the coach
    [data_fautes_coach] = computeFautesCoach(fdmtextcell,data_coach,gamedata);

    data_arbitre = regexp(recaptextcell{linenum+3}, '^(?<nom>\D+)', 'names', 'lineanchors');

    % Partie pour ajouter les points après les noms des arbitres si ils ne sont
    % pas présents. Problème si une lettre isolée dans nom du 1er arbitre
    % On vérifie si écart entre 1er et 2e espace = 2 alors il manque le point
    positionespace = strfind(data_arbitre.nom,' ');
    if length(positionespace) == 3 %length=3 sinon il peut y avoir un caractere isolé dans le nom
        if (positionespace(2) - positionespace(1)) == 2  
            data_arbitre.nom = insertBefore(data_arbitre.nom,positionespace(2),'.');
        end
    end
    %On vérifie si le dernier caractere de la ligne n'est pas un point
    if strcmp(data_arbitre.nom(end),'.') == 0
        data_arbitre.nom = insertAfter(data_arbitre.nom,length(data_arbitre.nom),'.');
    end

    noms_arbitres = strsplit(data_arbitre.nom,'.');
    if length(noms_arbitres) == 3
        arbitres{1} = [strrep(noms_arbitres{1},'''',' '),'.'];
        arbitres{2} = [strrep(noms_arbitres{2},'''',' '),'.'];
    elseif length(noms_arbitres) == 2
        arbitres{1} = [strrep(noms_arbitres{1},'''',' '),'.'];
    end

    % fclose(fid); %close recap

    [data_fautes] = computeFautes(data_fdm);

    %separe teams in two structures data_recap_domicile et exterieur.
    %Assume that the last number of first team is superior to the first of
    %second team
    for n = 1 : (numel(data_recap)-1)
            separation(n,1) = str2double(data_recap(n+1).num) - str2double(data_recap(n).num);
    end
    caseseparation = find(separation < 0);
    if isempty(caseseparation)
        disp('**********************************************************')
        disp('Le premier joueur visiteur a un numéro supérieur au dernier joueur domicile');
        disp(fdm(nbfile).name);
        caseseparation = input('Combien de joueurs dans l''equipe domicile -->');
    end
        
    data_recap_domicile = data_recap(1:caseseparation);
    data_recap_visiteur = data_recap(caseseparation+1:end);
    data_fdm_domicile = data_fdm(1:caseseparation);
    data_fdm_visiteur = data_fdm(caseseparation+1:end);
    data_fautes_domicile = data_fautes(1:caseseparation);
    data_fautes_visiteur = data_fautes(caseseparation+1:end);

    %compute total fautes techniques anti and disqua
    [totfautes] = totfautes(data_fautes_domicile,data_fautes_visiteur,data_fautes_coach);
    [data_recap_domicile,data_recap_visiteur] = computeTot(data_recap_domicile,data_recap_visiteur);
    %score QT 
    %1st and 2d arbitre are determined inside this function
    [data_qt,data_mt,prolongations] = scoreqt(data_arbitre,data_fdm_visiteur,fdmtextcell);
    
    [tdj_struct,histo_exploitable] = tdjHistorique(histotextcell,prolongations);
    [ecart] = computeEcart(histotextcell,data_mt);

if isempty(tdj_struct)
    erreur = [];
    erreur = sprintf([erreur,'tdj vide ',gamedata.chpt,' ',gamedata.poule,' ',gamedata.domicile,' ',gamedata.visiteur]);
    erreur = sprintf([erreur,'\n\n']);
    fid = fopen('aVerifier.txt','A');
    fprintf(fid,'%s\n',erreur);
    fclose(fid);
end
if isempty(ecart)
    erreur = [];
    erreur = sprintf([erreur,'ecart vide ',gamedata.chpt,' ',gamedata.poule,' ',gamedata.domicile,' ',gamedata.visiteur]);
    fid = fopen('aVerifier.txt','A');
    fprintf(fid,'%s\n',erreur);
    fclose(fid);
end
    %lance la fonction computestats.m
    [stats,nblfmanque_domicile,nblfmanque_visiteur,nbfautescoach,sqlJoueurs,sqlEquipes,sqlStatsJoueurs,sqlStatsEquipes,listeJoueurs,listeJoueursSansLicence,infosJoueurs] = computeStats(data_recap_domicile,data_recap_visiteur,data_fdm_domicile,data_fdm_visiteur,gamedata,data_fautes_domicile,data_fautes_visiteur,lfmanque,data_coach,stats,data_fautes_coach,totfautes,ecart,cinqdomicile,cinqvisiteur,sqlJoueurs,sqlEquipes,sqlStatsJoueurs,sqlStatsEquipes,tdj_struct,season,listeJoueurs,listeJoueursSansLicence);
    % Requete pour la table matchs
    [sqlMatchs] = computeStatsMatch(gamedata,data_coach,arbitres,data_qt,sqlMatchs,datesql,season);
    %calcul des stats entraineurs
    
    %calcul des ecart par 5
    [sqlEcartCinq] = computeEcartCinq(histotextcell,infosJoueurs,gamedata,season,histo_exploitable);

end


% if nbfile == 1 %new file for sql queries if first game of compilation
%     fid = fopen('sqljoueurs.sql','W');
%     fprintf(fid,'%s\n',sqljoueurs);
%     fclose(fid);
% 
%     fid = fopen('sqlequipes.sql','W');
%     fprintf(fid,'%s\n',sqlequipes);
%     fclose(fid);
% else %attend at the end of the file
%     fid = fopen('sqljoueurs.sql','A');
%     fprintf(fid,'%s\n',sqljoueurs);
%     fclose(fid);
% 
%     fid = fopen('sqlequipes.sql','A');
%     fprintf(fid,'%s\n',sqlequipes);
%     fclose(fid);
% 
% end
    
% Ecrire dans sqltotal pour faciliter le copier/coller
    fid = fopen('sqltotal.sql','A');
    fprintf(fid,'%s\n',sqlCompetition);
    fclose(fid);  

    fid = fopen('sqltotal.sql','A');
    fprintf(fid,'%s\n',sqlEquipes);
    fclose(fid); 
    
    fid = fopen('sqltotal.sql','A');
    fprintf(fid,'%s\n',sqlClubs);
    fclose(fid); 

    fid = fopen('sqltotal.sql','A');
    fprintf(fid,'%s\n',sqlMatchs);
    fclose(fid);

    fid = fopen('sqltotal.sql','A');
    fprintf(fid,'%s\n',sqlJoueurs);
    fclose(fid);
    
    fid = fopen('sqltotal.sql','A');
    fprintf(fid,'%s\n',sqlStatsJoueurs);
    fclose(fid);
    
    fid = fopen('sqltotal.sql','A');
    fprintf(fid,'%s\n',sqlStatsEquipes);
    fclose(fid);
    
    fid = fopen('sqltotal.sql','A');
    fprintf(fid,'%s\n',sqlEcartCinq);
    fclose(fid);

 toc

else
    disp('Le match est hors de la saison 2017-2018')
end
  end
    
    %Affiche message des erreurs qu'il a pu y avoir (match hors saison)
    if(isempty(messageErreur)==0)
        disp('Un match n''a pas été traité');
        disp(messageErreur);
    end
    
    save('stats.mat','stats');
    save('listeCompetition.mat','listeCompetition');
    save('listeJoueurs.mat','listeJoueurs');
    save('listeJoueursSansLicence.mat','listeJoueursSansLicence');
    save('listeClubs.mat','listeClubs');

%    %remove all files and folders contained in pdffiles. WARNING: problem if a file was not treated. 
%  rmdir('pdffiles/*','s')
toc
