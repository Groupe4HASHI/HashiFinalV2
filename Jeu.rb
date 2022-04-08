# encoding: UTF-8

##
# Auteur GR4
# Version 0.1 : Date : Wed Dec 19 15:38:33 CET 2018
#
require 'gtk3'
load 'Loader.rb'

class Jeu < Gtk::Builder

	#Tout les menus graphique du jeu
	attr_reader :menuPrincipal
	attr_reader :menuOption
	attr_reader :menuClassement
	attr_reader :menuChoixPartie
	attr_reader :menuApropos
	attr_reader :menuTutoriel

	def initialize
	    super()
	    self.add_from_file("./glade_ressources/Jeu.glade")
		# Creation d'une variable d'instance par composant identifié dans glade
		puts "Création des variables d'instances"
		self.objects.each() { |p|
				unless p.builder_name.start_with?("___object")
					puts "\tCreation de la variable d'instance @#{p.builder_name}"
					instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
				end
		}

		@menuPrincipal = MenuPrincipal.new
		@menuPrincipal.jeu = self
		@gridListeMenu.pack_end(@menuPrincipal.menu)

		@menuOption = MenuOption.new
		@menuOption.jeu = self
		@gridListeMenu.pack_end(@menuOption.menu)
		Profil.creerProfil("Choisir Profil")

		Profil.creerDossier
		Profil.charge
		@menuOption.updateComboBox

		@menuClassement = MenuClassement.new
		@menuClassement.jeu = self
		@gridListeMenu.pack_end(@menuClassement.menu)

		@menuChoixPartie = MenuChoixPartie.new
		@menuChoixPartie.jeu = self
		@gridListeMenu.pack_end(@menuChoixPartie.menu)

		@menuApropos = MenuApropos.new
		@menuApropos.jeu = self
		@gridListeMenu.pack_end(@menuApropos.menu)

		@menuTutoriel = MenuTutoriel.new
		@menuTutoriel.jeu = self
		@gridListeMenu.pack_end(@menuTutoriel.menu)

		Profil.setJeu(self)

		@hashi.show_all
		@hashi.set_size_request(600, 300)
		@hashi.signal_connect('destroy') { puts "Au Revoir !!!"; Gtk.main_quit }
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

	#La méthode pour quitter l'application
	def quitter
		Gtk.main_quit
	end

end

# On lance l'application
builder = Jeu.new()
Gtk.main
