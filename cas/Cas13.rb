load 'Noeud.rb'
## Description textuelle du cas :
# Noeud de taille 4
# Condition : Un noeud de taille 5 qui ne possède que 3 voisins peut compléter une partie de ses liens.

class Cas13
    ## On utilise new() pour constructeur

    ## Méthodes

    def estApplicable?(unNoeud)
        if( unNoeud.nbLiens == 4 && unNoeud.nbVoisinsZeroLien() == 1 && unNoeud.nbVoisinsUnLien() == 2 ) then
            return true
        else
            return false
        end
    end

    def appliquer(unNoeud, niveau)
        if(niveau == 1) # Aide textuelle simple
            $aide.set_text "Un noeud de taille 4 peut être complété."
        elsif(niveau == 2) # Donne le noeud où s'applique la tech
            $aide.set_text "Un noeud de taille 4 qui possède 3 voisins dont deux ne pouvant former qu'un lien peut créer tous ses liens."
        elsif(niveau == 3) # Donne les liens?
            $aide.set_text "Un noeud de taille 4 qui possède 3 voisins dont deux ne pouvant former qu'un lien peut créer tous ses liens."
            unNoeud.brillerOrange()
        end
    end

end
