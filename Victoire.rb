require 'gtk3'
load 'PlateauJeu.rb'

class Victoire

  def Victoire.creer(xGrille, yGrille, uneDifficulte, unNiveau)
    new(xGrille, yGrille, uneDifficulte, unNiveau)
  end

  private_class_method :new

  def initialize(xGrille, yGrille, uneDifficulte, unNiveau)
    victoire_fich = "./glade_ressources/Victoire.glade"
    builder = Gtk::Builder.new
    builder.add_from_file(victoire_fich)

    window_v = builder.get_object('window_victoire')
    window_v.set_title "Hashi"
    window_v.signal_connect "destroy" do
        Gtk.main_quit
    end

    t_victoire = builder.get_object('temps_victoire')
    t_victoire.set_text($temps.to_s + " secondes")

    btn_recommencer = builder.get_object('recommencer_victoire')
    btn_recommencer.signal_connect('clicked'){
      $window.destroy
      window_v.destroy
      #window_p.destroy
      #window = nil
      Thread.kill($threadChrono)
      if(uneDifficulte == "niv1") then
        diff = "Facile"
      elsif(uneDifficulte == "niv2") then
        diff = "Moyenne"
      else
        diff = "Difficile"
      end
      File.delete("./Sauvegarde/Save/#{diff}/grille#{unNiveau}.txt")
      File.delete("./Sauvegarde/Save/#{diff}/save#{unNiveau}.sav")
      PlateauJeu.creer(xGrille, yGrille, uneDifficulte, unNiveau, false)
    }

    btn_menu = builder.get_object('menu_victoire')
    btn_menu.signal_connect('clicked'){
      window_v.destroy
      $window.destroy
      $window = nil
      if(uneDifficulte == "niv1") then
        $menu_f.set_visible(true)
      elsif(uneDifficulte == "niv2") then
        $menu_m.set_visible(true)
      else
        $menu_d.set_visible(true)
      end
    }

    window_v.show
    Gtk.main
  end
end
