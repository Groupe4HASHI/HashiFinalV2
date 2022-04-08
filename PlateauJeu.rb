load 'MenuPause.rb'
load 'Aides.rb'
load 'Profil.rb'
load 'Hypothese.rb'


class PlateauJeu
  #$window => variable contenant le plateau de jeu
  #$threadChrono => un thread pour lancer le chrono
  #$chrono => variable contenant le label qui est present sur le plateau de jeu pour afficher le chrono
  #$temps => variable contenant le temps

  attr_reader :lignesGrille, :colonnesGrille, :niveau, :difficulte, :window

  def PlateauJeu.creer(xGrille, yGrille, uneDifficulte, unFichier, unNiveau)
    new(xGrille, yGrille, uneDifficulte, unFichier, unNiveau)
  end

  private_class_method :new

  def initialize(xGrille, yGrille, uneDifficulte, unFichier, unNiveau)
    @lignesGrille, @colonnesGrille, @difficulte,@fichier,@niveau= xGrille, yGrille, uneDifficulte, unFichier, unNiveau

    # Initialisation de la grille
    grille = Grille.creer(unFichier,uneDifficulte, unNiveau, xGrille, yGrille)

    aideGrille = Aides.creer(grille)

    save=Sauvegarde.creer(@difficulte,@niveau,Profil.getProfilAt(Profil.getJeu.menuPrincipal.comboBoxProfil.active))

    if(save.chargeToi !=nil)
      grille.setChargement(true)
    end

    #Chargement de la grille
    grille.chargeGrille
    #Creation de la fenêtre
    plateau = "./glade_ressources/Plateau2.glade"
    builder = Gtk::Builder.new
    builder.add_from_file(plateau)

    $window = builder.get_object('plateau')
    $window.set_title "Hashi"
    $window.signal_connect "destroy" do
        Thread.kill($threadChrono)
        Gtk.main_quit
    end

    grille_jeu = builder.get_object('grille_jeu')


    grille.set_column_spacing 0
    grille.set_row_spacing 0
    grille.expand = true
    grille.halign =  Gtk::Align::CENTER
    grille.valign =  Gtk::Align::CENTER
    grille.set_row_homogeneous(true)
    grille.set_column_homogeneous(true)

    # #Reglage du bouton Undo
    btnUndo = builder.get_object('btn_undo')
    btnUndo.signal_connect('clicked'){
      if(grille != nil) then
         grille.appelUndo
      end
    }

    # #Reglage du bouton Redo
    btnRedo = builder.get_object('btn_redo')
    btnRedo.signal_connect('clicked'){
      if(grille != nil) then
        grille.appelRedo
      end
    }

    btn_retour = builder.get_object('btn_home')
    btn_retour.signal_connect('clicked'){
      Thread.kill($threadChrono)
      $window.destroy
      $window = nil
      MenuPause.creer(@lignesGrille, @colonnesGrille, @difficulte,@fichier,@niveau)
    }

    btn_verifier = builder.get_object('btn_verifier')
    btn_verifier.signal_connect('clicked'){
      $temps = $temps + 60
      grille.verifierGrille
    }

    $aide = builder.get_object('label_aide')

    btn_aide1 = builder.get_object('aide_niv1')
    btn_aide1.signal_connect('clicked'){
      #$temps = $temps + 20
      aideGrille.appeler(1)
    }

    btn_aide2 = builder.get_object('aide_niv2')
    btn_aide2.signal_connect('clicked'){
      #$temps = $temps + 40
      aideGrille.appeler(2)
    }

    btn_aide3 = builder.get_object('aide_niv3')
    btn_aide3.signal_connect('clicked'){
      #$temps = $temps + 60
      aideGrille.appeler(3)
    }

    btn_commencerHypo = builder.get_object('btn_nouvelle_hypo')
    btn_commencerHypo.signal_connect('clicked'){
      @hypo = Hypothese.creer(save,grille)
      @hypo.commencerHypo
    }
      
    btn_validerHypo = builder.get_object('btn_valider_hypo')
    btn_validerHypo.signal_connect('clicked'){
      if(@hypo != nil)
	      @hypo.validerHypo
	      @hypo = nil
      end
    }
      
    btn_annulerHypo = builder.get_object('btn_annuler_hypo')
    btn_annulerHypo.signal_connect('clicked'){
      if(@hypo != nil)
      		grille_jeu.remove(grille)
      		
      	grille = Grille.creer(@fichier, @difficulte, @niveau, @lignesGrille, @colonnesGrille)
	   	  grille.setChargement(true)      
        grille.setHypothese(true)

	      @hypo.annulerHypo
	      	
	      	grille.chargeGrille
	      	grille.set_column_spacing 0
    		  grille.set_row_spacing 0
    		  grille.expand = true
    		  grille.halign =  Gtk::Align::CENTER
    		  grille.valign =  Gtk::Align::CENTER
    		  grille.set_row_homogeneous(true)
    		  grille.set_column_homogeneous(true)
	      	grille_jeu.add(grille)
	      	grille_jeu.show_all
	      	$chrono.set_text($temps.to_s)
	    end
    }
    

    $chrono = builder.get_object('chrono')

    $temps = 0

    $chrono.set_text($temps.to_s)

    # ajoutGrille(grid)
    grille_jeu.add(grille)
    grille_jeu.show_all

    #Thread chronomètre
    $threadChrono = Thread.new{
        while(true) do
            sleep(1)
            $temps += 1
            $chrono.set_text($temps.to_s)
        end
    }

    if(grille.grilleFini?) then
      Thread.kill($threadChrono)
    #  if(uneDifficulte == "niv1") then
    #    diff = "Facile"
    #  elsif(uneDifficulte == "niv2") then
    #    diff = "Moyenne"
    #  else
    #    diff = "Difficile"
    #  end
    #  grilleSauvegarde = File.readlines("./Sauvegarde/Save/#{diff}/grille#{unNiveau}.txt").map { |str| str.split(":") }
    #  #saveTab = File.readlines("./Sauvegarde/Save/#{diff}/grille#{unNiveau}.txt").map { |str| str.split(":") }
    #  $temps = grilleSauvegarde[xGrille-1][0].to_i
    #  $chrono.set_text($temps.to_s)
    end

    $window.show
    Gtk.main
  end

end
