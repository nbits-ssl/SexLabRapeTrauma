Scriptname SSLRTInit extends Quest  

Quest Property MainQuest Auto  

Event OnInit()
	if !(MainQuest.IsRunning())
		MainQuest.Start()
	endif
	self.Stop()
EndEvent
