load('stats.mat');
% Le code est créé dans latextable.txt. Copier coller dans un fichier latex

%% Partie à adapter 
comite = 'LR02';
type = 'championnat';
chpt = 'R2M';
poule = 'Poule_A';
equipe = 'ABC_LUTTERBACH';

tot = [];
mean = [];

latextable_finalisation = sprintf(['\\hline','\n','\\end{tabular}}','\n','\\end{table}','\n','\\newpage']);

fid = fopen('latextable.txt','w');
fprintf(fid,'%s\n','');
fclose(fid);

%Classe les joueurs par ordre alphabétique dans la structure
stats.(comite).championnat.(chpt).(poule).(equipe).joueurs = orderfields(stats.(comite).championnat.(chpt).(poule).(equipe).joueurs);

listejoueur = fieldnames(stats.(comite).championnat.(chpt).(poule).(equipe).joueurs);

%% Initialisation du document. packages + 

latex_init = sprintf(['\\documentclass[a4paper]{report}','\n',...
'\\usepackage[english]{babel}','\n',...
'\\usepackage[utf8]{inputenc}','\n',...
'\\usepackage{amsmath}','\n',...
'\\usepackage{amssymb}','\n',...
'\\usepackage{graphicx}','\n',...
'\\usepackage{graphics}','\n',...
'\\usepackage{array}','\n',...
'\\usepackage[colorinlistoftodos]{todonotes}','\n',...
'\\usepackage{setspace} %% pour augmenter l''interligne des abréviations','\n',...
'\\usepackage[top=1.8cm,bottom=1.5cm,right=0.5cm,left=0.5cm]{geometry} %% pour les marges','\n',...
'\\usepackage{indentfirst}','\n',...
'\\usepackage{subfigure}','\n',...
'%% \\usepackage{subcaption}','\n',...
'\\usepackage{colortbl} %%pour la couleur des tables','\n',...
'\\usepackage{makecell} %% pour définir des cellules spécifiques dans les tableaux','\n',...
'\\newcolumntype{L}[1]{>{\\raggedright\\let\\newline\\\\\\arraybackslash\\hspace{0pt}}m{#1}}  %% definition de cellule specifique pour les tableaux','\n',...
'\\newcolumntype{C}[1]{>{\\centering\\let\\newline\\\\\\arraybackslash\\hspace{0pt}}m{#1}} %% definition de cellule specifique pour les tableaux','\n',...
'\\setlength{\\parindent}{3em}','\n',...
'\\setlength{\\parskip}{1em}','\n',...
'\\renewcommand\\arraystretch{1.5}','\n\n']);


latex_fancy = sprintf(['%% custom footers and headers','\n', ...
'\\usepackage{fancyhdr,lastpage}','\n', ...
'\\pagestyle{fancy}','\n', ...
'\\lhead{',strrep(equipe,'_',' '),'}','\n', ...
'\\chead{}','\n', ...
'\\rhead{Saison 2017-2018}','\n', ...
'\\lfoot{basketstatistiques.fr}','\n', ...
'\\cfoot{\\thepage}','\n', ...
'\\rfoot{}','\n', ...
'\\renewcommand{\\headrulewidth}{1pt}','\n', ...
'\\renewcommand{\\footrulewidth}{1pt}']);

fid = fopen('latextable.txt','A');
fprintf(fid,'%s\n',latex_init,latex_fancy);
fclose(fid);

%% Debut du document avec page de titre
latex_begin_document=sprintf(['\\begin{document}','\n\n',...
'\\title{','\n',...
'\\includegraphics[width=0.5\\textwidth]{couverture} \\\\','\n',...
'\\vspace{100pt}','\n',...
'\\Huge\\bfseries ',strrep(equipe,'_',' '),' \\\\','\n',...
'\\vspace{50pt}','\n',...
'\\Huge\\bfseries ',strrep(chpt,'_',' '),' \\\\','\n',...
'\\vspace{150pt}','\n',...
'\\Huge \\bfseries Statistiques \\\\','\n',...
'\\vspace{50 pt}','\n',...
'\\huge \\bfseries Saison 2017-2018 \\\\','\n',...
'}','\n\n',...
'\\maketitle']);

fid = fopen('latextable.txt','A');
fprintf(fid,'%s\n',latex_begin_document);
fclose(fid);

%% Ecriture des abréviations. On ajoute cette section pour que l'on puisse écrire le titre en fonction du nom d'equipe dans le matlab

latex_abreviations= sprintf(['\\newgeometry{left=3cm,bottom=3cm}','\n',...
'\\chapter*{Abréviations}','\n',...
'\\large','\n',...
'\\begin{spacing}{1.2}','\n',...
'\\noindent\\textbf{2 int}: deux point intérieurs réussis \\\\','\n',...
'\\textbf{2 ext}: deux point extérieurs réussis \\\\','\n',...
'\\textbf{3 pts}: trois points réussis\\\\','\n',...
'\\textbf{age}: age du joueur au 31/12/2017 ou moyenne d''age de l''équipe\\\\','\n',...
'\\textbf{ftes}: fautes commises\\\\','\n',...
'\\textbf{ftes p.}: fautes provoquées\\\\','\n',...
'\\textbf{LF c.}: lancers francs concédés\\\\','\n',...
'\\textbf{LF m.}: lancers francs marqués\\\\','\n',...
'\\textbf{LF t.}: lancers francs tirés\\\\','\n',...
'\\textbf{LF \\%%}: pourcentage aux lancers francs\\\\','\n',...
'\\textbf{MJ}: matchs joués\\\\','\n',...
'\\textbf{nom}: nom du joueur\\\\','\n',...
'\\textbf{pts}: points marqués\\\\','\n',...
'\\textbf{pts 5}: points marqués par le 5 de base\\\\','\n',...
'\\textbf{pts bc}: points marqués par les rempla\\c{c}ants \\\\','\n',...
'\\textbf{pts e.}: points encaissés\\\\','\n',...
'\\textbf{pts m.}: points marqués\\\\','\n',...
'\\textbf{tdj}: temps de jeu\\\\','\n',...
'\\textbf{tirs}: tirs réussis\\\\','\n',...
'\\textbf{vs.}: match à domicile\\\\','\n',...
'\\textbf{a}: match à l''extérieur\\\\','\n',...
'\\textbf{+}: points marqués par l''équipe lorsque le joueur était sur le terrain\\\\','\n',...
'\\textbf{-}: points encaissés par l''équipe lorsque le joueur était sur le terrain\\\\','\n',...
'\\textbf{+/-}: écart lorsque le joueur était sur le terrain\\\\','\n',...
'\\textbf{\\%% pts 5}: pourcentage des points totaux marqués par le 5 de base\\\\','\n',...
'\\textbf{\\#}: numéro du joueur\\\\','\n',...
'\\textbf{*}: joueur dans le 5 de base\\\\','\n',...
'\\end{spacing}','\n',...
'\\normalsize','\n',...
'\\restoregeometry','\n']);

fid = fopen('latextable.txt','A');
fprintf(fid,'%s\n',latex_abreviations);
fclose(fid);


%% stats collectives
% Page titre
latextable_titlepage = sprintf(['\\newpage','\n','\\thispagestyle{empty}','\n','\\begin{center}','\n','\\vspace*{\\fill}','\n','\\includegraphics[width=0.6\\textwidth]{logo_BS_ecrit_noir} \\\\','\n','\\vspace{120pt}','\n','\\Huge\\bfseries Statistiques  \\\\','\n','\\vspace{30pt} \\Huge\\bfseries Collectives  \\\\','\n','\\vspace{90pt} \\vspace*{\\fill} \\end{center}','\n\n','\\newpage']);

fid = fopen('latextable.txt','A');
fprintf(fid,'%s\n',latextable_titlepage);
fclose(fid);

statteam = stats.(comite).championnat.(chpt).(poule).(equipe).equipe;

latextable_title = sprintf(['\\begin{center}','\n','\\section*{Stats collectives}','\n','\\end{center}','\n']);

%Initialisation
latextable_initialisation = sprintf(['\\begin{table}[h]','\n','\\centering','\n','\\resizebox{\\textwidth}{!}{%%','\n','\\begin{tabular}{|lcccccccccccccccc|}','\n','\\hline','\n','\\rowcolor[HTML]{F9F9F9}','\n','                          & pts m. & pts e. & pts 5 & pts bc & \\%% pts 5 & tirs & 3 pts & 2 ext & 2 int & LF m. & LF t. & LF \\%% & ftes & LF c. & ftes p. & âge  \\\\ \\Xhline{3\\arrayrulewidth}','\n']);

fid = fopen('latextable.txt','A');
fprintf(fid,'%s\n',latextable_title,latextable_initialisation);
fclose(fid);

    for nbmatch = 1 : length(statteam.matchs)
        %couleur de la liugne selon pair ou impair
        if mod(nbmatch,2)
            latextable_colorline = sprintf(['\\rowcolor[HTML]{EEEEEE}']);
        else
            latextable_colorline = sprintf(['\\rowcolor[HTML]{F9F9F9}']);
        end
        
        if length(statteam.matchs(nbmatch).nomrencontre) > 20
            nomrencontre = statteam.matchs(nbmatch).nomrencontre(1:20);
        else
            nomrencontre = statteam.matchs(nbmatch).nomrencontre;
        end
        
        latextable_line = sprintf([nomrencontre,'&',strrep(num2str(statteam.matchs(nbmatch).pts),'NaN','-'),'&',num2str(statteam.matchs(nbmatch).ptsencaisses),'&',num2str(statteam.matchs(nbmatch).ptscinq),'&',num2str(statteam.matchs(nbmatch).ptsbanc),'&',num2str(statteam.matchs(nbmatch).pctptscinq,'%3.1f'),'&',num2str(statteam.matchs(nbmatch).tirs),'&',num2str(statteam.matchs(nbmatch).troispts),'&',num2str(statteam.matchs(nbmatch).deuxext),'&',num2str(statteam.matchs(nbmatch).deuxint),'&',num2str(statteam.matchs(nbmatch).lfreussis),'&',num2str(statteam.matchs(nbmatch).lftentes),'&',strrep(num2str(statteam.matchs(nbmatch).lfpct,'%3.1f'),'NaN','-'),'&',num2str(statteam.matchs(nbmatch).ftes),'&',num2str(statteam.matchs(nbmatch).lfconc),'&',num2str(statteam.matchs(nbmatch).ftesprov),'&',strrep(num2str(statteam.matchs(nbmatch).age,'%3.1f'),'NaN','-'),'\n','\\\\']);
    
        fid = fopen('latextable.txt','A');
        fprintf(fid,'%s\n',latextable_colorline);
        fprintf(fid,'%s\n',latextable_line);
        fclose(fid);
    end
    
    %ligne horizontale de 2 pixels
    fid = fopen('latextable.txt','A');
    fprintf(fid,'%s\n','\Xhline{2\arrayrulewidth}');
    fclose(fid); 
    
% calcul du total des colonnes de statteam avec une for loop
%!!!!!!!!!!!!!!!!!!!! A mettre en fonction !!!!!!!!!!!!!!!!!!!!!!!
    lengthStatteam = length(statteam.matchs);
    
    tot.pts = 0;
    tot.ptsencaisses = 0;
    tot.ptscinq = 0;
    tot.ptsbanc = 0;
    tot.tirs = 0;
    tot.troispts = 0;
    tot.deuxext = 0;
    tot.deuxint = 0;
    tot.lfreussis =0;
    tot.lftentes = 0;
    tot.lfconc = 0;
    tot.ftes = 0;
    tot.ftesprov = 0;
    tot.age = 0;
    tot.anti = 0;
    tot.tech = 0;
    tot.disqua = 0;
    nbCellAgeEmpty = 0;
    
    for i = 1 : lengthStatteam
        if isempty(statteam.matchs(i).age)
            statteam.matchs(i).age = 0;
            statteam.matchs(i).anti = 0;
            statteam.matchs(i).tech = 0;
            statteam.matchs(i).disqua = 0;
        end
        
        
        tot.pts = tot.pts + statteam.matchs(i).pts;
        tot.ptsencaisses = tot.ptsencaisses + statteam.matchs(i).pts;
        tot.ptscinq = tot.ptscinq + statteam.matchs(i).ptscinq;
        tot.ptsbanc = tot.ptsbanc + statteam.matchs(i).ptsbanc;
        tot.tirs = tot.tirs + statteam.matchs(i).tirs;
        tot.troispts = tot.troispts + statteam.matchs(i).troispts;
        tot.deuxext = tot.deuxext + statteam.matchs(i).deuxext;
        tot.deuxint = tot.deuxint + statteam.matchs(i).deuxint;
        tot.lfreussis = tot.lfreussis + statteam.matchs(i).lfreussis;
        tot.lftentes = tot.lftentes + statteam.matchs(i).lftentes;
        tot.lfconc = tot.lfconc + statteam.matchs(i).lfconc;
        tot.ftes = tot.ftes + statteam.matchs(i).ftes;
        tot.ftesprov = tot.ftesprov + statteam.matchs(i).ftesprov;
        tot.age = tot.age + statteam.matchs(i).age;
        tot.anti = tot.anti + statteam.matchs(i).anti;
        tot.tech = tot.tech + statteam.matchs(i).tech;
        tot.disqua = tot.disqua + statteam.matchs(i).disqua;
        
        if statteam.matchs(i).age == 0
           nbCellAgeEmpty = nbCellAgeEmpty + 1; 
        end
    end
    
    tot.pctptscinq = tot.ptscinq / tot.pts*100;
    tot.lfpct = tot.lfreussis / tot.lftentes*100;
    
    mean.pts = tot.pts / lengthStatteam;
    mean.ptsencaisses = tot.ptsencaisses / lengthStatteam;
    mean.ptscinq = tot.ptscinq / lengthStatteam;
    mean.ptsbanc = tot.ptsbanc / lengthStatteam;
    mean.tirs = tot.tirs / lengthStatteam;
    mean.troispts = tot.troispts / lengthStatteam;
    mean.deuxext = tot.deuxext / lengthStatteam;
    mean.deuxint = tot.deuxint / lengthStatteam;
    mean.lfreussis = tot.lfreussis / lengthStatteam;
    mean.lftentes = tot.lftentes / lengthStatteam;
    mean.lfconc = tot.lfconc / lengthStatteam;
    mean.ftes = tot.ftes / lengthStatteam;
    mean.ftesprov = tot.ftesprov  / lengthStatteam;
    mean.age = tot.age / (lengthStatteam - nbCellAgeEmpty);
    mean.anti = tot.anti / lengthStatteam;
    mean.tech = tot.tech / lengthStatteam;
    mean.disqua = tot.disqua / lengthStatteam;
    
    mean.pctptscinq = tot.pctptscinq;
    mean.lfpct = tot.lfpct;
    
    
    if mod(nbmatch,2)
        latextable_totline = sprintf(['\\rowcolor[HTML]{F9F9F9}','\n','\\textbf{Total} & ',strrep(num2str(tot.pts),'NaN','-'),'&',num2str(tot.ptsencaisses),'&',num2str(tot.ptscinq),'&',num2str(tot.ptsbanc),'&',num2str(tot.pctptscinq,'%3.1f'),'&',num2str(tot.tirs),'&',num2str(tot.troispts),'&',num2str(tot.deuxext),'&',num2str(tot.deuxint),'&',num2str(tot.lfreussis),'&',num2str(tot.lftentes),'&',strrep(num2str(tot.lfpct,'%3.1f'),'NaN','-'),'&',num2str(tot.ftes),'&',num2str(tot.lfconc),'&',num2str(tot.ftesprov),'&','-','\n','\\\\']);
        latextable_meanline = sprintf(['\\rowcolor[HTML]{EEEEEE}','\n','\\textbf{Moyenne} & ',strrep(num2str(mean.pts,'%3.1f'),'NaN','-'),'&',num2str(mean.ptsencaisses,'%3.1f'),'&',num2str(mean.ptscinq,'%3.1f'),'&',num2str(mean.ptsbanc,'%3.1f'),'&',num2str(mean.pctptscinq,'%3.1f'),'&',num2str(mean.tirs,'%3.1f'),'&',num2str(mean.troispts,'%3.1f'),'&',num2str(mean.deuxext,'%3.1f'),'&',num2str(mean.deuxint,'%3.1f'),'&',num2str(mean.lfreussis,'%3.1f'),'&',num2str(mean.lftentes,'%3.1f'),'&',strrep(num2str(mean.lfpct,'%3.1f'),'NaN','-'),'&',num2str(mean.ftes,'%3.1f'),'&',num2str(mean.lfconc,'%3.1f'),'&',num2str(mean.ftesprov,'%3.1f'),'&',strrep(num2str(mean.age,'%3.1f'),'NaN','-'),'\n','\\\\']);
    else
        latextable_totline = sprintf(['\\rowcolor[HTML]{EEEEEE}','\n','\\textbf{Total} & ',strrep(num2str(tot.pts),'NaN','-'),'&',num2str(tot.ptsencaisses),'&',num2str(tot.ptscinq),'&',num2str(tot.ptsbanc),'&',num2str(tot.pctptscinq,'%3.1f'),'&',num2str(tot.tirs),'&',num2str(tot.troispts),'&',num2str(tot.deuxext),'&',num2str(tot.deuxint),'&',num2str(tot.lfreussis),'&',num2str(tot.lftentes),'&',strrep(num2str(tot.lfpct,'%3.1f'),'NaN','-'),'&',num2str(tot.ftes),'&',num2str(tot.lfconc),'&',num2str(tot.ftesprov),'&','-','\n','\\\\']);
        latextable_meanline = sprintf(['\\rowcolor[HTML]{F9F9F9}','\n','\\textbf{Moyenne} & ',strrep(num2str(mean.pts,'%3.1f'),'NaN','-'),'&',num2str(mean.ptsencaisses,'%3.1f'),'&',num2str(mean.ptscinq,'%3.1f'),'&',num2str(mean.ptsbanc,'%3.1f'),'&',num2str(mean.pctptscinq,'%3.1f'),'&',num2str(mean.tirs,'%3.1f'),'&',num2str(mean.troispts,'%3.1f'),'&',num2str(mean.deuxext,'%3.1f'),'&',num2str(mean.deuxint,'%3.1f'),'&',num2str(mean.lfreussis,'%3.1f'),'&',num2str(mean.lftentes,'%3.1f'),'&',strrep(num2str(mean.lfpct,'%3.1f'),'NaN','-'),'&',num2str(mean.ftes,'%3.1f'),'&',num2str(mean.lfconc,'%3.1f'),'&',num2str(mean.ftesprov,'%3.1f'),'&',strrep(num2str(mean.age,'%3.1f'),'NaN','-'),'\n','\\\\']);
    end
    
    fid = fopen('latextable.txt','A');
    fprintf(fid,'%s\n',latextable_totline,latextable_meanline,latextable_finalisation);
    fclose(fid);
    


%% table mean players
%Titre  
latextable_title = sprintf(['\\begin{center}','\n','\\section*{Stats moyennes par match}','\n','\\end{center}','\n']);
%Initialisation
latextable_initialisation = sprintf(['\\begin{table}[h]','\n','\\centering','\n','\\resizebox{\\textwidth}{!}{%%','\n','\\begin{tabular}{|lccccccccccccccc|}','\n','\\hline','\n','\\rowcolor[HTML]{F9F9F9}','\n','                          & MJ & tdj & pts & tirs & 3 pts & 2 ext & 2 int & LF m. & LF t. & LF \\%% & ftes & LF c. & + & - & +/-  \\\\ \\Xhline{3\\arrayrulewidth}','\n']);

fid = fopen('latextable.txt','A');
fprintf(fid,'%s\n',latextable_title,latextable_initialisation);
fclose(fid);
for ligne = 1 : length(listejoueur)
    nomjoueur = listejoueur{ligne};
    
    statPlayer = stats.(comite).championnat.(chpt).(poule).(equipe).joueurs.(nomjoueur).matchs;
    
    [tot, mean, min, nbMj] = latexTable_statPlayer(statPlayer);
    
    if length(nomjoueur) > 20
        nomjoueur = strrep(nomjoueur(1:20),'_',' ');
    else
        nomjoueur = strrep(nomjoueur,'_',' ');
    end
    
    %avoir le + avant l'écart
    if mean.ecart > 0
        ecartmean = ['+',strrep(num2str(mean.ecart,'%3.1f'),'NaN','-')];
    else
        ecartmean = strrep(num2str(mean.ecart,'%3.1f'),'NaN','-');
    end

    if mod(ligne,2)
        latextable_meanline = sprintf(['\\rowcolor[HTML]{EEEEEE}','\n',nomjoueur,' & ',num2str(nbMj),' & ',strrep(num2str(mean.tpsdejeu,'%3.1f'),'NaN','-'),' & ',num2str(mean.pts,'%3.1f'),' & ',num2str(mean.tirs,'%3.1f'),' & ',num2str(mean.troispts,'%3.1f'),' & ',num2str(mean.deuxext,'%3.1f'),' & ',num2str(mean.deuxint,'%3.1f'),' & ',num2str(mean.lfreussis,'%3.1f'),' & ',num2str(mean.lftentes,'%3.1f'),' & ',strrep(num2str(mean.lfpct,'%3.1f'),'NaN','-'),' & ',num2str(mean.ftes,'%3.1f'),' & ',num2str(mean.lfconc,'%3.1f'),' & ',strrep(num2str(mean.ptsmarq,'%3.1f'),'NaN','-'),' & ',strrep(num2str(mean.ptsenc,'%3.1f'),'NaN','-'),' & ',strrep(num2str(mean.ecart,'%3.1f'),'NaN','-'),'\n','\\\\']);
    else
        latextable_meanline = sprintf(['\\rowcolor[HTML]{F9F9F9}','\n',nomjoueur,' & ',num2str(nbMj),' & ',strrep(num2str(mean.tpsdejeu,'%3.1f'),'NaN','-'),' & ',num2str(mean.pts,'%3.1f'),' & ',num2str(mean.tirs,'%3.1f'),' & ',num2str(mean.troispts,'%3.1f'),' & ',num2str(mean.deuxext,'%3.1f'),' & ',num2str(mean.deuxint,'%3.1f'),' & ',num2str(mean.lfreussis,'%3.1f'),' & ',num2str(mean.lftentes,'%3.1f'),' & ',strrep(num2str(mean.lfpct,'%3.1f'),'NaN','-'),' & ',num2str(mean.ftes,'%3.1f'),' & ',num2str(mean.lfconc,'%3.1f'),' & ',strrep(num2str(mean.ptsmarq,'%3.1f'),'NaN','-'),' & ',strrep(num2str(mean.ptsenc,'%3.1f'),'NaN','-'),' & ',strrep(num2str(mean.ecart,'%3.1f'),'NaN','-'),'\n','\\\\']);
    end

    fid = fopen('latextable.txt','A');
    fprintf(fid,'%s\n',latextable_meanline);
    fclose(fid);
end
fid = fopen('latextable.txt','A');
fprintf(fid,'%s\n',latextable_finalisation);
fclose(fid);
    

%% table tot players
%Titre  
latextable_title = sprintf(['\\begin{center}','\n','\\section*{Stats totales}','\n','\\end{center}','\n']);
%Initialisation
latextable_initialisation = sprintf(['\\begin{table}[h]','\n','\\centering','\n','\\resizebox{\\textwidth}{!}{%%','\n','\\begin{tabular}{|lccccccccccccccc|}','\n','\\hline','\n','\\rowcolor[HTML]{F9F9F9}','\n','                          & MJ & tdj & pts & tirs & 3 pts & 2 ext & 2 int & LF m. & LF t. & LF \\%% & ftes & LF c. & + & - & +/-  \\\\ \\Xhline{3\\arrayrulewidth}','\n']);

fid = fopen('latextable.txt','A');
fprintf(fid,'%s\n',latextable_title,latextable_initialisation);
fclose(fid);
for ligne = 1 : length(listejoueur)
    nomjoueur = listejoueur{ligne};
    
    statPlayer = stats.(comite).championnat.(chpt).(poule).(equipe).joueurs.(nomjoueur).matchs;
    
    [tot, mean, min, nbMj] = latexTable_statPlayer(statPlayer);
    
    if length(nomjoueur) > 20
        nomjoueur = strrep(nomjoueur(1:20),'_',' ');
    else
        nomjoueur = strrep(nomjoueur,'_',' ');
    end
    
    %avoir le + avant l'écart
    if tot.ecart > 0
        ecartmean = ['+',strrep(num2str(tot.ecart,'%3.1f'),'NaN','-')];
    else
        ecartmean = strrep(num2str(tot.ecart,'%3.1f'),'NaN','-');
    end

    if mod(ligne,2)
        latextable_totline = sprintf(['\\rowcolor[HTML]{EEEEEE}','\n',nomjoueur,' & ',...
            num2str(nbMj),' & ',...
            strrep(num2str(tot.tpsdejeu,'%3.1f'),'NaN','-'),' & ',...
            num2str(tot.pts,'%3.0f'),' & ',...
            num2str(tot.tirs,'%3.0f'),' & ',...
            num2str(tot.troispts,'%3.0f'),' & ',...
            num2str(tot.deuxext,'%3.0f'),' & ',...
            num2str(tot.deuxint,'%3.0f'),' & ',...
            num2str(tot.lfreussis,'%3.0f'),' & ',...
            num2str(tot.lftentes,'%3.0f'),' & ',...
            strrep(num2str(tot.lfpct,'%3.1f'),'NaN','-'),' & ',...
            num2str(tot.ftes,'%3.0f'),' & ',...
            num2str(tot.lfconc,'%3.0f'),' & ',...
            strrep(num2str(tot.ptsmarq,'%3.0f'),'NaN','-'),' & ',...
            strrep(num2str(tot.ptsenc,'%3.0f'),'NaN','-'),' & ',...
            strrep(num2str(tot.ecart,'%3.0f'),'NaN','-'),'\n','\\\\']);
    else
        latextable_totline = sprintf(['\\rowcolor[HTML]{F9F9F9}','\n',nomjoueur,' & ',...
            num2str(nbMj),' & ',...
            strrep(num2str(tot.tpsdejeu,'%3.1f'),'NaN','-'),' & ',...
            num2str(tot.pts,'%3.0f'),' & ',...
            num2str(tot.tirs,'%3.0f'),' & ',...
            num2str(tot.troispts,'%3.0f'),' & ',...
            num2str(tot.deuxext,'%3.0f'),' & ',...
            num2str(tot.deuxint,'%3.0f'),' & ',...
            num2str(tot.lfreussis,'%3.0f'),' & ',...
            num2str(tot.lftentes,'%3.0f'),' & ',...
            strrep(num2str(tot.lfpct,'%3.1f'),'NaN','-'),' & ',...
            num2str(tot.ftes,'%3.0f'),' & ',...
            num2str(tot.lfconc,'%3.0f'),' & ',...
            strrep(num2str(tot.ptsmarq,'%3.0f'),'NaN','-'),' & ',...
            strrep(num2str(tot.ptsenc,'%3.0f'),'NaN','-'),' & ',...
            strrep(num2str(tot.ecart,'%3.0f'),'NaN','-'),'\n','\\\\']);
    end

    fid = fopen('latextable.txt','A');
    fprintf(fid,'%s\n',latextable_totline);
    fclose(fid);
end
fid = fopen('latextable.txt','A');
fprintf(fid,'%s\n',latextable_finalisation);
fclose(fid);

%% Table minplayer stats sur 40 min
%Titre  
latextable_title = sprintf(['\\begin{center}','\n','\\section*{Stats ramenées sur 40 minutes}','\n','\\end{center}','\n']);
%Initialisation
latextable_initialisation = sprintf(['\\begin{table}[h]','\n','\\centering','\n','\\resizebox{\\textwidth}{!}{%%','\n','\\begin{tabular}{|lccccccccccccccc|}','\n','\\hline','\n','\\rowcolor[HTML]{F9F9F9}','\n','                          & MJ & tdj & pts & tirs & 3 pts & 2 ext & 2 int & LF m. & LF t. & LF \\%% & ftes & LF c. & + & - & +/-  \\\\ \\Xhline{3\\arrayrulewidth}','\n']);

fid = fopen('latextable.txt','A');
fprintf(fid,'%s\n',latextable_title,latextable_initialisation);
fclose(fid);
for ligne = 1 : length(listejoueur)
    nomjoueur = listejoueur{ligne};
    
    statPlayer = stats.(comite).championnat.(chpt).(poule).(equipe).joueurs.(nomjoueur).matchs;
    [tot, mean, min, nbMj] = latexTable_statPlayer(statPlayer);
    
    if length(nomjoueur) > 20
        nomjoueur = strrep(nomjoueur(1:20),'_',' ');
    else
        nomjoueur = strrep(nomjoueur,'_',' ');
    end
    
    %avoir le + avant l'écart
    if min.ecart > 0
        ecartmin = ['+',strrep(num2str(min.ecart,'%3.1f'),'NaN','-')];
    else
        ecartmin = strrep(num2str(min.ecart,'%3.1f'),'NaN','-');
    end

    if mod(ligne,2)
        latextable_minline = sprintf(['\\rowcolor[HTML]{EEEEEE}','\n',nomjoueur,' & ',...
            num2str(nbMj),' & ',...
            strrep(num2str(min.tpsdejeu,'%3.0f'),'NaN','-'),' & ',...
            strrep(num2str(min.pts,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.tirs,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.troispts,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.deuxext,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.deuxint,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.lfreussis,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.lftentes,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.lfpct,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.ftes,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.lfconc,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.ptsmarq,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.ptsenc,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.ecart,'%3.1f'),'NaN','-'),'\n','\\\\']);
    else
        latextable_minline = sprintf(['\\rowcolor[HTML]{F9F9F9}','\n',nomjoueur,' & ',...
            num2str(nbMj),' & ',...
            strrep(num2str(min.tpsdejeu,'%3.0f'),'NaN','-'),' & ',...
            strrep(num2str(min.pts,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.tirs,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.troispts,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.deuxext,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.deuxint,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.lfreussis,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.lftentes,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.lfpct,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.ftes,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.lfconc,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.ptsmarq,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.ptsenc,'%3.1f'),'NaN','-'),' & ',...
            strrep(num2str(min.ecart,'%3.1f'),'NaN','-'),'\n','\\\\']);
    end

    fid = fopen('latextable.txt','A');
    fprintf(fid,'%s\n',latextable_minline);
    fclose(fid);
end
fid = fopen('latextable.txt','A');
fprintf(fid,'%s\n',latextable_finalisation);
fclose(fid);


%% table stats players
% Page titre
latextable_titlepage = sprintf(['\\thispagestyle{empty}','\n','\\begin{center}','\n','\\vspace*{\\fill}','\n','\\includegraphics[width=0.6\\textwidth]{logo_BS_ecrit_noir} \\\\','\n','\\vspace{120pt}','\n','\\Huge\\bfseries Statistiques  \\\\','\n','\\vspace{30pt} \\Huge\\bfseries Individuelles  \\\\','\n','\\vspace{90pt} \\vspace*{\\fill} \\end{center}','\n','\\newpage']);

fid = fopen('latextable.txt','A');
fprintf(fid,'%s\n',latextable_titlepage);
fclose(fid);

for ligne = 1 : length(listejoueur)
nomjoueur = listejoueur{ligne};

adn = stats.(comite).championnat.(chpt).(poule).(equipe).joueurs.(nomjoueur).adn;
statplayer = stats.(comite).championnat.(chpt).(poule).(equipe).joueurs.(nomjoueur).matchs;

[totplayer, meanplayer, minplayer, nbMj] = latexTable_statPlayer(statplayer);
% totplayer = stats.(comite).championnat.(chpt).(poule).(equipe).joueurs.(nomjoueur).total; 
% meanplayer = stats.(comite).championnat.(chpt).(poule).(equipe).joueurs.(nomjoueur).moyenne;
% minplayer = stats.(comite).championnat.(chpt).(poule).(equipe).joueurs.(nomjoueur).quarantemin;

latextable_title = sprintf(['\\begin{center}','\n','\\section*{',strrep(nomjoueur,'_',' '),' (',adn,')','}','\n','\\end{center}','\n']);

%Initialisation
latextable_initialisation = sprintf(['\\begin{table}[h]','\n','\\centering','\n','\\resizebox{\\textwidth}{!}{%%','\n','\\begin{tabular}{|lcccccccccccccc|}','\n','\\hline','\n','\\rowcolor[HTML]{F9F9F9}','\n','                          & tdj & pts & tirs & 3 pts & 2 ext & 2 int & LF m. & LF t. & LF \\%% & ftes & LF c. & + & - & +/-  \\\\ \\Xhline{3\\arrayrulewidth}','\n']);

fid = fopen('latextable.txt','A');
fprintf(fid,'%s\n',latextable_title,latextable_initialisation);
fclose(fid);

    for nbmatch = 1 : length(statplayer)
        %couleur de la liugne selon pair ou impair
        if mod(nbmatch,2)
            latextable_colorline = sprintf(['\\rowcolor[HTML]{EEEEEE}']);
        else
            latextable_colorline = sprintf(['\\rowcolor[HTML]{F9F9F9}']);
        end
        
        if length(statplayer(nbmatch).nomrencontre) > 20
            nomrencontre = statplayer(nbmatch).nomrencontre(1:20);
        else
            nomrencontre = statplayer(nbmatch).nomrencontre;
        end
        
        %avoir le + avant l'écart
        if statplayer(nbmatch).ecart > 0
            ecart = ['+',strrep(num2str(statplayer(nbmatch).ecart),'NaN','-')];
        else
            ecart = strrep(num2str(statplayer(nbmatch).ecart),'NaN','-');
        end
        
        latextable_line = sprintf([nomrencontre,'&',strrep(num2str(statplayer(nbmatch).tpsdejeu,'%3.1f'),'NaN','-'),'&',num2str(statplayer(nbmatch).pts),'&',num2str(statplayer(nbmatch).tirs),'&',num2str(statplayer(nbmatch).troispts),'&',num2str(statplayer(nbmatch).deuxext),'&',num2str(statplayer(nbmatch).deuxint),'&',num2str(statplayer(nbmatch).lfreussis),'&',num2str(statplayer(nbmatch).lftentes),'&',strrep(num2str(statplayer(nbmatch).lfpct,'%3.1f'),'NaN','-'),'&',num2str(statplayer(nbmatch).ftes),'&',num2str(statplayer(nbmatch).lfconc),'&',strrep(num2str(statplayer(nbmatch).ptsmarq),'NaN','-'),'&',strrep(num2str(statplayer(nbmatch).ptsenc),'NaN','-'),'&',ecart,'\n','\\\\']);
    
        fid = fopen('latextable.txt','A');
        fprintf(fid,'%s\n',latextable_colorline);
        fprintf(fid,'%s\n',latextable_line);
        fclose(fid);
    end
    %ligne horizontale de 2 pixels
    fid = fopen('latextable.txt','A');
    fprintf(fid,'%s\n','\Xhline{2\arrayrulewidth}');
    fclose(fid); 
    
    if totplayer.ecart > 0
        ecarttot = ['+',strrep(num2str(totplayer.ecart),'NaN','-')];
        ecartmin = ['+',strrep(num2str(minplayer.ecart,'%3.1f'),'NaN','-')];
        ecartmean = ['+',strrep(num2str(meanplayer.ecart,'%3.1f'),'NaN','-')];
    else
        ecarttot = strrep(num2str(totplayer.ecart),'NaN','-');
        ecartmin = strrep(num2str(minplayer.ecart,'%3.1f'),'NaN','-');
        ecartmean = strrep(num2str(meanplayer.ecart,'%3.1f'),'NaN','-');
    end
    
    if mod(nbmatch,2)
        latextable_totline = sprintf(['\\rowcolor[HTML]{F9F9F9}','\n','\\textbf{Total} & ',num2str(totplayer.tpsdejeu,'%3.1f'),' & ',num2str(totplayer.pts),' & ',num2str(totplayer.tirs),' & ',num2str(totplayer.troispts),' & ',num2str(totplayer.deuxext),' & ',num2str(totplayer.deuxint),' & ',num2str(totplayer.lfreussis),' & ',num2str(totplayer.lftentes),' & ',strrep(num2str(totplayer.lfpct,'%3.1f'),'NaN','-'),' & ',num2str(totplayer.ftes),' & ',num2str(totplayer.lfconc),' & ',strrep(num2str(totplayer.ptsmarq),'NaN','-'),' & ',strrep(num2str(totplayer.ptsenc),'NaN','-'),' & ',ecarttot,'\n','\\\\']);
        latextable_minline = sprintf(['\\rowcolor[HTML]{EEEEEE}','\n','\\textbf{Stats sur 40 min} & ',num2str(minplayer.tpsdejeu,'%3.1f'),' & ',strrep(num2str(minplayer.pts,'%3.1f'),'NaN','-'),' & ',strrep(num2str(minplayer.tirs,'%3.1f'),'NaN','-'),' & ',strrep(num2str(minplayer.troispts,'%3.1f'),'NaN','-'),' & ',strrep(num2str(minplayer.deuxext,'%3.1f'),'NaN','-'),' & ',strrep(num2str(minplayer.deuxint,'%3.1f'),'NaN','-'),' & ',strrep(num2str(minplayer.lfreussis,'%3.1f'),'NaN','-'),' & ',strrep(num2str(minplayer.lftentes,'%3.1f'),'NaN','-'),' & ',strrep(num2str(totplayer.lfpct,'%3.1f'),'NaN','-'),' & ',strrep(num2str(minplayer.ftes,'%3.1f'),'NaN','-'),' & ',strrep(num2str(minplayer.lfconc,'%3.1f'),'NaN','-'),' & ',strrep(num2str(minplayer.ptsmarq,'%3.1f'),'NaN','-'),' & ',strrep(num2str(minplayer.ptsenc,'%3.1f'),'NaN','-'),' & ',ecartmin,'\n','\\\\']);
        latextable_meanline = sprintf(['\\rowcolor[HTML]{F9F9F9}','\n','\\textbf{Moyenne} & ',strrep(num2str(meanplayer.tpsdejeu,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.pts,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.tirs,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.troispts,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.deuxext,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.deuxint,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.lfreussis,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.lftentes,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.lfpct,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.ftes,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.lfconc,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.ptsmarq,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.ptsenc,'%3.1f'),'NaN','-'),' & ',ecartmean,'\n','\\\\']);
    else
        latextable_totline = sprintf(['\\rowcolor[HTML]{EEEEEE}','\n','\\textbf{Total} & ',num2str(totplayer.tpsdejeu,'%3.1f'),' & ',num2str(totplayer.pts),' & ',num2str(totplayer.tirs),' & ',num2str(totplayer.troispts),' & ',num2str(totplayer.deuxext),' & ',num2str(totplayer.deuxint),' & ',num2str(totplayer.lfreussis),' & ',num2str(totplayer.lftentes),' & ',strrep(num2str(totplayer.lfpct,'%3.1f'),'NaN','-'),' & ',num2str(totplayer.ftes),' & ',num2str(totplayer.lfconc),' & ',strrep(num2str(totplayer.ptsmarq),'NaN','-'),' & ',strrep(num2str(totplayer.ptsenc),'NaN','-'),' & ',ecarttot,'\n','\\\\']);
        latextable_minline = sprintf(['\\rowcolor[HTML]{F9F9F9}','\n','\\textbf{Stats sur 40 min} & ',num2str(minplayer.tpsdejeu,'%3.1f'),' & ',strrep(num2str(minplayer.pts,'%3.1f'),'NaN','-'),' & ',strrep(num2str(minplayer.tirs,'%3.1f'),'NaN','-'),' & ',strrep(num2str(minplayer.troispts,'%3.1f'),'NaN','-'),' & ',strrep(num2str(minplayer.deuxext,'%3.1f'),'NaN','-'),' & ',strrep(num2str(minplayer.deuxint,'%3.1f'),'NaN','-'),' & ',strrep(num2str(minplayer.lfreussis,'%3.1f'),'NaN','-'),' & ',strrep(num2str(minplayer.lftentes,'%3.1f'),'NaN','-'),' & ',strrep(num2str(totplayer.lfpct,'%3.1f'),'NaN','-'),' & ',strrep(num2str(minplayer.ftes,'%3.1f'),'NaN','-'),' & ',strrep(num2str(minplayer.lfconc,'%3.1f'),'NaN','-'),' & ',strrep(num2str(minplayer.ptsmarq,'%3.1f'),'NaN','-'),' & ',strrep(num2str(minplayer.ptsenc,'%3.1f'),'NaN','-'),' & ',ecartmin,'\n','\\\\']);
        latextable_meanline = sprintf(['\\rowcolor[HTML]{EEEEEE}','\n','\\textbf{Moyenne} & ',strrep(num2str(meanplayer.tpsdejeu,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.pts,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.tirs,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.troispts,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.deuxext,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.deuxint,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.lfreussis,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.lftentes,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.lfpct,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.ftes,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.lfconc,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.ptsmarq,'%3.1f'),'NaN','-'),' & ',strrep(num2str(meanplayer.ptsenc,'%3.1f'),'NaN','-'),' & ',ecartmean,'\n','\\\\']);
    end
    
    fid = fopen('latextable.txt','A');
    fprintf(fid,'%s\n',latextable_totline,latextable_minline,latextable_meanline,latextable_finalisation);
    fclose(fid);
    
end

%% Table stats par match
% Page titre
latextable_titlepage = sprintf(['\\thispagestyle{empty}','\n','\\begin{center}','\n','\\vspace*{\\fill}','\n','\\includegraphics[width=0.6\\textwidth]{logo_BS_ecrit_noir} \\\\','\n','\\vspace{120pt}','\n','\\Huge\\bfseries Statistiques  \\\\','\n','\\vspace{30pt} \\Huge\\bfseries Par match  \\\\','\n','\\vspace{90pt} \\vspace*{\\fill} \\end{center}','\n','\\newpage']);
fid = fopen('latextable.txt','A');
fprintf(fid,'%s\n',latextable_titlepage);
fclose(fid);

statteam = statteam.matchs;  % on change la structure pour avoir accès directement aux stats sans passer par .matchs

statparmatch = stats.(comite).championnat.(chpt).(poule).(equipe).parmatch;
listematch = fieldnames(statparmatch);

for ligne = 1 : length(statteam)
    numeroRencontre = statteam(ligne).numrencontre;
    
    
    
    nommatchtitle = statteam(ligne).nomrencontre;
    if strcmp(nommatchtitle(1:2),'@.')
        nommatch = ['at',nommatchtitle(4:end)];
    else
        nommatch = ['vs',nommatchtitle(5:end)];
    end
    nommatch = strrep(nommatch,' ','_');
    nommatch = strrep(nommatch,'(','');
    nommatch = strrep(nommatch,')','');
    structurematch = statparmatch.(nommatch); % si ca bloque la il y a un caracter special dans le nom d'equipe qui n'est pas le meme dans statsparmatch et statteam
    
    if statteam(ligne).pts > statteam(ligne).ptsencaisses
        latextable_title = sprintf(['\\begin{center}','\n','\\section*{',...
            strrep(nommatchtitle,'_',' '),'}','\n','\\section*{Victoire ',...
            num2str(statteam(ligne).pts),' - ',num2str(statteam(ligne).ptsencaisses),...
            '}','\n']);
    else
        latextable_title = sprintf(['\\begin{center}','\n','\\section*{',...
            strrep(nommatchtitle,'_',' '),'}','\n','\\section*{Défaite ',...
            num2str(statteam(ligne).pts),' - ',num2str(statteam(ligne).ptsencaisses),...
            '}']);
    end
    
    latextable_nom_equipe = sprintf(['\\large','\n','\\textbf{',...
        strrep(equipe,'_',' '),'}\n','\\normalsize','\n', '\\end{center}','\n']);

    %Initialisation
    latextable_initialisation = sprintf(['\\begin{table}[h]','\n','\\centering','\n','\\resizebox{\\textwidth}{!}{%%','\n','\\begin{tabular}{|clccccccccccccccc|}','\n','\\hline','\n','\\rowcolor[HTML]{F9F9F9}','\n','\\# & nom & tdj & pts & tirs & 3 pts & 2 ext & 2 int & LF m. & LF t. & LF \\%% & ftes & LF c. & + & - & +/-  \\\\ \\Xhline{3\\arrayrulewidth}','\n']);

    fid = fopen('latextable.txt','A');
    fprintf(fid,'%s\n',latextable_title,latextable_nom_equipe,latextable_initialisation);
    fclose(fid);
    
    for nbjoueurs = 1 : length(statparmatch.(nommatch)) - 1
        %couleur de la liugne selon pair ou impair
        if mod(nbjoueurs,2)
            latextable_colorline = sprintf(['\\rowcolor[HTML]{EEEEEE}']);
        else
            latextable_colorline = sprintf(['\\rowcolor[HTML]{F9F9F9}']);
        end
        
        %avoir le + avant l'écart
        nomjoueur = structurematch(nbjoueurs).nomjoueur;
        if structurematch(nbjoueurs).ecart > 0
            ecart = ['+',strrep(num2str(structurematch(nbjoueurs).ecart),'NaN','-')];
        else
            ecart = strrep(num2str(structurematch(nbjoueurs).ecart),'NaN','-');
        end

        
        if length(structurematch(nbjoueurs).nomjoueur) > 20
            if strcmp(structurematch(nbjoueurs).nomjoueur(end),'*')
                nomjoueur = [structurematch(nbjoueurs).nomjoueur(1:19),'*'];
            else
                nomjoueur = structurematch(nbjoueurs).nomjoueur(1:19);
            end
        else
            nomjoueur = structurematch(nbjoueurs).nomjoueur;
        end
        
        latextable_line = sprintf([num2str(structurematch(nbjoueurs).numero),' & ',nomjoueur,'&',strrep(num2str(structurematch(nbjoueurs).tpsdejeu,'%3.1f'),'NaN','-'),'&',num2str(structurematch(nbjoueurs).pts),'&',num2str(structurematch(nbjoueurs).tirs),'&',num2str(structurematch(nbjoueurs).troispts),'&',num2str(structurematch(nbjoueurs).deuxext),'&',num2str(structurematch(nbjoueurs).deuxint),'&',num2str(structurematch(nbjoueurs).lfreussis),'&',num2str(structurematch(nbjoueurs).lftentes),'&',strrep(num2str(structurematch(nbjoueurs).lfpct,'%3.1f'),'NaN','-'),'&',num2str(structurematch(nbjoueurs).ftes),'&',num2str(structurematch(nbjoueurs).lfconc),'&',strrep(num2str(structurematch(nbjoueurs).ptsmarq),'NaN','-'),'&',strrep(num2str(structurematch(nbjoueurs).ptsenc),'NaN','-'),'&',ecart,'\n','\\\\']);
        
        fid = fopen('latextable.txt','A');
        fprintf(fid,'%s\n',latextable_colorline);
        fprintf(fid,'%s\n',latextable_line);
        fclose(fid);
    end
    
    %ligne horizontale de 2 pixels
    fid = fopen('latextable.txt','A');
    fprintf(fid,'%s\n','\Xhline{2\arrayrulewidth}');
    fclose(fid);
    
    %ligne de total pour l'équipe A
    if structurematch(nbjoueurs+1).ecart > 0
        ecart = ['+',strrep(num2str(structurematch(nbjoueurs+1).ecart),'NaN','-')];
    else
        ecart = strrep(num2str(structurematch(nbjoueurs+1).ecart),'NaN','-');
    end
    
    if mod(nbjoueurs,2)
        latextable_totline = sprintf(['\\rowcolor[HTML]{F9F9F9}','\n',' & Equipe &  &',...
            num2str(statteam(ligne).pts),'&',...
            num2str(statteam(ligne).tirs),'&',...
            num2str(statteam(ligne).troispts),'&',...
            num2str(statteam(ligne).deuxext),'&',...
            num2str(statteam(ligne).deuxint),'&',...
            num2str(statteam(ligne).lfreussis),'&',...
            num2str(statteam(ligne).lftentes),'&',...
            strrep(num2str(statteam(ligne).lfpct,'%3.1f'),'NaN','-'),'&',...
            num2str(statteam(ligne).ftes),'&',...
            num2str(statteam(ligne).lfconc),'&',...
            strrep(num2str(statteam(ligne).pts),'NaN','-'),'&',...
            strrep(num2str(statteam(ligne).ptsencaisses),'NaN','-'),'&',...
            ecart,'\n','\\\\']);
    else
        latextable_totline = sprintf(['\\rowcolor[HTML]{EEEEEE}','\n',' & Equipe &  &',...
            num2str(statteam(ligne).pts),'&',...
            num2str(statteam(ligne).tirs),'&',...
            num2str(statteam(ligne).troispts),'&',...
            num2str(statteam(ligne).deuxext),'&',...
            num2str(statteam(ligne).deuxint),'&',...
            num2str(statteam(ligne).lfreussis),'&',...
            num2str(statteam(ligne).lftentes),'&',...
            strrep(num2str(statteam(ligne).lfpct,'%3.1f'),'NaN','-'),'&',...
            num2str(statteam(ligne).ftes),'&',...
            num2str(statteam(ligne).lfconc),'&',...
            strrep(num2str(statteam(ligne).pts),'NaN','-'),'&',...
            strrep(num2str(statteam(ligne).ptsencaisses),'NaN','-'),'&',...
            ecart,'\n','\\\\']);
    end
    
    latextable_finalisation = sprintf(['\\hline','\n','\\end{tabular}}','\n','\\end{table}']);
    %Fin du tableau pour l'équipe A
    fid = fopen('latextable.txt','A');
    fprintf(fid,'%s\n',latextable_totline);
    fprintf(fid,'%s\n',latextable_finalisation);
    fclose(fid);
    
    %% Partie pour l'équipe B
    equipeB = nommatch(3:end);
    statparmatchB = stats.(comite).championnat.(chpt).(poule).(equipeB).parmatch;
    statteamB = stats.(comite).championnat.(chpt).(poule).(equipeB).equipe.matchs;
    
    % on cherche la ligne qui correspond au match
    for ii = 1 : length(statteamB)
        if statteamB(ii).numrencontre == numeroRencontre
            ligneB = ii;
        end
    end
    
    %ligneB = %ligne dans structure statteam qui correspond au match
    
    if strcmp(nommatch(1:2),'at')
        nommatchB = ['vs',equipe];
    else
        nommatchB = ['at',equipe];
    end
    
    structurematch = statparmatchB.(nommatchB);

    latextable_nom_equipe = sprintf(['\\begin{center}','\n','\\large','\n','\\textbf{',...
        strrep(equipeB,'_',' '),'}\n','\\normalsize','\n', '\\end{center}','\n']);

    %Initialisation
    latextable_initialisation = sprintf(['\\begin{table}[h]','\n','\\centering','\n','\\resizebox{\\textwidth}{!}{%%','\n','\\begin{tabular}{|clccccccccccccccc|}','\n','\\hline','\n','\\rowcolor[HTML]{F9F9F9}','\n','\\# & nom & tdj & pts & tirs & 3 pts & 2 ext & 2 int & LF m. & LF t. & LF \\%% & ftes & LF c. & + & - & +/-  \\\\ \\Xhline{3\\arrayrulewidth}','\n']);

    fid = fopen('latextable.txt','A');
    fprintf(fid,'%s\n',latextable_nom_equipe,latextable_initialisation);
    fclose(fid);
    
    for nbjoueurs = 1 : length(statparmatchB.(nommatchB)) - 1
        %couleur de la liugne selon pair ou impair
        if mod(nbjoueurs,2)
            latextable_colorline = sprintf('\\rowcolor[HTML]{EEEEEE}');
        else
            latextable_colorline = sprintf('\\rowcolor[HTML]{F9F9F9}');
        end
        
        %avoir le + avant l'écart
        if structurematch(nbjoueurs).ecart > 0
            ecart = ['+',strrep(num2str(structurematch(nbjoueurs).ecart),'NaN','-')];
        else
            ecart = strrep(num2str(structurematch(nbjoueurs).ecart),'NaN','-');
        end

        
        if length(structurematch(nbjoueurs).nomjoueur) > 20
            if strcmp(structurematch(nbjoueurs).nomjoueur(end),'*')
                nomjoueur = [structurematch(nbjoueurs).nomjoueur(1:19),'*'];
            else
                nomjoueur = structurematch(nbjoueurs).nomjoueur(1:19);
            end
        else
            nomjoueur = structurematch(nbjoueurs).nomjoueur;
        end
        
        latextable_line = sprintf([num2str(structurematch(nbjoueurs).numero),' & ',nomjoueur,'&',strrep(num2str(structurematch(nbjoueurs).tpsdejeu,'%3.1f'),'NaN','-'),'&',num2str(structurematch(nbjoueurs).pts),'&',num2str(structurematch(nbjoueurs).tirs),'&',num2str(structurematch(nbjoueurs).troispts),'&',num2str(structurematch(nbjoueurs).deuxext),'&',num2str(structurematch(nbjoueurs).deuxint),'&',num2str(structurematch(nbjoueurs).lfreussis),'&',num2str(structurematch(nbjoueurs).lftentes),'&',strrep(num2str(structurematch(nbjoueurs).lfpct,'%3.1f'),'NaN','-'),'&',num2str(structurematch(nbjoueurs).ftes),'&',num2str(structurematch(nbjoueurs).lfconc),'&',strrep(num2str(structurematch(nbjoueurs).ptsmarq),'NaN','-'),'&',strrep(num2str(structurematch(nbjoueurs).ptsenc),'NaN','-'),'&',ecart,'\n','\\\\']);
        
        fid = fopen('latextable.txt','A');
        fprintf(fid,'%s\n',latextable_colorline);
        fprintf(fid,'%s\n',latextable_line);
        fclose(fid);
    end
    
    %ligne horizontale de 2 pixels
    fid = fopen('latextable.txt','A');
    fprintf(fid,'%s\n','\Xhline{2\arrayrulewidth}');
    fclose(fid);
    
    %ligne de total pour l'équipe B
    if structurematch(nbjoueurs+1).ecart > 0
        ecart = ['+',strrep(num2str(structurematch(nbjoueurs+1).ecart),'NaN','-')];
    else
        ecart = strrep(num2str(structurematch(nbjoueurs+1).ecart),'NaN','-');
    end
    
    if mod(nbjoueurs,2)
        latextable_totline = sprintf(['\\rowcolor[HTML]{F9F9F9}','\n',' & Equipe &  &',...
            num2str(statteamB(ligneB).pts),'&',...
            num2str(statteamB(ligneB).tirs),'&',...
            num2str(statteamB(ligneB).troispts),'&',...
            num2str(statteamB(ligneB).deuxext),'&',...
            num2str(statteamB(ligneB).deuxint),'&',...
            num2str(statteamB(ligneB).lfreussis),'&',...
            num2str(statteamB(ligneB).lftentes),'&',...
            strrep(num2str(statteamB(ligneB).lfpct,'%3.1f'),'NaN','-'),'&',...
            num2str(statteamB(ligneB).ftes),'&',...
            num2str(statteamB(ligneB).lfconc),'&',...
            strrep(num2str(statteamB(ligneB).pts),'NaN','-'),'&',...
            strrep(num2str(statteamB(ligneB).ptsencaisses),'NaN','-'),'&',...
            ecart,'\n','\\\\']);
    else
        latextable_totline = sprintf(['\\rowcolor[HTML]{EEEEEE}','\n',' & Equipe &  &',...
            num2str(statteamB(ligneB).pts),'&',...
            num2str(statteamB(ligneB).tirs),'&',...
            num2str(statteamB(ligneB).troispts),'&',...
            num2str(statteamB(ligneB).deuxext),'&',...
            num2str(statteamB(ligneB).deuxint),'&',...
            num2str(statteamB(ligneB).lfreussis),'&',...
            num2str(statteamB(ligneB).lftentes),'&',...
            strrep(num2str(statteamB(ligneB).lfpct,'%3.1f'),'NaN','-'),'&',...
            num2str(statteamB(ligneB).ftes),'&',...
            num2str(statteamB(ligneB).lfconc),'&',...
            strrep(num2str(statteamB(ligneB).pts),'NaN','-'),'&',...
            strrep(num2str(statteamB(ligneB).ptsencaisses),'NaN','-'),'&',...
            ecart,'\n','\\\\']);
    end
    
    latextable_finalisation = sprintf(['\\hline','\n','\\end{tabular}}','\n','\\end{table}','\n','\\newpage']);
    %Fin du tableau pour l'équipe B
    fid = fopen('latextable.txt','A');
    fprintf(fid,'%s\n',latextable_totline);
    fprintf(fid,'%s\n',latextable_finalisation);
    fclose(fid);
    
    
end

%% Fin du document
latex_end_document = sprintf(['\n','\\end{document}','\n']);
fid = fopen('latextable.txt','A');
fprintf(fid,'%s\n',latex_end_document);
fclose(fid);


