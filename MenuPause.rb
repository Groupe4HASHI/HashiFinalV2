class MenuPause
  attr_reader :difficulte, :niveau, :x, :y

  def MenuPause.creer(lig, col, uneDifficulte,unNomFichier, unNiveau)
    new(lig, col, uneDifficulte,unNomFichier, unNiveau)
  end

  private_class_method :new

  def initialize(lig, col, uneDifficulte,unNomFichier, unNiveau)
    @niveau = unNiveau
    @difficulte = uneDifficulte
    @fichier = unNomFichier
    @x = lig
    @y = col

    glade_pause = "./glade_ressources/MenuPause.glade"
    builder = Gtk::Builder.new
  	builder.add_from_file(glade_pause)

  	menu = builder.get_object('menu_pause')
  	menu.set_title "Hashi"
  	menu.signal_connect "destroy" do
  			Gtk.main_quit
  	end

    btn_reprendre = builder.get_object('btn_reprendre')
		btn_reprendre.signal_connect('clicked'){
      menu.destroy
			PlateauJeu.creer(@x,@y,@difficulte,@fichier,@niveau)
		}

    btn_recommencer = builder.get_object('btn_recommencer')
		btn_recommencer.signal_connect('clicked'){
      menu.destroy
      save=Sauvegarde.creer(@difficulte,@niveau,Profil.getProfilAt(Profil.getJeu.menuPrincipal.comboBoxProfil.active))
      save.supprimeToi
			PlateauJeu.creer(@x,@y,@difficulte,@fichier,@niveau)
		}

    btn_quitter = builder.get_object('btn_quitter')
		btn_quitter.signal_connect('clicked'){
      menu.destroy
      #$window.destroy
      $window = nil
      if uneDifficulte == "niv1" then
        $menu_f.set_visible(true)
        #MenuFacile.new
      elsif uneDifficulte == "niv2" then
        #MenuMoyen.new
        $menu_m.set_visible(true)
      elsif uneDifficulte == "niv3" then
        #MenuDifficile.new
        $menu_d.set_visible(true)
      end
		}

    menu.show_all
    Gtk.main
  end

end
