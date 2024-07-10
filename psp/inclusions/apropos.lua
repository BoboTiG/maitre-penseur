titre = musique[3]
Mp3me.stop()
Mp3me.load(titre)
Mp3me.play()

anctouche = Controls.read()

while sortie == false do
	touche = Controls.read()
	screen:clear()
	screen:blit(0, 0, fond["apropos"])
	
	lire_musique()
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
