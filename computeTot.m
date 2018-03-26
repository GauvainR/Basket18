function [data_recap_domicile,data_recap_visiteur] = computeTot(data_recap_domicile,data_recap_visiteur)

row_tot = (numel(data_recap_domicile))+1;

%compute total points scored by players, and store the value in the last
%cell of the column
pts_tot = 0;
for i = 1 : row_tot-1
    pts_tot = pts_tot + str2double(data_recap_domicile(i).pts);
end
data_recap_domicile(row_tot).pts = num2str(pts_tot);


tirs_tot = 0;
for i = 1 : row_tot-1
    tirs_tot = tirs_tot + str2double(data_recap_domicile(i).tirs);
end
data_recap_domicile(row_tot).tirs = num2str(tirs_tot);


troispts_tot = 0;
for i = 1 : row_tot-1
    troispts_tot = troispts_tot + str2double(data_recap_domicile(i).troispts);
end
data_recap_domicile(row_tot).troispts = num2str(troispts_tot);

deuxext_tot = 0;
for i = 1 : row_tot-1
    deuxext_tot = deuxext_tot + str2double(data_recap_domicile(i).deuxext);
end
data_recap_domicile(row_tot).deuxext = num2str(deuxext_tot);

deuxint_tot = 0;
for i = 1 : row_tot-1
    deuxint_tot = deuxint_tot + str2double(data_recap_domicile(i).deuxint);
end
data_recap_domicile(row_tot).deuxint = num2str(deuxint_tot);

lf_tot = 0;
for i = 1 : row_tot-1
    lf_tot = lf_tot + str2double(data_recap_domicile(i).lf);
end 
data_recap_domicile(row_tot).lf = num2str(lf_tot);

ftes_tot = 0;
for i = 1 : row_tot-1
    ftes_tot = ftes_tot + str2double(data_recap_domicile(i).ftes);
end
data_recap_domicile(row_tot).ftes = num2str(ftes_tot);

%compute total for data_recap_visiteur
row_tot = (numel(data_recap_visiteur))+1;

%compute total points scored by players, and store the value in the last
%cell of the column
pts_tot = 0;
for i = 1 : row_tot-1
    pts_tot = pts_tot + str2double(data_recap_visiteur(i).pts);
end
data_recap_visiteur(row_tot).pts = num2str(pts_tot);


tirs_tot = 0;
for i = 1 : row_tot-1
    tirs_tot = tirs_tot + str2double(data_recap_visiteur(i).tirs);
end
data_recap_visiteur(row_tot).tirs = num2str(tirs_tot);


troispts_tot = 0;
for i = 1 : row_tot-1
    troispts_tot = troispts_tot + str2double(data_recap_visiteur(i).troispts);
end
data_recap_visiteur(row_tot).troispts = num2str(troispts_tot);

deuxext_tot = 0;
for i = 1 : row_tot-1
    deuxext_tot = deuxext_tot + str2double(data_recap_visiteur(i).deuxext);
end
data_recap_visiteur(row_tot).deuxext = num2str(deuxext_tot);

deuxint_tot = 0;
for i = 1 : row_tot-1
    deuxint_tot = deuxint_tot + str2double(data_recap_visiteur(i).deuxint);
end
data_recap_visiteur(row_tot).deuxint = num2str(deuxint_tot);

lf_tot = 0;
for i = 1 : row_tot-1
    lf_tot = lf_tot + str2double(data_recap_visiteur(i).lf);
end 
data_recap_visiteur(row_tot).lf = num2str(lf_tot);

ftes_tot = 0;
for i = 1 : row_tot-1
    ftes_tot = ftes_tot + str2double(data_recap_visiteur(i).ftes);
end
data_recap_visiteur(row_tot).ftes = num2str(ftes_tot);

end