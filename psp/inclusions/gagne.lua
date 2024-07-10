if nb_coups > 1 then
	message = "Vous avez gagne en "..nb_coups.." coups !"
else
	message = "Vous avez gagne en "..nb_coups.." coup !"
end

while sortie == false do
	touche = Controls.read()
	screen:clear()
	screen:blit(0, 0, fond["gagne"])
	screen:print(40, y + 35, message, couleur_texte)
	screen:print(40, y + 50, "Pour lancer une nouvelle partie", couleur_texte)
	screen:print(40, y + 65, "appuyez sur start", couleur_texte)
	if tricheur == true then
		screen:blit(300, 73, Image.load("./images/tricheur.png"))
	end
	if touche:start() and not anctouche:start() then
		recup_touche()
	end
	
	anctouche = touche
	screen:waitVblankStart()
	screen:flip()
end
