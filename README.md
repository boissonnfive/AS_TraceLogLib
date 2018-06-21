# Trace Log #

Une bibliothèque pour écrire dans un fichier log en AppleScript.

## Fonctionnalités

- Écrit dans un fichier log du dossier _~/Library/Logs/_ (ouvre et ferme le fichier à chaque écriture)
- Chaque trace dans le log peut être précédée d'une date (voir paramètre _theTimeStamp_ de la fonction _createTraceLog_)
- Filtrage des traces grâce à un système de priorités (ou niveau hiérarchique des traces)

**Niveaux hiérarchiques des traces**

Chaque trace dans le log a une priorité, un niveau hiérarchique : DEBUG < INFO < WARN < ERROR < FATAL. Et le log est créé avec un niveau de priorité minimum (voir paramètre _theLevel_ de la fonction _createTraceLog_). Ainsi, un log créé avec une priorité P1 ne peut tracer que des traces de priorité P2 >= P1 (avec ALL < DEBUG < INFO < WARN < ERROR < FATAL).

Dans une phase de mise au point, on utilisera un log de niveau « ALL » ou « DEBUG ». En production, on pourra ne garder que les traces de niveau « ERROR » et « FATAL » en initialisant le log avec le niveau « ERROR ».

(voir les tests pour des exemples de log avec priorité)

## Fonctions

- __creerUnCheminDeFichierLog__ : Renvoi un chemin vers un fichier de log dans _~/Library/Logs/_ (fonction privée)
- __createTraceLog__ : Crée un nouveau TraceLog
- __sLog__ : Écrit dans le fichier log
- __pLog of ligne given level:theLevel__ : Écrit dans le fichier log avec un niveau de priorité
- __separatorLog__ : Écrit une marque de séparation dans le fichier log.
- __loggingIntroduction__ : Écrit une marque de début de trace dans le fichier log.
- __loggingTermination__ : Écrit une marque de fin de trace dans le fichier log.
- __creerTimeStamp__ : Renvoi la date et l'heure (au format JJ/MM/AAAA HH:MM:SS)
- __closeLog__ : Écrit une marque de fin de trace dans le fichier log.

*NOTE : le message d'introduction et le message de fin de log peuvent être modifiés grâce aux propriétés suivantes :*

- messageIntroduction
- messageFinal


## Installer

Pour installer cette bibliothèque :

1. Ouvrez le fichier *Trace Log.applescript* avec l'« Éditeur de script »
2. Exporter ce fichier au format « Script » => *Trace Log.scpt*
3. Copiez *Trace Log.scpt* dans le dossier *~/Library/Script Libraries*

## Utliser/Tester

Pour tester le fonctionnement de cette bibliothèque :

1.    Ouvrez le fichier *Trace Log.applescript* avec l'« Éditeur de script »
2.    Copiez tout le code qui se trouve sous :

        -----------------------------------------------------------------------
        --                              TESTS
        -----------------------------------------------------------------------

     Dans un nouveau fichier Applescript.

3.   Enlevez les commentaires «(*» et «*)»
4.   Lancer le script

Vous savez comment utliser cette bibliothèque. Faites de même dans votre projet.
