---------------------------------------------------------------------------------------------------------------------------
-- Nom du fichier :    TraceLogLib.applescript
---------------------------------------------------------------------------------------------------------------------------
-- Description      :    Permet de tracer dans un fichier log.
---------------------------------------------------------------------------------------------------------------------------
-- Remarques      :
--				    - A log request of level L in a logger with (either assigned or inherited, whichever is appropriate) level K, is enabled if L >= K.
--				  - Une trace de niveau L dans un loggueur de niveau K est active si L >= K (ex : un loggueur de niveau INFO ne peut tracer que des traces de niveau WARN, ERROR, FATAL
--				    - DEBUG < INFO < WARN < ERROR < FATAL
--				    - testŽ sur Mac OS X 10.12.6
---------------------------------------------------------------------------------------------------------------------------


property parent : AppleScript
property cheminPOSIXComplet : ""
property referenceVersFichierLog : 0
property dateEtHeure : false
property niveauMin : "ALL" -- DEBUG < INFO < WARN < ERROR < FATAL
property messageIntroduction : "DEBUT DU PROGRAMME"
property messageFinal : "FIN DU PROGRAMME"

(*
	ALL    		DEBUG		INFO		WARN		ERROR		FATAL	OFF
	¥DEBUG  	¥DEBUG 
	¥INFO 		¥INFO		¥INFO          
	¥WARN		¥WARN		¥WARN		¥WARN 
	¥ERROR		¥ERROR		¥ERROR		¥ERROR		¥ERROR
	¥FATAL		¥FATAL		¥FATAL		¥FATAL		¥FATAL		¥FATAL
	*)




(*
Nom			: creerUnCheminDeFichierLog
Description	: Renvoi un chemin vers un fichier de log dans ~/Library/Logs/
fileName		: le nom du fichier de log sans extension
retour		: Un chemin vers un fichier de log dans ~/Library/Logs/.
Remarques	: Le nom du fichier de log est nom-du-script-sans-extension.log
			  Le nom complet est donc : ~/Library/Logs/nom-du-script-sans-extension.log
*)

on creerUnCheminDeFichierLog(fileName)
	set libAlias to path to library folder from user domain
	return ((POSIX path of libAlias) as text) & "Logs/" & fileName & ".log"
end creerUnCheminDeFichierLog


(*
Nom				: make new 
Description		: CrŽe un nouveau TraceLog
fileName        	: (txt) le nom du fichier de log sans extension (ex: fichier)
theTimeStamp	: (bool) trace la date et l'heure ou non
theLevel			: (txt) niveau de trace (ex : "DEBUG" ou "INFO" ou "WARN" ou "ERROR" ou "FATAL"
retour			: un objet TraceLog
*)
--on make new TraceLog at fileName given timeStamp:theTimeStamp, level:theLevel
on createTraceLog(fileName, theTimeStamp, theLevel)
	copy me to unObjet
	
	set unObjet's cheminPOSIXComplet to unObjet's creerUnCheminDeFichierLog(fileName)
	set unObjet's dateEtHeure to theTimeStamp
	set unObjet's niveauMin to theLevel
	
	return unObjet
end createTraceLog
--end make


(*
Nom			: sLog (standard log)
Description	: ƒcrit dans le fichier log
ligne        	: (txt) Ce qui doit tre Žcrit dans le fichier log
retour		: La ligne Žcrite, ou "" si erreur
*)
to sLog(ligne) -- standard log
	
	set retour to ""
	
	if dateEtHeure then
		set ligne to creerTimeStamp() & " " & ligne & return
	else
		set ligne to ligne & return
	end if
	
	try
		set referenceVersFichierLog to open for access (POSIX file cheminPOSIXComplet) with write permission
		write ligne to referenceVersFichierLog starting at eof as Çclass utf8È
		close access referenceVersFichierLog
		set retour to ligne
	on error
		try
			close access referenceVersFichierLog
		end try
	end try
	
	return retour
	
end sLog

(*
Nom			: pLog (priority log)
Description	: ƒcrit dans le fichier log avec un niveau de prioritŽ
ligne        	: (txt) Ce qui doit tre Žcrit dans le fichier log
theLevel       	: niveau donnŽe ˆ la trace (ex : "DEBUG" ou "INFO" ou "WARN" ou "ERROR" ou "FATAL") 
retour		: ce qui a ŽtŽ Žcrit ou "" si erreur.
*)
to pLog of ligne given level:theLevel -- priority log
	
	set retour to ""
	
	if (length of theLevel is 4) then
		set theLevel to theLevel & " "
	end if
	log "theLevel is " & theLevel
	
	if (theLevel is "DEBUG") or (theLevel is "INFO ") or (theLevel is "WARN ") or (theLevel is "ERROR") or (theLevel is "FATAL") then
		set ligne to "[" & theLevel & "] " & ligne
		log "ligne is " & ligne
	end if
	
	log "niveauMin is " & niveauMin
	
	if (niveauMin is "ALL") or (niveauMin is "DEBUG") or ((niveauMin is "INFO") and (theLevel is not "DEBUG")) or ((niveauMin is "WARN") and ((theLevel is not "DEBUG") and (theLevel is not "INFO "))) or ((niveauMin is "ERROR") and ((theLevel is not "DEBUG") and (theLevel is not "INFO ") and (theLevel is not "WARN "))) or ((niveauMin is "FATAL") and ((theLevel is not "DEBUG") and (theLevel is not "INFO ") and (theLevel is not "WARN ") and (theLevel is not "ERROR"))) then
		sLog(ligne)
		set retout to ligne
		log "On a Žcrit : " & ligne
	else
		-- do nothing
		log "do nothing"
	end if
	
end pLog


(*
Nom			: separatorLog
Description	: ƒcrit une marque de sŽparation dans le fichier log.
retour		: RIEN.
Remarque    	: la sŽparation est de la forme : " -----------------------------------------------"
*)
to separatorLog()
	sLog(" -----------------------------------------------")
end separatorLog


(*
Nom			: loggingIntroduction
Description	: ƒcrit une marque de dŽbut de trace dans le fichier log.
retour		: RIEN.
*)
on loggingIntroduction()
	sLog(" --------------- " & messageIntroduction & " ----------------")
end loggingIntroduction


(*
Nom			: loggingTermination
Description	: ƒcrit une marque de fin de trace dans le fichier log.
retour		: RIEN.
*)
on loggingTermination()
	sLog(" --------------- " & messageFinal & " ----------------")
	sLog("")
end loggingTermination


(*
Nom			: creerTimeStamp
Description	: Renvoi la date et l'heure (au format JJ/MM/AAAA HH:MM:SS)
retour		: la date et l'heure (au format JJ/MM/AAAA HH:MM:SS).
*)
on creerTimeStamp()
	return (short date string of (current date) & " " & time string of (current date))
end creerTimeStamp

(*
Nom			: closeLog
Description	: Ferme le fichier de log (on ne peut plus Žcrire dedans)
retour		: RIEN.
Remarque	: Un message de fin est ajoutŽ avant la fermeture (borne fin du log)
*)
on closeLog()
	loggingTermination()
end closeLog




-----------------------------------------------------------------------------------------------------------
--                                                     TESTS
-----------------------------------------------------------------------------------------------------------


-- Pour tester cette bibliothque :

-- 1¡) Installez la bibliothque dans le dossier : ~/Library/Script Libraries/
-- 2¡) CrŽez un nouveau fichier script contenant le code suivant :

(*
tell script "Trace Log"
	
	--set monLog to make new TraceLog at "testLib" with timeStamp given level:"ALL"
	
	set monLog to createTraceLog("testLib", true, "ALL")
	
	if monLog is not missing value then
		
		tell monLog
			
			log cheminPOSIXComplet of it
			log referenceVersFichierLog of it
			log dateEtHeure of it
			log niveauMin of it
			log messageIntroduction of it
			log messageFinal of it
			
			set listeDesNiveaux to {"ALL", "DEBUG", "INFO", "WARN", "ERROR", "FATAL", "OFF"}
			
			repeat with niveau in listeDesNiveaux
				
				set its niveauMin to niveau as text
				set message to "--------------------- " & niveau & " --------------------------"
				sLog(message)
				log message
				
				pLog of "Un message de type debug !" given level:"DEBUG"
				pLog of "Un message de type info  !" given level:"INFO"
				pLog of "Un message de type warn  !" given level:"WARN"
				pLog of "Un message de type error !" given level:"ERROR"
				pLog of "Un message de type fatal !" given level:"FATAL"
				log "fin de boucle"
				
			end repeat
			
			closeLog()
			
		end tell
	end if
	
	
end tell



*)


-----------------------------------------------------------------------------------------------------------
--                                                     FIN
-----------------------------------------------------------------------------------------------------------
