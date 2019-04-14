Scriptname SSLRTMain extends Quest  

Event OnInit()
	RegisterForModEvent("HookAnimationStart", "AddRapeTrauma")
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
	
	Actor act = controller.Positions[1]
	if (act.GetActorBase().GetSex() != 0) ; not male
		return
	endif
	
	Perk[] perks = self._getPerks(act)
	Spell[] spells = self._getSpells(act)
	int level = controller.Positions.length - 1
	
	self._addRapeTrauma(Player, perks, spells, level)
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
			self._downRapeTrauma(player, perks, spells, 0, true)
		endif
	endif
EndFunction

Function _downRapeTrauma(Actor act, Perk[] perks, Spell[] spells, int level, bool allremove = false)
	act.RemovePerk(perks[level])
	act.RemoveSpell(spells[level])
	if (level != 0)
		int x = level - 1
		act.AddSpell(spells[x], false)
	endif
	
	act.AddSpell(SSLRTRemoveTrauma, false)
	Utility.Wait(1.0)
	act.RemoveSpell(SSLRTRemoveTrauma)
	
	if (allremove)
		debug.notification("$SLRTAllRemoveTrauma")
	else
		debug.notification("$SLRTRemoveTrauma")
	endif
EndFunction

Function _addRapeTrauma(Actor player, Perk[] perks, Spell[] spells, int level)
	bool newtrauma = false
	int perklevel = 0
	; level max = 4 (5P)
	
	if (player.HasPerk(perks[4])) ; lv.5
		return
	elseif (player.HasPerk(perks[3])) ; lv.4
		perklevel = 4
	elseif (player.HasPerk(perks[2])) ; lv.3
		if (level == 1)
			perklevel = 3
		else
			perklevel = 4
		endif
	elseif (player.HasPerk(perks[1])) ; lv.2
		if (level <= 2)
			perklevel = level + 1
		else
			perklevel = 4
		endif
	elseif (player.HasPerk(perks[0])) ; lv.1
		if (level <= 3)
			perklevel = level
		else
			perklevel = 4
		endif
	else ; no trauma
		newtrauma = true
		perklevel = level - 1
	endif
	player.AddPerk(perks[perklevel])
	
	self._addSpells(player, perklevel, spells, newtrauma)
EndFunction

Function _addSpells(Actor player, int perklevel, Spell[] spells, bool newtrauma)
	if (!newtrauma)
		int len = spells.Length
		while len > 0
			len -= 1
			player.RemoveSpell(spells[len])
		endwhile
	endif
	
	debug.trace("SLRT: " + perklevel)
	player.AddSpell(spells[perklevel], false)
	
	Utility.Wait(1.0)
	if (newtrauma)
		debug.notification("$SLRTGetTrauma")
	else
		debug.notification("$SLRTAddTrauma")
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
