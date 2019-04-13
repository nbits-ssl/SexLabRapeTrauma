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
		Spell[] spells = self._getSpells(victim)
		
		if (player.HasPerk(perks[4]))
			self._downRapeTrauma(player, perks, spells, 4)
		elseif (player.HasPerk(perks[3]))
			self._downRapeTrauma(player, perks, spells, 3)
		elseif (player.HasPerk(perks[2]))
			self._downRapeTrauma(player, perks, spells, 2)
		elseif (player.HasPerk(perks[1]))
			self._downRapeTrauma(player, perks, spells, 1)
		elseif (player.HasPerk(perks[0]))
			self._downRapeTrauma(player, perks, spells, 0)
		endif
	endif
EndFunction

Function _downRapeTrauma(Actor act, Perk[] perks, Spell[] spells, int level)
	act.RemovePerk(perks[level])
	act.RemoveSpell(spells[level])
	if (level != 0)
		int x = level - 1
		act.AddSpell(spells[x])
	endif
	
	act.AddSpell(SSLRTRemoveTrauma)
	Utility.Wait(1.0)
	act.RemoveSpell(SSLRTRemoveTrauma)
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

Spell[] Function _getSpells(Actor act)
	if (act.HasKeyword(ActorTypeNPC))
		return MaleSpells
	elseif (act.HasKeyword(ActorTypeDwarven))
		return DwarvenSpells 
	elseif (act.IsInFaction(PredatorFaction))
		return PredatorSpells
	else
		return CreatureSpells
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

SPELL[] Property MaleSpells  Auto  
SPELL[] Property CreatureSpells  Auto  
SPELL[] Property DwarvenSpells  Auto  
SPELL[] Property PredatorSpells  Auto  
; SPELL[] Property PredetorSpells  Auto  ; fuck, miss spell
SPELL Property SSLRTRemoveTrauma  Auto  

GlobalVariable Property SSLRTRemovePercent  Auto  
