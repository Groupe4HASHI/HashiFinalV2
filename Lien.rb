require 'gtk3'
#load 'Noeud.rb'

class Lien < Gtk::Button

	#Un lien a un identifiant, connait les deux noeuds qui lient, le nombre de trait qu'il y a entre ces deux noeuds.
	#Il y aura donc 3 VI:
	#@grille : la grille sur laquelle sera placé le lien
	#@noeudDeb et @noeudFin : les deux noeuds qui pouront être liées par le lien
	#@nbTrait : le nombre de traits actuels entre dans le noeud(s'il est égal à 0 c'est qu'il y a pas de trait)
	#@direction : la direction du lien. Si la valeur est "v" alors ce lien est vertical et si la valeur est "h" alors le lien est horizental.
	#@type : le type du lien (si "-1" c'est un faux lien, "0" pas de lien, "1" un seul lien, "2" un double lien)
	#Un lien sera capable de s'afficher, d'ajouter un trait et d'effacer tout les traits existants.
	#Le Lien aura des paramètres lors de la création, donc on créera une nouvelle méthode de classe "Lien.creer",
	#et on redefinera la méthode initialize en affectant 0 à la VI nbTrait et respectivement aux VI idLien, caseDeb et caseFin, un identifiant, une case de debut et une case de fin.  .

	attr_accessor :nbTrait, :direction, :type, :image
	attr_reader :grille, :x, :y, :status

	def Lien.creer(uneGrille, lig, col)
		new(uneGrille, lig, col)
	end

	private_class_method :new

	def initialize(uneGrille, lig, col)
		super()
		@grille, @x, @y = uneGrille, lig, col
		#super(uneGrille, 0, lig, col)
		@nbTrait = 0
		@status = 'l'
		@direction = ''
		@image = Gtk::Image.new(:file => nil);
		self.set_image(@image)

		#  Retire les contours
    set_relief(Gtk::ReliefStyle::NONE)
    always_show_image = false

		set_sensitive(false)  # Un lien n'est pas cliquable par défaut
	end

	def getDirection
		return @direction
	end

	def setDirection(uneDirection)
		@direction = uneDirection
	end

	def setType(val)
		@nbTrait = val
	end

	def getType()
		return @nbTrait
	end

	def ajouterTrait()
		@nbTrait = @nbTrait + 1
	end

	def effacerTout()
		@nbTrait = 0
		@direction = ''
	end

	#Màj du lien
  def maj()
        if @nbTrait == 0 && @direction== ''
						@image = Gtk::Image.new(:file => nil);
						self.set_image(@image)
        elsif @nbTrait == 1
            # Si direction == "h" alors il est horizontal
            # Sinon il est vertical
            if @direction == 'h'
								if(@grille.lignes == 10 && @grille.colonnes == 7)
								 self.image.from_file= "./images/Lien/1_horiz.png"
						 		elsif(@grille.lignes == 11 && @grille.colonnes == 8)
								 self.image.from_file= "./images/Lien/1moyen_horiz.png"
						 		else(@grille.lignes == 13 && @grille.colonnes == 9)
								 self.image.from_file= "./images/Lien/1difficile_horiz.png"
						 		end
            else
								if(@grille.lignes == 10 && @grille.colonnes == 7)
								 self.image.from_file= "./images/Lien/1_verti.png"
								elsif(@grille.lignes == 11 && @grille.colonnes == 8)
								 self.image.from_file= "./images/Lien/1moyen_verti.png"
								else(@grille.lignes == 13 && @grille.colonnes == 9)
								 self.image.from_file= "./images/Lien/1difficile_verti.png"
								end
            end
        elsif @nbTrait == 2
            if @direction == 'h'
							if(@grille.lignes == 10 && @grille.colonnes == 7)
							 self.image.from_file= "./images/Lien/2_horiz.png"
							elsif(@grille.lignes == 11 && @grille.colonnes == 8)
							 self.image.from_file= "./images/Lien/2moyen_horiz.png"
							else(@grille.lignes == 13 && @grille.colonnes == 9)
							 self.image.from_file= "./images/Lien/2difficile_horiz.png"
							end
            else
							if(@grille.lignes == 10 && @grille.colonnes == 7)
							 self.image.from_file= "./images/Lien/2_verti.png"
							elsif(@grille.lignes == 11 && @grille.colonnes == 8)
							 self.image.from_file= "./images/Lien/2moyen_verti.png"
							else(@grille.lignes == 13 && @grille.colonnes == 9)
							 self.image.from_file= "./images/Lien/2difficile_verti.png"
							end
            end
        end

        return self
  end
end
