require 'gtk3'
load 'PlateauJeu.rb'

class MenuFacile
  def initialize
    menu_facile = "./glade_ressources/MenuFacile.glade"
    builder = Gtk::Builder.new
  	builder.add_from_file(menu_facile)

  	$menu_f = builder.get_object('menu_facile')
  	$menu_f.set_title "Hashi"
  	$menu_f.signal_connect "destroy" do
  			Gtk.main_quit
  	end

    $btn_grille1_facile = builder.get_object('niv1_grille1')
		$btn_grille1_facile.signal_connect('clicked'){
      #$menu_f.destroy
      $menu_f.set_visible(false)
			PlateauJeu.creer(10, 7,"niv1", "1_Grille_facile_7_10.txt", 1)
		}

    $btn_grille2_facile = builder.get_object('niv1_grille2')
		$btn_grille2_facile.signal_connect('clicked'){
      #menu.destroy
      $menu_f.set_visible(false)
			PlateauJeu.creer(10, 7,"niv1", "2_Grille_facile_7_10.txt", 2)
			#Gtk.main
		}

    $btn_grille3_facile = builder.get_object('niv1_grille3')
		$btn_grille3_facile.signal_connect('clicked'){
      #menu.destroy
      $menu_f.set_visible(false)
			PlateauJeu.creer(10, 7,"niv1", "3_Grille_facile_7_10.txt", 3)
			#Gtk.main
		}

    $btn_grille4_facile = builder.get_object('niv1_grille4')
		$btn_grille4_facile.signal_connect('clicked'){
      #menu.destroy
      $menu_f.set_visible(false)
			PlateauJeu.creer(10, 7,"niv1", "4_Grille_facile_7_10.txt", 4)
			#Gtk.main
		}

    $btn_grille5_facile = builder.get_object('niv1_grille5')
		$btn_grille5_facile.signal_connect('clicked'){
      #menu.destroy
      $menu_f.set_visible(false)
			PlateauJeu.creer(10, 7,"niv1", "5_Grille_facile_7_10.txt", 5)
			#Gtk.main
		}

    $btn_grille6_facile = builder.get_object('niv1_grille6')
		$btn_grille6_facile.signal_connect('clicked'){
      #menu.destroy
      $menu_f.set_visible(false)
			PlateauJeu.creer(10, 7,"niv1", "6_Grille_facile_7_10.txt", 6)
			#Gtk.main
		}

    $btn_grille7_facile = builder.get_object('niv1_grille7')
		$btn_grille7_facile.signal_connect('clicked'){
      #menu.destroy
      $menu_f.set_visible(false)
			PlateauJeu.creer(10, 7,"niv1", "7_Grille_facile_7_10.txt", 7)
			#Gtk.main
		}

    $btn_grille8_facile = builder.get_object('niv1_grille8')
		$btn_grille8_facile.signal_connect('clicked'){
      #menu.destroy
      $menu_f.set_visible(false)
			PlateauJeu.creer(10, 7,"niv1", "8_Grille_facile_7_10.txt", 8)
			#Gtk.main
		}

    $btn_grille9_facile = builder.get_object('niv1_grille9')
		$btn_grille9_facile.signal_connect('clicked'){
      #menu.destroy
      $menu_f.set_visible(false)
			PlateauJeu.creer(10, 7,"niv1", "9_Grille_facile_7_10.txt", 9)
			#Gtk.main
		}

    btn_retour = builder.get_object('grille_btn_retour')
    btn_retour.signal_connect('clicked'){
      		$menu_f.destroy
    }

    $menu_f.show_all
    Gtk.main
  end

end
