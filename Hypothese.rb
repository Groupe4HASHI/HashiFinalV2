load 'Sauvegarde.rb'


#Cette classe est nécessaire pour effectuer une hypothèse lors de notre partie il a besoin de connaître la sauvegarde et la grille.
class Hypothese
# Variables d'instances
	#- save : Correspond à la sauvegarde qui va être utiliser pour sauvegarder la grille à un moment précis
	#- grille : Correspond à la grille de notre jeu 
	attr_reader :save
	attr_reader :grille


	#Nouvelle Méthode de classe de création d'instance sans paramètre.
	
	# Création d'une hypothèse
	def Hypothese.creer(save,grille)
		new(save,grille)
	end
	
	#Méthode d'instance d'initialisation.
	def initialize(save,grille)
		@save, @grille = save, grille
	end

	#Commence l'hypothese en sauvegardant la grille
	def commencerHypo
		@save.sauvegardeToiHypo(@grille,0)
		puts "Commencement de l'hypothèse"
	end 

	#Annule l'hypothèse en rechargeant la grille avec  la sauvegarde précédente
	def annulerHypo
		Sauvegarde.chargeLaGrilleHypo(@grille)
		puts "L'hypothèse a été annulé"
	end
	
	#Valide l'hypothèse en supprimant la sauvegarde de l'hypothèse
	def validerHypo
		@save.supprimeToiHypo
		puts "L'hypothese a été validé"
	end
		


end # Marqueur de fin de classe
