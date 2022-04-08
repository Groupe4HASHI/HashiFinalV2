load 'Noeud.rb'
## Description textuelle du cas :
# Noeud de taille 3
# Condition : Un noeud de taille 5 qui ne possède que 3 voisins peut compléter une partie de ses liens.

class Cas18
    ## On utilise new() pour constructeur

    ## Méthodes

    def estApplicable?(unNoeud)
        if( unNoeud.nbLiens == 3 && unNoeud.nbVoisinsZeroLien() == 1 && unNoeud.nbVoisinsUnLien() == 2 ) then
            return true
        else
            return false
        end
    end

    def appliquer(unNoeud, niveau)
        if(niveau == 1) # Aide textuelle simple
            $aide.set_text "Un noeud de taille 3 peut former un lien."
        elsif(niveau == 2) # Donne le noeud où s'applique la tech
            $aide.set_text "Un noeud de taille 3 possédant 3 voisins dont 2 ne peuvent former au maximum qu'un seul lien peut créer un lien simple avec son 3eme voisin."
        elsif(niveau == 3) # Donne les liens?
            $aide.set_text "Un noeud de taille 3 possédant 3 voisins dont 2 ne peuvent former au maximum qu'un seul lien peut créer un lien simple avec son 3eme voisin."
            unNoeud.brillerOrange()
        end
    end

end
