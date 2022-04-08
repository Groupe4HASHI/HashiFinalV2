# encoding: UTF-8

require 'yaml'
require 'gtk3'
load 'OS.rb'
load 'Noeud.rb'
load 'Lien.rb'
load 'Profil.rb'
class Sauvegarde
#Une sauvegarde possède le temps du chronomètre, la difficulté de la partie, le niveau de la partie et le profil de celui qui joue.

# Variables d'instances
	# @temps : La durée de la partie est sauvegardé
	# @difficulte : La difficulté de la grille est sauvegardé
	# @niveau : Le niveau de la grille est sauvegardé
	# @finie : Pour savoir si la partie est finie ou non
	# @profil : Le profil utilisé est sauvegardé
	attr_reader  :temps ,:difficulte ,:niveau, :finie
	private_class_method :new



	#Nouvelle Méthode de classe de création d'instance avec les paramètres:
	# -difficulte
	# -niveau
	# -profil
	# Création d'une sauvegarde
	def Sauvegarde.creer(difficulte,niveau,profil)
		new(difficulte,niveau,profil)
	end
	#Méthode d'instance d'initialisation sans paramètre.
	def initialize(difficulte,niveau,profil)
		@difficulte,@niveau,@profil=difficulte,niveau,profil
		@temps=0
		@finie = 0
	end



	#Création des dossiers d'emplacements des sauvegardes
	def Sauvegarde.creerDossier
		if(!Dir.exist?("Sauvegarde"))
			Dir.mkdir("Sauvegarde")
		end
		if(!Dir.exist?("Sauvegarde/Save"))
			Dir.mkdir("Sauvegarde/Save")
		end
		if(!Dir.exist?("Sauvegarde/Save/Facile"))
			Dir.mkdir("Sauvegarde/Save/Facile")
		end
		if(!Dir.exist?("Sauvegarde/Save/Moyenne"))
			Dir.mkdir("Sauvegarde/Save/Moyenne")
		end
		if(!Dir.exist?("Sauvegarde/Save/Difficile"))
			Dir.mkdir("Sauvegarde/Save/Difficile")
		end
	end




	#Ajoute dans un fichier .sav  la difficulté, le niveau et le temps donné en paramètre.
	#la grille me permet de créer un fichier .txt qui contiendra tous les changements apporté à la grille initiale 
	# -temps 
	# -grille
	def sauvegardeToi(grille,temps)
		@temps = temps
		Sauvegarde.creerDossier #Vérifie si les dossier de sauvegarde sont créé sinon je les créer
		dump=YAML::dump(self) #Va contenir mon objet de classe Sauvegarde qu'il sera mis par la suite  dans un fichier .sav grâce à YAML
		#Vérification de la difficulté du niveau pour créer le fichier .sav et ma grille.txt au bon endroit
		if(@difficulte=="niv1")
			file= File.new("Sauvegarde/Save/Facile/save#{@niveau}_#{@profil.nom}.sav","w")
			grilletxt=File.new("Sauvegarde/Save/Facile/grille#{@niveau}_#{@profil.nom}.txt","w")
		end
		if(@difficulte=="niv2")
			file= File.new("Sauvegarde/Save/Moyenne/save#{@niveau}_#{@profil.nom}.sav","w")
			grilletxt=File.new("Sauvegarde/Save/Moyenne/grille#{@niveau}_#{@profil.nom}.txt","w")
		end
		if(@difficulte=="niv3")
			file= File.new("Sauvegarde/Save/Difficile/save#{@niveau}_#{@profil.nom}.sav","w")
			grilletxt=File.new("Sauvegarde/Save/Difficile/grille#{@niveau}_#{@profil.nom}.txt","w")
		end	

		file.write dump #Met l'objet de classe Sauvegarde dans le fichier .sav
		file.close #et il faut bien sûr fermer le fichier .sav
#Cette partie sera consacré à l'écriture  de la grille avec toutes ses modifications(ajout de plusieurs lien,etc...)
#en format .txt avec le fichier créer en haut
#Parcours de la grille puis écriture dans le fichier tous les noeuds et les liens  avec les noeuds relié si ils le sont
		for lig in 0..(grille.lignes - 1)
			for col in 0..(grille.colonnes - 1)
				caseGrille = grille.get_child_at(col,lig)
				if(caseGrille.status=='n') #Regarde si la case de ma grille est un noeud si c'est le cas on note le chiffre qui le représente
					grilletxt.write caseGrille.nbLiens
				end
				if(caseGrille.status == 'l') #si la case de ma grille est un lien,on note le nombre de trait qu'il représente
					if(caseGrille.direction=="h") #Vérifie si c'est un lien horizontal
						case caseGrille.nbTrait
							when 0
								grilletxt.write "0" #Met un 0 lorsqu'il n'y a pas de trait
							when 1
								grilletxt.write "-" #Met un - lorsqu'il n'y a qu'un seul trait
							when 2
								grilletxt.write "=" #Met un = lorsqu'il y a un double trait
						end
					else #Pareil lorsque c'est un lien vertical il n'y a que la notation dans fichier.txt qui change
						case caseGrille.nbTrait
							when 0
								grilletxt.write "0"#Met un 0 lorsqu'il n'y a pas de trait
							when 1
								grilletxt.write "|"#Met un | lorsqu'il n'y a qu'un seul trait
							when 2
								grilletxt.write '"'#Met un " lorsqu'il y a un double trait
						end
					end
                end
				if(col != grille.colonnes-1) #ensuite écriture de ":" qui sera le séparateur pour le parcour du fichier qu'on verra plus bas
					grilletxt.write ":"
				else 
					grilletxt.write "\n" #et enfin saut d'une ligne dans le fichier.txt lorsqu'on passe à la ligne suivante
				end
			end
		end
		grilletxt.close #et on n'oublie pas de fermer le fichier
	end

	#Cette methode est la même que celle du haut mais pour les hypothèses 
	def sauvegardeToiHypo(grille,temps)
		@temps = temps
		Sauvegarde.creerDossier
		dump=YAML::dump(self)
		if(@difficulte=="niv1")
			file= File.new("Sauvegarde/Save/Facile/save#{@niveau}_#{@profil.nom}_hypo.sav","w")
			grilletxt=File.new("Sauvegarde/Save/Facile/grille#{@niveau}_#{@profil.nom}_hypo.txt","w")
		end
		if(@difficulte=="niv2")
			file= File.new("Sauvegarde/Save/Moyenne/save#{@niveau}_#{@profil.nom}_hypo.sav","w")
			grilletxt=File.new("Sauvegarde/Save/Moyenne/grille#{@niveau}_#{@profil.nom}_hypo.txt","w")
		end
		if(@difficulte=="niv3")
			file= File.new("Sauvegarde/Save/Difficile/save#{@niveau}_#{@profil.nom}_hypo.sav","w")
			grilletxt=File.new("Sauvegarde/Save/Difficile/grille#{@niveau}_#{@profil.nom}_hypo.txt","w")
		end	

		file.write dump
		file.close

		for lig in 0..(grille.lignes - 1)
			for col in 0..(grille.colonnes - 1)
				caseGrille = grille.get_child_at(col,lig)
				if(caseGrille.status=='n')
					grilletxt.write caseGrille.nbLiens
				end
				if(caseGrille.status == 'l')
					if(caseGrille.direction=="h")
						case caseGrille.nbTrait
							when 0
								grilletxt.write "0"
							when 1
								grilletxt.write "-"
							when 2
								grilletxt.write "="
						end
					else 
						case caseGrille.nbTrait
							when 0
								grilletxt.write "0"
							when 1
								grilletxt.write "|"
							when 2
								grilletxt.write '"'
						end
					end
                end
				if(col != grille.colonnes-1)
					grilletxt.write ":"
				else 
					grilletxt.write "\n"
				end
			end
		end
		grilletxt.close
	end



	#Vérifie si il existe un fichier sauvegarde et le charge avec YAML
	def chargeToi
		#Vérifie la difficulté pour récupérer le fichier .sav au bon endroit
		case @difficulte
			when "niv1"
				if(OS.windows?) #Si c'est un window effectue la méthode YAML.unsafe_load à la place de YAML.load
					save= (File.exist?("Sauvegarde/Save/Facile/save#{@niveau}_#{@profil.nom}.sav"))?YAML.unsafe_load(File.read("Sauvegarde/Save/Facile/save#{@niveau}_#{@profil.nom}.sav")):nil
				else 
					save= (File.exist?("Sauvegarde/Save/Facile/save#{@niveau}_#{@profil.nom}.sav"))?YAML.load(File.read("Sauvegarde/Save/Facile/save#{@niveau}_#{@profil.nom}.sav")):nil
				end
			when "niv2"
				if(OS.windows?)
					save= (File.exist?("Sauvegarde/Save/Moyenne/save#{@niveau}_#{@profil.nom}.sav"))?YAML.unsafe_load(File.read("Sauvegarde/Save/Moyenne/save#{@niveau}_#{@profil.nom}.sav")):nil
				else 
					save= (File.exist?("Sauvegarde/Save/Moyenne/save#{@niveau}_#{@profil.nom}.sav"))?YAML.load(File.read("Sauvegarde/Save/Moyenne/save#{@niveau}_#{@profil.nom}.sav")):nil
				end	
			when "niv3"
				if(OS.windows?)
					save= (File.exist?("Sauvegarde/Save/Difficile/save#{@niveau}_#{@profil.nom}.sav"))?YAML.unsafe_load(File.read("Sauvegarde/Save/Difficile/save#{@niveau}_#{@profil.nom}.sav")):nil
				else 
					save= (File.exist?("Sauvegarde/Save/Difficile/save#{@niveau}_#{@profil.nom}.sav"))?YAML.load(File.read("Sauvegarde/Save/Difficile/save#{@niveau}_#{@profil.nom}.sav")):nil
			end	
		end
		return save #retourne le fichier .sav ou nil si il n'existe pas
	end
	
	#La même méthode que celle du haut mais utilisé pour les hypothèses
	def chargeToiHypo

		case @difficulte
			when "niv1"
				if(OS.windows?)
					save= (File.exist?("Sauvegarde/Save/Facile/save#{@niveau}_#{@profil.nom}_hypo.sav"))?YAML.unsafe_load(File.read("Sauvegarde/Save/Facile/save#{@niveau}_#{@profil.nom}_hypo.sav")):nil
				else 
					save= (File.exist?("Sauvegarde/Save/Facile/save#{@niveau}_#{@profil.nom}_hypo.sav"))?YAML.load(File.read("Sauvegarde/Save/Facile/save#{@niveau}_#{@profil.nom}_hypo.sav")):nil
				end
			when "niv2"
				if(OS.windows?)
					save= (File.exist?("Sauvegarde/Save/Moyenne/save#{@niveau}_#{@profil.nom}_hypo.sav"))?YAML.unsafe_load(File.read("Sauvegarde/Save/Moyenne/save#{@niveau}_#{@profil.nom}_hypo.sav")):nil
				else 
					save= (File.exist?("Sauvegarde/Save/Moyenne/save#{@niveau}_#{@profil.nom}_hypo.sav"))?YAML.load(File.read("Sauvegarde/Save/Moyenne/save#{@niveau}_#{@profil.nom}_hypo.sav")):nil
				end	
			when "niv3"
				if(OS.windows?)
					save= (File.exist?("Sauvegarde/Save/Difficile/save#{@niveau}_#{@profil.nom}_hypo.sav"))?YAML.unsafe_load(File.read("Sauvegarde/Save/Difficile/save#{@niveau}_#{@profil.nom}_hypo.sav")):nil
				else 
					save= (File.exist?("Sauvegarde/Save/Difficile/save#{@niveau}_#{@profil.nom}_hypo.sav"))?YAML.load(File.read("Sauvegarde/Save/Difficile/save#{@niveau}_#{@profil.nom}_hypo.sav")):nil
			end	
		end
		return save
	end


	#Regarde si il y a une sauvegarde de la grille dans les dossiers et charge cette sauvegarde de la grille
	# -grille
	def Sauvegarde.chargeLaGrille(grille)
		data = [] #va contenir toute les lignes de la sauvegarde de la grille
		#Pour prendre le bon chemin qui amène au bon fichier .txt qui contient  la sauvegarde de la grille
		case grille.difficulte
			when "niv1"
				grilletxt="Sauvegarde/Save/Facile/grille#{grille.niveau}_#{Profil.getProfilAt(Profil.getJeu.menuPrincipal.comboBoxProfil.active).nom}.txt"
			when "niv2"
				grilletxt="Sauvegarde/Save/Moyenne/grille#{grille.niveau}_#{Profil.getProfilAt(Profil.getJeu.menuPrincipal.comboBoxProfil.active).nom}.txt"
			when "niv3"
				grilletxt="Sauvegarde/Save/Difficile/grille#{Profil.getProfilAt(Profil.getJeu.menuPrincipal.comboBoxProfil.active).nom}.txt"
		end

		#je parcours le fichier .txt qui contient la sauvegarde de la grille et je met chaque ligne dans mon tableau data 
        File.foreach(grilletxt) do |line|
            data << line.chomp
        end
		#Parcours de la grille pour ajouter les liens entre les noeuds si ils en avaient
		for i in 0..(data.length() - 1)
            data[i].split(':').each_with_index do | caseGrille, index| #Parcours du fichier .txt avec ':' en tant que séparateur
				case caseGrille
					when '-'
						if grille.get_child_at(index-1,i) != nil #Vérifie que la case à gauche de la case actuelle n'est pas vide
							if grille.get_child_at(index-1,i).status == "n" #Vérifie que la case à gauche est bien un noeud 
								if grille.get_child_at(index-1,i).nDroit !=nil #Vérifie si il y a un voisin droit du noeud de la case à gauche 
									grille.ajoutLien(grille.get_child_at(index-1,i),grille.get_child_at(index-1,i).nDroit,false) 
								end #Appelle de la méthode ajoutLien de la classe Grille qui va ajoute un lien entre les noeuds de la case à gauche et son voisin droit
							end
						end
					when '=' #reprend le même principe que celui du haut mais on appelle deux fois la methode ajoutLien pour faire un double lien
						if grille.get_child_at(index-1,i) != nil
							if grille.get_child_at(index-1,i).status == "n"
								if grille.get_child_at(index-1,i).nDroit !=nil
									grille.ajoutLien(grille.get_child_at(index-1,i),grille.get_child_at(index-1,i).nDroit,false)
									grille.ajoutLien(grille.get_child_at(index-1,i),grille.get_child_at(index-1,i).nDroit,false)
								end
							end
						end 
					when '|' #reprend le même principe que le premier sauf qu'on vérifie la case en haut
						if grille.get_child_at(index,i-1) != nil
							if grille.get_child_at(index,i-1).status == "n"
								if grille.get_child_at(index,i-1).nBas !=nil
									grille.ajoutLien(grille.get_child_at(index,i-1),grille.get_child_at(index,i-1).nBas,false)
								end
							end
						end
					when '"' #reprend le même principe que celui du haut mais on appelle deux fois la methode ajoutLien pour faire un double lien
						if grille.get_child_at(index,i-1) != nil
							if grille.get_child_at(index,i-1).status == "n"
								if grille.get_child_at(index,i-1).nBas !=nil
									grille.ajoutLien(grille.get_child_at(index,i-1),grille.get_child_at(index,i-1).nBas,false)
									grille.ajoutLien(grille.get_child_at(index,i-1),grille.get_child_at(index,i-1).nBas,false)
								end
							end
						end
				end
			end
		end
	end


	#Reprend les même fonctionnalités que celle du haut sauf que celle ci est pour les hypothèses
	def Sauvegarde.chargeLaGrilleHypo(grille)
		data = [] #va contenir toute les lignes de la sauvegarde de la grille
		#Pour prendre le bon chemin qui amène au bon fichier .txt qui contient  la sauvegarde de la grille
		case grille.difficulte
			when "niv1"
				grilletxt="Sauvegarde/Save/Facile/grille#{grille.niveau}_#{Profil.getProfilAt(Profil.getJeu.menuPrincipal.comboBoxProfil.active).nom}_hypo.txt"
			when "niv2"
				grilletxt="Sauvegarde/Save/Moyenne/grille#{grille.niveau}_#{Profil.getProfilAt(Profil.getJeu.menuPrincipal.comboBoxProfil.active).nom}_hypo.txt"
			when "niv3"
				grilletxt="Sauvegarde/Save/Difficile/grille#{Profil.getProfilAt(Profil.getJeu.menuPrincipal.comboBoxProfil.active).nom}_hypo.txt"
		end

		#je parcours le fichier .txt qui contient la sauvegarde de la grille et je met chaque ligne dans mon tableau data 
        File.foreach(grilletxt) do |line|
            data << line.chomp
        end
		#Parcours de la grille pour ajouter des liens entre les noeuds si ils en avaient
		for i in 0..(data.length() - 1)
            data[i].split(':').each_with_index do | caseGrille, index|
				case caseGrille
					when '-'
						if grille.get_child_at(index-1,i) != nil
							if grille.get_child_at(index-1,i).status == "n"
								if grille.get_child_at(index-1,i).nDroit !=nil
									grille.ajoutLien(grille.get_child_at(index-1,i),grille.get_child_at(index-1,i).nDroit,false)
								end
							end
						end
					when '='
						if grille.get_child_at(index-1,i) != nil
							if grille.get_child_at(index-1,i).status == "n"
								if grille.get_child_at(index-1,i).nDroit !=nil
									grille.ajoutLien(grille.get_child_at(index-1,i),grille.get_child_at(index-1,i).nDroit,false)
									grille.ajoutLien(grille.get_child_at(index-1,i),grille.get_child_at(index-1,i).nDroit,false)
								end
							end
						end 
					when '|'
						if grille.get_child_at(index,i-1) != nil
							if grille.get_child_at(index,i-1).status == "n"
								if grille.get_child_at(index,i-1).nBas !=nil
									grille.ajoutLien(grille.get_child_at(index,i-1),grille.get_child_at(index,i-1).nBas,false)
								end
							end
						end
					when '"'
						if grille.get_child_at(index,i-1) != nil
							if grille.get_child_at(index,i-1).status == "n"
								if grille.get_child_at(index,i-1).nBas !=nil
									grille.ajoutLien(grille.get_child_at(index,i-1),grille.get_child_at(index,i-1).nBas,false)
									grille.ajoutLien(grille.get_child_at(index,i-1),grille.get_child_at(index,i-1).nBas,false)
								end
							end
						end
				end
			end
		end
	end


	#Supprime son fichier sav correspondant
	def supprimeToi
		if(self.chargeToi !=nil)#Vérifie si il y a une sauvegarde (un fichier .sav) si oui le supprime
			case @difficulte
				when "niv1"
					File.delete("Sauvegarde/Save/Facile/save#{@niveau}_#{@profil.nom}.sav")
					File.delete("Sauvegarde/Save/Facile/grille#{@niveau}_#{@profil.nom}.txt")
				when "niv2"
					File.delete("Sauvegarde/Save/Moyenne/save#{@niveau}_#{@profil.nom}.sav")
					File.delete("Sauvegarde/Save/Moyenne/grille#{@niveau}_#{@profil.nom}.txt")
				when "niv3"
					File.delete("Sauvegarde/Save/Difficile/save#{@niveau}_#{@profil.nom}.sav")
					File.delete("Sauvegarde/Save/Difficile/grille#{@niveau}_#{@profil.nom}.txt")
			end
		end
	end

	#Effectue la même chose que la méthode au dessus mais pour les hypothèses
	def supprimeToiHypo
		if(self.chargeToiHypo !=nil)#Vérifie si il y a une sauvegarde (un fichier .sav) si oui le supprime
			case @difficulte
				when 1
					File.delete("Sauvegarde/Save/Facile/save#{@niveau}_#{@profil.nom}_hypo.sav")
					File.delete("Sauvegarde/Save/Facile/grille#{@niveau}_#{@profil.nom}_hypo.txt")
				when 2
					File.delete("Sauvegarde/Save/Moyenne/save#{@niveau}_#{@profil.nom}_hypo.sav")
					File.delete("Sauvegarde/Save/Moyenne/grille#{@niveau}_#{@profil.nom}_hypo.txt")
				when 3
					File.delete("Sauvegarde/Save/Difficile/save#{@niveau}_#{@profil.nom}_hypo.sav")
					File.delete("Sauvegarde/Save/Difficile/grille#{@niveau}_#{@profil.nom}_hypo.txt")
			end
		end
	end

	#Supprime tous les fichiers sauvegardes dans le dossier Save
	def Sauvegarde.supprimeTout
		Dir.glob("Sauvegarde/Save/Facile/*").each{|save| #regarde tous les fichiers .sav du dossier et le supprime
			if (File.file?(save))
				File.delete(save)
			end
		}
		Dir.glob("Sauvegarde/Save/Moyenne/*").each{|save|
			if (File.file?(save))
				File.delete(save)
			end
		}
		Dir.glob("Sauvegarde/Save/Difficile/*").each{|save|
			if (File.file?(save))
				File.delete(save)
			end
		}
	end
	
	@Override
	def to_s
	return "Sauvegarde de #{@profil.nom} : temps #{@temps} , difficulté #{@difficulte} , niveau #{@niveau}, terminée? #{@finie}"
	end
end # Marqueur de fin de classe
