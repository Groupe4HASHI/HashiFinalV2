require 'gtk3'
load 'Noeud.rb'
load 'Lien.rb'
load 'Victoire.rb'
load 'Sauvegarde.rb'

class Grille < Gtk::Grid

	#Il s'agit d'une classe qui permet de representer une grille de hashi
	#@nomGrille => le nom du fichier où est rechargé la grille(par exemple : "grille1.txt")
	#@niveau => le niveau de difficulté du jeu(facile, moyen, difficile)
	#@lignes => le nombres de lignes de la grille
	#@colonnes => le nombre de colonnes de la grille
	#@undoRedo => un objet UndoRedo
	#@sauvegarde => un objet sauvegarde
	#@tabNoeuds => tableau contenant tout les noeuds
	#@tabLiens => tableau contenant tout les liens
	#@deuxNoeuds => un tableau qui memorise temporairement deux noeuds
	#La grille a les comportements suivants :
	#grilleFini?() => Vérifie si la grille est fini et a été correctement remplis
	#cliquerSurNoeud() => permet de notifier la grille qu'on a cliqué sur un noeud
	#creationLien() => permet d'ajouter un lien entre deux noeuds
	#suppresionLien() => permet de supprimer un lien entre deux noeuds

	attr_accessor :lignes, :colonnes, :undo, :redo
	attr_reader :tabNoeuds, :tabLiens, :difficulte, :niveau, :nomGrille, :sauvegarde, :chargement

	def Grille.creer(unNomGrille,uneDifficulte, unNiveau, nbLignes, nbColonnes)
		new(unNomGrille,uneDifficulte, unNiveau, nbLignes, nbColonnes)
	end

	private_class_method :new

	def initialize(unNomGrille,uneDifficulte, unNiveau, nbLignes, nbColonnes)
		super()
		@nomGrille,@difficulte, @niveau, @lignes, @colonnes = unNomGrille,uneDifficulte, unNiveau, nbLignes, nbColonnes
		@deuxNoeuds = []
		@tabNoeuds = []
		@undo = Array.new
		@redo = Array.new
		@chargement = false
		@hypothese = false
		
		@sauvegarde = Sauvegarde.creer(uneDifficulte, unNiveau,Profil.getProfilAt(Profil.getJeu.menuPrincipal.comboBoxProfil.active))
	end

	#undo un coup qui a déjà été joué
	def appelUndo
		if(!@undo.empty?)
			lienUndo = @undo.pop
			n1 = lienUndo[0]
			n2 = lienUndo[1]
			if lienUndo[2] == 's' && lienUndo[3] == '1st'
				supprimeLien(n1, n2, true)
			else
				ajoutLien(n1, n2, true)
			end
			@redo << lienUndo
		end
	end

	#redo un coup qui a déjà été joué
	def appelRedo
		if(!@redo.empty?)
			lienRedo = @redo.pop
			n1 = lienRedo[0]
			n2 = lienRedo[1]
			if lienRedo[2] == 's' && lienRedo[3] == '1st'
				ajoutLien(n1, n2, true)
			else
				supprimeLien(n1, n2, true)
			end
			@undo << lienRedo
		end
	end

	# Methode qui reagit lorsqu'on clique sur une case
  	def clickReaction()
				for x in 0..(self.lignes-1)
						for y in 0..(self.colonnes-1)
								if (self.get_child_at(y,x).status == 'n')
									self.get_child_at(y,x).set_image(self.get_child_at(y,x).image)
								end
						end
				end

        @deuxNoeuds.first.choixPossible()
        if( @deuxNoeuds.length == 2 )
            @deuxNoeuds.first.annulerChoixPossible()

            l2 = @deuxNoeuds.pop()
            l1 = @deuxNoeuds.pop()

            if lienValide?(l1,l2) == true
                ajoutLien(l1,l2,false)
            end
        end

        return self
  	end

		#Vérifie si la grille est fini et a été correctement remplis
  	def grilleFini?
        for lig in 0..(@lignes - 1)
            for col in 0..(@colonnes - 1)
                noeud = self.get_child_at(col,lig)
                if (noeud.status == 'n')
                    if !noeud.estComplet?
                        return false
                    end
                end
            end
        end
        return true
    end

		#Verifier l'état de la grille, si il y'a dans
		def verifierGrille
			grilleComplete = File.readlines("./grille_complete/#{@difficulte}/grille#{@niveau}.txt").map { |str| str.split(":") }
			tableauxDeNoeud = []
			for x in 0..(self.lignes-1)
					for y in 0..(self.colonnes-1)
							caseGrille = self.get_child_at(y,x)
							if caseGrille.status == 'n' then
								if(caseGrille.nDroit != nil) then
									if ((grilleComplete[x][y+1] == '-') && (caseGrille.nbNoeudsDroit == 2))
											tableauxDeNoeud << caseGrille
											tableauxDeNoeud << caseGrille.nDroit
									elsif ((grilleComplete[x][y+1] == '-') && (caseGrille.estComplet?) && (caseGrille.nbNoeudsDroit == 0))
											tableauxDeNoeud << caseGrille
									elsif ((grilleComplete[x][y+1] == '=') && (caseGrille.estComplet?) && (caseGrille.nbNoeudsDroit == 0))
											tableauxDeNoeud << caseGrille
									elsif ((grilleComplete[x][y+1] == '=') && (caseGrille.estComplet?) && (caseGrille.nbNoeudsDroit == 1))
											tableauxDeNoeud << caseGrille
											tableauxDeNoeud << caseGrille.nDroit
									elsif ( ((grilleComplete[x][y+1] == '|') || (grilleComplete[x][y+1] == 'H')) && ((caseGrille.nbNoeudsDroit == 1) || (caseGrille.nbNoeudsDroit == 2)))
											tableauxDeNoeud << caseGrille
											tableauxDeNoeud << caseGrille.nDroit
									end
								end
								if(caseGrille.nBas != nil)
										if ((grilleComplete[x+1][y] == "|") && (caseGrille.nbNoeudsBas == 2))
												tableauxDeNoeud << caseGrille
												tableauxDeNoeud << caseGrille.nBas
										elsif ((grilleComplete[x+1][y] == '|') && (caseGrille.estComplet?) && (caseGrille.nbNoeudsBas == 0))
												tableauxDeNoeud << caseGrille
										elsif ((grilleComplete[x+1][y] == 'H') && (caseGrille.estComplet?) && (caseGrille.nbNoeudsBas == 0))
												tableauxDeNoeud << caseGrille
										elsif ((grilleComplete[x+1][y] == 'H') && (caseGrille.estComplet?) && (caseGrille.nbNoeudsBas == 1))
												tableauxDeNoeud << caseGrille
												tableauxDeNoeud << caseGrille.nBas
										elsif ( ((grilleComplete[x+1][y] == '-') || (grilleComplete[x+1][y] == '=')) && ((caseGrille.nbNoeudsBas == 1) || (caseGrille.nbNoeudsBas == 2)))
												tableauxDeNoeud << caseGrille
												tableauxDeNoeud << caseGrille.nBas
										end
								end
							end
					end
			end

			for noeud in tableauxDeNoeud
          noeud.brillerOrange
      end
		end

		#Rendre toute la grille non cliquable la grille
		#Ceci arrive lorsque vous avez terminé une grille
		def rendreImage
			for x in 0..(self.lignes-1)
					for y in 0..(self.colonnes-1)
						if self.get_child_at(y, x).status == 'n'
							#image1 = Gtk::Image.new(:file => "./images/Noeud/facile.png")
							#image1.show()
							#self.get_child_at(y, x).image.from_file = "./images/Noeud/#{self.get_child_at(y, x).nbLiens}.jpg"
							self.get_child_at(y, x).set_sensitive(false)
						end
					end
			end
		end

    # Méthode permettant de notifier la grille qu'on a cliqué sur un noeud
    def notification(unNoeud)
        @deuxNoeuds << unNoeud
        clickReaction()
    end

	# Ajoute un lien entre deux noeuds
    def ajoutLien(n1,n2,undoRedoVal)

        # incrémente le nombre de liens sur les noeuds
        n1.incrementeLiens()
        n2.incrementeLiens()

        # Récupèration des cases separant deux noeuds
        liens = lesLiensEntre(n1,n2)

        #cas noeud Haut
        if n1.nHaut == n2
					n1.nbNoeudsHaut = n1.nbNoeudsHaut + 1
					n2.nbNoeudsBas = n2.nbNoeudsBas + 1
            n1.maj
            n2.maj
        elsif n1.nDroit == n2  #cas noeud droit
            n1.nbNoeudsDroit = n1.nbNoeudsDroit + 1
						n2.nbNoeudsGauche = n2.nbNoeudsGauche + 1
            n1.maj
            n2.maj
        elsif n1.nGauche == n2 #cas noeud gauche
            n1.nbNoeudsGauche = n1.nbNoeudsGauche + 1
						n2.nbNoeudsDroit = n2.nbNoeudsDroit + 1
            n1.maj
            n2.maj
        elsif n1.nBas == n2 #cas noeud bas
            n1.nbNoeudsBas = n1.nbNoeudsBas + 1
						n2.nbNoeudsHaut = n2.nbNoeudsHaut + 1
            n1.maj
            n2.maj
        else
            print("Le lien ne peut pas être créé")
				end

				#n1.majNbLiensCourant
        #n2.majNbLiensCourant

        # Ajoute le lien entre deux noeuds
        liens.each do |lien|
            lien.ajouterTrait()
            lien.maj
        end
				if undoRedoVal == true
	        return self
				end
				@undo << [n1, n2, 's', '1st']
				
				@sauvegarde.sauvegardeToi(self, $temps)

				if((self.grilleFini? == true) && ($window != nil))
							self.rendreImage
							@undo.clear
							@redo.clear
							Victoire.creer(@lignes, @colonnes, @difficulte, @niveau)
							if(@difficulte == "niv1")
								image1 = Gtk::Image.new(:file => "./images/facile.png")
						    #image1.show()
								if(@niveau == 1)
									$btn_grille1_facile.set_image(image1)
								elsif(@niveau == 2)
									$btn_grille2_facile.set_image(image1)
								elsif(@niveau == 3)
									$btn_grille3_facile.set_image(image1)
								elsif(@niveau == 4)
									$btn_grille4_facile.set_image(image1)
								elsif(@niveau == 5)
									$btn_grille5_facile.set_image(image1)
								elsif(@niveau == 6)
									$btn_grille6_facile.set_image(image1)
								elsif(@niveau == 7)
									$btn_grille7_facile.set_image(image1)
								elsif(@niveau == 8)
									$btn_grille8_facile.set_image(image1)
								elsif(@niveau == 9)
									$btn_grille9_facile.set_image(image1)
								end
							elsif(@difficulte == "niv2")
								image2 = Gtk::Image.new(:file => "./images/moyen.png")
								if(@niveau == 1)
									$btn_grille1_moyenne.set_image(image2)
								elsif(@niveau == 2)
									$btn_grille2_moyenne.set_image(image2)
								elsif(@niveau == 3)
									$btn_grille3_moyenne.set_image(image2)
								elsif(@niveau == 4)
									$btn_grille4_moyenne.set_image(image2)
								elsif(@niveau == 5)
									$btn_grille5_moyenne.set_image(image2)
								elsif(@niveau == 6)
									$btn_grille6_moyenne.set_image(image2)
								elsif(@niveau == 7)
									$btn_grille7_moyenne.set_image(image2)
								elsif(@niveau == 8)
									$btn_grille8_moyenne.set_image(image2)
								elsif(@niveau == 9)
									$btn_grille9_moyenne.set_image(image2)
								end
							else
								image3 = Gtk::Image.new(:file => "./images/difficile.png")
								if(@niveau == 1)
									$btn_grille1_difficile.set_image(image3)
								elsif(@niveau == 2)
									$btn_grille2_difficile.set_image(image3)
								elsif(@niveau == 3)
									$btn_grille3_difficile.set_image(image3)
								elsif(@niveau == 4)
									$btn_grille4_difficile.set_image(image3)
								elsif(@niveau == 5)
									$btn_grille5_difficile.set_image(image3)
								elsif(@niveau == 6)
									$btn_grille6_difficile.set_image(image3)
								elsif(@niveau == 7)
									$btn_grille7_difficile.set_image(image3)
								elsif(@niveau == 8)
									$btn_grille8_difficile.set_image(image3)
								elsif(@niveau == 9)
									$btn_grille9_difficile.set_image(image3)
								end
							end
				elsif((self.grilleFini? == true) && ($window == nil))
							if(@difficulte == "niv1")
								image1 = Gtk::Image.new(:file => "./images/facile.png")
								#image1.show()
								if(@niveau == 1)
									$btn_grille1_facile.set_image(image1)
								elsif(@niveau == 2)
									$btn_grille2_facile.set_image(image1)
								elsif(@niveau == 3)
									$btn_grille3_facile.set_image(image1)
								elsif(@niveau == 4)
									$btn_grille4_facile.set_image(image1)
								elsif(@niveau == 5)
									$btn_grille5_facile.set_image(image1)
								elsif(@niveau == 6)
									$btn_grille6_facile.set_image(image1)
								elsif(@niveau == 7)
									$btn_grille7_facile.set_image(image1)
								elsif(@niveau == 8)
									$btn_grille8_facile.set_image(image1)
								elsif(@niveau == 9)
									$btn_grille9_facile.set_image(image1)
								end
						elsif(@difficulte == "niv2")
							image2 = Gtk::Image.new(:file => "./images/moyen.png")
							if(@niveau == 1)
								$btn_grille1_moyenne.set_image(image2)
							elsif(@niveau == 2)
								$btn_grille2_moyenne.set_image(image2)
							elsif(@niveau == 3)
								$btn_grille3_moyenne.set_image(image2)
							elsif(@niveau == 4)
								$btn_grille4_moyenne.set_image(image2)
							elsif(@niveau == 5)
								$btn_grille5_moyenne.set_image(image2)
							elsif(@niveau == 6)
								$btn_grille6_moyenne.set_image(image2)
							elsif(@niveau == 7)
								$btn_grille7_moyenne.set_image(image2)
							elsif(@niveau == 8)
								$btn_grille8_moyenne.set_image(image2)
							elsif(@niveau == 9)
								$btn_grille9_moyenne.set_image(image2)
							end
						else
							image3 = Gtk::Image.new(:file => "./images/difficile.png")
							if(@niveau == 1)
								$btn_grille1_difficile.set_image(image3)
							elsif(@niveau == 2)
								$btn_grille2_difficile.set_image(image3)
							elsif(@niveau == 3)
								$btn_grille3_difficile.set_image(image3)
							elsif(@niveau == 4)
								$btn_grille4_difficile.set_image(image3)
							elsif(@niveau == 5)
								$btn_grille5_difficile.set_image(image3)
							elsif(@niveau == 6)
								$btn_grille6_difficile.set_image(image3)
							elsif(@niveau == 7)
								$btn_grille7_difficile.set_image(image3)
							elsif(@niveau == 8)
								$btn_grille8_difficile.set_image(image3)
							elsif(@niveau == 9)
								$btn_grille9_difficile.set_image(image3)
							end
						end
							self.rendreImage
				end

	      return self
    end


    #  Supprime un lien entre deux noeuds
    def supprimeLien(n1, n2, undoRedoVal)
      	# Stockage dans la variable liens les cases separant deux noeuds
      	liens = lesLiensEntre(n1,n2)

      	#maj() des liens
      	if n1.nHaut == n2 #cas noeud haut
					n1.nbNoeudsHaut = 0
					n2.nbNoeudsBas = 0
        elsif n1.nDroit == n2  #cas noeud droit
            n1.nbNoeudsDroit = 0
						n2.nbNoeudsGauche = 0
        elsif n1.nGauche == n2 #cas noeud gauche
            n1.nbNoeudsGauche = 0
						n2.nbNoeudsDroit = 0
        elsif n1.nBas == n2 #cas noeud bas
            n1.nbNoeudsBas = 0
						n2.nbNoeudsHaut = 0
        else
            print("pas de lien entre n1 et n2")
				end

        # Suppression du lien
        liens.each do |lien|
            lien.effacerTout()
						#lien.setDirection("")
            lien.maj
        end

        n1.majNbLiensCourant
        n2.majNbLiensCourant
        n1.maj
        n2.maj

				if undoRedoVal == true
					return self
				end
				@undo << [n1, n2, 'a', '1st']

				@sauvegarde.sauvegardeToi(self, $temps)

        return self
    end

	#Charge tout les voisins d'un noeuds dans les VI de la classe Noeud "nGauche","nDroit", "nHaut" et "nBas"
    def remplirVoisins
        for x in 0..(self.lignes-1)
            for y in 0..(self.colonnes-1)
                if (self.get_child_at(y,x).status == 'n')

                    # DROITE
                    for y2 in (y+1).upto(self.colonnes-1)
                        if (self.get_child_at(y2, x).status == 'n')
                            self.get_child_at(y, x).nDroit = self.get_child_at(y2,x)
                            break
                        end
                    end

                    #BAS
                    for x2 in (x+1).upto(self.lignes-1)
                        if (self.get_child_at(y,x2).status == 'n')
                            self.get_child_at(y,x).nBas = self.get_child_at(y,x2)
                            break
                        end
                    end

                    #HAUT
                    for x2 in (x-1).downto(0)
                        if (self.get_child_at(y,x2).status == 'n')
                            self.get_child_at(y,x).nHaut = self.get_child_at(y,x2)
                            break
                        end
                    end

                    # Gauche
                    for y2 in (y-1).downto(0)
                        if (self.get_child_at(y2,x).status == 'n')
                            self.get_child_at(y,x).nGauche = self.get_child_at(y2,x)
                            break
                        end
                    end
                end
            end
        end

        return self
    end

		#Permet de verifier si un lien est possible entre deux noeuds pour afficher les liens possibles pour un noeud
		def lienValideChoixPossible?(n1, n2)
			if(n1.nHaut != n2 && n1.nDroit != n2 && n1.nBas != n2 && n1.nGauche != n2)
					return false
			end

			#Voisin en haut du noeud
			if(n1.nHaut == n2)
						# cas où les il y aurait un croisement de liens potentiel
							for x2 in (n1.x-1).downto(0)
									if(self.get_child_at(n1.y,x2) == n2)
											break;
									else
											if(self.get_child_at(n1.y,x2).direction == 'h')
													return false
											end
									end
							end
			end

			#Voisin à droite du noeud
			if(n1.nDroit == n2)
							# cas où les il y aurait un croisement de liens potentiel
							for y2 in (n1.y+1).upto(@lignes-1)
									if(self.get_child_at(y2,n1.x) == n2)
											break;
									else
											if(self.get_child_at(y2,n1.x).direction == 'v')
													return false
											end
									end
							end
			end

			#Voisin en bas du noeud
			if(n1.nBas == n2)
							# cas où les il y aurait un croisement de liens potentiel
							for x2 in (n1.x+1).upto(@colonnes-1)
									if(self.get_child_at(n1.y,x2) == n2)
											break;
									else
											if(self.get_child_at(n1.y,x2).direction == 'h')
													return false
											end
									end
							end
			end

			 #Voisin à gauche du noeud
			 if(n1.nGauche == n2)
							# cas où les il y aurait un croisement de liens potentiel
							for y2 in (n1.y-1).downto(0)
									if(self.get_child_at(y2,n1.x) == n2)
											break;
									else
											if( self.get_child_at(y2,n1.x).direction == 'v')
													return false
											end
									end
							end
			end
			return true
		end

		#Permet de verifier si un lien entre deux noeuds peut être valide, c'est-à-dire qu'il y ait pas d'intersection avec un autre lien
    def lienValide?(n1, n2)

            if(n1.nHaut != n2 && n1.nDroit != n2 && n1.nBas != n2 && n1.nGauche != n2)
                return false
            end

						if(n1.estComplet? == true || n2.estComplet? == true)
							supprimeLien(n1,n2, false)
							return false
						end

            #Voisin en haut du noeud
            if(n1.nHaut == n2)
                if(n1.nbNoeudsHaut == 2)
                    supprimeLien(n1,n2, false)
                    return false
                else
                	# cas où les il y aurait un croisement de liens potentiel
                    for x2 in (n1.x-1).downto(0)
                        if(self.get_child_at(n1.y,x2) == n2)
                            break;
                        else
                            if(self.get_child_at(n1.y,x2).direction == 'h')
                                return false
                            end
                        end
                    end
                end
            end

            #Voisin à droite du noeud
            if(n1.nDroit == n2)
                if(n1.nbNoeudsDroit == 2)
                    supprimeLien(n1,n2, false)
                    return false
                else
                    # cas où les il y aurait un croisement de liens potentiel
                    for y2 in (n1.y+1).upto(@lignes-1)
                        if(self.get_child_at(y2,n1.x) == n2)
                            break;
                        else
                            if(self.get_child_at(y2,n1.x).direction == 'v')
                                return false
                            end
                        end
                    end
                end
            end

            #Voisin en bas du noeud
            if(n1.nBas == n2)
                if(n1.nbNoeudsBas == 2)
                    supprimeLien(n1,n2, false)
                    return false
                else
                   	# cas où les il y aurait un croisement de liens potentiel
                    for x2 in (n1.x+1).upto(@colonnes-1)
                        if(self.get_child_at(n1.y,x2) == n2)
                            break;
                        else
                            if(self.get_child_at(n1.y,x2).direction == 'h')
                                return false
                            end
                        end
                    end
                end

            end

             #Voisin à gauche du noeud
             if(n1.nGauche == n2)
                if(n1.nbNoeudsGauche == 2)
                    supprimeLien(n1,n2, false)
                    return false
                else
                    # cas où les il y aurait un croisement de liens potentiel
                    for y2 in (n1.y-1).downto(0)
                        if(self.get_child_at(y2,n1.x) == n2)
                            break;
                        else
                            if( self.get_child_at(y2,n1.x).direction == 'v')
                                return false
                            end
                        end
                    end
                end
            end
        return true
    end

    # Renvoie un tableau contenant les cases separant deux noeuds
    def lesLiensEntre(n1, n2)
        cases = []

        # Noeud voisin en haut
        if(n1.nHaut == n2)

	        for lig in (n1.x-1).downto(0)
	                if(self.get_child_at(n1.y, lig) == n2)
	                    break;
									else
	                    self.get_child_at(n1.y, lig).setDirection('v')
	                    cases << self.get_child_at(n1.y, lig)
	                end
					end
        # Noeud voisin à droite
        elsif(n1.nDroit == n2)

	        for col in (n1.y+1).upto(@colonnes-1)
	                if(self.get_child_at(col, n1.x) == n2)
	                    break;
									else
	                    self.get_child_at(col, n1.x).setDirection('h')
	                    cases << self.get_child_at(col, n1.x)
	                end
					end
		# Noeud voisin à gauche
        elsif(n1.nGauche == n2)

            for col in (n1.y-1).downto(0)
                if(self.get_child_at(col, n1.x) == n2)
                    break;
                else
                    self.get_child_at(col, n1.x).setDirection('h')
                    cases << self.get_child_at(col, n1.x)
                end
            end
        # Noeud voisin en bas
        elsif(n1.nBas == n2)
            for lig in (n1.x+1).upto(@lignes-1)
                if(self.get_child_at(n1.y, lig) == n2)
                    break;
                else
                    self.get_child_at(n1.y, lig).setDirection('v')
                   cases << self.get_child_at(n1.y, lig)
                end
						end
        end
        return cases
    end

	#Méthode qui permet de savoir si il y a une sauvegarde de la grille
	def setChargement(chargement)
		@chargement=chargement
	end

	#Méthode qui permet de savoir si c'est une hypothese
	def setHypothese(hypo)
		@hypothese = hypo
	end
    # Chargement d'une grille depuis un fichier
    def chargeGrille()
		#je vérifie la difficulte pour arriver au bon dossier où se trouve ma grille
		if(@difficulte == "niv1") then
			diff = "Facile"
		elsif(@difficulte == "niv2") then
			diff = "Moyenne"
		else
			diff = "Difficile"
		end
        data = []#va contenir les lignes de la grille.txt
				nom_fich = "grille_ressources/#{diff}/#{@nomGrille}"

		#Parcours de la grille.txt et chaque ligne est mit dans le tableau
		File.foreach(nom_fich) do |line|
            data << line.chomp
        end

        # Chargements des noeuds et des liens
        for i in 0..(data.length() - 1)
            data[i].split(':').each_with_index do | caseGrille, ind|
                # # Création d'une case
                if caseGrille != '0'
                    btn = Noeud.creer(self, Integer(caseGrille),i,ind)
                    @tabNoeuds << btn
                else
                    btn = Lien.creer(self, i, ind)
                end

                #Attacher le noeud ou le lien à la grille
                self.attach(btn, ind,i, 1, 1)
            end
        end
		
		self.remplirVoisins() #Rempli les voisins des noeuds

		if(@chargement == true) then #Si il y a une sauvegarde j'utilise cette méthode pour charger la sauvegarde
			if(@hypothese !=true) #Si c'est une hypothese j'utilise cette méthode pour charger la sauvegarde de l'hypothese
				Sauvegarde.chargeLaGrille(self)
			else 
				Sauvegarde.chargeLaGrilleHypo(self)
			end
		end

        return self
    end

end
