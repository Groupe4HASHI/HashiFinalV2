# encoding: UTF-8

##
# Auteur Pierre-Louis Mrozowski
#
require 'gtk3'

class MenuTutoriel < Menu
	def initialize
	    super()
	    @numPage = 0
	    self.add_from_file("./glade_ressources/MenuTutoriel.glade")
		# Creation d'une variable d'instance par composant identifié dans glade
		puts "Création des variables d'instances"
		self.objects.each() { |p|
				if(p.itself.class.to_s == "Gtk::TextBuffer") then
					# L'utilisation de TextBuffer est incompatible avec la recherche de variable d'instance en dessous
				else
					unless p.builder_name.start_with?("___object")
						puts "\tCreation de la variable d'instance @#{p.builder_name} avec la methode "
						instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
					end
				end
		}

		# Validation par l'utilisateur avant de fermer l'appli
		@MenuTutoriel.signal_connect('delete-event') {
			d = Gtk.MessageDialog(transient_for=self, modal=True, buttons=Gtk.ButtonsType.OK_CANCEL)
	        d.props.text = 'Êtes-vous sûr?'
	        response = d.run()
	        d.destroy()

	        if response == Gtk.ResponseType.OK
	            return False
			else
		        return True
	        end
 		}

		@menu = @MenuTutoriel

		@MenuTutoriel.signal_connect('destroy') { puts "Fermeture"; Gtk.main_quit }
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

end

#Passage à la page suivante du tutoriel
def suivant
	if(@numPage != 5)then
		instance_variable_get("@boxTuto#{@numPage}").set_visible(false)
		@numPage = @numPage+1
		instance_variable_get("@boxTuto#{@numPage}").set_visible(true)
	end
end

#Retour à la page précédente du tutoriel
def precedent
	if(@numPage != 0)then
		instance_variable_get("@boxTuto#{@numPage}").set_visible(false)
		@numPage = @numPage-1
		instance_variable_get("@boxTuto#{@numPage}").set_visible(true)
	end
end

#Retour au menu précédent
def retour
	@numPage = 0
	super()
end
