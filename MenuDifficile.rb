require 'gtk3'
load 'PlateauJeu.rb'

class MenuDifficile
  def initialize
    menu_difficile = "./glade_ressources/MenuDifficile.glade"
    builder = Gtk::Builder.new
  	builder.add_from_file(menu_difficile)

  	$menu_d = builder.get_object('menu_difficile')
  	$menu_d.set_title "Hashi"
  	$menu_d.signal_connect "destroy" do
  			Gtk.main_quit
  	end

    $btn_grille1_difficile = builder.get_object('niv3_grille1')
		$btn_grille1_difficile.signal_connect('clicked'){
      $menu_d.set_visible(false)
			PlateauJeu.creer(11, 8, "niv3", "1_Grille_difficile_9_13.txt",1)
			#Gtk.main
		}

    $btn_grille2_difficile = builder.get_object('niv3_grille2')
		$btn_grille2_difficile.signal_connect('clicked'){
      $menu_d.set_visible(false)
			PlateauJeu.creer(11, 8, "niv3", "2_Grille_difficile_9_13.txt",2)
			#Gtk.main
		}

    $btn_grille3_difficile = builder.get_object('niv3_grille3')
		$btn_grille3_difficile.signal_connect('clicked'){
      $menu_d.set_visible(false)
			PlateauJeu.creer(11, 8, "niv3", "3_Grille_difficile_9_13.txt",3)
			#Gtk.main
		}

    $btn_grille4_difficile = builder.get_object('niv3_grille4')
		$btn_grille4_difficile.signal_connect('clicked'){
      $menu_d.set_visible(false)
			PlateauJeu.creer(11, 8, "niv3", "4_Grille_difficile_9_13.txt",4)
			#Gtk.main
		}

    $btn_grille5_difficile = builder.get_object('niv3_grille5')
		$btn_grille5_difficile.signal_connect('clicked'){
      $menu_d.set_visible(false)
			PlateauJeu.creer(13, 9, "niv3", "5_Grille_difficile_9_13.txt",5)
			#Gtk.main
		}

    $btn_grille6_difficile = builder.get_object('niv3_grille6')
		$btn_grille6_difficile.signal_connect('clicked'){
      $menu_d.set_visible(false)
			PlateauJeu.creer(13, 9, "niv3", "6_Grille_difficile_9_13.txt",6)
			#Gtk.main
		}

    $btn_grille7_difficile = builder.get_object('niv3_grille7')
		$btn_grille7_difficile.signal_connect('clicked'){
      $menu_d.set_visible(false)
			PlateauJeu.creer(13, 9, "niv3", "7_Grille_difficile_9_13.txt",7)
			#Gtk.main
		}

    $btn_grille8_difficile = builder.get_object('niv3_grille8')
		$btn_grille8_difficile.signal_connect('clicked'){
      $menu_d.set_visible(false)
			PlateauJeu.creer(13, 9, "niv3", "8_Grille_difficile_9_13.txt",8)
			#Gtk.main
		}

    $btn_grille9_difficile = builder.get_object('niv3_grille9')
		$btn_grille9_difficile.signal_connect('clicked'){
      #$menu_d.destroy
      $menu_d.set_visible(false)
			PlateauJeu.creer(13, 9, "niv3", "9_Grille_difficile_9_13.txt",9)
			#Gtk.main
		}

    btn_retour = builder.get_object('grille_btn_retour')
    btn_retour.signal_connect('clicked'){
      		$menu_d.destroy
    }

    $menu_d.show_all
    Gtk.main
  end

end
