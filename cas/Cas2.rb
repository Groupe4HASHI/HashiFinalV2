load 'Noeud.rb'

## Description textuelle du cas :
# Noeud de taille 7
# Condition : un des voisins ne peut créer qu'un lien

class Cas2
    ## On utilise new() pour constructeur

    ## Méthodes

    def estApplicable?(unNoeud)
        if( unNoeud.nbLiens == 7 && unNoeud.nbVoisinsUnLien() == 1 ) then
            return true
        else
            return false
        end
    end

    def appliquer(unNoeud, niveau)
        if(niveau == 1) # Aide textuelle simple / Indication sur la taille du noeud
            $aide.set_text("Un noeud de taille 7 peut être complété.")
        elsif(niveau == 2) # Donne le noeud où s'applique la tech / Indication de la technique
            $aide.set_text "Un noeud de taille 7 qui possède un voisin ne pouvant créer qu'un seul lien peut donc compléter tous ses liens."
        elsif(niveau == 3) # Donne les liens? / Indication du noeud où s'applique la technique
            $aide.set_text "Un noeud de taille 7 qui possède un voisin ne pouvant créer qu'un seul lien peut donc compléter tous ses liens."
            unNoeud.brillerOrange
        end
    end

end
