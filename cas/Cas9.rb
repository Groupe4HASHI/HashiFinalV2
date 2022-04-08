load 'Noeud.rb'
## Description textuelle du cas :
# Noeud de taille 5
# Condition : Un noeud de taille 5 qui ne possède que 3 voisins peut compléter une partie de ses liens.

class Cas9
    ## On utilise new() pour constructeur

    ## Méthodes

    def estApplicable?(unNoeud)
        if( unNoeud.nbLiens == 5 && unNoeud.nbVoisinsUnLien() == 3 ) then
            return true
        else
            return false
        end
    end

    def appliquer(unNoeud, niveau)
        if(niveau == 1) # Aide textuelle simple
            $aide.set_text "Un noeud de taille 5 peut être complété."
        elsif(niveau == 2) # Donne le noeud où s'applique la tech
            $aide.set_text "Un noeud de taille 5 possédant 3 voisins ne pouvant former qu'un lien peut compléter une partie de ses liens."
        elsif(niveau == 3) # Donne les liens?
            $aide.set_text "Un noeud de taille 5 possédant 3 voisins ne pouvant former qu'un lien peut compléter une partie de ses liens."
            unNoeud.brillerOrange()
        end
    end

end
