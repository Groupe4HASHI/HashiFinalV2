load 'Noeud.rb'

## Description textuelle du cas :
# Noeud de taille 8
# Condition : Aucune, un 8 peut toujours être fini

class Cas1
    ## On utilise new() pour constructeur

    ## Méthodes

    def estApplicable?(unNoeud)
        if( unNoeud.nbLiens == 8 )
            return true
        else
            return false
        end
    end

    def appliquer(unNoeud, niveau)
        if(niveau == 1) # Aide textuelle simple
            $aide.set_text("Un noeud de taille 8 peut être complété.")
        elsif(niveau == 2) # Donne le noeud où s'applique la tech
            $aide.set_text("Un noeud de taille 8 peut former 4 doubles liens avec ses voisins.")
        elsif(niveau == 3) # Donne les liens?
            $aide.set_text("Un noeud de taille 8 peut former 4 doubles liens avec ses voisins.")
            unNoeud.brillerOrange()
        end
    end

end
