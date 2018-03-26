function [fichetech,sqlparmatch] = writeFT(gamedata,data_recap_domicile,data_recap_visiteur,data_coach,data_mt,arbitres,data_fdm_visiteur,data_fdm_domicile,data_qt,totfautes,nblfmanque_domicile,nblfmanque_visiteur,data_tot_domicile,data_tot_visiteur,nbfautescoach,lienFT,sqlparmatch,season)


fichetech = sprintf(lienFT);
fichetech = sprintf([fichetech,gamedata.domicilewithspace,' ']);
%check if handicap at the beginning of the game
if str2double(data_recap_domicile(end).pts) ~= str2double(data_mt(2).domicile)
    handicap = num2str(str2double(data_mt(2).domicile) - str2double(data_recap_domicile(end).pts));
    fichetech = sprintf([fichetech,'(+',handicap,') ']);
end

fichetech = sprintf([fichetech,'<u>',data_mt(2).domicile,' - ',data_mt(2).visiteur,'</u> ',gamedata.visiteurwithspace,' ']);
%check if handicap at the beginning of the game
if str2double(data_recap_visiteur(end).pts) ~= str2double(data_mt(2).visiteur)
    handicap = num2str(str2double(data_mt(2).visiteur) - str2double(data_recap_visiteur(end).pts));
    fichetech = sprintf([fichetech,'(+',handicap,') ']);
end

if length(data_qt) == 5 %prolongations
    fichetech = sprintf([fichetech,'(a.p.)']);
end

fichetech = sprintf([fichetech,'</a>']);

fichetech = sprintf([fichetech,'\n']);

%Arbitres
if length(arbitres) == 2
    fichetech = sprintf([fichetech,'Arbitres: ','MM. ',arbitres{1},' et',arbitres{2}]);
elseif length(arbitres) == 1
    fichetech = sprintf([fichetech,'Arbitre: ','M. ',arbitres{1}]);
end    
    
fichetech = sprintf([fichetech,'\n']);
fichetech = sprintf([fichetech,'Quart-temps: ',data_qt(1).domicile,'-',data_qt(1).visiteur,', ',data_qt(2).domicile,'-',data_qt(2).visiteur,' (',data_mt(1).domicile,'-',data_mt(1).visiteur,'), ']);
fichetech = sprintf([fichetech,data_qt(3).domicile,'-',data_qt(3).visiteur,' (',num2str(str2double(data_mt(1).domicile)+str2double(data_qt(3).domicile)),'-',num2str(str2double(data_mt(1).visiteur)+str2double(data_qt(3).visiteur)),'), ',data_qt(4).domicile,'-',data_qt(4).visiteur]);

if length(data_qt) == 5 % prolongations
    fichetech = sprintf([fichetech,' (',num2str(str2double(data_mt(2).domicile)-str2double(data_qt(5).domicile)),'-',num2str(str2double(data_mt(2).visiteur)-str2double(data_qt(5).visiteur)),'), ',data_qt(5).domicile,'-',data_qt(5).visiteur]);
end

fichetech = sprintf([fichetech,'.']);
fichetech = sprintf([fichetech,'\n\n']);


%% Domicile
%declare  points in which we are going to write names of players and points
points = [];
for i = 1 : numel(data_recap_domicile)-1
    nomjoueur = strrep(data_fdm_domicile(i).nom,'*','');
    nomjoueur = strrep(nomjoueur,'''',' '); 
    points = [points,nomjoueur,' ',data_recap_domicile(i).pts];
    
    %comma after the number of point
    if i < numel(data_recap_domicile)-1
        points = [points,',',' '];
    elseif i == numel(data_recap_domicile)-1
        points = [points,'.'];
    end    
    if i == 5   %à la ligne tous les 5
        points = [points,'\n'];
    end

end

%add fautes, tirs réussis et trois points
fichetech = sprintf([fichetech,gamedata.domicilewithspace,' : ',num2str(str2double(data_tot_domicile.ftes) + nbfautescoach.domicile),' fautes']);

if totfautes.domicile.anti == 0 && totfautes.domicile.tech == 0 && totfautes.domicile.disqua == 0
    fichetech = sprintf([fichetech,'.']);
elseif totfautes.domicile.anti ~= 0 && totfautes.domicile.tech == 0 && totfautes.domicile.disqua == 0
    fichetech = sprintf([fichetech,' (dont ',num2str(totfautes.domicile.anti),' antisportive']);
        if totfautes.domicile.anti>1
        fichetech = sprintf([fichetech,'s']);
        end
    fichetech = sprintf([fichetech,').']);
elseif totfautes.domicile.anti ~= 0 && totfautes.domicile.tech ~= 0 && totfautes.domicile.disqua == 0
    fichetech = sprintf([fichetech,' (dont ',num2str(totfautes.domicile.anti),' antisportive']);
        if totfautes.domicile.anti>1
        fichetech = sprintf([fichetech,'s']);
        end   
    fichetech = sprintf([fichetech,' et ',num2str(totfautes.domicile.tech),' technique']);
        if totfautes.domicile.tech>1
        fichetech = sprintf([fichetech,'s']);
        end 
    fichetech = sprintf([fichetech,').']);
elseif totfautes.domicile.anti ~= 0 && totfautes.domicile.tech == 0 && totfautes.domicile.disqua ~= 0
    fichetech = sprintf([fichetech,' (dont ',num2str(totfautes.domicile.anti),' antisportive']);
        if totfautes.domicile.anti>1
        fichetech = sprintf([fichetech,'s']);
        end
    fichetech = sprintf([fichetech,' et ',num2str(totfautes.domicile.disqua),' disqualifiante']);
        if totfautes.domicile.disqua > 1
        fichetech = sprintf([fichetech,'s']);
        end 
    fichetech = sprintf([fichetech,').']);
elseif totfautes.domicile.anti ~= 0 && totfautes.domicile.tech ~= 0 && totfautes.domicile.disqua ~= 0
    fichetech = sprintf([fichetech,' (dont ',num2str(totfautes.domicile.anti),' antisportive']);
        if totfautes.domicile.anti>1
        fichetech = sprintf([fichetech,'s']);
        end
    fichetech = sprintf([fichetech,', ',num2str(totfautes.domicile.tech),' technique']);
        if totfautes.domicile.tech > 1
        fichetech = sprintf([fichetech,'s']);
        end 
    fichetech = sprintf([fichetech,' et ',num2str(totfautes.domicile.disqua),' disqualifiante']);
        if totfautes.domicile.disqua > 1
        fichetech = sprintf([fichetech,'s']);
        end 
    fichetech = sprintf([fichetech,').']);    
elseif totfautes.domicile.anti == 0 && totfautes.domicile.tech ~= 0 && totfautes.domicile.disqua == 0
    fichetech = sprintf([fichetech,' (dont ',num2str(totfautes.domicile.tech),' technique']);
        if totfautes.domicile.tech > 1
        fichetech = sprintf([fichetech,'s']);
        end 
    fichetech = sprintf([fichetech,').']);
elseif totfautes.domicile.anti == 0 && totfautes.domicile.tech ~= 0 && totfautes.domicile.disqua ~= 0
    fichetech = sprintf([fichetech,' (dont ',num2str(totfautes.domicile.tech),' technique']);
         if totfautes.domicile.tech > 1
        fichetech = sprintf([fichetech,'s']);
        end 
    fichetech = sprintf([fichetech,' et ',num2str(totfautes.domicile.disqua),' disqualifiante']);
        if totfautes.domicile.disqua > 1
        fichetech = sprintf([fichetech,'s']);
        end 
    fichetech = sprintf([fichetech,').']);        
elseif totfautes.domicile.anti == 0 && totfautes.domicile.tech == 0 && totfautes.domicile.disqua ~= 0
    fichetech = sprintf([fichetech,' (dont ',num2str(totfautes.domicile.disqua),' disqualifiante']);
        if totfautes.domicile.disqua > 1
        fichetech = sprintf([fichetech,'s']);
        end 
    fichetech = sprintf([fichetech,').']);      
end

%lf and tirs
fichetech = sprintf([fichetech,'\n',data_tot_domicile.lfreussis,' LF/',num2str(str2double(data_tot_domicile.lfreussis) + nblfmanque_domicile),' (',strrep(num2str(str2double(data_tot_domicile.lfreussis)/(str2double(data_tot_domicile.lfreussis) + nblfmanque_domicile)*100,'%.0f'),'NaN','-'),'&#37). ',data_recap_domicile(end).tirs,' paniers dont ',data_recap_domicile(end).troispts,' &#224 3 points.']);
%add names and points
fichetech = sprintf([fichetech,'\n', points,'\n' ]);
%add coach
fichetech = sprintf([fichetech,'Coach: ',data_coach(1).nom,'.','\n\n']);



%% Visiteurs
points = [];
for i = 1 : numel(data_recap_visiteur)-1
    nomjoueur = strrep(data_fdm_visiteur(i).nom,'*','');
    nomjoueur = strrep(nomjoueur,'''',' ');
    points = [points,nomjoueur,' ',data_recap_visiteur(i).pts];
    
        %comma after the number of point
    if i < numel(data_recap_visiteur)-1
        points = [points,',',' '];
    elseif i == numel(data_recap_visiteur)-1
        points = [points,'.'];
    end  
    if i == 5
        points = [points,'\n'];
    end    
end

%add fautes, tirs réussis et trois points
fichetech = sprintf([fichetech,gamedata.visiteurwithspace,' : ',num2str(str2double(data_tot_visiteur.ftes) + nbfautescoach.visiteur),' fautes']);

if totfautes.visiteur.anti == 0 && totfautes.visiteur.tech == 0 && totfautes.visiteur.disqua == 0
    fichetech = sprintf([fichetech,'.']);
elseif totfautes.visiteur.anti ~= 0 && totfautes.visiteur.tech == 0 && totfautes.visiteur.disqua == 0
    fichetech = sprintf([fichetech,' (dont ',num2str(totfautes.visiteur.anti),' antisportive']);
        if totfautes.visiteur.anti>1
        fichetech = sprintf([fichetech,'s']);
        end
    fichetech = sprintf([fichetech,').']);
elseif totfautes.visiteur.anti ~= 0 && totfautes.visiteur.tech ~= 0 && totfautes.visiteur.disqua == 0
    fichetech = sprintf([fichetech,' (dont ',num2str(totfautes.visiteur.anti),' antisportive']);
        if totfautes.visiteur.anti>1
        fichetech = sprintf([fichetech,'s']);
        end   
    fichetech = sprintf([fichetech,' et ',num2str(totfautes.visiteur.tech),' technique']);
        if totfautes.visiteur.tech>1
        fichetech = sprintf([fichetech,'s']);
        end 
    fichetech = sprintf([fichetech,').']);
elseif totfautes.visiteur.anti ~= 0 && totfautes.visiteur.tech == 0 && totfautes.visiteur.disqua ~= 0
    fichetech = sprintf([fichetech,' (dont ',num2str(totfautes.visiteur.anti),' antisportive']);
        if totfautes.visiteur.anti>1
        fichetech = sprintf([fichetech,'s']);
        end
    fichetech = sprintf([fichetech,' et ',num2str(totfautes.visiteur.disqua),' disqualifiante']);
        if totfautes.visiteur.disqua > 1
        fichetech = sprintf([fichetech,'s']);
        end 
    fichetech = sprintf([fichetech,').']);
elseif totfautes.visiteur.anti ~= 0 && totfautes.visiteur.tech ~= 0 && totfautes.visiteur.disqua ~= 0
    fichetech = sprintf([fichetech,' (dont ',num2str(totfautes.visiteur.anti),' antisportive']);
        if totfautes.visiteur.anti>1
        fichetech = sprintf([fichetech,'s']);
        end
    fichetech = sprintf([fichetech,', ',num2str(totfautes.visiteur.tech),' technique']);
        if totfautes.visiteur.tech > 1
        fichetech = sprintf([fichetech,'s']);
        end 
    fichetech = sprintf([fichetech,' et ',num2str(totfautes.visiteur.disqua),' disqualifiante']);
        if totfautes.visiteur.disqua > 1
        fichetech = sprintf([fichetech,'s']);
        end 
    fichetech = sprintf([fichetech,').']);    
elseif totfautes.visiteur.anti == 0 && totfautes.visiteur.tech ~= 0 && totfautes.visiteur.disqua == 0
    fichetech = sprintf([fichetech,' (dont ',num2str(totfautes.visiteur.tech),' technique']);
        if totfautes.visiteur.tech > 1
        fichetech = sprintf([fichetech,'s']);
        end 
    fichetech = sprintf([fichetech,').']);
elseif totfautes.visiteur.anti == 0 && totfautes.visiteur.tech ~= 0 && totfautes.visiteur.disqua ~= 0
    fichetech = sprintf([fichetech,' (dont ',num2str(totfautes.visiteur.tech),' technique']);
         if totfautes.visiteur.tech > 1
        fichetech = sprintf([fichetech,'s']);
        end 
    fichetech = sprintf([fichetech,' et ',num2str(totfautes.visiteur.disqua),' disqualifiante']);
        if totfautes.visiteur.disqua > 1
        fichetech = sprintf([fichetech,'s']);
        end 
    fichetech = sprintf([fichetech,').']);        
elseif totfautes.visiteur.anti == 0 && totfautes.visiteur.tech == 0 && totfautes.visiteur.disqua ~= 0
    fichetech = sprintf([fichetech,' (dont ',num2str(totfautes.visiteur.disqua),' disqualifiante']);
        if totfautes.visiteur.disqua > 1
        fichetech = sprintf([fichetech,'s']);
        end 
    fichetech = sprintf([fichetech,').']);      
end

fichetech = sprintf([fichetech,'\n',data_tot_visiteur.lfreussis,' LF/',num2str(str2double(data_tot_visiteur.lfreussis) + nblfmanque_visiteur),' (',strrep(num2str(str2double(data_tot_visiteur.lfreussis)/(str2double(data_tot_visiteur.lfreussis) + nblfmanque_visiteur)*100,'%.0f'),'NaN','-'),'&#37;). ',data_recap_visiteur(end).tirs,' paniers dont ',data_recap_visiteur(end).troispts,' &#224 3 points.']);

%add names and points
fichetech = sprintf([fichetech,'\n', points,'\n' ]);
%add coach
fichetech = sprintf([fichetech,'Coach: ',data_coach(2).nom,'.']);

% Requete sql (sql query)
    sqlparmatch = sprintf([sqlparmatch, 'UPDATE parmatch_',season]);
    sqlparmatch = sprintf([sqlparmatch,'\n']);
    sqlparmatch = sprintf([sqlparmatch, 'SET fichetech=''',fichetech,''' \n']);
    sqlparmatch = sprintf([sqlparmatch,'WHERE comite=''',gamedata.comite,''' AND chpt=''',gamedata.chpt,''' AND poule=''',gamedata.poule,''' AND numrencontre=''',gamedata.numrencontre,''';']);
    sqlparmatch = sprintf([sqlparmatch,'\n\n']);

end