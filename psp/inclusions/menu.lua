menu = {
	"Retour",
	"Nouvelle partie",
	"Choix du niveau",
	"Choix de la musique",
	"A propos",
	"Sauvegarder la configuration",
	"Quitter",
}
selection = 1
texte_sauvegarde = " "

anctouche = Controls.read()

while sortie == false do
	touche = Controls.read()
	screen:clear()
	
	if touche:up() and not anctouche:up() then
		if selection > 1 then
			selection = selection - 1
		elseif selection == 1 then
			selection = #menu
		end
	end
	if touche:down() and not anctouche:down() then
		if selection < #menu then
			selection = selection + 1
		elseif selection == #menu then
			selection = 1
		end
	end
	if (touche:left() and not anctouche:left()) or (touche:right() and not anctouche:right()) then
		if selection == 4 then -- Choix de la musique
			if musique_en_cours == 1 then
				musique_en_cours = 2
				titre = musique[2]
			else
				musique_en_cours = 1
				titre = musique[1]
			end
			Mp3me.stop()
			Mp3me.load(titre)
			Mp3me.play()
		end
	end
	if touche:left() and not anctouche:left() then
		if selection == 3 then -- Choix du niveau
			if niveau > 2 then
				niveau = niveau - 1
			else
				niveau = 9
			end
			raz()
		end
	end
	if touche:right() and not anctouche:right() then
		if selection == 3 then -- Choix du niveau
			if niveau < 9 then
				niveau = niveau + 1
			else
				niveau = 2
			end
			raz()
		end
	end
	if touche:cross() and not anctouche:cross() then
		if selection == 1 then -- Retour
			sortie = true
		elseif selection == 2 then -- Nouvelle partie
			raz()
			sortie = true
		elseif selection == 4 then -- Choix de la musique
			if musique_en_cours == 1 then
				musique_en_cours = 2
				titre = musique[2]
			else
				musique_en_cours = 1
				titre = musique[1]
			end
			Mp3me.stop()
			Mp3me.load(titre)
			Mp3me.play()
		elseif selection == 5 then -- A propos
			dofile("./inclusions/apropos.lua")
			sortie = false
			titre = musique[musique_en_cours]
			Mp3me.stop()
			Mp3me.load(titre)
			Mp3me.play()
		elseif selection == 6 then -- Sauvegarder la configuration
			fichier = io.open("./inclusions/parametres.cfg", "w")
			fichier:write("niveau = "..niveau.."\nmusique_en_cours = "..musique_en_cours.."\n")
			fichier:close()
			texte_sauvegarde = "...Ok"
		elseif selection == #menu then -- Quitter
			System.Quit()
		end
	end
	
	afficher_menu()
	screen:print(374, 160, texte_sauvegarde, couleur_vert)
	
	if touche:select() and not anctouche:select() then
		sortie = true
	end
	if touche:circle() and not anctouche:circle() then
		sortie = true
	end
	
	anctouche = touche
	screen:waitVblankStart()
	screen:flip()
end
