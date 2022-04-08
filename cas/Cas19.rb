load 'Noeud.rb'
## Description textuelle du cas :
# Noeud de taille 2
# Condition : Un noeud de taille 5 qui ne possède que 3 voisins peut compléter une partie de ses liens.

class Cas19
    ## On utilise new() pour constructeur

    ## Méthodes

    def estApplicable?(unNoeud)
        if( unNoeud.nbLiens == 2 && unNoeud.nbVoisinsZeroLien() == 3 ) then
            return true
        else
            return false
        end
    end

    def appliquer(unNoeud, niveau)
        if(niveau == 1) # Aide textuelle simple
            $aide.set_text "Un noeud de taille 2 peut être complété."
        elsif(niveau == 2) # Donne le noeud où s'applique la tech
            $aide.set_text "Un noeud de taille 2 qui ne possède qu'un voisin peut toujours être complété."
        elsif(niveau == 3) # Donne les liens?
            $aide.set_text "Un noeud de taille 2 qui ne possède qu'un voisin peut toujours être complété."
            unNoeud.brillerOrange()
        end
    end

end
