load 'Noeud.rb'
## Description textuelle du cas :
# Noeud de taille 3
# Condition : Un noeud de taille 5 qui ne possède que 3 voisins peut compléter une partie de ses liens.

class Cas17
    ## On utilise new() pour constructeur

    ## Méthodes

    def estApplicable?(unNoeud)
        if( unNoeud.nbLiens == 3 && unNoeud.nbVoisinsZeroLien() == 2 ) then
            return true
        else
            return false
        end
    end

    def appliquer(unNoeud, niveau)
        if(niveau == 1) # Aide textuelle simple
            $aide.set_text "Un noeud de taille 3 peut être en partie complété."
        elsif(niveau == 2) # Donne le noeud où s'applique la tech
            $aide.set_text "Un noeud de taille 3 avec seulement 2 voisins peut former au moins un lien simple avec ses voisins."
        elsif(niveau == 3) # Donne les liens?
            $aide.set_text "Un noeud de taille 3 avec seulement 2 voisins peut former au moins un lien simple avec ses voisins."
            unNoeud.brillerOrange()
        end
    end

end
