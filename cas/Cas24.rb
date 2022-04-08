load 'Noeud.rb'
## Description textuelle du cas :
# Noeud de taille 1
# Condition + particulière : "6" entouré de 3 "2"

class Cas24
    ## On utilise new() pour constructeur

    ## Méthodes

    def estApplicable?(unNoeud)
        cpt = 0
        for voisin in unNoeud.noeudVoisins()
            if( voisin.nbLiens == 2 )
                cpt += 1
            end
        end
        return( unNoeud.nbLiens == 4 && unNoeud.nbVoisinsZeroLien() == 1 && cpt == 2 )
    end

    def appliquer(unNoeud, niveau)
        if(niveau == 1) # Aide textuelle simple
            $aide.set_text "Un noeud de taille 4 peut être relié."
        elsif(niveau == 2) # Donne le noeud où s'applique la tech
            $aide.set_text "Un noeud de taille 4 qui possède 2 voisins qui, reliés, formeraient un groupe fermé ne respectant pas les règles du Hashi. Ce noeud doit alors nécéssairement relier la 3eme île pour ne pas aller contre les règles."
        elsif(niveau == 3) # Donne les liens?
            $aide.set_text "Un noeud de taille 4 qui possède 2 voisins qui, reliés, formeraient un groupe fermé ne respectant pas les règles du Hashi. Ce noeud doit alors nécéssairement relier la 3eme île pour ne pas aller contre les règles."
            unNoeud.brillerOrange()
        end
    end

end
