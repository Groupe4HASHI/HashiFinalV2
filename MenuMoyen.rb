require 'gtk3'
load 'PlateauJeu.rb'

class MenuMoyen
  def initialize
    menu_moyen = "./glade_ressources/MenuMoyen.glade"
    builder = Gtk::Builder.new
  	builder.add_from_file(menu_moyen)

  	$menu_m = builder.get_object('menu_moyen')
  	$menu_m.set_title "Hashi"
  	$menu_m.signal_connect "destroy" do
  			Gtk.main_quit
  	end

    $btn_grille1_moyenne = builder.get_object('niv2_grille1')
		$btn_grille1_moyenne.signal_connect('clicked'){
      $menu_m.set_visible(false)
			PlateauJeu.creer(11, 8, "niv2","1_Grille_moyenne_8_11.txt", 1)
			#Gtk.main
		}

    #btn_grille2 = builder.get_object('image2')
    #btn_grille2.set_from_file("")
    $btn_grille2_moyenne = builder.get_object('niv2_grille2')
    #image2 = Gtk::Image.new(:file => "./images/moyen.png")
    #image2.show()
    #$btn_grille2_moyenne.set_image(image2)
		$btn_grille2_moyenne.signal_connect('clicked'){
      $menu_m.set_visible(false)
			PlateauJeu.creer(11, 8, "niv2","2_Grille_moyenne_8_11.txt", 2)
			#Gtk.main
		}

    $btn_grille3_moyenne = builder.get_object('niv2_grille3')
		$btn_grille3_moyenne.signal_connect('clicked'){
      $menu_m.set_visible(false)
			PlateauJeu.creer(11, 8, "niv2","3_Grille_moyenne_8_11.txt", 3)
			#Gtk.main
		}

    $btn_grille4_moyenne = builder.get_object('niv2_grille4')
		$btn_grille4_moyenne.signal_connect('clicked'){
      $menu_m.set_visible(false)
			PlateauJeu.creer(11, 8, "niv2","4_Grille_moyenne_8_11.txt", 4)
			#Gtk.main
		}

    $btn_grille5_moyenne = builder.get_object('niv2_grille5')
		$btn_grille5_moyenne.signal_connect('clicked'){
      $menu_m.set_visible(false)
			PlateauJeu.creer(13, 9, "niv2", "5_Grille_moyenne_9_13.txt",5)
			#Gtk.main
		}

    $btn_grille6_moyenne = builder.get_object('niv2_grille6')
		$btn_grille6_moyenne.signal_connect('clicked'){
      $menu_m.set_visible(false)
			PlateauJeu.creer(13, 9, "niv2", "6_Grille_moyenne_9_13.txt",6)
			#Gtk.main
		}

    $btn_grille7_moyenne = builder.get_object('niv2_grille7')
		$btn_grille7_moyenne.signal_connect('clicked'){
      $menu_m.set_visible(false)
			PlateauJeu.creer(13, 9, "niv2", "7_Grille_moyenne_9_13.txt",7)
			#Gtk.main
		}

    $btn_grille8_moyenne = builder.get_object('niv2_grille8')
		$btn_grille8_moyenne.signal_connect('clicked'){
      $menu_m.set_visible(false)
			PlateauJeu.creer(13, 9, "niv2", "8_Grille_moyenne_9_13.txt",8)
			#Gtk.main
		}

    $btn_grille9_moyenne = builder.get_object('niv2_grille9')
		$btn_grille9_moyenne.signal_connect('clicked'){
      #$menu_m.destroy
      $menu_m.set_visible(false)
			PlateauJeu.creer(13, 9, "niv2", "9_Grille_moyenne_9_13.txt",9)
			#Gtk.main
		}

    btn_retour = builder.get_object('grille_btn_retour')
    btn_retour.signal_connect('clicked'){
      		$menu_m.destroy
    }

    $menu_m.show_all
    Gtk.main
  end

end
