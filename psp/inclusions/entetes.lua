-- Initialisation du moteur de nombres aléatoires
math.randomseed(os.time())

-- Images de fond
fond = {
	normal = Image.load("./images/fond.png"),
	gagne = Image.load("./images/fond_gagne.png"),
	apropos = Image.load("./images/fond_apropos.png"),
}

-- Différentes icones
icone = {}
icone[0] = Image.load("./images/rond.png")
icone[1] = Image.load("./images/croix.png")
icone[2] = Image.load("./images/carre.png")
icone[3] = Image.load("./images/triangle.png")

-- Musiques de fond
musique = {
	"./musiques/fond1.mp3",
	"./musiques/fond2.mp3",
	"./musiques/apropos.mp3",
}

-- Couleurs
couleur_texte = Color.new(241, 17, 17)
couleur_jaune = Color.new(255, 255, 0)
couleur_vert = Color.new(0, 255, 0)

-- Autres variables
nb_mystere = {}
nb_propose = {}
historique = {}
longueur_nb_mystere = 0
saisie = 0
nb_coups = 0
pos_prop = 1
bien_place = 0
mal_place = 0
tricheur = false
indice_histo = 1
titre = musique[musique_en_cours]

-- Position en y à partir de laquelle écrire quelque chose
y = 100

-- Booléen pour sortir de la boucle lorsque l'on a gagné
sortie = false
