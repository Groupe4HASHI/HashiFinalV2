# encoding: UTF-8

##
# Auteur LeNomDeLEtudiant
# Version 0.1 : Date : Tue Mar 29 09:37:52 CEST 2022
#
require 'gtk3'


class Menu < Gtk::Builder

	#La fenetre graphique du menu
	attr_reader :menu

	#Le jeu
	attr_accessor :jeu

	#La méthode pour afficher un menu
	def afficheToi
		@menu.set_visible(true)
	end

	#La méthode pour cacher un menu
	def fermeToi
		@menu.set_visible(false)
	end

		#Le retour au menu principal
	def retour
		self.fermeToi
		@jeu.menuPrincipal.afficheToi
	end

end # Marqueur de fin de classe
