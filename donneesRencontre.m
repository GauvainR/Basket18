function [gamedata] = donneesRencontre(fdmtextcell)
% find line where CHAMPIONNAT is written
linenum = find(~cellfun(@isempty,strfind(fdmtextcell,'CHAMPIONNAT')));
linenum=linenum(1);
%Assume name of comité begin at 13th column
if strcmp(fdmtextcell{linenum}(13:end), 'DE')
    gamedata.comite = 'FRAN';
    linenumcat = linenum + 2;
else
    gamedata.comite = fdmtextcell{linenum}(13:end);
    linenumcat = linenum + 1;
end

%% numéro de rencontre
%On prend 5 caracteres si jamais le numero de rencontre est supérieur à
%10000. Puis on supprime l'espace de la fin si jamais length = 4
decompo_ligne_numrencontre = regexp(fdmtextcell{linenum - 2},'\d+','match');
gamedata.numrencontre = decompo_ligne_numrencontre{1};
gamedata.numrencontre = strrep(gamedata.numrencontre,' ','');

%% championnat
%Find name of the category
gamedata.chpt = fdmtextcell{linenumcat};
gamedata.chpt = strrep(gamedata.chpt,'-','_');
gamedata.chpt = strrep(gamedata.chpt,' ','_');
% gamedata.chpt = strrep(gamedata.chpt,'__','_');

% Changement généraux
gamedata.chpt = strrep(gamedata.chpt,'1/2','DEMI');
gamedata.chpt = strrep(gamedata.chpt,'BARR','Barrage');
gamedata.chpt = strrep(gamedata.chpt,'FINALES','Finales');
gamedata.chpt = strrep(gamedata.chpt,'FINALE','Finale');
gamedata.chpt = strrep(gamedata.chpt,'FIN','Finale');
gamedata.chpt = strrep(gamedata.chpt,'DEMI','Demi');


% Régionaux
gamedata.chpt = strrep(gamedata.chpt,'R1SEM','PNM');
gamedata.chpt = strrep(gamedata.chpt,'R2SEM','R2M');
gamedata.chpt = strrep(gamedata.chpt,'RM2','R2M');
gamedata.chpt = strrep(gamedata.chpt,'PNMPH2','PNMP2');
gamedata.chpt = strrep(gamedata.chpt,'R2SM1','R2M');
gamedata.chpt = strrep(gamedata.chpt,'R3SM1','R3M');
gamedata.chpt = strrep(gamedata.chpt,'R3SEM','R3M');
gamedata.chpt = strrep(gamedata.chpt,'MR3P2','R3M_Phase_2');

% Départementaux
gamedata.chpt = strrep(gamedata.chpt,'PREGM','DM1');
gamedata.chpt = strrep(gamedata.chpt,'DEP2M','DM2');
gamedata.chpt = strrep(gamedata.chpt,'95_DM2','DM2');
gamedata.chpt = strrep(gamedata.chpt,'DEP3M','DM3');
gamedata.chpt = strrep(gamedata.chpt,'DEP4M','DM4');
gamedata.chpt = strrep(gamedata.chpt,'DEP5M','DM5'); 

gamedata.chpt = strrep(gamedata.chpt,'PREGF','DF1');
gamedata.chpt = strrep(gamedata.chpt,'D2SEF','DF2');
gamedata.chpt = strrep(gamedata.chpt,'DEP2F','DF2');
gamedata.chpt = strrep(gamedata.chpt,'DEP3F','DF3');
gamedata.chpt = strrep(gamedata.chpt,'DEP4F','DF4');

% Jeunes
gamedata.chpt = strrep(gamedata.chpt,'JFD1U20','U20F_D1');
gamedata.chpt = strrep(gamedata.chpt,'MMD2U15','U15M_D2');
gamedata.chpt = strrep(gamedata.chpt,'MMD1U15','U15M_D1');
gamedata.chpt = strrep(gamedata.chpt,'MMPR_U15','U15M_Pre_Regionale');
gamedata.chpt = strrep(gamedata.chpt,'BU15M1','U15M1_Brassage');
gamedata.chpt = strrep(gamedata.chpt,'BU17F1','U17F1_Brassage');

gamedata.chpt = strrep(gamedata.chpt,'LR19_RMU15E_1','U15MEL'); 


% Coupes
gamedata.chpt = strrep(gamedata.chpt,'CPE_CMUT._SM___1ER','CCMM');
gamedata.chpt = strrep(gamedata.chpt,'CPM3','CPM'); %coupe de provence masculins
gamedata.chpt = strrep(gamedata.chpt,'CTQCFM','CFM'); %coupe de France masculins
gamedata.chpt = strrep(gamedata.chpt,'TCRSM4','CFM'); %coupe de France masculins
gamedata.chpt = strrep(gamedata.chpt,'CLM1/8','CLM'); %coupe du lyonnais
gamedata.chpt = strrep(gamedata.chpt,'CLM_1/4','CLM'); %coupe du lyonnais
gamedata.chpt = strrep(gamedata.chpt,'CLM___1/4','CLM'); %coupe du lyonnais
gamedata.chpt = strrep(gamedata.chpt,'LR19_TCSM_5','CFM'); 
gamedata.chpt = strrep(gamedata.chpt,'C_CANDAU_1/16E','Cpe_Candau'); %CD40
gamedata.chpt = strrep(gamedata.chpt,'C_CANDAU_1/8E','Cpe_Candau'); %CD40

gamedata.chpt = strrep(gamedata.chpt,'CPE_ENCOU._SM___1/4','CCMM'); % credit mut CD67
gamedata.chpt = strrep(gamedata.chpt,'CPE_ENCOU._SM___2EME','CCMM'); % credit mut CD67
gamedata.chpt = strrep(gamedata.chpt,'CPE_ENCOU._SM___1/8EME','CCMM'); % credit mut CD67
gamedata.chpt = strrep(gamedata.chpt,'CPE_ENCOU._SM___DEMI','CCMM');
gamedata.chpt = strrep(gamedata.chpt,'C_MASC_Finale','CCMM'); % credit mut CD68 saison 16-17
gamedata.chpt = strrep(gamedata.chpt,'DEMI_Finale','Demi_Finale');

gamedata.chpt = strrep(gamedata.chpt,'NM3_1_4_A','NM3_PO');
gamedata.chpt = strrep(gamedata.chpt,'NM3_1_4_R','NM3_PO');
gamedata.chpt = strrep(gamedata.chpt,'NM2_1/4_A','NM2_PO');

%avoid 1/4, 1/2 etc...
if gamedata.chpt(1:3) == 'CCM'
    if gamedata.chpt(1:4) == 'CCMM'
    gamedata.chpt = 'CCMM';
    elseif gamedata.chpt(1:4) == 'CCMF' 
    gamedata.chpt = 'CCMF';
    end
end

% coupe CD33
if gamedata.chpt(1:3) == 'C33'
    if gamedata.chpt(1:6) == 'C33_SM'
    gamedata.chpt = 'C33_SM';
    elseif gamedata.chpt(1:6) == 'C33_SF' 
    gamedata.chpt = 'C33_SF';
    end
end

% coupe de france
if strcmp(gamedata.chpt(1:3), 'TCS')
    if strcmp(gamedata.chpt(1:4), 'TCSM')
        gamedata.chpt = 'CFM';
    elseif strcmp(gamedata.chpt(1:4), 'TCSF')
        gamedata.chpt = 'CFF';
    end
end

if strcmp(gamedata.chpt(1:3), 'SCS')
    if strcmp(gamedata.chpt(1:4), 'SCSO')
        gamedata.chpt = 'SCSO';
    end
end
    
%category with only U17F for example
if strcmp(gamedata.chpt(1:2),'U1') && length(gamedata.chpt) > 5
    gamedata.chpt = [gamedata.chpt(1:4),'_',gamedata.chpt(5:end)];
end


%% Poule 
gamedata.poule = fdmtextcell{linenum-3};
gamedata.poule = strrep(gamedata.poule,'-','');
gamedata.poule = strrep(gamedata.poule,'_','');
gamedata.poule = strrep(gamedata.poule,'UN','');

if strcmp(gamedata.poule,'') == 0 % si le nom de la poule n'est pas vide
    if length(isstrprop(gamedata.poule,'upper')) > 1 || isstrprop(gamedata.poule,'upper') == 0 % si le nom de la poule a plus d'un charactere ou si le charactere n'est pas une lettre
        disp('***************************************************************')
        disp([gamedata.chpt,' ',gamedata.comite])
        disp(['Le nom de la poule est ',gamedata.poule,' qui n''existe pas dans la bdd']);
        gamedata.poule = input('Le nom de la poule est =>');
    end
end

end