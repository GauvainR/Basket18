function [nom_club,numero_club,listeClubs,sqlClubs] = checkClubExist(nom_club,numero_club,listeClubs,sqlClubs,season,gamedata,nom_equipe)
    % recherche des indices ou il y a le numero de club
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
           
           if strcmp(listeClubs{ligne,2},numero_club)
                index_numero(kk) = ligne;
                kk = kk+1;
           end
       end
       
       % si on a pas trouvé ni de nom, ni de numero dans les deux premieres
       % colonnes, on cherche s'il y a un numero dans les 3e et + colonnes
       % Car si numero club est celui de la 3e colonne et le nom du club
       % est différent (ex: BNS) alors club pas détecté comme le meme
       if isempty(index_nom) && isempty(index_numero)
            for ligne = 1: sizeListeClubs(1)
                for col = 2 : sizeListeClubs(2)
                    if strcmp(listeClubs{ligne,col},numero_club)
                        index_numero(kk) = ligne;
                        kk = kk+1;
                    end
                end
            end
       end
                    
      
       doesClubExist = false;
       % si rien ne correspond dans listeClubs
       if isempty(index_nom) && isempty(index_numero)
           % on ajoute le club a listeClubs
           listeClubs{end+1,1} = nom_club;
           listeClubs{end,2} = numero_club;
           
           % on demande la ville ou joue le club
           disp(' ')
           disp('*************************************************************')
           disp(['Un nouveau club: ', nom_club,' ',numero_club])
           commune = input('Quelle est la commune ?');
           commune = strrep(commune,' ','_');
           
           % on ajoute le club dans la table club
           sqlClubs = sprintf([sqlClubs,'INSERT INTO club (nom_club,numero_club,ligue,comite,commune) ']);
           sqlClubs = sprintf([sqlClubs,'VALUES (''',nom_club,''',''',numero_club,''',''',numero_club(1:2),''',''',numero_club(3:4),''',''',commune,''');']);
           sqlClubs = sprintf([sqlClubs,'\n\n']);
           
          %Requete qui initialise le equipes.club_id
           sqlClubs = sprintf([sqlClubs,'UPDATE equipes SET club_id=(SELECT id_club FROM club WHERE nom_club=''',nom_club,''' AND numero_club=''',numero_club,''') ']);
           sqlClubs = sprintf([sqlClubs,'WHERE comite_id= (SELECT id_comite FROM comite WHERE nom_comite= ''',gamedata.comite,''') AND nom_equipe=''',nom_equipe,''' AND saison_id=(SELECT id_saison FROM saison WHERE annee=',season,') AND  competition_id=(SELECT id_competition FROM competition WHERE (chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt= ''',gamedata.chpt,''') AND poule_id=(SELECT id_poule FROM poule WHERE nom_poule=''',gamedata.poule,''')));']);
           sqlClubs = sprintf([sqlClubs,'\n\n']);
           
           doesClubExist = true;       
       
       elseif length(index_nom) == 1 && length(index_numero) == 1 && strcmp(listeClubs{index_nom(1),1},nom_club) && strcmp(listeClubs{index_nom(1),2},numero_club) 
           % Si on a trouvé un club au meme nom et 1 au meme numero et que
       % c'est le meme index alors le club existe
       % C'est ce qui devrait arriver le plus souvent
           doesClubExist = true;
                 
           %Requete qui initialise le equipes.club_id
           sqlClubs = sprintf([sqlClubs,'UPDATE equipes SET club_id=(SELECT id_club FROM club WHERE nom_club=''',nom_club,''' AND numero_club=''',listeClubs{index_numero(1),2},''') ']);
           sqlClubs = sprintf([sqlClubs,'WHERE comite_id= (SELECT id_comite FROM comite WHERE nom_comite= ''',gamedata.comite,''') AND nom_equipe=''',nom_equipe,''' AND saison_id=(SELECT id_saison FROM saison WHERE annee=',season,') AND  competition_id=(SELECT id_competition FROM competition WHERE (chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt= ''',gamedata.chpt,''') AND poule_id=(SELECT id_poule FROM poule WHERE nom_poule=''',gamedata.poule,''')));']);
           sqlClubs = sprintf([sqlClubs,'\n\n']);
           
       elseif length(index_nom) ~= length(index_numero) && length(index_nom)==1 && length(index_numero)>0
           % si la longeur de index numero et index nom est differente et que il y a un seul nom qui est similaire
           % il est possible que le club fasse partie d'une CTC alors on
           % regarde tous les index_numero pour voir s'il y en a un seul
           % qui colle aussi pour le nom
           nbNomsClubsCorresp = 0;
           % boucle for pour compter le nombre de fois ou le nom de club
           % correspond quand le numero est le bon
           for idx = 1 : length(index_numero)
               if strcmp(listeClubs{index_numero(idx), 1}, nom_club)
                   nbNomsClubsCorresp = nbNomsClubsCorresp + 1;
               end
           end
           
           % si nom club correspond que une fois alors
           if nbNomsClubsCorresp == 1
               numero_club = listeClubs{index_numero(idx),2};
               doesClubExist = true;

               %Requete qui initialise le equipes.club_id
               sqlClubs = sprintf([sqlClubs,'UPDATE equipes SET club_id=(SELECT id_club FROM club WHERE nom_club=''',nom_club,''' AND numero_club=''',numero_club,''') ']);
               sqlClubs = sprintf([sqlClubs,'WHERE comite_id= (SELECT id_comite FROM comite WHERE nom_comite= ''',gamedata.comite,''') AND nom_equipe=''',nom_equipe,''' AND saison_id=(SELECT id_saison FROM saison WHERE annee=',season,') AND  competition_id=(SELECT id_competition FROM competition WHERE (chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt= ''',gamedata.chpt,''') AND poule_id=(SELECT id_poule FROM poule WHERE nom_poule=''',gamedata.poule,''')));']);
               sqlClubs = sprintf([sqlClubs,'\n\n']);
               
           elseif nbNomsClubsCorresp == 0
               % normalement c'est impossible, on met un input si jamais
               disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
               input('normalement on arrive pas la!! (checkClubExist)')
               
           elseif nbNomsClubsCorresp>1
               % si on est la alors il y a deux entrees qui ont le meme nom
               % et le meme numero dans la structure listeClubs c'est un
               % probleme et ne devrait theoriquement pas arriver
               disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
               input('Il semble qu''un club est enregistré deux fois dans listeClubs')
           end
           
       else
           for i = 1 : length(index_nom)
               if doesClubExist == false
                      % si le numero du club commence par 00 alors on dit que le club est le meme et qu'on ne change pas le numero
                      if strcmp(numero_club(1:2),'00') 
                        changerNumClub = 1;
                      end
                      % on regarde s'il y a dans les colonnes suivantes un
                      % numero de club qui correspond au numero actuel (
                      % ajouté parce qu'il y a des CTC qui ont plusieurs
                      % numéros de clubs)
                      tailleListeClubs = size(listeClubs);
                      for idx = 2 : tailleListeClubs(2)
                          if strcmp(listeClubs{index_nom(1), idx}, numero_club)
                              % si un des numeros suivants la deuxieme
                              % colonne est le meme que le numero courant
                              % de la fdm alors c'est le meme club
                              changerNumClub = 1;
                          end
                      end
                      
                     
                      
                      if exist('changerNumClub', 'var') == 0 % si changerNumClub n'existe pas on a pas trouvé de numéro de club équivalent dans la ligne du club 
                          
                          disp('****************************************************')
                          disp('Un club a le meme nom mais pas le meme numero')
                          disp('listeClubs:')
                          disp(['nom: ', listeClubs{index_nom(i),1}])
                          disp(['numero: ', listeClubs{index_nom(i),2}])
                          disp('match actuel:')
                          disp(['nom: ', nom_club])
                          disp(['numero: ', numero_club])
                          disp('Est-ce le meme club ?')
                          disp('(on a vérifié les numéros suivants de la ligne)')
                          disp('1: oui, 2: non, 3: oui + chgt de numero dans listeClubs')
                          disp('4: oui + ajout du numéro de club a la suite de la ligne');
                          changerNumClub = input('==> ');
                      end
                  

                       switch changerNumClub
                           case 1
                               numero_club = listeClubs{index_nom(i),2};
                               doesClubExist = true;

                               %Requete qui initialise le equipes.club_id
                               sqlClubs = sprintf([sqlClubs,'UPDATE equipes SET club_id=(SELECT id_club FROM club WHERE nom_club=''',nom_club,''' AND numero_club=''',numero_club,''') ']);
                               sqlClubs = sprintf([sqlClubs,'WHERE comite_id= (SELECT id_comite FROM comite WHERE nom_comite= ''',gamedata.comite,''') AND nom_equipe=''',nom_equipe,''' AND saison_id=(SELECT id_saison FROM saison WHERE annee=',season,') AND  competition_id=(SELECT id_competition FROM competition WHERE (chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt= ''',gamedata.chpt,''') AND poule_id=(SELECT id_poule FROM poule WHERE nom_poule=''',gamedata.poule,''')));']);
                               sqlClubs = sprintf([sqlClubs,'\n\n']);
                           case 2
                                %on fait rien

                           case 3
                               listeClubs{index_nom(i),2} = numero_club;
                               doesClubExist = true;
                               % chgt de numero de club dans bdd
                               sqlClubs = sprintf([sqlClubs,'UPDATE club SET numero_club=''',numero_club,''', ligue=''',numero_club(1:2),''', comite=''',numero_club(3:4),'''']);
                               sqlClubs = sprintf([sqlClubs,' WHERE nom_club=''',nom_club,''';']);
                               sqlClubs = sprintf([sqlClubs,'\n\n']);

                               %Requete qui initialise le equipes.club_id
                               sqlClubs = sprintf([sqlClubs,'UPDATE equipes SET club_id=(SELECT id_club FROM club WHERE nom_club=''',nom_club,''' AND numero_club=''',numero_club,''') ']);
                               sqlClubs = sprintf([sqlClubs,'WHERE comite_id= (SELECT id_comite FROM comite WHERE nom_comite= ''',gamedata.comite,''') AND nom_equipe=''',nom_equipe,''' AND saison_id=(SELECT id_saison FROM saison WHERE annee=',season,') AND  competition_id=(SELECT id_competition FROM competition WHERE (chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt= ''',gamedata.chpt,''') AND poule_id=(SELECT id_poule FROM poule WHERE nom_poule=''',gamedata.poule,''')));']);
                               sqlClubs = sprintf([sqlClubs,'\n\n']);
                               
                           case 4
                               % on ajoute le numero courant du club a la
                               % suite des numéros existants
                               for idx = 2 : tailleListeClubs(2)
                                   if isempty(listeClubs{index_nom(1), idx})
                                    % si une cellule est vide alors on
                                    % ajoute dans cette cell le numero
                                    listeClubs{index_nom(1), idx} = numero_club;
                                    % le numero du club est celui du premier
                                    % rentré dans la colonne
                                    numero_club = listeClubs{index_nom(1),2};
                                    doesClubExist = true;
                                    
                                    break
                                   end
                               end
                               
                               if doesClubExist ~= true
                                   % on ajoute une autre colonne avec le
                                   % nouveau numero du club
                                   listeClubs{index_nom(1), idx+1} = numero_club;
                                   % le numero du club est celui du premier
                                    % rentré dans la colonne
                                    numero_club = listeClubs{index_nom(1),2};
                                    doesClubExist = true;
                               end
                               
                               %Requete qui initialise le equipes.club_id
                               sqlClubs = sprintf([sqlClubs,'UPDATE equipes SET club_id=(SELECT id_club FROM club WHERE nom_club=''',nom_club,''' AND numero_club=''',numero_club,''') ']);
                               sqlClubs = sprintf([sqlClubs,'WHERE comite_id= (SELECT id_comite FROM comite WHERE nom_comite= ''',gamedata.comite,''') AND nom_equipe=''',nom_equipe,''' AND saison_id=(SELECT id_saison FROM saison WHERE annee=',season,') AND  competition_id=(SELECT id_competition FROM competition WHERE (chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt= ''',gamedata.chpt,''') AND poule_id=(SELECT id_poule FROM poule WHERE nom_poule=''',gamedata.poule,''')));']);
                               sqlClubs = sprintf([sqlClubs,'\n\n']);
                       
                  end
               end
           end
                    
           for i = 1 : length(index_numero)
               if doesClubExist == false
                   disp('****************************************************')
                   disp('Un club a le meme numero mais pas le meme nom');
                   disp('listeClubs:')
                   disp(['nom: ', listeClubs{index_numero(i),1}])
                   disp(['numero: ', listeClubs{index_numero(i),2}])
                   disp('match actuel:')
                   disp(['nom: ', nom_club])
                   disp(['numero: ', numero_club])
                   disp('Est-ce le meme club ?')
                   changerNomClub = input('1: oui, 2: non, 3: oui + chgt de nom dans listeClubs');

                   switch changerNomClub
                       case 1
                           nom_club = listeClubs{index_numero(i),1};
                           doesClubExist = true;
                           
                           %Requete qui initialise le equipes.club_id
                           sqlClubs = sprintf([sqlClubs,'UPDATE equipes SET club_id=(SELECT id_club FROM club WHERE nom_club=''',nom_club,''' AND numero_club=''',numero_club,''') ']);
                           sqlClubs = sprintf([sqlClubs,'WHERE comite_id= (SELECT id_comite FROM comite WHERE nom_comite= ''',gamedata.comite,''') AND nom_equipe=''',nom_equipe,''' AND saison_id=(SELECT id_saison FROM saison WHERE annee=',season,') AND  competition_id=(SELECT id_competition FROM competition WHERE (chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt= ''',gamedata.chpt,''') AND poule_id=(SELECT id_poule FROM poule WHERE nom_poule=''',gamedata.poule,''')));']);
                           sqlClubs = sprintf([sqlClubs,'\n\n']);
                       case 2
                            %on fait rien
                            
                       case 3
                            listeClubs{index_numero(i),1} = nom_club;
                            doesClubExist = true;
                            
                            % chgt de numero de club dans bdd
                           sqlClubs = sprintf([sqlClubs,'UPDATE club SET nom_club=''',nom_club,'''']);
                           sqlClubs = sprintf([sqlClubs,'WHERE numero_club=''',numero_club,''';']);
                           sqlClubs = sprintf([sqlClubs,'\n\n']);
                           
                           %Requete qui initialise le equipes.club_id
                           sqlClubs = sprintf([sqlClubs,'UPDATE equipes SET club_id=(SELECT id_club FROM club WHERE nom_club=''',nom_club,''' AND numero_club=''',numero_club,''') ']);
                           sqlClubs = sprintf([sqlClubs,'WHERE comite_id= (SELECT id_comite FROM comite WHERE nom_comite= ''',gamedata.comite,''') AND nom_equipe=''',nom_equipe,''' AND saison_id=(SELECT id_saison FROM saison WHERE annee=',season,') AND  competition_id=(SELECT id_competition FROM competition WHERE (chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt= ''',gamedata.chpt,''') AND poule_id=(SELECT id_poule FROM poule WHERE nom_poule=''',gamedata.poule,''')));']);
                           sqlClubs = sprintf([sqlClubs,'\n\n']);
                   end
               end
           end
       end
       
       if doesClubExist == false
           
           % on demande la ville ou joue le club
           disp(' ')
           disp('*************************************************')
           disp(['Un nouveau club: ', nom_club,' ',numero_club])
           disp('Quelle est la commune (entre guillemets)?')
           commune = input(' --> ');
           commune = strrep(commune,' ','_');
           
           listeClubs{end+1,1} = nom_club;
           listeClubs{end,2} = numero_club;
                           
           % on ajoute le club dans la table club
           sqlClubs = sprintf([sqlClubs,'INSERT INTO club (nom_club,numero_club,ligue,comite,commune) ']);
           sqlClubs = sprintf([sqlClubs,'VALUES (''',nom_club,''',''',numero_club,''',''',numero_club(1:2),''',''',numero_club(3:4),''',''',commune,''');']);
           sqlClubs = sprintf([sqlClubs,'\n\n']);
           
          %Requete qui initialise le equipes.club_id
           sqlClubs = sprintf([sqlClubs,'UPDATE equipes SET club_id=(SELECT id_club FROM club WHERE nom_club=''',nom_club,''' AND numero_club=''',numero_club,''') ']);
           sqlClubs = sprintf([sqlClubs,'WHERE comite_id= (SELECT id_comite FROM comite WHERE nom_comite= ''',gamedata.comite,''') AND nom_equipe=''',nom_equipe,''' AND saison_id=(SELECT id_saison FROM saison WHERE annee=',season,') AND  competition_id=(SELECT id_competition FROM competition WHERE (chpt_id=(SELECT id_chpt FROM chpt WHERE nom_chpt= ''',gamedata.chpt,''') AND poule_id=(SELECT id_poule FROM poule WHERE nom_poule=''',gamedata.poule,''')));']);
           sqlClubs = sprintf([sqlClubs,'\n\n']);
       end
           

end