load 'Noeud.rb'

## Description textuelle du cas :
# Noeud de taille 6
# Condition : Le noeud possède un voisin avec lesquel il ne peut pas créer de lien

class Cas5
    ## On utilise new() pour constructeur

    ## Méthodes

    def estApplicable?(unNoeud)
        if( unNoeud.nbLiens == 6 && unNoeud.nbVoisinsZeroLien() == 1 ) then
            return true
        else
            return false
        end
    end

    def appliquer(unNoeud, niveau)
        if(niveau == 1) # Aide textuelle simple
            $aide.set_text "Un noeud de taille 6 peut être complété."
        elsif(niveau == 2) # Donne le noeud où s'applique la tech
            $aide.set_text "Un noeud de taille 6 qui ne possède que 3 voisins peut créer tous ses liens."
        elsif(niveau == 3) # Donne les liens?
            $aide.set_text "Un noeud de taille 6 qui ne possède que 3 voisins peut créer tous ses liens."
            unNoeud.brillerOrange()
        end
    end

end
