Scriptname SSLRTKillActorEvent extends Quest  

Event OnInit()
	Actor act = Victim.GetActorRef()
	if (act)
		if (act.GetLeveledActorBase().GetSex() == 0)
			MainScript.RemoveRapeTrauma(act)
		endif
	endif
	self.Stop()
EndEvent

ReferenceAlias Property Victim  Auto  
SSLRTMain Property MainScript Auto