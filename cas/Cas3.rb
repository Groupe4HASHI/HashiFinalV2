load 'Noeud.rb'

## Description textuelle du cas :
# Noeud de taille 8
# Condition : Le noeud n'est pas complet

class Cas3
    ## On utilise new() pour constructeur

    ## Méthodes

    def estApplicable?(unNoeud)
        if( unNoeud.nbLiens == 7 && !unNoeud.liensRestants() > 3 ) then
            return true
        else
            return false
        end
    end

    def appliquer(unNoeud, niveau)
        if(niveau == 1) # Aide textuelle simple
            $aide.set_text "Un noeud de taille 7 peut être en partie complété."
        elsif(niveau == 2) # Donne le noeud où s'applique la tech
            $aide.set_text "Un noeu de taille 7 peut toujours au moins créer un lien dans chaque direction."
        elsif(niveau == 3) # Donne les liens?
            $aide.set_text "Un noeu de taille 7 peut toujours au moins créer un lien dans chaque direction."
            unNoeud.brillerOrange
        end
    end

end
