--
-- Fonction	: copie_table
-- Objectif	: copie le contenu d'un tableau dans un autre.
-- Entrées	:
--		- (array) le tableau à copier
-- Sortie	:
--		- (array) le tableau copié
-- MAJ		: 10/03/2010
--
function copie_table(tableau_source)
	local i = 1
	local longueur_source = #tableau_source
	local tableau_destination = {}
	
	while i <= longueur_source do
		tableau_destination[i] = tableau_source[i]
		i = i + 1
	end
	return tableau_destination
end --fin copie_table


--
-- Fonction	: efface_indice_table
-- Objectif	: efface N indices du tableau.
-- Entrées	:
--		- (array) le tableau à purger
--		- (int) le nombre d'éléments à supprimer
-- Sortie	:
--		- (array) le tableau purgé
-- MAJ		: 10/03/2010
--
function efface_indice_table(tableau_source, nb_efface)
	local i = 1
	local longueur_source = #tableau_source - nb_efface
	local tableau_destination = {}
	
	while i <= longueur_source do
		tableau_destination[i] = tableau_source[i]
		i = i + 1
	end
	return tableau_destination
end --fin efface_indice_table


--
-- Fonction	: genere_mystere
-- Objectif	: générer un nombre mystère.
-- Entrées	:
-- Sortie	:
-- MAJ		: 16/03/2010
--
function genere_mystere()
	local i = 1
	
	while i <= niveau do
		nb_mystere[i] = math.random(0, 3)
		i = i + 1
	end
	longueur_nb_mystere = niveau
end --fin genere_mystere


--
-- Fonction	: recup_touche
-- Objectif	: récupère le bouton appuyé et effectue l'action qui lui est assignée.
-- Entrées	:
-- Sortie	:
-- MAJ		: 15/03/2010
--
function recup_touche()
	-- Boutons de proposition : rond, croix, carré et triangle
	if touche:triangle() and not anctouche:triangle() then
		saisie = 3
		if pos_prop <= longueur_nb_mystere then
			nb_propose[pos_prop] = saisie
			pos_prop = pos_prop + 1
		end
	end
	if touche:square() and not anctouche:square() then
		saisie = 2
		if pos_prop <= longueur_nb_mystere then
			nb_propose[pos_prop] = saisie
			pos_prop = pos_prop + 1
		end
	end
	if touche:cross() and not anctouche:cross() then
		saisie = 1
		if pos_prop <= longueur_nb_mystere then
			nb_propose[pos_prop] = saisie
			pos_prop = pos_prop + 1
		end
	end
	if touche:circle() and not anctouche:circle() then
		saisie = 0
		if pos_prop <= longueur_nb_mystere then
			nb_propose[pos_prop] = saisie
			pos_prop = pos_prop + 1
		end
	end
	
	-- Boutons de validation et d'effacement
	if touche:l() and not anctouche:l() and pos_prop == longueur_nb_mystere + 1 then -- valider
		maitre_penseur()
	end
	if touche:r() and not anctouche:r() then -- effacer le dernier caractère
		if pos_prop > 1 then
			pos_prop = pos_prop - 1
			nb_propose = efface_indice_table(nb_propose, 1)
		end
	end
	
	-- Boutons de remise à zéro et d'à propos
	if touche:start() and not anctouche:start() then
		raz()
		sortie = true
	end
	-- Bouton daccès au menu
	if touche:select() and not anctouche:select() then
		dofile("./inclusions/menu.lua")
		sortie = false
	end
	
	-- Bouton de triche
	if touche:hold() then
		tricheur = true
		afficher_icones(122, 80, nb_mystere)
	end
	
	-- Boutons de défilement de l'historique
	if touche:up() and not anctouche:up() then
		indice_historique("plus")
	end
	if touche:down() and not anctouche:down() then
		indice_historique("moins")
	end
	if touche:left() and not anctouche:left() then
		indice_histo = #historique
	end
	if touche:right() and not anctouche:right() then
		indice_histo = 1
	end
end --fin recup_touche


--
-- Fonction	: raz
-- Objectif	: remise à zero pour préparer une nouvelle partie.
-- Entrées	:
-- Sortie	:
-- MAJ		: 10/03/2010
--
function raz()
	nb_mystere = {}
	nb_propose = {}
	historique = {}
	pos_prop = 1
	nb_coups = 0
	bien_place = 0
	mal_place = 0
	tricheur = false
	indice_histo = 1
	genere_mystere()
end --fin raz

--
-- Fonction	: maitre_penseur
-- Objectif	: traitement de comparaisons entre le nombre mystère et la proposition de l'utlisateur.
-- Entrées	:
-- Sortie	:
-- MAJ		: 10/03/2010
--
function maitre_penseur()
	local mystere = copie_table(nb_mystere)
	local proposition = copie_table(nb_propose)
	local i = 1
	local j = 1

	bien_place = 0
	mal_place = 0
	nb_coups = nb_coups + 1
	if table.concat(proposition) == table.concat(mystere) then
		dofile("./inclusions/gagne.lua")
		return
	end

	-- compter les bien placés
	while i <= longueur_nb_mystere do
		if proposition[i] == mystere[i] then
			bien_place = bien_place + 1
			proposition[i] = "#"
			mystere[i] = "#"
		end
		i = i + 1
	end

	-- compter les mal placés
	i = 1
	while i <= longueur_nb_mystere do
		j = 1
		while j <= longueur_nb_mystere do
			if mystere[i] == proposition[j] and mystere[i] ~= "#" then
				mal_place = mal_place + 1
				mystere[i] = "#"
				proposition[j] = "#"
			end
			j = j + 1
		end
		i = i + 1
	end
	
	ajouter_historique()
	nb_propose = {}
	pos_prop = 1
end --fin maitre_penseur


--
-- Fonction	: afficher_icones
-- Objectif	: affiche les icones des boutons.
-- Entrées	:
--		- (int) position en x des icones
--		- (int) position en y des icones
--		- (array) tableau contenant les indices des icones à afficher
-- Sortie	:
-- MAJ		: 10/03/2010
--
function afficher_icones(posx, posy, nombre) 
	local longueur = #nombre
	local i = 1
	
	while i <= longueur do
		if nombre[i] ~= nil and icone[nombre[i]] ~= nil then
			screen:blit(posx, posy, icone[nombre[i]])
			posx = posx + icone[nombre[i]]:width() + 1
		end
		i = i + 1
	end
end --fin afficher_icones


--
-- Fonction	: ajouter_historique
-- Objectif	: ajoute une proposition à l'historique des propositions.
-- Entrées	:
-- Sortie	:
-- MAJ		: 10/03/2010
--
function ajouter_historique()
	local longueur = #historique
	
	if nb_coups == 1 then
		historique[1] = {
			essai = nb_coups,
			combinaison = copie_table(nb_propose),
			b = bien_place,
			m = mal_place
		}
		return
	elseif historique[longueur]["essai"] ~= nb_coups then
		historique[longueur + 1] = {
			essai = nb_coups,
			combinaison = copie_table(nb_propose),
			b = bien_place,
			m = mal_place
		}
	end
	indice_historique()
end --fin ajouter_historique


--
-- Fonction	: afficher_historique
-- Objectif	: affiche les lignes de l'historique des propositions.
-- Entrées	:
-- Sortie	:
-- MAJ		: 15/03/2010
--
function afficher_historique()
	local i = 1
	local j = indice_histo
	local posy = 126
	local decalage = 0
	
	while i <= indice_histo and i < 10 do
		screen:print(33, posy + decalage, historique[j]["essai"], couleur_texte)
		afficher_icones(66, posy + decalage - 2, historique[j]["combinaison"])
		screen:print(183, posy + decalage, historique[j]["b"], couleur_texte)
		screen:print(203, posy + decalage, historique[j]["m"], couleur_texte)
		j = j - 1
		i = i + 1
		decalage = decalage + 12
	end
end --fin afficher_historique


--
-- Fonction	: indice_historique
-- Objectif	: modifier l'indice de l'historique.
-- Entrées	:
-- 		- (string) "plus" ou "moins"
-- Sortie	:
-- MAJ		: 15/03/2010
--
function indice_historique(mode)
	if mode == nil then
		indice_histo = #historique
	elseif mode == "plus" and indice_histo < #historique then
		indice_histo = indice_histo + 1
	elseif mode == "moins" and indice_histo > 1 then
		indice_histo = indice_histo - 1
	end
end --fin indice_historique


--
-- Fonction	: afficher_menu
-- Objectif	: modifier l'indice de l'historique.
-- Entrées	:
-- Sortie	:
-- MAJ		: 16/03/2010
--
function afficher_menu()
	local total_menu = #menu
	local posy = 86
	local posx = 125
	local decalage = 0
	local indice_menu = 1
	
	while indice_menu <= total_menu do
		if indice_menu == selection then
			screen:print(posx, posy + decalage, menu[indice_menu], couleur_jaune)
		else
			screen:print(posx, posy + decalage, menu[indice_menu], couleur_texte)
		end
		indice_menu = indice_menu + 1
		decalage = decalage + 15
	end
	screen:print(posx + 180, posy + 30, niveau.."/9", couleur_vert)
	screen:print(posx + 180, posy + 45, musique_en_cours.."/2", couleur_vert)
end --fin afficher_menu


--
-- Fonction	: lire_musique
-- Objectif	: Gère la lecture de musique.
-- Entrées	:
-- Sortie	:
-- MAJ		: 16/03/2010
--
function lire_musique()
	if Mp3me.eos() == "true" then
		Mp3me.stop()
		Mp3me.load(titre)
		Mp3me.play()
	end
end --fin lire_musique
