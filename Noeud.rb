require "gtk3"

class Noeud < Gtk::Button

	#Un noeud connait ses coordonnées en x et y, le nb de lien qu'il doit avoir, le nb de lien qu'il a à un moment donnée.
	#grille : la grille sur laquelle sera placé le noeud
	#@x : l'abcisse du noeud dans la grille
	#@y : l'ordonnee du noeud dans la grille
	#@statut : un caractere : 'n' signifie que c'est un noeud, 'l' signifie que c'est un lien
	#@nbLiens : le nombre de lien à faire relier sur un noeud
	#@nbLiensCourant : le nombre de lien courant relié à un noeud
	#@nGauche : le noeud voisin gauche d'un noeud
	#@nDroit : le noeud voisin droit d'un noeud
	#@nBas : le noeud voisin en bas d'un noeud
	#@nHaut : le noeud voisin en haut d'un noeud
	#@nbNoeudsGauche : le nombre de liens entre un noeud et son noeud voisin gauche(s'il existe)
	#@nbNoeudsDroit : le nombre de liens entre un noeud et son noeud voisin droit(s'il existe)
	#@nbNoeudsBas : le nombre de liens entre un noeud et son noeud voisin au sud(s'il existe)
	#@nbNoeudsHaut : le nombre de liens entre un noeud et son noeud voisin au nord(s'il existe)
	#Il connait aussi ses noeuds gauche, droit, haut et bas.
	#Il est capable de montrer tout les liens possibles à partir de ce noeud.

	attr_reader :grille, :x, :y, :nbLiens, :nbLiensCourant, :status, :type
	attr_accessor :nbNoeudsGauche, :nbNoeudsDroit, :nbNoeudsBas, :nbNoeudsHaut, :image, :nGauche, :nDroit, :nBas, :nHaut

	def Noeud.creer(uneGrille, unNbDeLiens, uneAbcisse, uneOrdonnee)
		new(uneGrille, unNbDeLiens, uneAbcisse, uneOrdonnee)
	end

	private_class_method :new

	def initialize(uneGrille, unNbDeLiens, uneAbcisse, uneOrdonnee)
		super()
		@grille, @nbLiens, @x, @y = uneGrille, unNbDeLiens, uneAbcisse, uneOrdonnee
		@nbLiensCourant = 0
		@nGauche = nil
		@nDroit = nil
		@nBas = nil
		@nHaut = nil
		@nbNoeudsGauche = 0
		@nbNoeudsDroit = 0
		@nbNoeudsBas = 0
		@nbNoeudsHaut = 0
		@status = 'n'

		style_context.add_class('noeud')
    self.set_name("noeud")

		# Charge une image correspondants au noeud
		@type = "#{@nbLiens.to_s}"
		if(@grille.lignes == 10 && @grille.colonnes == 7)
			nom_file = "./images/Noeud/" + @nbLiens.to_s + ".jpg"
			@image = Gtk::Image.new(:file => nom_file)
		elsif(@grille.lignes == 11 && @grille.colonnes == 8)
			nom_file = "./images/Noeud/" + @nbLiens.to_s + "_moyen.jpg"
			@image = Gtk::Image.new(:file => nom_file)
		else(@grille.lignes == 13 && @grille.colonnes == 9)
			nom_file = "./images/Noeud/" + @nbLiens.to_s + "_difficile.jpg"
			@image = Gtk::Image.new(:file => nom_file)
		end
		self.style_context.add_class('noeud')
    self.set_image(@image)

    #  Retire les contours
    set_relief(Gtk::ReliefStyle::NONE)
    always_show_image = false
    signal_connect('clicked') { self.cliquerSurNoeud() }
	end

	#mis a jour du nombre de liens liés au noeud
	def majNbLiensCourant()
		@nbLiensCourant = @nbNoeudsGauche + @nbNoeudsDroit + @nbNoeudsBas + @nbNoeudsHaut
	end

	#Renvoie le nombre de liens restants à un noeud pour qu'il soit complet
	def liensRestants
		return @nbLiens - @nbLiensCourant
	end

	#Renvoie le nombre de liens reliés au noeud
	def lienLiees
        nbLiens = 0

        if( @nHaut != nil )
            nbLiens += @nbNoeudsHaut
            @nbLiensCourant += @nbNoeudsHaut
        end
        if( @nGauche != nil )
            nbLiens += @nbNoeudsGauche
            @nbLiensCourant += @nbNoeudsGauche
        end
        if( @nHaut != nil )
            nbLiens += @nbNoeudsHaut
            @nbLiensCourant += @nbNoeudsHaut
        end
        if( @nDroit != nil )
            nbLiens += @nbNoeudsDroit
            @nbLiensCourant += @nbNoeudsDroit
        end
        return nbLiens
    end

    # Retourne true si le noeud est reliée à tout ses voisins, false sinon
    def estRelieVoisins?
       return self.lienLiees() >= self.noeudVoisins().size
    end

	#Renvoie un tableau contenant les noeuds voisins d'un noeud donné
	def noeudVoisins
		Array nVoisins = Array.new
		if(@nGauche != nil) then
			nVoisins.push(@nGauche)
		end
		if(@nDroit != nil) then
			nVoisins.push(@nDroit)
		end
		if(@nBas != nil) then
			nVoisins.push(@nBas)
		end
		if(@nHaut != nil) then
			nVoisins.push(@nHaut)
		end
		return nVoisins
	end

	#Retourne true si le noeud est complet
	def estComplet?
		return @nbLiens == @nbLiensCourant
	end

	#Renvoie dans un tableau les voisins du noeud qui ne sont pas encore complets
	def voisinsNonComplets
		voisins = self.noeudVoisins
		voisinsNC = Array.new

		voisins.each do |voisin|
			if !voisin.estComplet?
				voisinsNC.push(voisin)
			end
		end
		return voisinsNC
	end

	#Renvoie le nombre de voisins du noeud qui ne sont pas encore complets
	def nbVoisinsNComplets()
        return self.voisinsNonComplets.size
    end

	#incremente le nombre de liens associé au noeud
	def incrementeLiens
		@nbLiensCourant = @nbLiensCourant + 1
	end

	#decremente le nombre de liens associé au noeud
	def decrementeLiens
		@nbLiensCourant = @nbLiensCourant - 1
	end

	#Change la couleur du noeud en orange
	#Cette méthode est appelé
	def brillerOrange
		if(@type == "#{@nbLiens.to_s}")
			if(@grille.lignes == 10 && @grille.colonnes == 7)
				ima = Gtk::Image.new(:file => "./images/Noeud/#{@nbLiens.to_s}_orange.jpg")
			elsif(@grille.lignes == 11 && @grille.colonnes == 8)
				ima = Gtk::Image.new(:file => "./images/Noeud/#{@nbLiens.to_s}moyen_orange.jpg")
			else(@grille.lignes == 13 && @grille.colonnes == 9)
				ima = Gtk::Image.new(:file => "./images/Noeud/#{@nbLiens.to_s}difficile_orange.jpg")
			end
		else
			if(@grille.lignes == 10 && @grille.colonnes == 7)
				ima = Gtk::Image.new(:file => "./images/Noeud/#{@nbLiens.to_s}barre_orange.jpg")
			elsif(@grille.lignes == 11 && @grille.colonnes == 8)
				ima = Gtk::Image.new(:file => "./images/Noeud/#{@nbLiens.to_s}barre_moyen_orange.jpg")
			else(@grille.lignes == 13 && @grille.colonnes == 9)
				ima = Gtk::Image.new(:file => "./images/Noeud/#{@nbLiens.to_s}barre_difficile_orange.jpg")
			end
		end
		self.set_image(ima)

		return self
	end

	#Abel
	def surbriller
		if(@type == "#{@nbLiens.to_s}")
			ima = Gtk::Image.new(:file => "./images/Noeud/#{@nbLiens.to_s}_orange.jpg")
		else
			ima = Gtk::Image.new(:file => "./images/Noeud/#{@nbLiens.to_s}barre_orange.jpg")
		end
		self.set_image(ima)

		return self
	end

	#   Détecter le nombre de voisins avec lequel le Noeud peut faire OU possède EXACTEMENT 1 Lien
  def nbVoisinsUnLien()
        cpt = 0
        for voisin in self.noeudVoisins()
            if(voisin.liensRestants() == 1)
                cpt = cpt + 1
            end
        end
        return cpt
  end

	#Détecter le nombre de voisins avec lequel le Noeud ne peut PAS faire de Lien
  def nbVoisinsZeroLien()
        return( 4 - self.voisinsNonComplets().size() )
  end
  #Détecter le nombre de voisins avec lequel le Noeud peut faire OU possède 2 Liens ou +
  def nbVoisinsDeuxLien()
        cpt = 0
        for voisin in self.noeudVoisins()
            if(voisin.liensRestants() > 1)
                cpt = cpt + 1
            end
        end
        return cpt
  end

	#Met à jour le noeud
    def maj
        if self.estComplet? == true
						@type = "#{@nbLiens.to_s}_barre"
						if(@grille.lignes == 10 && @grille.colonnes == 7)
							@image = Gtk::Image.new(:file => "./images/Noeud/#{@nbLiens.to_s}_barre.jpg")
	            self.set_image(self.image)
						elsif(@grille.lignes == 11 && @grille.colonnes == 8)
							@image = Gtk::Image.new(:file => "./images/Noeud/#{@nbLiens.to_s}moyen_barre.jpg")
	            self.set_image(self.image)
						else(@grille.lignes == 13 && @grille.colonnes == 9)
							@image = Gtk::Image.new(:file => "./images/Noeud/#{@nbLiens.to_s}difficile_barre.jpg")
	            self.set_image(self.image)
						end
        else
						@type = "#{@nbLiens.to_s}"
						if(@grille.lignes == 10 && @grille.colonnes == 7)
							@image = Gtk::Image.new(:file => "./images/Noeud/#{@nbLiens.to_s}.jpg")
	            self.set_image(self.image)
						elsif(@grille.lignes == 11 && @grille.colonnes == 8)
							@image = Gtk::Image.new(:file => "./images/Noeud/#{@nbLiens.to_s}_moyen.jpg")
	            self.set_image(self.image)
						else(@grille.lignes == 13 && @grille.colonnes == 9)
							@image = Gtk::Image.new(:file => "./images/Noeud/#{@nbLiens.to_s}_difficile.jpg")
	            self.set_image(self.image)
						end
            self.style_context.remove_class('complet')
            self.style_context.remove_class('incorrect')
        end

        return self
    end


	#Affiche les noeuds possibles à relier au noeud self
	def choixPossible
		voisins = self.noeudVoisins
		for voisin in voisins
			if voisin != nil && @grille.lienValideChoixPossible?(self, voisin)
				if(@grille.lignes == 10 && @grille.colonnes == 7)
					ima = Gtk::Image.new(:file => "./images/Noeud/#{voisin.nbLiens.to_s}_vert.jpg")
				elsif(@grille.lignes == 11 && @grille.colonnes == 8)
					ima = Gtk::Image.new(:file => "./images/Noeud/#{voisin.nbLiens.to_s}moyen_vert.jpg")
				else(@grille.lignes == 13 && @grille.colonnes == 9)
					ima = Gtk::Image.new(:file => "./images/Noeud/#{voisin.nbLiens.to_s}difficile_vert.jpg")
				end
				voisin.set_image(ima)
			end
		end
	end

	def annulerChoixPossible
		voisins = self.noeudVoisins
		for voisin in voisins
			if voisin != nil
				#if voisin.estComplet? == false
              voisin.style_context.remove_class('possibles')
              voisin.set_image(voisin.image)
				#end
			end
		end
	end

    #methode qui s'execute lorsqu'on clique sur un noeud
    def cliquerSurNoeud()
        @grille.notification(self)
        return self
    end

# 	def montreToutChemin(unePartie)
# 		unePartie.afficheLiensNoeud(self)
# 	end

end
