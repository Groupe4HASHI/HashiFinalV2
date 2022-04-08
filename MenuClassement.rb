# encoding: UTF-8

##
# Auteur GR4
# Version 0.1 : Date : Wed Dec 19 15:38:33 CET 2018
#
require 'gtk3'
load 'Menu.rb'
load 'Sauvegarde.rb'

class MenuClassement < Menu
	# Variables d'instances
	# @diff : La difficulté des niveaux
	# @niv : Le niveau dont on consulte le classement
	# @scores : Tableau contenant jusqu'à 10 scores
	attr_accessor :diff, :niv, :scores

	def initialize
	    super()

	    self.add_from_file("./glade_ressources/MenuClassement.glade")
		# Creation d'une variable d'instance par composant identifié dans glade
		puts "Création des variables d'instances"
		self.objects.each() { |p|
				unless p.builder_name.start_with?("___object")
					puts "\tCreation de la variable d'instance @#{p.builder_name}"
					instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
				end
		}

		@menu = @menuClassement
		@diff = 0
		@niv = 0
		@scores = nil
		# On connecte les signaux aux méthodes (qui doivent exister)
		puts "\nConnexion des signaux"
		self.connect_signals { |handler|
				puts "\tConnection du signal #{handler}"
				begin
					method(handler)
				rescue
					puts "\t\t[Attention] Vous devez definir la methode #{handler} :\n\t\t\tdef #{handler}\n\t\t\t\t....\n\t\t\tend\n"
					self.class.send( :define_method, handler.intern) {
						puts "La methode #{handler} n'est pas encore définie.. Arrêt"
						Gtk.main_quit
					}
					retry
				end
		}
	end

	# Retourne la chaine de caractère associée à la difficulté enregistrée
	def getDiffStr
		case @diff
			when 1
				return "facile"
			when 2
				return "moyenne"
			when 3
				return "difficile"
		end
	end

	# Modifie le titre en haut du classement en fonction des options actuelle d'affichage
	def setLabelTitre
		chaine = "<span font='14'> Classement"
		case @diff
			when 1
				chaine = chaine+", difficulté facile"
			when 2
				chaine = chaine+", difficulté moyenne"
			when 3
				chaine = chaine+", difficulté difficile"
		end

		if @niv!=0
			chaine = chaine+" pour le niveau #{@niv.to_s}"
		end
		chaine = chaine+"</span>"
		@lblTitreClassement.set_label(chaine)
	end

	# Affichage de l'élément graphique des scores
	def afficherClassement
		puts "Je veux afficher le niveau "+@niv.to_s+" du mode "+getDiffStr
		setLabelTitre
		@boxListeJoueurs.set_visible(true)
		if(@diff!=0 && @niv!=0)
			afficherScores
		end
	end

	# Affichage des boutons permettant de seletionner pour quel niveau on souhaite voir les scores
	def afficherNiveaux
		puts "Je suis en difficulté "+getDiffStr
		setLabelTitre
		@boxNiveaux.set_visible(true)
		if(@diff!=0 && @niv!=0)
			afficherScores
		end
	end

	# La série de méthodes pour afficher les niveaux et les classements sert à contourner l'impossibilité de passer des méthodes
	# prenant des paramètres dans le gestionnaire de signaux de glade

	def afficherClassement1
		@niv=1
		afficherClassement
	end

	def afficherClassement2
		@niv=2
		afficherClassement
	end

	def afficherClassement3
		@niv=3
		afficherClassement
	end

	def afficherClassement4
		@niv=4
		afficherClassement
	end

	def afficherClassement5
		@niv=5
		afficherClassement
	end

	def afficherClassement6
		@niv=6
		afficherClassement
	end

	def afficherClassement7
		@niv=7
		afficherClassement
	end

	def afficherClassement8
		@niv=8
		afficherClassement
	end

	def afficherClassement9
		@niv=9
		afficherClassement
	end


	def afficherNiveauxFacile
		@diff=1
		afficherNiveaux
	end

	def afficherNiveauxNormal
		@diff=2
		afficherNiveaux
	end

	def afficherNiveauxDifficile
		@diff=3
		afficherNiveaux
	end

	# Récupération des temps dans toutes les sauvegardes, épuration de ceux qui nous interessent(partie finie, niveau que l'on recherche)
	# @return Un tableau de maximum 10 entiers classés en ordre décroissant
	def chargerScores
		res = Array.new
		idSaves = Array.new
		nbSaves = Dir["../Sauvegarde/Save/#{getDiffStr.capitalize}/*.sav"].each{|x| idSaves.push( x.gsub(/\D/, '').to_i )}
		if idSaves!=nil
			puts idSaves.size.to_s
			while idSaves != []
				puts "Sauvegarde no"+idSaves.to_s
				testa = idSaves.first
				save = Sauvegarde.creer(@diff, idSaves.shift)
				save = save.chargeToi
				if save.nil?
					puts "Cette sauvegarde est cassée"
				else
					puts "Infos sauvegarde n°#{testa}"
					puts save.to_s
					puts @niv.to_s
					puts "Fin infos sauvegarde"

					if(save.finie==1) and (save.niveau==@niv)
						puts save.to_s
						res.push(save.temps)
					end
				end
			end
		end
		return res.sort.take(10)

	end

	# Affichage graphique des scores récupérés par la méthode chargerScore
	def afficherScores
		@scores = Array.new(chargerScores)
		for i in 1..10 do
			#instance_variable_get("@score#{i}").set_label("Score "+i.to_s+" diff "+getDiffStr+" niv "+niv.to_s)
			if(scores!=[])
				while(scores.first==0)
					scores.shift
				end
				instance_variable_get("@score#{i}").set_label("<span font='10'>#{scores.shift.to_s}</span>")
			else
				instance_variable_get("@score#{i}").set_label("<span font='10'>0</span>")
			end
		end
	end

	#Remise à zéro de ce menu et retour au menu précédent
	def retour
		@diff = 0
		@niv = 0
		@scores = nil
		@boxListeJoueurs.set_visible(false)
		@boxNiveaux.set_visible(false)
		setLabelTitre
		super()
	end

end
