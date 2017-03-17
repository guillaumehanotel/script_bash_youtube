#!/bin/bash

################################################################################
# Description   : Le script va chercher tous les fichiers txt du dossier todl
#		  On cree un fichier rapport dans le home avec la date a laquelle le
#		  le script se lance, 
#		  Pour chaque fichier txt, pour chaque ligne, on appelle le script 
#		  catchit qui telechargera l'audio avec les liens trouves
#		  Chaque lien sera reecrit dans le fichier rapport avec OK ou
#		  KO selon si le telechargement a fonctionne ou non 
#
# Auteur	: Guillaume HANOTEL
################################################################################

if [ ! -d "$HOME/todl/" ];then
	echo "Creation du dossier todl qui sera surveille"
	mkdir "$HOME/todl/"
fi

dossier=$(echo "$HOME/todl/")

touch $HOME/rapport.txt

while true
do
	fichiers=$(find $dossier -name "*.txt")
	date=$(date +%D:%Hh%M)

	# si la variable fichiers n'est pas vide, on ecrit une nouvelle date dans le rapport
	if [ ! -z $fichiers ];then
		echo "------- Rapport du $date -------" >> $HOME/rapport.txt
		echo "Debut du/des téléchargements..."

		#pour chaque fichier dans le dossier todl
		for f in $fichiers
		do
			#pour chaque ligne d'un fichier
			while read line; do
				# On DL
				$HOME/catchit.sh $line
	 
				# si ça s'est bien passe, on ecrit OK pour ce lien dans le rapport
				if (( $?==true ));then
					echo "$line OK" >> $HOME/rapport.txt
				#sinon on ecrit KO
				else 
					echo "$line KO" >> $HOME/rapport.txt
				fi
			done <$f
			#si le fichier existe
			if [ -e $f ];then
				rm $f #on supprime le fichier
			fi

		done
		echo "Fin du/des téléchargements"

	fi

	#on attend 1 seconde entre chaque boucle 
	sleep 1
done </dev/null 2>&1 &
disown
#le script devient un daemon
