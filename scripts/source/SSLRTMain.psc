Scriptname SSLRTMain extends Quest  

Event OnInit()
	RegisterForModEvent("HookStageStart", "AddRapeTrauma")
EndEvent

Event AddRapeTrauma(int tid, bool hasPlayer)
	Actor Player = Game.GetPlayer()
	if (!hasPlayer || Player.GetActorBase().GetSex() == 0)
		return
	endif
	
	sslThreadController controller = SexLab.GetController(tid)
	if (controller.IsAggressive)
		if !(controller.IsVictim(Player))
			return
		endif
	else
		return
	endif
	
	Perk[] perks = self._getPerks(controller.Positions[1])
	int level = controller.Positions.length - 1
	
	self._addRapeTrauma(Player, level, perks)
EndEvent

Function RemoveRapeTrauma(Actor victim)
	if (Utility.RandomInt() < SSLRTRemovePercent.GetValue())
		Actor Player = Game.GetPlayer()
		Perk[] perks = self._getPerks(victim)
		if (player.HasPerk(perks[4]))
			player.RemovePerk(perks[4])
			return
		elseif (player.HasPerk(perks[3]))
			player.RemovePerk(perks[3])
			return
		elseif (player.HasPerk(perks[2]))
			player.RemovePerk(perks[2])
			return
		elseif (player.HasPerk(perks[1]))
			player.RemovePerk(perks[1])
			return
		elseif (player.HasPerk(perks[0]))
			player.RemovePerk(perks[0])
			return
		endif
	endif
EndFunction

Function _addRapeTrauma(Actor player, int level, Perk[] perks)
	if (player.HasPerk(perks[4]))
		return
	elseif (player.HasPerk(perks[3]))
		player.AddPerk(perks[4])
	elseif (player.HasPerk(perks[2]))
		if (level == 1)
			player.AddPerk(perks[3])
		else
			player.AddPerk(perks[4])
		endif
	elseif (player.HasPerk(perks[1]))
		if (level <= 2)
			player.AddPerk(perks[level + 1])
		else
			player.AddPerk(perks[4])
		endif
	else
		if (level <= 3)
			player.AddPerk(perks[level])
		else
			player.AddPerk(perks[4])
		endif
	endif
EndFunction

Perk[] Function _getPerks(Actor act)
	if (act.HasKeyword(ActorTypeNPC))
		return MalePerks
	elseif (act.HasKeyword(ActorTypeDwarven))
		return DwarvenPerks 
	elseif (act.IsInFaction(PredatorFaction))
		return PredatorPerks
	else
		return CreaturePerks
	endif
EndFunction

SexLabFramework Property SexLab Auto

Keyword Property ActorTypeNPC  Auto  
Keyword Property ActorTypeDwarven  Auto  
Faction Property PredatorFaction  Auto  
Faction Property CreatureFaction  Auto  ; not use

Perk[] Property MalePerks  Auto  
Perk[] Property DwarvenPerks  Auto  
Perk[] Property PredatorPerks  Auto  
Perk[] Property CreaturePerks  Auto  

GlobalVariable Property SSLRTRemovePercent  Auto  
