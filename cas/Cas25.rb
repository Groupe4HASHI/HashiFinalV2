load 'Noeud.rb'
## Description textuelle du cas :
# Noeud de taille 1
# Condition + particulière : "6" entouré de 3 "2"

class Cas25
    ## On utilise new() pour constructeur

    ## Méthodes

    def estApplicable?(unNoeud)
        cpt = 0
        for voisin in unNoeud.noeudVoisins()
            if( voisin.nbLiens == 2 )
                cpt += 1
            end
        end
        return( unNoeud.nbLiens == 2 && unNoeud.nbVoisinsZeroLien() == 2 && cpt >= 1 )
    end

    def appliquer(unNoeud, niveau)
        if(niveau == 1) # Aide textuelle simple
            $aide.set_text "Un noeud de taille 2 peut être relié."
        elsif(niveau == 2) # Donne le noeud où s'applique la tech
            $aide.set_text "Un noeud de taille 2 qui possède 2 voisins et qui formerait un groupe fermé avec un de ces voisins, doit alors nécéssairement relier une autre île."
        elsif(niveau == 3) # Donne les liens?
            $aide.set_text "Un noeud de taille 2 qui possède 2 voisins et qui formerait un groupe fermé avec un de ces voisins, doit alors nécéssairement relier une autre île."
            unNoeud.brillerOrange()
        end
    end

end
