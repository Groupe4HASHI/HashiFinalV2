load 'Noeud.rb'

## Description textuelle du cas :
# Noeud de taille 6
# Condition : Le noeud possède deux voisins avec lesquels il ne peut créer qu'un lien

class Cas4
    ## On utilise new() pour constructeur

    ## Méthodes

    def estApplicable?(unNoeud)
        if( unNoeud.nbLiens == 6 && unNoeud.nbVoisinsUnLien() == 2 ) then
            return true
        else
            return false
        end
    end

    def appliquer(unNoeud, niveau)
        if(niveau == 1) # Aide textuelle simple
            $aide.set_text "Un noeud de taille 6 peut être complété."
        elsif(niveau == 2) # Donne le noeud où s'applique la tech
            $aide.set_text "Un noeud de taille 6 possédant deux voisins qui ne peuvent créer qu'un lien peut compléter ses liens."
        elsif(niveau == 3) # Donne les liens?
            $aide.set_text "Un noeud de taille 6 possédant deux voisins qui ne peuvent créer qu'un lien peut compléter ses liens."
            unNoeud.brillerOrange()
        end
    end

end
