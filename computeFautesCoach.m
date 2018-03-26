function [data_fautes_coach] = computeFautesCoach(fdmtextcell,data_coach,gamedata)

%ATTENTION: si coach domicile a meme nom que coach visiteur ca peut etre
%emmerdant
prochelinenumcoach = [];

% ligne ou le nom de l'equipe est ecrit deux lignes de suite. Le nom du
% coach sera pas loin
linenum = find(~cellfun(@isempty,strfind(fdmtextcell,gamedata.domicile)));

if length(linenum) == 1 || linenum(2) - linenum(1) > 5 %ajouter parce que E. BASKET OLTINGUE-DURMENACH s'écrit parfois E BASKET OLTINGUE-DURMENACH
    prochelinenumcoach = linenum(1);
else
    for i = 1 : length(linenum)-1
        if linenum(i+1)-linenum(i) == 1 && isempty(prochelinenumcoach) == 1 %isempty si jamais il y a le nom du club deux lignes à la suite plus tard (ex:marqueur + aide marqueur)
            prochelinenumcoach = linenum(i);
        end
    end
end

%find line where name of coach is written. 
linenum = find(~cellfun(@isempty,strfind(fdmtextcell,data_coach(1).nom)));
  for i = 1 : length(linenum)
      if abs(prochelinenumcoach - linenum(i)) < 3
        linenumcoach = linenum(i);
      end
  end
%read the line to VT. Assume license of coach is VT. this is wrong!    
fautecoach.dom = regexp(fdmtextcell{linenumcoach}, '^(?<type>[^VT]+)', 'names', 'lineanchors');

clear linenum;
clear linenumcoach;
prochelinenumcoach = [];
    
% ligne ou le nom de l'equipe est ecrit deux lignes de suite. Le nom du
% coach sera pas loin
linenum = find(~cellfun(@isempty,strfind(fdmtextcell,gamedata.visiteur)));


if length(linenum) == 1 || linenum(2) - linenum(1) > 5 %ajouter parce que E. BASKET OLTINGUE-DURMENACH s'écrit parfois E BASKET OLTINGUE-DURMENACH
    prochelinenumcoach = linenum(1);
else
    for i = 1 : length(linenum)-1
        if linenum(i+1)-linenum(i) == 1 && isempty(prochelinenumcoach) == 1 %isempty si jamais il y a le nom du club deux lignes à la suite plus tard (ex:marqueur + aide marqueur)
            prochelinenumcoach = linenum(i);
        end
    end
end

%coach visiteur. 
linenum = find(~cellfun(@isempty,strfind(fdmtextcell,data_coach(2).nom)));
 for i = 1 : length(linenum)
      if abs(prochelinenumcoach - linenum(i)) < 3
        linenumcoach = linenum(i);
      end
  end
%read the line to VT. Assume license of coach is VT. this is wrong!
fautecoach.visit = regexp(fdmtextcell{linenumcoach}, '^(?<type>[^VT]+)', 'names', 'lineanchors');

if length(fautecoach.dom) == 1 
    a = strfind(fautecoach.dom.type,'B1');
    data_fautes_coach(1).B1 = length(a);
    a = strfind(fautecoach.dom.type,'C1');
    data_fautes_coach(1).C1 = length(a);   
    a = strfind(fautecoach.dom.type,'D2');
    data_fautes_coach(1).D2 = length(a);
else
    data_fautes_coach(1).B1 = 0;
    data_fautes_coach(1).C1 = 0;
    data_fautes_coach(1).D2 = 0;
end

if length(fautecoach.visit) == 1
    a = strfind(fautecoach.visit.type,'B1');
    data_fautes_coach(2).B1 = length(a);
    a = strfind(fautecoach.visit.type,'C1');
    data_fautes_coach(2).C1 = length(a);
    a = strfind(fautecoach.visit.type,'D2');
    data_fautes_coach(2).D2 = length(a);
else
    data_fautes_coach(2).B1 = 0;
    data_fautes_coach(2).C1 = 0; 
    data_fautes_coach(2).D2 = 0;
end

end