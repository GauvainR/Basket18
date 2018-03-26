recap = rdir('pdffiles\**\Recapitulatif*');
fdm = rdir('pdffiles\**\Feuille*');
histo = rdir('pdffiles\**\Historique*');

if  length(recap) ~= length (histo) 
    disp('**************************************************************************')
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
    input('STOP le nombre de fichiers recap/histo n''est pas le meme')
end

  for nbfile = 1 : length(fdm)
      filename = fdm(nbfile).name;

    %declare the name of pdf to open for the pdftotext
    filename = fdm(nbfile).name;
    %extract a string pdfstr which contain the text
    [pdfstr] = pdftotext(filename);
    % write pdfstr in the file fdm.txt
    fid = fopen('fdm.txt','w');
    fprintf(fid,'%s',pdfstr);
    fclose(fid); %close fdm.txt

    fdmtextcell = textread('fdm.txt','%s','delimiter','\n');
    
    
% nom du championnat + numero rencontre + poule 
[gamedata] = donneesRencontre(fdmtextcell);



%% Copy and move pdffiles
 %folder name of folder in wich pdffiles are archived
 if strcmp(gamedata.comite,'FRAN') == 0
    folder_name = ['C:/Users/Gauvain/Documents/Basket/Basketstatistiques/Feuilles de marques/2017-2018_bon/',gamedata.comite,'/',gamedata.chpt,'/','Poule_',gamedata.poule];
 else
     folder_name = ['C:/Users/Gauvain/Documents/Basket/Basketstatistiques/Feuilles de marques/2017-2018_bon/',gamedata.chpt,'/','Poule_',gamedata.poule];
 end
 
  % Make folder if it does not exist.
if exist(folder_name, 'dir') == 0
  mkdir(folder_name);
end

movefile(fdm(nbfile).name,folder_name);
movefile(recap(nbfile).name,folder_name);
movefile(histo(nbfile).name,folder_name);

  end

  
% for nbfile = 1 : length(recap)
%     filename = recap(nbfile).name;
%     %extract a string pdfstr which contain the text
%     [pdfstr] = pdftotext(filename);
%     % write pdfstr in the file recap.txt
%     fid = fopen('recap.txt','w');
%     fprintf(fid,'%s',pdfstr);
%     fclose(fid); %close recap.txt
% 
%     %declare the name of pdf Recapitulatif to open for the pdftotext
%     filename = histo(nbfile).name; %si ca s'arrete la, il manque un fichier historique
%     %extract a string pdfstr which contain the text
%     [pdfstr] = pdftotext(filename);
%     % write pdfstr in the file recap.txt
%     fid = fopen('histo.txt','w');
%     fprintf(fid,'%s',pdfstr);
%     fclose(fid); %close histo.txt
% 
%     recaptextcell = textread('recap.txt','%s','delimiter','\n');
%     histotextcell = textread('histo.txt','%s','delimiter','\n');
% 
%     % find line where CHAMPIONNAT is written
%     linenum = find(~cellfun(@isempty,strfind(recaptextcell,'CHAMPIONNAT')));
%     linenum=linenum(1);
%     %Assume name of comité begin at 13th column
%     if strcmp(recaptextcell{linenum}(13:end), 'DE')
%         linenumpoule = linenum - 2;
%         linenumcat = linenum + 2;
%         gamedata.comite = 'FRAN';
%     else
%         linenumpoule = linenum - 1;
%         linenumcat = linenum + 1;
%         debutChampionnat = strfind(recaptextcell{linenum},'CHAMPIONNAT');
%         gamedata.comite = recaptextcell{linenum}(debutChampionnat+12:end);
%     end
% 
%     linePoule = recaptextcell{linenumpoule};
%     poulerecap = linePoule(2);
%     
%     if strcmp(poulerecap,'') == 0 % si le nom de la poule n'est pas vide
%         if length(isstrprop(poulerecap,'upper')) > 1 || isstrprop(poulerecap,'upper') == 0 % si le nom de la poule a plus d'un charactere ou si le charactere n'est pas une lettre
%             disp(['Le nom de la poule est ',poulerecap,' qui n''existe pas dans la bdd']);
%             poulerecap = input('Le nom de la poule est =>');
%         end
%     end
%     
%     lineChpt = recaptextcell{linenumcat};
%     
%     gamedata.chpt = recaptextcell{linenumcat};
% gamedata.chpt = strrep(gamedata.chpt,'-','_');
% gamedata.chpt = strrep(gamedata.chpt,' ','_');
% gamedata.chpt = strrep(gamedata.chpt,'1/2','DEMI');
% gamedata.chpt = strrep(gamedata.chpt,'FIN','Finale');
% gamedata.chpt = strrep(gamedata.chpt,'BARR','Barrage');
% gamedata.chpt = strrep(gamedata.chpt,'LR19_RMU15E_1','U15MEL'); 
% gamedata.chpt = strrep(gamedata.chpt,'DEP3M','DM3'); 
% gamedata.chpt = strrep(gamedata.chpt,'DEP4F','DF4');
% gamedata.chpt = strrep(gamedata.chpt,'DEP3F','DF3');
% gamedata.chpt = strrep(gamedata.chpt,'DEP2F','DF2');
% gamedata.chpt = strrep(gamedata.chpt,'DEP4M','DM4');
% gamedata.chpt = strrep(gamedata.chpt,'DEP5M','DM5');
% gamedata.chpt = strrep(gamedata.chpt,'DEP2M','DM2');
% gamedata.chpt = strrep(gamedata.chpt,'JFD1U20','U20F_D1');
% gamedata.chpt = strrep(gamedata.chpt,'MMD2U15','U15M_D2');
% gamedata.chpt = strrep(gamedata.chpt,'MMD2U15','U15M_D2');
% gamedata.chpt = strrep(gamedata.chpt,'CPE_CMUT._SM___1ER','CCMM');
% gamedata.chpt = strrep(gamedata.chpt,'CPM3','CPM'); %coupe de provence masculins
% gamedata.chpt = strrep(gamedata.chpt,'CTQCFM','CFM'); %coupe de France masculins
% gamedata.chpt = strrep(gamedata.chpt,'TCRSM4','CFM'); %coupe de France masculins
% gamedata.chpt = strrep(gamedata.chpt,'CLM1/8','CLM'); %coupe du lyonnais
% gamedata.chpt = strrep(gamedata.chpt,'CLM_1/4','CLM'); %coupe du lyonnais
% gamedata.chpt = strrep(gamedata.chpt,'LR19_TCSM_5','CFM'); 
% gamedata.chpt = strrep(gamedata.chpt,'C_CANDAU_1/16E','Cpe_Candau'); %CD40
% gamedata.chpt = strrep(gamedata.chpt,'R1SEM','PNM');
% 
% %avoid 1/4, 1/2 etc...
% if gamedata.chpt(1:3) == 'CCM'
%     if gamedata.chpt(1:4) == 'CCMM'
%     gamedata.chpt = 'CCMM';
%     elseif gamedata.chpt(1:4) == 'CCMF' 
%     gamedata.chpt = 'CCMF';
%     end
% end
% %category with only U17F for example
% if strcmp(gamedata.chpt(1:2),'U1') && length(gamedata.chpt) > 5
%     gamedata.chpt = [gamedata.chpt(1:4),'_',gamedata.chpt(5:end)];
% end
% 
%     %% Copy and move pdffiles
%      %folder name of folder in wich pdffiles are archived
%      if strcmp(gamedata.comite,'FRAN') == 0
%          folder_name_recap_histo = ['C:/Users/Gauvain/Documents/Basket/Basketstatistiques/Feuilles de marques/2017-2018_bon/',gamedata.comite,'/',gamedata.chpt,'/','Poule_',poulerecap];
%      else
%          folder_name_recap_histo = ['C:/Users/Gauvain/Documents/Basket/Basketstatistiques/Feuilles de marques/2017-2018_bon/',gamedata.chpt,'/','Poule_',poulerecap];
%      end
% 
%       % Make folder if it does not exist.
% 
%     if exist(folder_name_recap_histo, 'dir') == 0
%       mkdir(folder_name_recap_histo);
%     end
% 
%     movefile(recap(nbfile).name,folder_name_recap_histo);
%     movefile(histo(nbfile).name,folder_name_recap_histo);
% 
% end