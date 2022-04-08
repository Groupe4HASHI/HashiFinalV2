##
# Auteur GR4
# Version 0.1 : Date : Wed Dec 19 15:38:33 CET 2018
#
require 'gtk3'
load 'Menu.rb'
load 'MenuFacile.rb'
load 'MenuMoyen.rb'
load 'MenuDifficile.rb'

class MenuChoixPartie < Menu

	attr_reader :difficulte
	attr_reader :classe

	def initialize
	    super()
	    self.add_from_file("./glade_ressources/MenuChoixPartie.glade")
		# Creation d'une variable d'instance par composant identifié dans glade
		puts "Création des variables d'instances"
		self.objects.each() { |p|
				unless p.builder_name.start_with?("___object")
					puts "\tCreation de la variable d'instance @#{p.builder_name}"
					instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
				end
		}

		@menu = @menuChoixPartie

		@edit = true

		@classe = false
		@difficulte = 0

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

	def commencerPartie
		case @difficulte
		when 0
			MenuFacile.new
		when 1
			MenuMoyen.new
		when 2
			MenuDifficile.new
		end
	end

	def modeFacile
		if @edit then
			@edit = false
			@btnDiffMoyen.set_active(false)
			@btnDiffDifficile.set_active(false)

			@btnDiffFacile.set_sensitive(false)
			@btnDiffMoyen.set_sensitive(true)
			@btnDiffDifficile.set_sensitive(true)

			@edit = true
			@difficulte = 0
		end
	end

	def modeMoyen
		if @edit then
			@edit = false

			@btnDiffFacile.set_active(false)
			@btnDiffDifficile.set_active(false)

			@btnDiffFacile.set_sensitive(true)
			@btnDiffMoyen.set_sensitive(false)
			@btnDiffDifficile.set_sensitive(true)

			@edit = true
			@difficulte = 1
		end
	end

	def modeDifficile
		if @edit then
			@edit = false

			@btnDiffFacile.set_active(false)
			@btnDiffMoyen.set_active(false)

			@btnDiffFacile.set_sensitive(true)
			@btnDiffMoyen.set_sensitive(true)
			@btnDiffDifficile.set_sensitive(false)

			@edit = true
			@difficulte = 2
		end
	end

	def modeEntrainement
		if @edit then
			@edit = false

			@btnModeClasse.set_active(false)

			@btnModeEntrainement.set_sensitive(false)
			@btnModeClasse.set_sensitive(true)

			@edit = true
			@classe = false
		end
	end

	def modeClasse
		if @edit then
			@edit = false

			@btnModeEntrainement.set_active(false)

			@btnModeEntrainement.set_sensitive(true)
			@btnModeClasse.set_sensitive(false)

			@edit = true
			@classe = true
		end
	end
end
