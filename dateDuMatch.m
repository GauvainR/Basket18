function [dateok,datesql,messageErreur] = dateDuMatch(histotextcell,messageErreur)

a = regexp(histotextcell{6}, '\d+', 'match');

datematch = datenum(str2double(a{1,4}),str2double(a{1,3}),str2double(a{1,2}));
datesql = [num2str(2000+str2double(a{1,4})),'-',a{1,3},'-',a{1,2}];
debutsaison = datenum(17,08,01);
finsaison = datenum(18,07,31);

if datematch > debutsaison && datematch < finsaison
    dateok = 1;
else
    dateok = 0;
    messageErreur = [messageErreur,'Le match ',histotextcell{end},' \n n''est pas dans la saison en cours et n''a pas été traité'];
end

end

