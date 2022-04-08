# encoding: UTF-8

# encoding: UTF-8

# encoding: UTF-8

##
# Auteur GR4
# Version 0.1 : Date : Mon Mar 14 17:55:41 CET 2022
#

require 'yaml'
require 'gtk3'
load 'OS.rb'
class Profil

	#L'id de ce profil
	attr_accessor:idProfil

	#Le pseudo de ce profil
	attr_accessor:nom

	#Le nombre de profil qui existe
	@@nbProfil = 0

	#Le tableau des profils
	@@listeProfil = []


	#L'initialisation d'un nouveau profil
	def initialize(unNom)
		@idProfil, @nom = @@nbProfil, unNom
		@@nbProfil += 1
		@@listeProfil << self
	end

	def Profil.getTabProfil
		return @@listeProfil
	end

	def Profil.getProfilAt(unId)
		return @@listeProfil[unId]
	end

	def getNom
		return @nom
	end

	def getId
		return @idProfil
	end

	def Profil.setJeu(leJeu)
		@@jeu = leJeu
	end

	def Profil.getJeu
		return @@jeu
	end

	#La méthode pour créer un profil
	def Profil.creerProfil(unNom)
		new(unNom)
	end

	#La méthode pour supprimer un profil
	def Profil.supprimer(unId)
		@@nbProfil -= 1

		@@listeProfil.delete_at(unId)
		@@listeProfil.each{|profil|
			if profil.idProfil >= unId then profil.idProfil -= 1
			end
		}
	end

	#La méthode pour modifier le pseudo d'un profil
	def Profil.changerNom(unId, unNom)
		@@listeProfil[unId].nom = unNom
	end

	#Une méthode de test qui affiche tous les profils
	def Profil.afficherListeProfil
		puts 'La liste des profil : '
		@@listeProfil.each{|profil|
			print profil.idProfil
			print ' '
			puts profil.nom }
	end

	#La méthode pour vérifié qu'un pseudo n'éxiste pas déja
	def Profil.existePseudo(unPseudo)
		@@listeProfil.each{|profil|
			if profil.nom.eql?(unPseudo) then
				return true
			end
		}
		return false
	end

	#Vérification de la création d'un dossier Profil, si il y en a pas on le creer
	def Profil.creerDossier
		if(!Dir.exist?("Sauvegarde"))
			Dir.mkdir("Sauvegarde")
		end
		if(!Dir.exist?("Sauvegarde/Profil"))
			Dir.mkdir("Sauvegarde/Profil")
		end
	end

	#Sauvegarde la liste de profil
	def Profil.sauvegarde
		Profil.creerDossier
		dump=YAML::dump(@@listeProfil)
		file= File.new("Sauvegarde/Profil/profils.sav","w")
		file.write dump
		file.close
	end

	#Charge la liste de profil
	def Profil.charge
		#Vérifie si il y a un fichier profils.sav et si c'est le cas on le met dans cette variable sinon
		#on met nil
		if(OS.windows?)
			list= (File.exist?("Sauvegarde/Profil/profils.sav"))?YAML.unsafe_load(File.read("Sauvegarde/Profil/profils.sav")):nil
		else
			list= (File.exist?("Sauvegarde/Profil/profils.sav"))?YAML.load(File.read("Sauvegarde/Profil/profils.sav")):nil
		end
		if(list!=nil)
			@@listeProfil=list
		else puts "Il n'y a pas de liste de profils dans le dossier Profil"
		end
		return list
	end

	#Supprime le fichier profils.sav
	def Profil.supprimeSauvegarde
		if(File.file?("Sauvegarde/Profil/profils.sav"))
			File.delete("Sauvegarde/Profil/profils.sav")
		end
	end



end # Marqueur de fin de classe
