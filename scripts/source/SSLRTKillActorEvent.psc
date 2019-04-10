Scriptname SSLRTKillActorEvent extends Quest  

Event OnInit()
	Actor act = Victim.GetActorRef()
	if (act)
		MainScript.RemoveRapeTrauma(act)
	endif
	self.Stop()
EndEvent

ReferenceAlias Property Victim  Auto  
SSLRTMain Property MainScript Auto