function [gamedata] = categorie(gamedata)

if strcmp(gamedata.chpt(1:2),'DM') || strcmp(gamedata.chpt(1:3) , 'R2M') || strcmp(gamedata.chpt(1:3) , 'R3M') || strcmp(gamedata.chpt(1:3) , 'PNM') || strcmp(gamedata.chpt(1:2) , 'NM')
    gamedata.cat = 'SM';
    
elseif strcmp(gamedata.chpt(1:2) , 'DF') || strcmp(gamedata.chpt(1:3) , 'R2F') || strcmp(gamedata.chpt(1:3) , 'PNF') || strcmp(gamedata.chpt(1:2) , 'NF')
    gamedata.cat = 'SF';
    
elseif strcmp(gamedata.chpt(1) , 'U') && strcmp(gamedata.chpt(4) , 'M')
    gamedata.cat = 'JM';
    
elseif strcmp(gamedata.chpt(1) , 'U') && strcmp(gamedata.chpt(4) , 'F')
    gamedata.cat = 'JF';
    
elseif strcmp(gamedata.chpt(1:2) , 'U9')
    gamedata.cat = 'MI';
    
elseif strcmp(gamedata.chpt(1:3),'CCM') || strcmp(gamedata.chpt(1:3),'CPM') || strcmp(gamedata.chpt(1:3),'CLM') || strcmp(gamedata.chpt(1:3),'CFM')
    gamedata.cat = 'CO';
    
else
    gamedata.cat = 'CO';
end

end
    
