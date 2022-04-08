load 'Noeud.rb'

## Description textuelle du cas :
# Noeud de taille 6
# Condition : Le noeud possède deux voisins avec lesquels il ne peut créer qu'un lien

class Cas6
    ## On utilise new() pour constructeur

    ## Méthodes

    def estApplicable?(unNoeud)
        if( unNoeud.nbLiens == 6 && unNoeud.nbVoisinsUnLien() == 1 ) then
            return true
        else
            return false
        end
    end

    def appliquer(unNoeud, niveau)
        if(niveau == 1) # Aide textuelle simple
            $aide.set_text "Un noeud de taille 6 peut être en partie complété."
        elsif(niveau == 2) # Donne le noeud où s'applique la tech
            $aide.set_text "Un noeud pouvant créer 6 liens et possédant un voisin qui ne peut en créer qu'un peut créer 3 liens simples avec ses voisins."
        elsif(niveau == 3) # Donne les liens?
            $aide.set_text "Un noeud pouvant créer 6 liens et possédant un voisin qui ne peut en créer qu'un peut créer 3 liens simples avec ses voisins."
            unNoeud.brillerOrange()
        end
    end

end
