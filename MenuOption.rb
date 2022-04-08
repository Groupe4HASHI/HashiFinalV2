##
# Auteur GR4
# Version 0.1 : Date : Wed Dec 19 15:38:33 CET 2018
#
require 'gtk3'
load 'Menu.rb'
load 'Profil.rb'

class MenuOption < Menu

	def initialize
	    super()
	    self.add_from_file("./glade_ressources/MenuOption.glade")
		# Creation d'une variable d'instance par composant identifié dans glade
		puts "Création des variables d'instances"
		self.objects.each() { |p|
				unless p.builder_name.start_with?("___object")
					puts "\tCreation de la variable d'instance @#{p.builder_name}"
					instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
				end
		}

		@menu = @menuOption

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

	#La méthode pour mettre à jour les combobox
	def updateComboBox
		@comboBoxSelectProfilOption.remove_all
		@jeu.menuPrincipal.comboBoxProfil.remove_all

		Profil.getTabProfil.each{|profil|
			@comboBoxSelectProfilOption.append_text(profil.nom)
			@jeu.menuPrincipal.comboBoxProfil.append_text(profil.nom)
		}

		@comboBoxSelectProfilOption.set_active(0)
		@jeu.menuPrincipal.comboBoxProfil.set_active(0)
	end

	#Méthode de vérification de la validité du texte saisie par l'utilisateur pour modifier ou créer des profils
	def updateEntryNomProfil
		if (@entryNomProfil.text == "" || @entryNomProfil.text.start_with?(" ") || Profil.existePseudo(@entryNomProfil.text)) then
			@btnCreerProfil.set_sensitive(false)
			@btnRenommerProfil.set_sensitive(false)
		else
			@btnCreerProfil.set_sensitive(true)
			@btnRenommerProfil.set_sensitive(true)
		end
	end

	#La méthode pour créer un profil
	#Ajoute le profil à la liste des profils
	#Mets à jour les données dans les combo box
	def creerProfil
		Profil.creerProfil(@entryNomProfil.text)

		updateComboBox

		@entryNomProfil.set_text("")

		Profil.sauvegarde
	end

	#La méthode pour supprimer un profil
	#Enlève le profil de la liste des profils
	#Mets à jour les données dans les combo box
	def supprimerProfil
		idActu = @comboBoxSelectProfilOption.active
		if idActu != 0 then
			Profil.supprimer(idActu)
			updateComboBox
		end
		Profil.sauvegarde
	end

	#La méthode pour modifier le nom d'un profil
	#Mets à jour le profil de la liste des profils
	#Mets à jour les données dans les combo box
	def changerNomProfil
		idActu = @comboBoxSelectProfilOption.active
		if idActu != 0 then
			Profil.changerNom(idActu, @entryNomProfil.text)
			updateComboBox
			@entryNomProfil.set_text("")
		end
		Profil.sauvegarde
	end
end
