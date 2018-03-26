function [doesJoueursListeJoueursExist,namewithoutspace,listeJoueurs,stats,doesPlayerExist,sqlJoueurs] = checkListeJoueurs(numero_licence,nom_joueur,nom_equipe,listeJoueurs,gamedata,namewithoutspace,stats,sqlJoueurs)
   
    %Verification dans la liste joueurs si le joueur existe
    nom_joueur = strrep(nom_joueur,',','_');
    nom_joueur = strrep(nom_joueur,'-','_');

    % recherche des indices ou il y a le numero de licence
       index = [];
       ii = 1;
       sizeListeJoueurs = size(listeJoueurs);
       for ligne = 1: sizeListeJoueurs(1)
           if strcmp(listeJoueurs{ligne,1},numero_licence)
                index(ii) = ligne;
                ii = ii+1;
           end
       end

       % Recherche si un nom correspond a un des numeros de licence
       doesJoueursListeJoueursExist = false;
       for k = 1:length(index)
           % si le nom dans l deuxieme case est ok, le joueur existe
           if strcmp(listeJoueurs{index(k),2},nom_joueur)
               doesJoueursListeJoueursExist = true;
           end
           % verif nom dans troisieme case
           if isempty(listeJoueurs{index(k),3}) == 0
               if strcmp(listeJoueurs{index(k),3},nom_joueur)
                   doesJoueursListeJoueursExist = true;
                   namewithoutspace = listeJoueurs{index(k),2};
               end
               %verif nom dans 4e case seulement si 3e contenait qqc etc
                if isempty(listeJoueurs{index(k),4}) == 0 
                    if strcmp(listeJoueurs{index(k),4},nom_joueur)
                        doesJoueursListeJoueursExist = true;
                        namewithoutspace = listeJoueurs{index(k),2};
                    end
                    if isempty(listeJoueurs{index(k),5}) == 0 
                        if strcmp(listeJoueurs{index(k),5},nom_joueur)
                            doesJoueursListeJoueursExist = true;
                            namewithoutspace = listeJoueurs{index(k),2};
                        end
                        if isempty(listeJoueurs{index(k),6}) == 0 
                            if strcmp(listeJoueurs{index(k),6},nom_joueur)
                                doesJoueursListeJoueursExist = true;
                                namewithoutspace = listeJoueurs{index(k),2};
                            end
                            if isempty(listeJoueurs{index(k),7}) == 0 
                                if strcmp(listeJoueurs{index(k),7},nom_joueur)
                                    doesJoueursListeJoueursExist = true;
                                    namewithoutspace = listeJoueurs{index(k),2};
                                end
                            end
                        end
                    end
                end
           end
       end


       if doesJoueursListeJoueursExist == false
           for k = 1:length(index)
               disp(' ')
               disp('************************************************')
               disp('Est-ce les memes joueurs?');
               disp([listeJoueurs{index(k),2},' et']);
               disp([nom_joueur,' de ', nom_equipe,' ',gamedata.chpt,' poule ',gamedata.poule])
               disp(' ')
                prompt = '1:oui 2:non 3:oui+changement de nom ---> ';
                reponseInput = input(prompt);
                if reponseInput == 1
                    namewithoutspace= listeJoueurs{index(k),2};
                    doesJoueursListeJoueursExist = true;
                    if isempty(listeJoueurs{index(k),3}) == 1
                        listeJoueurs{index(k),3} = strrep(nom_joueur,' ','_');
                    elseif isempty(listeJoueurs{index(k),4}) == 1
                        listeJoueurs{index(k),4} = strrep(nom_joueur,' ','_');
                    elseif isempty(listeJoueurs{index(k),5}) == 1
                        listeJoueurs{index(k),5} = strrep(nom_joueur,' ','_');
                    elseif isempty(listeJoueurs{index(k),6}) == 1
                        listeJoueurs{index(k),6} = strrep(nom_joueur,' ','_');
                    elseif isempty(listeJoueurs{index(k),7}) == 1
                        listeJoueurs{index(k),7} = strrep(nom_joueur,' ','_');
                    end
                    
                    break  % si les joueurs sont les memes alors on sort de la boucle for. Sinon on va redemander si c'est les memes et seule la derniere reponse sera prise en compte
                    
                elseif reponseInput == 3
                    try % on essaie, si ca marche pas, joueur est d'une autre competition et donc on poeut pas changer le nom
                        stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).(nom_equipe).joueurs.(namewithoutspace) = stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).(nom_equipe).joueurs.(listeJoueurs{index(k),2});
                        stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).(nom_equipe).joueurs = rmfield(stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).(nom_equipe).joueurs,listeJoueurs{index(k),2});
                    catch
                        erreur = ['Changer le nom du joueur ',namewithoutspace,' du comité ',gamedata.comite,' de l''équipe ',nom_equipe,' du championnat ',gamedata.chpt,' de la poule ',gamedata.poule,'.'];
                        erreur = [erreur,'\n\n'];
                        erreur = [erreur,'Son nom est différent dans une autre compétition. Trouver la compétition+ faire le changement dans stats'];
                        erreur = [erreur,'\n\n'];
                        fid = fopen('aVerifier.txt','A');
                        fprintf(fid,'%s\n',erreur);
                        fclose(fid); 
                    end
                    if isempty(listeJoueurs{index(k),3}) == 1
                        listeJoueurs{index(k),3} = listeJoueurs{index(k),2};
                    elseif isempty(listeJoueurs{index(k),4}) == 1
                        listeJoueurs{index(k),4} = listeJoueurs{index(k),2};
                    elseif isempty(listeJoueurs{index(k),5}) == 1
                        listeJoueurs{index(k),5} = listeJoueurs{index(k),2};
                    elseif isempty(listeJoueurs{index(k),6}) == 1
                        listeJoueurs{index(k),6} = listeJoueurs{index(k),2};
                    elseif isempty(listeJoueurs{index(k),7}) == 1
                        listeJoueurs{index(k),7} = listeJoueurs{index(k),2};
                    end

                    sqlJoueurs = sprintf([sqlJoueurs,'UPDATE joueurs SET nom_joueur=''',namewithoutspace,'''']);
                    sqlJoueurs = sprintf([sqlJoueurs,' WHERE (nom_joueur=''',listeJoueurs{index(k),2},''' AND licence=''',numero_licence,''');']);
                    sqlJoueurs = sprintf([sqlJoueurs,'\n\n']);

                    listeJoueurs{index(k),2} = namewithoutspace;
                    doesJoueursListeJoueursExist = true;
                    
                    break  % si les joueurs sont les memes alors on sort de la boucle for. Sinon on va redemander si c'est les memes et seule la derniere reponse sera prise en compte

                else
                    doesJoueursListeJoueursExist = false;
                end   
           end
       end

       %On revérifie si le joueur existe dans la structure stats
       doesPlayerExist = true;
    try
        stats.(gamedata.comite).championnat.(gamedata.chpt).(['Poule_',gamedata.poule]).([nom_equipe]).joueurs.(namewithoutspace);
    catch
        doesPlayerExist = false;
    end
   
end