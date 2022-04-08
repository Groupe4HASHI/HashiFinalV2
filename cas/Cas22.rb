load 'Noeud.rb'
## Description textuelle du cas :
# Noeud de taille 1
# Condition : Un noeud de taille 5 qui ne possède que 3 voisins peut compléter une partie de ses liens.

class Cas22
    ## On utilise new() pour constructeur

    ## Méthodes

    def estApplicable?(unNoeud)
        if( unNoeud.nbLiens == 1 && unNoeud.nbVoisinsZeroLien() == 3 ) then
            return true
        else
            return false
        end
    end

    def appliquer(unNoeud, niveau)
        if(niveau == 1) # Aide textuelle simple
            $aide.set_text "Un noeud de taille 1 peut être relié."
        elsif(niveau == 2) # Donne le noeud où s'applique la tech
            $aide.set_text "Un noeud de taille 1 qui ne peut créer de liens que dans une direction doit créer ce lien."
        elsif(niveau == 3) # Donne les liens?
            $aide.set_text "Un noeud de taille 1 qui ne peut créer de liens que dans une direction doit créer ce lien."
            unNoeud.brillerOrange()
        end
    end

end
