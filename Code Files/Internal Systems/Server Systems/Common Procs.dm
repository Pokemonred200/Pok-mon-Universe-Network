var typeMatchup[0][0]
var tmIncompatible[]

proc
	getPokerusLength(pokemon/P)
		var pokerusStrain = ((P.pokerus >> 4) & 0x000F)
		return pokerusStrain
	getPokerusStrain(pokemon/P)
		var pokerusLength = (P.pokerus & 0x000F)
		return pokerusLength
	setPokerusLength(pokemon/P,value)
		P.pokerus &= ~(0x00F0)
		P.pokerus |= (value << 4)
	setPokerusStrain(pokemon/P,value)
		P.pokerus &= ~(0x000F)
		P.pokerus |= (value)

	speciesMatch(pokemon/P1,pokemon/P2,list/nlist1,list/nlist2)
		if(!islist(nlist1))nlist1 = list(nlist1)
		if(!islist(nlist2))nlist2 = list(nlist2)
		if((P1.gender != NEUTER) && (P2.gender != NEUTER))
			if(P1.gender==P2.gender)return FALSE
		return (((P1.pName in nlist1)&&(P2.pName in nlist2))||((P1.pName in nlist2)&&(P2.pName in nlist1)))
	Shuffle(list/shuffle)
		for(var/i in 1 to shuffle.len)
			shuffle.Swap(i,rand(i,shuffle.len))
		return shuffle
	ribbonDesc(ribbon)
		switch(ribbon)
			if("Classic Champion Ribbon")return "Defeated the Champion in a Pokémon Generation III game."
			if("Cool Ribbon")return "Won a Hoenn Normal Rank Cool Contest in Pokémon Ruby, Sapphire, or Emerald."
			if("Super Cool Ribbon")return "Won a Hoenn Super Rank Cool Contest in Pokémon Ruby, Sapphire, or Emerald."
			if("Cool Hyper Ribbon")return "Won a Hoenn Hyper Rank Cool Contest in Pokémon Ruby, Sapphire, or Emerald."
			if("Cool Master Ribbon")return "Won a Hoenn Master Rank Cool Contest in Pokémon Ruby, Sapphire, or Emerald."
			if("Beauty Ribbon")return "Won a Hoenn Normal Rank Beauty Contest in Pokémon Ruby, Sapphire, or Emerald."
			if("Super Beauty Ribbon")return "Won a Hoenn Super Rank Beauty Contest in Pokémon Ruby, Sapphire, or Emerald."
			if("Beauty Hyper Ribbon")return "Won a Hoenn Hyper Rank Beauty Contest in Pokémon Ruby, Sapphire, or Emerald."
			if("Beauty Master Ribbon")return "Won a Hoenn Master Rank Beauty Contest in Pokémon Ruby, Sapphire, or Emerald."
			if("Cute Ribbon")return "Won a Hoenn Normal Rank Cute Contest in Pokémon Ruby, Sapphire, or Emerald."
			if("Super Cute Ribbon")return "Won a Hoenn Super Rank Cute Contest in Pokémon Ruby, Sapphire, or Emerald."
			if("Cute Hyper Ribbon")return "Won a Hoenn Hyper Rank Cute Contest in Pokémon Ruby, Sapphire, or Emerald."
			if("Cute Master Ribbon")return "Won a Hoenn Master Rank Beauty Contest in Pokémon Ruby, Sapphire, or Emerald."
			if("Smart Ribbon")return "Won a Hoenn Normal Rank Smart Contest in Pokémon Ruby, Sapphire, or Emerald."
			if("Super Smart Ribbon")return "Won a Hoenn Super Rank Smart Contest in Pokémon Ruby, Sapphire, or Emerald."
			if("Smart Hyper Ribbon")return "Won a Hoenn Hyper Rank Smart Contest in Pokémon Ruby, Sapphire, or Emerald."
			if("Smart Master Ribbon")return "Won a Hoenn Master Rank Smart Contest in Pokémon Ruby, Sapphire, or Emerald."
			if("Tough Ribbon")return "Won a Hoenn Normal Rank Tough Contest in Pokémon Ruby, Sapphire, or Emerald."
			if("Super Tough Ribbon")return "Won a Hoenn Super Rank Tough Contest in Pokémon Ruby, Sapphire, or Emerald."
			if("Tough Hyper Ribbon")return "Won a Hoenn Hyper Rank Tough Contest in Pokémon Ruby, Sapphire, or Emerald."
			if("Tough Master Ribbon")return "Won a Hoenn Master Rank Tough Contest in Pokémon Ruby, Sapphire, or Emerald."
			if("Artist Ribbon")return "Got recognized as a Super Sketch Model in Hoenn in Pokémon Ruby, Sapphire, or Emerald."
			if("Effort Ribbon")return "Worked hard and has full Effort Values."
			if("Winning Ribbon")return "Cleared the Level 50 Challenge at Hoenn's Battle Tower in Pokémon Ruby, Sapphire, or Emerald."
			if("Victory Ribbon")return "Cleared the Level 100 or Open Level Challenge at Hoenn's Battle Tower in Pokémon Ruby, Sapphire, or Emerald."
	canLearnThis(pokemon/PK,movetext,type)
		if(isnull(PK))return
		var learnable
		if(PK.pName in list("Rattata","Raticate","Raichu","Sandshrew","Sandslash","Vulpix","Ninetales","Diglett","Dugtrio",
		"Meowth","Persian","Geodude","Graveler","Golem","Grimer","Muk","Exeggutor","Marowak","Wormadam")) // Alolan Forms (And Wormadam) can use different TMs.
			learnable = "[PK.pName][PK.form]"
		else
			learnable = "[PK.pName]"
		switch(type)
			if("TM")
				var tmInfo = getTMInfo(movetext)
				if(tmInfo=="ALL"). = !("[learnable]" in tmIncompatible)
				else if(tmInfo=="ALLGENDERED")
					if(PK.gender in list("male","female")). = !("[learnable]" in tmIncompatible)
					else . = false
				else if(istype(tmInfo,/list) && (tmInfo[1]=="ALLEXCEPT"))
					var tmList[] = tmInfo
					. = (!("[learnable]" in tmIncompatible)) && (!("[learnable]" in tmList.Copy(2,0)))
				else . = ("[learnable]" in tmInfo)
			if("HM"). =  ("[learnable]" in getHMInfo(movetext))
			if("Tutor"). = ("[learnable]" in getMoveTutorInfo(movetext))
			if("Friend Tutor")
				if(PK.friendship==255). = ("[learnable]" in getMoveTutorInfo(movetext))

	getStats(pokemon/P){. = pokemonStats["[P.pName][P.form][P.formID]"]}
	setStats(pokemon/P)
		pokemonStats["[P.pName][P.form][P.formID]"] = P.stats
		P.stats = null
	getEvs(pokemon/P){. = pokemonEvs["[P.pName][P.form][P.formID]"]}
	setEvs(pokemon/P)
		pokemonEvs["[P.pName][P.form][P.formID]"] = P.evYield
		P.evYield = null
	updateEvents(player/P)
		var mob/eventBattle/DeoxysBattle/D = locate(/mob/eventBattle/DeoxysBattle)
		P.client.images.Remove(D.rubyImage,D.sapphireImage,D.emeraldImage)
		if(!(P.story.storyFlags2 & CAUGHT_DEOXYS))
			switch(P.mode)
				if("Ruby")
					P.client.images |= D.rubyImage
				if("Sapphire")
					P.client.images |= D.sapphireImage
				if("Emerald")
					P.client.images |= D.emeraldImage
		var mob/eventBattle/DarkraiBattle/DR = locate(/mob/eventBattle/DarkraiBattle)
		if(!(P.story.storyFlags2 & CAUGHT_DARKRAI))
			P.client.images |= DR.sprite
		else
			P.client.images -= DR.sprite
		var mob/eventBattle/Ho_Oh_Battle/H = locate(/mob/eventBattle/Ho_Oh_Battle)
		if(!(P.story.storyFlags2 & CAUGHT_HO_OH))
			P.client.images |= H.sprite
		else
			P.client.images -= H.sprite
		H = locate(/mob/eventBattle/LugiaBattle)
		if(!(P.story.storyFlags2 & CAUGHT_LUGIA))
			P.client.images |= H.sprite
		else
			P.client.images -= H.sprite
		for(var/turf/outdoor/objects/sign/mode_sign/S in signList)
			P.client.images.Remove(S.rubyImage,S.sapphireImage,S.emeraldImage)
			switch(P.mode)
				if("Ruby")
					P.client.images += S.rubyImage
				if("Sapphire")
					P.client.images += S.sapphireImage
				if("Emerald")
					P.client.images += S.emeraldImage
	dirSwitch(atom/movable/O,atom/movable/T)
		if(!istype(O,/atom/movable))return
		var olddir = O.dir
		switch(O.dir)
			if(NORTHEAST)O.dir = pick(NORTH,EAST)
			if(NORTHWEST)O.dir = pick(NORTH,WEST)
			if(SOUTHEAST)O.dir = pick(SOUTH,EAST)
			if(SOUTHWEST)O.dir = pick(SOUTH,WEST)
		if(istype(T,/atom/movable))
			switch(O.dir)
				if(NORTH)T.dir = SOUTH
				if(SOUTH)T.dir = NORTH
				if(EAST)T.dir = WEST
				if(WEST)T.dir = EAST
		O.dir = olddir
	genderGet(atom/movable/O,type="his")
		switch(O.gender)
			if(MALE)
				. = "he"
				switch(type)
					if("his","hers").= "his"
					if("His"). = "His"
					if("himself","herself"). = "himself"
					if("he","she"). = "he"
					if("He","She"). = "He"
					if("him"). = "him"
			if(FEMALE)
				. = "she"
				switch(type)
					if("his"). = "her"
					if("His"). = "Her"
					if("hers"). = "hers"
					if("he","she"). = "she"
					if("himself","herself"). = "herself"
					if("He","She"). = "She"
					if("him"). = "her"
			if(PLURAL)
				. = "them"
				switch(type)
					if("his"). = "their"
					if("His"). = "Their"
					if("hers"). = "theirs"
					if("himself","herself"). = "themself"
					if("he","she"). = "they"
					if("He","She"). = "They"
					if("him"). = "them"
			if(NEUTER)
				. = "it"
				switch(type)
					if("his","hers"). = "its"
					if("His"). = "Its"
					if("himself","herself"). = "itself"
					if("he","she","him"). = "it"
					if("He","She"). = "It"
	awardMedal(medal,player)
		if(!world.GetMedal(medal,player))
			world.SetMedal(medal,player)
			if(istype(player,/player))
				var player/P = player
				world << "[P.name]([P.key]) has earned the medal [medal]!"
			else
				world << "[player] has earned the medal [medal]!"
	getAbilityDesc(ability)
		. = "Ability Description Here"
		switch(ability)
			if("Adaptability"). = "STAB for attack moves is increased."
			if("Aerilate"). = "Normal-type moves become Flying-type moves with increased power."
			if("Aftermath"). = "When KOed, the foe that landed the hit gets hurt."
			if("Air Lock","Cloud Nine"). = "Weather effects are gone, but the weather itself remains."
			if("Analytic"). = "Move attack power is increased if the user went last."
			if("Anger Point"). = "Taking critical hits will raise Attack."
			if("Anticipation"). = "Detects the foe's strongest moves"
			if("Arena Trap"). = "Enemies cannot escape the fighting without Run Away."
			if("Aroma Veil"). = "The owner and its allies can't have their choice of action limited by an enemy attack or ability."
			if("Aura Break"). = "Fairy Aura and Dark Aura's effects are reversed when used near the owner."
			if("Bad Dreams"). = "Sleeping foes lose HP because of Nigtmares."
			if("Battery"). = "The owner will empower the special attacks of its allies."
			if("Battle Armor"). = "The owner cannot be critically hit."
			if("Battle Bond"). = "Greninja's bond with its trainer causes it to transform into Ash-Greninja, which empowers Water Shuriken."
			if("Beast Boost"). = "When the owner knocks out a foe, its strongest stat becomes even stronger."
			if("Berserk"). = "Boosts the owner's Special Attack when its HP is dropped below half."
			if("Big Pecks"). = "Defense cannot be lowered by enemies."
			if("Blaze"). = "Fire type moves gain power with low HP"
			if("Bulletproof"). = "The owner cannot be damaged by moves using bombs or balls."
			if("Cacophony","Soundproof"). = "Sound based moves do nothing to the owner"
			if("Chlorophyll"). = "The owner is faster in strong sunlight."
			if("Clear Body","White Smoke","Full Metal Body"). = "The owner's stats cannot be lowered by enemies."
			if("Cloud Nine","Air Lock"). = "Weather effects are gone, but the weather itself remains."
			if("Color Change"). = "The owner changes type to that of the attack that had hit it."
			if("Comatose"). = "The owner is always in a drowsy state. It will not wake up, but it can still attack."
			if("Compoundeyes"). = "The owner gets boosted accuracy"
			if("Contrary"). = "Stat mods are inverted"
			if("Corrosion"). = "The owner can poison Steel and Poison Type Pokémon."
			if("Cursed Body"). = "1 in 3 of the moves that hit the owner will be disabled."
			if("Cute Charm"). = "Direct contact with the owner will cause the foe to fall in love."
			if("Cutting Edge"). = "The owner's cutting attacks will deal 50% increased damage. This bonus is doubled on critical hits."
			if("Damp"). = "Foes cannot self destruct."
			if("Dancer"). = "The owner will copy the foe's dance moves."
			if("Dark Aura"). = "The owner's aura will power up Dark-Type moves."
			if("Dark Magic"). = "This Pokémon takes 50% less damage when not asleep, frozen, or paralyzed."
			if("Queenly Magesty"). = "The foe cannot use priority moves."
			if("Defeatist"). = "Attack and Sp. Attack are halved at half HP."
			if("Defiant"). = "When a stat is lowered, Attack is raised two stages"
			if("Desolate Land"). = "The owner summons the power of a thousand burning suns to create harse sunlight in battle."
			if("Delta Stream"). = "The owner summons strong wind upon the area that protects Flying Types and can calm other weather."
			if("Disguise"). = "The owner's protective cloak allows it to absorb an attack once per battle."
			if("Download"). = "The owner's Attack and Sp. Attack are increased based on the foe's Defense and Sp. Defense."
			if("Drizzle"). = "When the owner shows up, it begins to rain."
			if("Drought"). = "When the owner shows up, the sun blazes."
			if("Dry Skin"). = "Heat drains HP. Water restores it."
			if("Early Bird"). = "The early bird catches the worm, causing it to wake up twice as fast."
			if("Effect Spore"). = "Sleep, Paralysis, and Poison can arise from contact w/ the owner."
			if("Electric Surge"). = "Electric Terrain is thrown into effect when the owner enters the battle."
			if("Emergency Exit"). = "The owner detects an emergency and switches out when its HP drops below half."
			if("Fairy Aura"). = "All pokémon get a fairy-type power up."
			if("Filter"). = "Super-Effective moves get a power drop when used on the owner."
			if("Flame Body"). = "The foe can be burned by touching the owner."
			if("Flare Boost"). = "The Pokémon gains increased power on special attacks when burned."
			if("Flash Fire"). = "Fire-type moves are made stronger when the owner is hit by one."
			if("Flower Gift"). = "Sunlight makes the owner and its allies gain Special Defense."
			if("Flower Veil"). = "The owner's Grass-Type allies cannot have their stats lowered or suffer status conditions."
			if("Fluffy"). = "The owner takes half damage from attacks that make direct contact, but suffers double damage from Fire."
			if("Forecast"). = "Castform will transform with the weather."
			if("Forewarn"). = "The foe's strongest move is determined"
			if("Friend Guard"). = "Allies take less damage."
			if("Frisk"). = "The owner will know the foe's held item"
			if("Frozen Heart"). = "The owner's Ice-type moves have increased priority."
			if("Full Metal Body","Clear Body","White Smoke"). = "The owner's stats cannot be lowered by enemies."
			if("Fur Coat"). = "Physical moves deal half damage."
			if("Gale Wings"). = "Flying type moves move first."
			if("Galvanize"). = "Normal type moves become Electric-type moves with boosted power."
			if("Gluttony"). = "The owner will eat its berry much sooner."
			if("Gooey"). = "The owner reduces the foe's speed on contact."
			if("Grass Pelt"). = "The owner's defensive stats are increased in Grassy Terrain."
			if("Grassy Surge"). = "The owner will summon Grassy Terrain when it enters the battlefield."
			if("Guts"). = "Status problems will increase the owner's Attack Stat."
			if("Hard Wired"). = "The owner's Electric-type moves are stronger and may hit Ground-type Pokémon."
			if("Harvest"). = "A berry is restored after it is used."
			if("Healer"). = "Allies will have a 30% chance of being cured from a major status ailment."
			if("Heatproof"). = "Fire type moves are weaker."
			if("Heavy Metal"). = "This fat demon has twice its defined pokédex weight."
			if("Honey Gather"). = "The owner will somehow get honey at random"
			if("Huge Power","Pure Power"). = "The owner has a higher-than-average attack stat."
			if("Hustle"). = "The owner has a high attack stat but lower accuracy."
			if("Hydration"). = "Heals status problems in the rain."
			if("Hyper Cutter"). = "The attack stat cannot be lowered."
			if("Ice Body"). = "HP comes back in the hail."
			if("Illuminate"). = "Wild pokémon may appear more often"
			if("Illusion"). = "The Pokémon is disguised as the last Pokémon in the party."
			if("Immunity"). = "Like Poison and Steel types, the owner can't be poisoned."
			if("Imposter"). = "The owner transforms into the foe upon entering battle."
			if("Innards Out"). = "The owner's remaining HP before death is dealt to the last target to hit it."
			if("Infiltrator"). = "Light Screen, Reflect, and Safe Guard do nothing."
			if("Infusion"). = "Moves that do not come in contact with the target gain increased damage."
			if("Inner Focus"). = "The owner cannot flinch."
			if("Insomnia","Vital Spirit"). = "The owner doesn't sleep."
			if("Intimidate"). = "The owner will lower the foe's attack stat."
			if("Iron Barbs"). = "Attacking foes lose HP on contact."
			if("Iron Fist"). = "Punching moves become stronger."
			if("Justified"). = "Attack is raised when hit with Dark-Type moves."
			if("Keen Eye"). = "No accuracy loss for the owner!"
			if("Klutz"). = "Aww, no use of held items for the owner :("
			if("Leaf Guard"). = "No status problems with sunlight."
			if("Levitate"). = "Just like for flying types, ground moves do nothing."
			if("Light Metal"). = "Skinny! The owner has half of its defined pokédex weight."
			if("Lightning Rod"). = "Indirection and Immunity to Electric moves is provided. Does not affect Discharge."
			if("Limber"). = "Just like Electric-Types, the owner can't be paralyzed"
			if("Liquid Ooze"). = "Instead of healing, foes get damaged when draining the owner's HP."
			if("Liquid Voice"). = "Sound-based moves become water-type moves upon use."
			if("Long Reach"). = "The owner doesn't need to make direct contact with the foe for its moves to work."
			if("Magic Bounce"). = "A lot of non-damaging used go back to the user."
			if("Magic Guard"). = "Only attacks can damage the owner."
			if("Magician"). = "If the foe hits the owner, it steals the foe's item."
			if("Magma Amplifier"). = "Th owner's next attack will deal increased damage when hit by a damage-dealing attack."
			if("Magma Armor"). = "Just like Ice-types, the owner cannot be frozen."
			if("Magnet Pull"). = "Steel-types cannot escape from battle."
			if("Marvel Scale"). = "Status problems raise defense"
			if("Mega Launcher"). = "The owner's aura and pulse moves are stronger."
			if("Merciless"). = "The owner will always land critical hits on a poisoned target."
			if("Minus"). = "Special Attack is boosted with Plus."
			if("Misty Terrain"). = "The owner turns the field into Misty Terrain when it begins combat."
			if("Mold Breaker","Turboblaze","Teravolt"). = "Ability effects are downgraded or nullified."
			if("Moody"). = "Stats are raised and lowered at random every turn."
			if("Motor Drive"). = "Electric moves raise speed."
			if("Moxie"). = "Attack is raised upon defeating foes."
			if("Multiscale"). = "Damage taken from full HP is halved."
			if("Multitype"). = "Arceus's type is changed with the plate it holds."
			if("Mummy"). = "Direct contact with the owner spreads the ability."
			if("Natural Cure"). = "All status problems are healed automatically when swapping."
			if("No Guard"). = "The owner and their allies' attacks never miss, no matter what."
			if("Normalize"). = "All of the owner's moves will be Normal Type."
			if("Oblivious"). = "No puppy love for the owner."
			if("Overcoat"). = "No more weather damage for the owner."
			if("Overgrow"). = "Low HP gives a boost to Grass-Type moves."
			if("Own Tempo"). = "No more confusion for the owner."
			if("Parental Bond"). = "Kangaskhan and its child both attack the foe. The baby will strike for less damage."
			if("Pickpocket"). = "The attacking foe loses its held item on contact."
			if("Pickup"). = "The owner may find items."
			if("Pixie Power"). = "The owner gains special attack when hit by damaging moves. Moves making direct contact will infatuate the foe."
			if("Pixilate"). = "The owner's Normal-type moves become Fairy-type moves with higher power."
			if("Plus"). = "Boosts Sp. Attack if an ally has Minus."
			if("Poison Heal"). = "HP is restored with poisoning."
			if("Poison Point","Poison Touch"). = "Contact with the owner can cause poisoning."
			if("Poison Touch","Poison Point"). = "Contact with the owner can cause poisoning."
			if("Power Construct"). = "When Zygarde's HP drops below half, it gathers its cells to transform into Perfect Zygarde."
			if("Power of Alchemy"). = "The owner takes on the ability of its defeated ally."
			if("Prankster"). = "The priority of non-damaging moves increases by one."
			if("Pressure"). = "Raises the PP useage of the foe."
			if("Primordial Sea"). = "The owner summons a devistating rainstorm upon the area that causes extreme rain in battle."
			if("Prism Armor"). = "Reduces the power of super-effective attacks."
			if("Protean"). = "The owner's type will always match that of the move it uses."
			if("Psychic Surge"). = "The ground is turned into Psychic Terrain when the owner enters the field."
			if("Pure Power","Huge Power"). = "Physical attacks get an attack boost."
			if("Pure Rock"). = "The owner uses the rocks that hit it to repair itself."
			if("Protean"). = "The owner's type becomes that of the move it uses."
			if("Queenly Majesty"). = "The owner's Queenly presence makes the foe incapable of using priority attacks."
			if("Quick Feet"). = "The pokémon gets a speed boost with status problems."
			if("Rain Dish"). = "The owner recovers its HP in the rain."
			if("Rattled"). = "The owner's speed is raised when hit by Dark, Ghost or Bug moves."
			if("Receiver"). = "The owner takes on the ability of its defeated ally."
			if("Reckless"). = "The owner's recoil moves have increased power."
			if("Refrigerate"). = "The owner's Normal-Type moves become power-boosted Ice-Type moves."
			if("Regenerator"). = "The owner regains a small amount of HP when it is removed from the battlefield."
			if("Rivalry"). = "Attack is raised if the foe has the same gender."
			if("RKS System"). = "Silvally's type is changed to match the Memory Disc it has equipped."
			if("Rock Head"). = "Protects the user from recoil damage."
			if("Rough Skin"). = "The foe gets damage from physical contact with the owner."
			if("Run Away"). = "The owner can always escape from a wild pokémon."
			if("Sand Force"). = "The owner's Rock, Ground, and Steel moves are boosted in Sandstorms."
			if("Sand Rush"). = "The owner's speed is doubled in sandstorms."
			if("Sand Stream"). = "The owner summons a sandstorm during the battle."
			if("Sand Veil"). = "The owner avoids attacks better in a sandstorm"
			if("Sap Sipper"). = "The owner's attack is increased upon getting hit by a Grass-Type move."
			if("Schooling"). = "Wishiwashi groups together in a massive, terrifying school when its HP is high enough."
			if("Scrappy"). = "If the foe is Ghost-Type, it can be hit by Normal and Fighting moves."
			if("Serene Grace"). = "Added move affects are much more common."
			if("Shadow Shield"). = "The owner takes less damage from its first attack."
			if("Shadow Tag"). = "The foe cannot escape unless it has Shadow Tag."
			if("Shed Skin"). = "The owner can heal its own status ailments."
			if("Sheer Force"). = "The added effects of a move are removed to increase its power."
			if("Shell Armor"). = "The owner cannot get hit by criticals."
			if("Shield Dust"). = "The owner can't be hit by bad added effects."
			if("Shields Down"). = "Minior's shield breaks when its HP is dropped below half, causing it to become much more aggressive."
			if("Simple"). = "The owner is prone to wild stat changes."
			if("Skill Link"). = "Multi-hit moves will get more hits."
			if("Slow Start"). = "Regigigas's attack and speed will be reduced."
			if("Slush Rush"). = "The owner is much faster in the hail."
			if("Sniper"). = "The owner's critical hit damage is increased."
			if("Snow Cloak"). = "The owner evades more in snowstorms."
			if("Snow Warning"). = "The owner causes a sandstorm."
			if("Solar Power"). = "Sp. Attack is increased at the cost of a bit of HP."
			if("Solid Rock"). = "Super-effective moves do less damage to the owner."
			if("Soul-Heart"). = "Each time a Pokémon faints, Magearna's Special Attack is boosted."
			if("Soundproof","Cacophony"). = "Sound based moves do nothing to the owner"
			if("Speed Boost"). = "The owner gets faster every turn."
			if("Stakeout"). = "If the target switches out, its replacement takes double damage from an attack."
			if("Stall"). = "The owner moves slower than slower foes."
			if("Stanima"). = "The owner's Defense and Special Defense stats are boosted when hit by an attack."
			if("Stance Change"). = "Aegislash's form changes depeding on its battle style."
			if("Static"). = "A non-electric foe may experience paralysis upon contact with the owner."
			if("Steadfast"). = "The owner gets faster every time it fliches."
			if("Steelworker"). = "The owner's Steel-type moves are empowered."
			if("Stench"). = "Wild pokémon are repelled."
			if("Sticky Hold"). = "Items cannot be stolen."
			if("Storm Drain"). = "The owner gets immunity to water type moves. It also absorbs their use."
			if("Strong Jaw"). = "The owner's biting moves have increased power."
			if("Sturdy"). = "The owner cannot be knocked out in one hit at full HP."
			if("Suction Cups"). = "The owner can't be forced to switch out."
			if("Super Luck"). = "Moves get more crits."
			if("Surge Surfer"). = "The owner gains doubled speed on Electric Terrain."
			if("Swarm"). = "Bug type moves are stronger with low HP."
			if("Sweet Veil"). = "The owner and its allies cannot fall asleep."
			if("Swift Swim"). = "The owner is faster in the rain."
			if("Symbiosis"). = "The owner can give items to an ally."
			if("Synchronize"). = "Burn, poison, and paralysis are given to the foe."
			if("Tangled Feet"). = "Confused pokémon evade attacks more."
			if("Technician"). = "Moves with a weaker power are strengthened."
			if("Tangling Hair"). = "The owner causes its foes to slow down when making contact."
			if("Technician"). = "Moves with less than 60 Power are 50% stronger."
			if("Telepathy"). = "Allies cannot damage the owner."
			if("Teravolt","Mold Breaker","Turboblaze"). = "Ability effects are downgraded or nullified."
			if("Thick Fat"). = "The owner takes less damage from Fire and Ice type moves."
			if("Tinted Lens"). = "\"Not very effective\" moves are stronger."
			if("Torrent"). = "Water type moves are stronger with low HP."
			if("Tough Claws"). = "Moves that make direct contact are stronger."
			if("Toxic Boost"). = "Attacks are 50% stronger when poisoned."
			if("Toxic Theft"). = "When the owner lands a poison-type move, half of the damage from it is healed back."
			if("Trace"). = "The owner takes the foe's ability."
			if("Triage"). = "Healing moves have increased priority."
			if("Truant"). = "The owner lazily loafs around every other turn."
			if("True Talent"). = "The user cannot miss a Special-Attack."
			if("Turboblaze","Teravolt","Mold Breaker"). = "Ability effects are downgraded or nullified."
			if("Unaware"). = "The foe's stat changes don't matter to the owner."
			if("Unburden"). = "The owner is faster when it uses its held item."
			if("Unnerve"). = "The owner makes its foes afraid to use berries."
			if("Vaporize"). = "The owner's HP is healed in the rain, and the power of Water-type moves gets a boost."
			if("Victory Star"). = "The owner's allies have increased move power."
			if("Vital Spirit","Insomnia"). = "The owner doesn't sleep."
			if("Volt Absorb"). = "Electric Moves restore the owner's HP."
			if("Water Absorb"). = "Water Moves restore the owner's HP."
			if("Water Bubble"). = "The owner takes less damage from Fire-Type attacks and is immune to burns."
			if("Water Compaction"). = "The owner's Defense is sharply raised when hit by Water-type attacks."
			if("Water Viel"). = "Prevents the owner from being burned."
			if("Weak Armor"). = "Speed is raised and Defense lowered when the owner gets hit."
			if("White Smoke","Clear Body","Full Metal Body"). = "The owner's stats cannot be lowered by enemies."
			if("Wimp Out"). = "The owner switches out due to cowardice when its HP drops below half."
			if("Wonder Guard"). = "Shedinja can only be hit by super-effective moves."
			if("Wonder Skin"). = "Half the time damaging moves that give status ailments fail."
			if("Zen Mode"). = "Darmanitan's form changes at half HP."
	sortMoves(LA[],LB[])
		var
			pmove
				A = LA["move"]
				B = LB["move"]
			pokemon
				P = LA["pokemon"]
				E = LB["pokemon"]
			thePriorityA = A.getPriority(P.owner.client,P)
			thePriorityB = B.getPriority(P.owner.client,E)
		if(thePriorityA < thePriorityB)
			. = 1
		else if(thePriorityA > thePriorityB)
			. = -1
		else
			. = 0
	sortRawPokemon(pokemon/A,pokemon/B)
		if(A.speed<B.speed)
			. = 1
		else if(A.speed>B.speed)
			. = -1
		else
			. = 0
	sortPokemon(LA[],LB[])
		var pokemon/A = LA["pokemon"]
		var pokemon/B = LB["pokemon"]
		var aspeed = A.getSpeed()
		var bspeed = B.getSpeed()
		if(aspeed<bspeed)
			. = 1
		else if(aspeed>bspeed)
			. = -1
		else
			. = 0
	reverse(string)
		var/reverse = ""
		for(var/i in lentext(string) to 1 step -1)
			reverse += copytext(string, i, i+1)
		. = reverse
	capitalize(t as text,delim="" as text)
		t = uppertext(copytext(t,1,2)) + copytext(t,2)
		if(delim != "")
			var tloc = 1
			tloc = findtext(t,delim,tloc)
			while(tloc)
				t = copytext(t,1,tloc+1)+uppertext(copytext(t,tloc+1,tloc+2))+copytext(t,tloc+2)
				tloc = findtext(t,delim,tloc+1)
		. = t
	honeyGather(pokemon/P)
		if(!istype(P,/pokemon))
			throw EXCEPTION("Expected a Pokémon as an argument to honeyGather(pokemon/P).")
		. = P.held
		if(!("Honey Gather" in list(P.ability1,P.ability2)))return
		if(!isnull(P.held))return
		switch(P.level)
			if(1 to 10). = pick(prob(5);new/item/normal/Honey,null)
			if(11 to 20). = pick(prob(10);new/item/normal/Honey,null)
			if(21 to 30). = pick(prob(15);new/item/normal/Honey,null)
			if(31 to 40). = pick(prob(20);new/item/normal/Honey,null)
			if(41 to 50). = pick(prob(25);new/item/normal/Honey,null)
			if(51 to 60). = pick(prob(30);new/item/normal/Honey,null)
			if(61 to 70). = pick(prob(35);new/item/normal/Honey,null)
			if(71 to 80). = pick(prob(40);new/item/normal/Honey,null)
			if(81 to 90). = pick(prob(45);new/item/normal/Honey,null)
			if(91 to 100). = pick(prob(50);new/item/normal/Honey,null)
	pickupGet(pokemon/P)
		if(!istype(P,/pokemon))
			throw EXCEPTION("Expected a Pokémon as an argument to pickupGet(pokemon/P).")
		. = P.held
		if(!("Pickup" in list(P.ability1,P.ability2)))return
		if(!isnull(P.held))return
		var itemType
		if(prob(10)) // get an item
			switch(P.level)
				if(1 to 10)itemType = pick(prob(30);/item/medicine/Potion,prob(10);/item/medicine/Antidote,prob(10);/item/medicine/Super_Potion,
				prob(10);/item/pokeball/Great_Ball,prob(10);/item/normal/repellent/Super_Repel,prob(10);/item/normal/Escape_Rope,prob(10);/item/medicine/Paralyze_Heal,
				prob(4);/item/medicine/Hyper_Potion,prob(4);/item/pokeball/Ultra_Ball,prob(1);/item/medicine/Hyper_Potion,prob(1);/item/normal/Nugget)
				if(11 to 20)itemType = pick(prob(30);/item/medicine/Antidote,prob(10);/item/medicine/Super_Potion,
				prob(10);/item/pokeball/Great_Ball,prob(10);/item/normal/repellent/Super_Repel,prob(10);/item/normal/Escape_Rope,
				prob(10);/item/medicine/Paralyze_Heal,prob(10);/item/medicine/Hyper_Potion,prob(4);/item/pokeball/Ultra_Ball,
				prob(4);/item/medicine/Revive,prob(1);/item/normal/Nugget,prob(1);/item/normal/evolve_item/trade/King\'\s_Rock)
				if(21 to 30)itemType = pick(prob(30);/item/medicine/Super_Potion,prob(10);/item/pokeball/Great_Ball,
				prob(10);/item/normal/repellent/Super_Repel,prob(10);/item/normal/Escape_Rope,prob(10);/item/medicine/Paralyze_Heal,
				prob(10);/item/medicine/Hyper_Potion,prob(10);/item/pokeball/Ultra_Ball,prob(4);/item/medicine/Revive,
				prob(4);/item/medicine/Rare_Candy,prob(1);/item/normal/evolve_item/trade/King\'\s_Rock,prob(1);/item/medicine/Full_Restore)
				if(31 to 40)itemType = pick(prob(30);/item/pokeball/Great_Ball,prob(10);/item/normal/repellent/Super_Repel,
				prob(10);/item/normal/Escape_Rope,prob(10);/item/medicine/Paralyze_Heal,prob(10);/item/medicine/Hyper_Potion,
				prob(10);/item/pokeball/Ultra_Ball,prob(10);/item/medicine/Revive,prob(4);/item/medicine/Rare_Candy,
				prob(4);/item/normal/stone/Sun_Stone,prob(1);/item/medicine/Full_Restore,prob(1);/item/medicine/Ether)
				if(41 to 50)itemType = pick(prob(30);/item/normal/repellent/Super_Repel,prob(10);/item/normal/Escape_Rope,
				prob(10);/item/medicine/Paralyze_Heal,prob(10);/item/medicine/Hyper_Potion,prob(10);/item/pokeball/Ultra_Ball,
				prob(10);/item/medicine/Revive,prob(10);/item/medicine/Rare_Candy,prob(4);/item/normal/stone/Sun_Stone,
				prob(4);/item/normal/stone/Moon_Stone,prob(1);/item/medicine/Ether,prob(1);/item/normal/Iron_Ball)
				if(51 to 60)itemType = pick(prob(30);/item/normal/Escape_Rope,prob(10);/item/medicine/Paralyze_Heal,
				prob(10);/item/medicine/Hyper_Potion,prob(10);/item/pokeball/Ultra_Ball,prob(10);/item/medicine/Revive,
				prob(10);/item/medicine/Rare_Candy,prob(10);/item/normal/stone/Sun_Stone,prob(4);/item/normal/stone/Moon_Stone,
				prob(4);/item/normal/Heart_Scale,prob(1);/item/normal/Iron_Ball,prob(1);/item/normal/Destiny_Knot)
				if(61 to 70)itemType = pick(prob(30);/item/medicine/Paralyze_Heal,prob(10);/item/medicine/Hyper_Potion,prob(10);/item/pokeball/Ultra_Ball,
				prob(10);/item/medicine/Revive,prob(10);/item/medicine/Rare_Candy,prob(10);/item/normal/stone/Sun_Stone,prob(10);/item/normal/stone/Moon_Stone,
				prob(4);/item/normal/Heart_Scale,prob(4);/item/medicine/Full_Restore,prob(1);/item/normal/Destiny_Knot,prob(1);/item/medicine/Elixir)
				if(71 to 80)itemType = pick(prob(30);/item/medicine/Hyper_Potion,prob(10);/item/pokeball/Ultra_Ball,prob(10);/item/medicine/Revive,
				prob(10);/item/medicine/Rare_Candy,prob(10);/item/normal/stone/Sun_Stone,prob(10);/item/normal/stone/Moon_Stone,prob(10);/item/normal/Heart_Scale,
				prob(4);/item/medicine/Full_Restore,prob(4);/item/medicine/Max_Revive,prob(1);/item/medicine/Elixir,prob(1);/item/normal/Destiny_Knot)
				if(81 to 90)itemType = pick(prob(30);/item/pokeball/Ultra_Ball,prob(10);/item/medicine/Revive,prob(10);/item/medicine/Rare_Candy,
				prob(10);/item/normal/stone/Sun_Stone,prob(10);/item/normal/stone/Moon_Stone,prob(10);/item/normal/Heart_Scale,prob(10);/item/medicine/Full_Restore,
				prob(4);/item/medicine/Max_Revive,prob(4);/item/medicine/PP_Up,prob(1);/item/normal/Destiny_Knot,prob(1);/item/normal/Leftovers)
				if(91 to 100)itemType = pick(prob(30);/item/medicine/Revive,prob(10);/item/medicine/Rare_Candy,prob(10);/item/normal/stone/Sun_Stone,
				prob(10);/item/normal/stone/Moon_Stone,prob(10);/item/normal/Heart_Scale,prob(10);/item/medicine/Full_Restore,prob(10);/item/medicine/Max_Revive,
				prob(4);/item/medicine/PP_Up,prob(4);/item/medicine/Max_Elixir,prob(1);/item/normal/Leftovers,prob(1);/item/normal/Destiny_Knot)
				else itemType = pick(prob(30);/item/medicine/Antidote,prob(10);/item/medicine/Super_Potion,
				prob(10);/item/pokeball/Great_Ball,prob(10);/item/normal/repellent/Super_Repel,prob(10);/item/normal/Escape_Rope,
				prob(10);/item/medicine/Paralyze_Heal,prob(10);/item/medicine/Hyper_Potion,prob(4);/item/pokeball/Ultra_Ball,
				prob(4);/item/medicine/Revive,prob(1);/item/normal/Nugget,prob(1);/item/normal/evolve_item/trade/King\'\s_Rock)
			return new itemType
	getTypeMatchup(atype,btype)
		if((!atype) || (!btype))return 1
		var s = typeMatchup[atype][btype]
		if((s == null) || (s == ""))return 1
		return s
	n_calc(nature,stat) // Written by Red(Pokemonred200)
		. = 1
		switch(stat)
			if("HP")
				switch(nature)
					if("Caring","Kind","Spirited","Proud","Cheerful")
						. = 1.1
					if("Feeble","Hyper","Morbid","Rude","Stressful")
						. = 0.9
			if("attack")
				switch(nature)
					if("Lonely","Adamant","Naughty","Brave","Hyper")
						. = 1.1
					if("Bold","Modest","Calm","Timid","Caring")
						. = 0.9
			if("defense")
				switch(nature)
					if("Bold","Impish","Lax","Relaxed","Rude")
						. = 1.1
					if("Lonely","Mild","Gentle","Hasty","Spirited")
						. = 0.9
			if("spAttack")
				switch(nature)
					if("Modest","Mild","Rash","Quiet","Morbid")
						. = 1.1
					if("Adamant","Impish","Careful","Jolly","Kind")
						. = 0.9
			if("spDefense")
				switch(nature)
					if("Calm","Gentle","Careful","Sassy","Stressful")
						. = 1.1
					if("Naughty","Lax","Rash","Naive","Proud")
						. = 0.9
			if("speed")
				switch(nature)
					if("Timid","Hasty","Jolly","Naive","Feeble")
						. = 1.1
					if("Brave","Relaxed","Quiet","Sassy","Cheerful")
						. = 0.9
	setTypeMatchups() // Written by Red(Pokemonred200)
		set waitfor = 0 // so as to not lag the rest of the server during opening
		typeMatchup[NORMAL] = list()
		typeMatchup[WATER] = list()
		typeMatchup[FIRE] = list()
		typeMatchup[GRASS] = list()
		typeMatchup[ELECTRIC] = list()
		typeMatchup[DARK] = list()
		typeMatchup[FAIRY] = list()
		typeMatchup[ROCK] = list()
		typeMatchup[ICE] = list()
		typeMatchup[DRAGON] = list()
		typeMatchup[BUG] = list()
		typeMatchup[STEEL] = list()
		typeMatchup[GHOST] = list()
		typeMatchup[FIGHTING] = list()
		typeMatchup[FLYING] = list()
		typeMatchup[POISON] = list()
		typeMatchup[GROUND] = list()
		typeMatchup[PSYCHIC] = list()
		typeMatchup[LIGHT] = list()
		typeMatchup[SOUND] = list()
		typeMatchup[BUBBLE] = list()
		typeMatchup[FPRESS] = list()
		typeMatchup[EPRESS] = list()
		typeMatchup[NPRESS] = list()
		typeMatchup[UNKNOWN] = list()

		typeMatchup[NORMAL][GHOST] = 0
		typeMatchup[NORMAL][ROCK] = 0.5
		typeMatchup[NORMAL][STEEL] = 0.5

		typeMatchup[WATER][FIRE] = 2
		typeMatchup[WATER][ROCK] = 2
		typeMatchup[WATER][GROUND] = 2
		typeMatchup[WATER][SOUND] = 2
		typeMatchup[WATER][WATER] = 0.5
		typeMatchup[WATER][ICE] = 0.5
		typeMatchup[WATER][GRASS] = 0.5
		typeMatchup[WATER][DRAGON] = 0.5

		typeMatchup[FIRE][BUG] = 2
		typeMatchup[FIRE][GRASS] = 2
		typeMatchup[FIRE][STEEL] = 2
		typeMatchup[FIRE][ICE] = 2
		typeMatchup[FIRE][FIRE] = 0.5
		typeMatchup[FIRE][WATER] = 0.5
		typeMatchup[FIRE][ROCK] = 0.5
		typeMatchup[FIRE][DRAGON] = 0.5

		typeMatchup[GRASS][WATER] = 2
		typeMatchup[GRASS][ROCK] = 2
		typeMatchup[GRASS][GROUND] = 2
		typeMatchup[GRASS][BUBBLE] = 2
		typeMatchup[GRASS][FIRE] = 0.5
		typeMatchup[GRASS][POISON] = 0.5
		typeMatchup[GRASS][GRASS] = 0.5
		typeMatchup[GRASS][BUG] = 0.5
		typeMatchup[GRASS][STEEL] = 0.5
		typeMatchup[GRASS][DRAGON] = 0.5
		typeMatchup[GRASS][FLYING] = 0.5

		typeMatchup[ELECTRIC][WATER] = 2
		typeMatchup[ELECTRIC][FLYING] = 2
		typeMatchup[ELECTRIC][GRASS] = 0.5
		typeMatchup[ELECTRIC][ELECTRIC] = 0.5
		typeMatchup[ELECTRIC][DRAGON] = 0.5
		typeMatchup[ELECTRIC][LIGHT] = 0.5
		typeMatchup[ELECTRIC][GROUND] = 0

		typeMatchup[PSYCHIC][FIGHTING] = 2
		typeMatchup[PSYCHIC][POISON] = 2
		typeMatchup[PSYCHIC][PSYCHIC] = 0.5
		typeMatchup[PSYCHIC][STEEL] = 0.5
		typeMatchup[PSYCHIC][DARK] = 0

		typeMatchup[GHOST][PSYCHIC] = 2
		typeMatchup[GHOST][GHOST] = 2
		typeMatchup[GHOST][DARK] = 0.5
		typeMatchup[GHOST][STEEL] = 0.5
		typeMatchup[GHOST][LIGHT] = 0.5
		typeMatchup[GHOST][NORMAL] = 0

		typeMatchup[FAIRY][DRAGON] = 2
		typeMatchup[FAIRY][DARK] = 2
		typeMatchup[FAIRY][FIGHTING] = 2
		typeMatchup[FAIRY][FIRE] = 0.5
		typeMatchup[FAIRY][POISON] = 0.5
		typeMatchup[FAIRY][STEEL] = 0.5

		typeMatchup[FIGHTING][NORMAL] = 2
		typeMatchup[FIGHTING][DARK] = 2
		typeMatchup[FIGHTING][STEEL] = 2
		typeMatchup[FIGHTING][ROCK] = 2
		typeMatchup[FIGHTING][ICE] = 2
		typeMatchup[FIGHTING][POISON] = 0.5
		typeMatchup[FIGHTING][PSYCHIC] = 0.5
		typeMatchup[FIGHTING][FLYING] = 0.5
		typeMatchup[FIGHTING][BUG] = 0.5
		typeMatchup[FIGHTING][FAIRY] = 0.5
		typeMatchup[FIGHTING][LIGHT] = 0.5
		typeMatchup[FIGHTING][GHOST] = 0

		typeMatchup[BUG][GRASS] = 2
		typeMatchup[BUG][PSYCHIC] = 2
		typeMatchup[BUG][DARK] = 2
		typeMatchup[BUG][POISON] = 2
		typeMatchup[BUG][FAIRY] = 2
		typeMatchup[BUG][BUG] = 0.5
		typeMatchup[BUG][FIRE] = 0.5
		typeMatchup[BUG][FLYING] = 0.5
		typeMatchup[BUG][STEEL] = 0.5

		typeMatchup[DARK][PSYCHIC] = 2
		typeMatchup[DARK][GHOST] = 2
		typeMatchup[DARK][LIGHT] = 2
		typeMatchup[DARK][FIGHTING] = 0.5
		typeMatchup[DARK][DARK] = 0.5
		typeMatchup[DARK][STEEL] = 0.5
		typeMatchup[DARK][FAIRY] = 0.5

		typeMatchup[STEEL][ROCK] = 2
		typeMatchup[STEEL][ICE] = 2
		typeMatchup[STEEL][FAIRY] = 2
		typeMatchup[STEEL][FIRE] = 0.5
		typeMatchup[STEEL][WATER] = 0.5
		typeMatchup[STEEL][ELECTRIC] = 0.5
		typeMatchup[STEEL][STEEL] = 0.5

		typeMatchup[DRAGON][DRAGON] = 2
		typeMatchup[DRAGON][STEEL] = 0.5
		typeMatchup[DRAGON][FAIRY] = 0

		typeMatchup[POISON][GRASS] = 2
		typeMatchup[POISON][FAIRY] = 2
		typeMatchup[POISON][LIGHT] = 2
		typeMatchup[POISON][BUG] = 2
		typeMatchup[POISON][POISON] = 0.5
		typeMatchup[POISON][GROUND] = 0.5
		typeMatchup[POISON][ROCK] = 0.5
		typeMatchup[POISON][GHOST] = 0.5
		typeMatchup[POISON][STEEL] = 0

		typeMatchup[ROCK][FIRE] = 2
		typeMatchup[ROCK][ICE] = 2
		typeMatchup[ROCK][FLYING] = 2
		typeMatchup[ROCK][FIGHTING] = 0.5
		typeMatchup[ROCK][STEEL] = 0.5
		typeMatchup[ROCK][GROUND] = 0.5

		typeMatchup[GROUND][FIRE] = 2
		typeMatchup[GROUND][ELECTRIC] = 2
		typeMatchup[GROUND][STEEL] = 2
		typeMatchup[GROUND][ROCK] = 2
		typeMatchup[GROUND][POISON] = 2
		typeMatchup[GROUND][GRASS] = 0.5
		typeMatchup[GROUND][BUG] = 0.5

		typeMatchup[ICE][GRASS] = 2
		typeMatchup[ICE][DRAGON] = 2
		typeMatchup[ICE][GROUND] = 2
		typeMatchup[ICE][FLYING] = 2
		typeMatchup[ICE][BUBBLE] = 2
		typeMatchup[ICE][FIRE] = 0.5
		typeMatchup[ICE][ICE] = 0.5
		typeMatchup[ICE][STEEL] = 0.5

		typeMatchup[FLYING][GRASS] = 2
		typeMatchup[FLYING][BUG] = 2
		typeMatchup[FLYING][FIGHTING] = 2
		typeMatchup[FLYING][ELECTRIC] = 0.5
		typeMatchup[FLYING][ROCK] = 0.5
		typeMatchup[FLYING][STEEL] = 0.5

		typeMatchup[SOUND][STEEL] = 2
		typeMatchup[SOUND][WATER] = 0.5
		typeMatchup[SOUND][BUG] = 0.5

		typeMatchup[LIGHT][DARK] = 2
		typeMatchup[LIGHT][FIGHTING] = 2
		typeMatchup[LIGHT][STEEL] = 2
		typeMatchup[LIGHT][GHOST] = 2
		typeMatchup[LIGHT][LIGHT] = 0.5
		typeMatchup[LIGHT][POISON] = 0.5
		typeMatchup[LIGHT][GRASS] = 0.5

		typeMatchup[BUBBLE][FIRE] = 2
		typeMatchup[BUBBLE][FIGHTING] = 2
		typeMatchup[BUBBLE][ELECTRIC] = 2
		typeMatchup[BUBBLE][ROCK] = 2
		typeMatchup[BUBBLE][GROUND] = 2
		typeMatchup[BUBBLE][WATER] = 0.5
		typeMatchup[BUBBLE][GRASS] = 0.5
		typeMatchup[BUBBLE][ICE] = 0.5

		typeMatchup[FPRESS][NORMAL] = 2
		typeMatchup[FPRESS][GRASS] = 2
		typeMatchup[FPRESS][ICE] = 2
		typeMatchup[FPRESS][FIGHTING] = 2
		typeMatchup[FPRESS][DARK] = 2
		typeMatchup[FPRESS][ELECTRIC] = 0.5
		typeMatchup[FPRESS][POISON] = 0.5
		typeMatchup[FPRESS][FLYING] = 0.5
		typeMatchup[FPRESS][PSYCHIC] = 0.5
		typeMatchup[FPRESS][FAIRY] = 0.5
		typeMatchup[FPRESS][LIGHT] = 0.5
		typeMatchup[FPRESS][GHOST] = 0

		typeMatchup[EPRESS][FIGHTING] = 2
		typeMatchup[EPRESS][FLYING] = 2
		typeMatchup[EPRESS][BUG] = 2
		typeMatchup[EPRESS][WATER] = 2
		typeMatchup[EPRESS][ROCK] = 0.5
		typeMatchup[EPRESS][STEEL] = 0.5
		typeMatchup[EPRESS][DRAGON] = 0.5
		typeMatchup[EPRESS][LIGHT] = 0.25
		typeMatchup[EPRESS][ELECTRIC] = 0.25

		typeMatchup[NPRESS][FIGHTING] = 2
		typeMatchup[NPRESS][BUG] = 2
		typeMatchup[NPRESS][GRASS] = 2
		typeMatchup[NPRESS][ELECTRIC] = 0.5
		typeMatchup[NPRESS][ROCK] = 0.25
		typeMatchup[NPRESS][STEEL] = 0.25
		typeMatchup[NPRESS][GHOST] = 0