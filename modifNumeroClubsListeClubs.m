function [listeClubs] = modifNumeroClubsListeClubs(nom_club,numero_club,listeClubs)
    % recherche des indices ou il y a le numero de licence
       index_nom = [];
       index_numero = [];
       ii = 1;
       kk = 1;
       sizeListeClubs = size(listeClubs);
       for ligne = 1: sizeListeClubs(1)
           if strcmp(listeClubs{ligne,1},nom_club)
                index_nom(ii) = ligne;
                ii = ii+1;
           end
       end
       
       if length(index_nom) == 1 % un seul club détecté avec meme nom
           listeClubs{index_nom(1),2} = numero_club;
       elseif length(index_nom) > 1 
           disp('*********************************************')
           disp('On change numero de club dans liste club')
           disp('Deux clubs ont le meme nom')
           input('arrete le programme et vient ecrire l''algo de modif modifNumeroClubsListeClubs')
       end
           
       
end