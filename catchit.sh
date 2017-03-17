#!/bin/bash

################################################################################
# Description   : Le script prend en paramètre une URL youtube dans le but de 
#		  télécharger l'audio de la vidéo, si l'URL est bonne, l'audio sera 
#		  enregistré en mp3 dans le répertoire ~/musique
#
# Auteur        : Guillaume HANOTEL  Ingésup B1A
################################################################################


# enregistre dans la variable format le meilleur format grace à la commande grep qui 
# recherche la ligne indiquant le meilleur format
# on redirige les erreurs dans le néant, et on affiche le message d'erreur qu on veut
# si la l'execution de la commande s est mal passé

format=$(youtube-dl --list-formats $1 2> /dev/null | grep best)
if (( $?==true ));then

	# grace à la commande cut, on récupère la 1ère colonne (l'identifiant) du format
	# pour pouvoir l'utiliser dans la cmd pour télécharger le bon fichier
	id=$(echo $format | cut -d ' ' -f1)
	
	#on télécharge en précisant le dossier de destination, et le format audio
	youtube-dl -x -f $id --audio-format mp3 -o "~/musique/%(title)s.%(ext)s" $1 &> /dev/null
else
	echo "Lien inexistant"
	#renvoi un code erreur différent de 0
	exit 113
fi
