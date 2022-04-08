load 'cas/Cas1.rb'
load 'cas/Cas2.rb'
load 'cas/Cas3.rb'
load 'cas/Cas4.rb'
load 'cas/Cas5.rb'
load 'cas/Cas6.rb'
load 'cas/Cas7.rb'
load 'cas/Cas8.rb'
load 'cas/Cas9.rb'
load 'cas/Cas10.rb'
load 'cas/Cas11.rb'
load 'cas/Cas12.rb'
load 'cas/Cas13.rb'
load 'cas/Cas14.rb'
load 'cas/Cas15.rb'
load 'cas/Cas16.rb'
load 'cas/Cas17.rb'
load 'cas/Cas18.rb'
load 'cas/Cas19.rb'
load 'cas/Cas20.rb'
load 'cas/Cas21.rb'
load 'cas/Cas22.rb'
load 'cas/Cas23.rb'
load 'cas/Cas24.rb'
load 'cas/Cas25.rb'

class Aides
## Variables
    # @listeNoeuds  - Liste contenant les références aux noeuds dans un ordre dit "escargot"
    # @listeCas     - Liste contenant les références aux différents cas d'assistance répertoriés
    # @grille       - Contient une référence à la grille
    # @niveau       - Contient le niveau de l'aide à appliquer
    attr_reader :listeNoeuds, :listeCas

## Constructeur
    private_class_method :new

    def Aides.creer(uneGrille)
        new(uneGrille)
    end

    def initialize(uneGrille)
        # listeCas à remplir
        @listeCas = [ Cas1.new(), Cas2.new(), Cas3.new(), Cas4.new(), Cas5.new(), Cas6.new(), Cas7.new(), Cas8.new(), Cas9.new(), Cas10.new(), Cas11.new(), Cas12.new(), Cas13.new(), Cas14.new(), Cas15.new(), Cas16.new(), Cas17.new(), Cas18.new(), Cas19.new(), Cas20.new(), Cas21.new(), Cas22.new(), Cas23.new(), Cas24.new(), Cas25.new() ]
        #Remplir la listeNoeuds ?
        @listeNoeuds = uneGrille.tabNoeuds
    end

## Méthodes
    # Méthode utilisée à l'appui sur le bouton d'aide
    def appeler(unNiveau)
        # Parcours de la liste de Noeuds pour trouver un noeud où s'applique une aide
        for noeud in @listeNoeuds
            if(!noeud.estComplet?)
                # Parcours de la liste de Cas pour trouver un cas qui s'applique
                for cas in @listeCas
                    if cas.estApplicable?(noeud)
                        if unNiveau == 1 then
                          $temps += 20
                        elsif unNiveau == 2 then
                          $temps += 40
                        else
                          $temps += 60
                        end
                        cas.appliquer(noeud, unNiveau)
                        return
                    end
                end
            end
        end
    end

end
