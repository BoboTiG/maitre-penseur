-- Récupération de la configuration
dofile("./inclusions/parametres.cfg")

-- Récupération des entêtes, variables
dofile("./inclusions/entetes.lua")

-- Récupération des fonctions
dofile("./inclusions/fonctions.lua")

-- C'est parti !
anctouche = Controls.read()
genere_mystere()
Mp3me.load(titre)
Mp3me.play()

-- Boucle principale, coeur du programme
while true do
	sortie = false
	touche = Controls.read()
	screen:clear()
	screen:blit(0, 0, fond["normal"])
	
	lire_musique()
	recup_touche()
	afficher_icones(122, 92, nb_propose)
	if nb_coups > 0 then
		afficher_historique()
	end
	
	anctouche = touche
	screen:waitVblankStart()
	screen:flip()
end
