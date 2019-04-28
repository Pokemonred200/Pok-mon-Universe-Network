player
	New()
		. = ..()
		//textThing = new /Maptext("",1000,1000,src.sprite,4,32)
	proc
		updatePartySwap()
			for(var/x in 1 to 6)
				winset(src,"PartySwap.partySwap[x]","command=battleSwap+[x]+0")
				winset(src,"PartySwap.healthBar[x]","is-visible=false")
				winset(src,"PartySwap.partyBattle[x]",list2params(list("text"="")))
				winset(src,"PartySwap.partySwap[x]",list2params(list("image"="")))
				winset(src,"PartySwap.partySwap[x]","background-color=#ffffff")
			for(var/x in 1 to 6)
				var pokemon/P = src.party[x]
				if(isnull(P))break
				winset(src,"PartySwap.partySwap[x]","image=\ref[fcopy_rsc(P.menuIcon)]")
				winset(src,"PartySwap.partyBattle[x]",list2params(list("text"="[P.name]")))
				var barValue
				if(istype(P,/Egg))
					barValue = 0
				else
					barValue = min(round((P.HP/P.maxHP)*100),100)
				winset(src,"PartySwap.healthBar[x]","is-visible=true")
				winset(src,"PartySwap.healthBar[x]","value=[barValue]")
				if(barValue > 50)
					winset(src,"PartySwap.healthBar[x]","bar-color=#00FF00")
				else if(barValue > 20)
					winset(src,"PartySwap.healthBar[x]","bar-color=#FFFF00")
				else
					winset(src,"PartySwap.healthBar[x]","bar-color=#FF0000")
				if(istype(P,/pokemon))
					var statusColor
					switch(P.status)
						if(BURNED)
							statusColor = "ff6600"
						if(FROZEN)
							statusColor = "#add8e6"
						if(ASLEEP)
							statusColor = "#d3d3d3"
						if(POISONED)
							statusColor = "#ff00ff"
						if(BAD_POISON)
							statusColor = "#551a8b"
						if(PARALYZED)
							statusColor = "#ffff00"
						if(FAINTED)
							statusColor = "#800000"
						else
							statusColor = "#ffffff"
					winset(src,"PartySwap.partySwap[x]","background-color=[statusColor]")
				else
					winset(src,"PartySwap.partySwap[x]","background-color=#FFFFFF")
			winset(src,"PartySwap.partyClose",list2params(list("text"="Cancel Switch")))
	verb
		useItem(index as num,itemref as text)
			set hidden = 1
			if(!istype(src.party[index],/pokemon))return
			var item/I = locate(itemref)
			if(istype(I,/item/medicine))
				var item/medicine/M = I
				M.useTarget = src.party[index]
				if(src.client.battle)
					var pmove/ItemUseProxy/IUP = new
					IUP.usedItem = I
					var pokemon/S = src.client.battle.activePokemon[src.client.battle.getPlayerText(src.client)]
					src.client.battle.chosenMoveData[src.client.battle.getPokemonText(S)]["move"] = IUP
				else
					if(M.activate(src) && I.consume)
						src.bag.getItem(I.type)
				winset(src,"PartySwap","is-visible=false")
		resetPartySwapCommands()
			set hidden = 1
			for(var/x in 1 to 6)
				winset(src,"PartySwap.partySwap[x]","command=battleSwap+[x]+0")
		switchClose()
			set hidden = 1
			var battleSystem/battle = src.client.battle
			if(src.playerFlags & USING_ITEM)
				src.playerFlags &= ~USING_ITEM
				if(battle && (!(battle.canCancelSwitch[battle.getPlayerText(src.client)])))return
			winset(src,"PartySwap","is-visible=false")
		battleSwap(pos as num,forced as num)
			set hidden = 1
			var pokemon/P = src.party[pos]
			var battleSystem/battle = src.client.battle
			if(istype(P,/Egg))
				src.ShowText("Eggs can't battle, ya dingus!")
				return
			else if(P.status == FAINTED)
				src.ShowText("[P] doesn't have enough energy to battle. Try not to be the cruel trainer.")
				return
			else if(P in list(battle.P1,battle.P2,battle.E1,battle.E2))
				src.ShowText("[P] is already on the battlefield!")
				return
			else
				if(alert(src,"Are you sure you want to switch in [P]?","Switch in [P]","Yes!","No...")=="Yes!")
					if(!forced)
						var pmove/RecallProxy/RP = new
						RP.showUserQuote = TRUE
						RP.monSwitch = P
						battle.chosenMoveData[battle.getPokemonText(battle.activePokemon[battle.getPlayerText(src)])]["move"] = RP
					else
						var theplayertext = battle.getPlayerText(src.client)
						var pokemon/A = battle.activePokemon[theplayertext]
						var pokemon/monSwitch = P
						monSwitch.fsprite.screen_loc = A.fsprite.screen_loc
						monSwitch.bsprite.screen_loc = A.bsprite.screen_loc
						monSwitch.fsprite.transform = A.fsprite.transform
						monSwitch.bsprite.transform = A.bsprite.transform
						for(var/client/CL in list(battle.C1,battle.C2,battle.C3,battle.C4))
							CL.screen.Remove(A.fsprite,A.bsprite)
						var theText = battle.getPokemonText(A)
						battle.vars["[theText]"] = monSwitch
						battle.partyPos["[theText]"] = src.party.Find(monSwitch,1,7)
						battle.chosenMoveData["[theText]"]["pokemon"] = monSwitch
						battle.activePokemon["[theplayertext]"] = monSwitch
						battle.ownerParticipatedList += monSwitch
						#if 0
						for(var/battle/movebutton/MB in client.screen)
							client.screen -= MB
						for(var/battle/targetbutton/TB in client.screen)
							client.screen -= TB
						battle.battleStage[theplayertext] = BATTLE_STAGE_ACTION_SELECT
						client.screen |= theButtons
						#endif
						//monSwitch.owner.client.goBackInBattle()
						for(var/HPBar/H in battle.hpBars)
							if(H.P==A)
								H.changePKMN(monSwitch)
						for(var/client/CL in list(battle.C1,battle.C2,battle.C3,battle.C4))
							var theSprite
							if(monSwitch in list(battle.P1,battle.P2))
								if(CL in list(battle.C1,battle.C3))
									theSprite = monSwitch.bsprite
								else
									theSprite = monSwitch.fsprite
							else
								if(CL in list(battle.C1,battle.C3))
									theSprite = monSwitch.fsprite
								else
									theSprite = monSwitch.bsprite
							CL.screen += theSprite
						battle.canCancelSwitch[theplayertext] = TRUE
						battle.hasSwitched[theplayertext] = TRUE
						src.ShowText("Take em' down, [monSwitch]!")
			switchClose()
		linkPAV()
			set hidden = 1
			src << link("http://www.byond.com/games/Choryong/PokemonAwesomeVersion")
		censorToggle()
			set hidden = 1
			src.com.toggleCensor()
		Set_Walker_Friendship()
			if(src.walker)
				src.walker.friendship = min(max(input(src,"New Friendship?","Friendship") as num,0),255)
		Summary_Walker()
			if(src.walker)
				ShowSummary(src.walker)
		Toggle_Bike()
			if(!(src.savedPlayerFlags & BIKING))
				if(src.active_costume.bike_idle)
					src.sprite.icon = src.active_costume.bike_idle
					src.savedPlayerFlags |= BIKING
					if(alert(src,"Will you use the Mach Bike or Acro Bike?","Mach or Acro","Mach Bike","Acro Bike")=="Mach Bike")
						src.savedPlayerFlags |= MACH
					else
						src.savedPlayerFlags &= ~MACH
			else
				src.savedPlayerFlags &= ~(BIKING | MACH)
				src.sprite.icon = src.active_costume.icon
				src.sprite.icon_state = src.active_costume.icon_state
			var turf/T = src.loc
			var area/A = T.loc
			updateMusic(src,A)
		Toggle_GB_Sounds()
			src.savedPlayerFlags ^= GB_SOUNDS
			var theFlagData = src.savedPlayerFlags & GB_SOUNDS
			src << "You turned [(theFlagData)?("on"):("off")] the power to the GB Player!"
			var turf/T = src.loc
			if(istype(T,/turf))
				var area/Town_Route/R = T.loc
				var sound/S = src.client.Audio.sounds["123"]
				if((src.savedPlayerFlags & GB_SOUNDS) && R.routeMusic8Bit)
					if(isnull(S) || (S.file!=R.routeMusic8Bit))
						src.client.Audio.addSound(music(R.routeMusic8Bit,repeat=1,channel=4),"123",autoplay=TRUE)
				else
					if(isnull(S) || (S.file!=R.routeMusic))
						src.client.Audio.addSound(music(R.routeMusic,repeat=1,channel=4),"123",autoplay=TRUE)
		Teleport_To_Respawn_Point()
			src.Move(src.respawnpoint)
		Teleport_To_Pal_Park()
			var turf/T = locate("Pal Park")
			if(T)src.Move(T)
		Get_Min_And_Hour()
			world << "[gameTime.Hour()]"
			world << "[gameTime.Minute()]"
		Test_Form_Change()
			if(!src.walker)return
			if(src.walker.pName=="Arceus")
				var choices[] = typesof(/item/normal/plate) - /item/normal/plate
				if(!isnull(src.walker.held))
					choices += null
					var thingy = locate(src.walker.held.type)
					if(thingy in choices)
						choices -= thingy
				var newplate = pick(choices)
				if(!isnull(newplate))
					newplate = new newplate
				src.walker.held = newplate
			else if(src.walker.pName=="Giratina")
				if((src.current_world_region == "Distortion World") && (src.walker.form == "-O"))return
				else if(isnull(src.walker.held) || (!istype(src.walker.held,/item/normal/stat_item/Griseous_Orb)))
					src.walker.held = new /item/normal/stat_item/Griseous_Orb
				else
					src.walker.held = null
			else if(src.walker.pName=="Groudon")
				if(isnull(src.walker.held) || (!istype(src.walker.held,/item/normal/Red_Orb)))
					src.walker.held = new /item/normal/Red_Orb
				else
					src.walker.held = null
			else if(src.walker.pName=="Kyogre")
				if(isnull(src.walker.held) || (!istype(src.walker.held,/item/normal/Blue_Orb)))
					src.walker.held = new /item/normal/Blue_Orb
				else
					src.walker.held = null
			src.walker.formChange()
		chat(t as text)
			set hidden = 1
			if(World_muted && !src.Is_staff){src << output("The world is <B>MUTED</B>!"); return}
			if(winget(src, "ooccheck", "is-checked") == "false" && winget(src, "saycheck", "is-checked") == "false"){
				src << output("You key have to check one of the boxes <B>BELOW</B>!"); return}
			if(winget(src, "ooccheck", "is-checked") == "true"){com.OOC(t)}
			if(winget(src, "saycheck", "is-checked") == "true"){com.Say(t)}
		who()
			set hidden = 1
			var i = 0; winset(src, "who", "is-visible=false"); src << output("<B>Players Online: 0</B>", "playersonline")
			src << output(null, "players"); winset(src, "who", "is-visible=true")
			for(var/player/P in global.online_players)
				var rank
				if(P.Staff_num == 3){rank = "\red(Admin)</font color>"}
				if(P.Staff_num == 2){rank = "\blue(Mod)</font color>"}
				if(P.Staff_num == 1){rank = "\green(Con)</font color>"}
				i ++; src << output("[i].) <B>[rank][P.name]([P.key])</B>", "players")
			src << output("Players Online: [i]", "playersonline")
		switch_costume()
			set hidden = 1
			src.costume()
		savegame()
			set hidden = 1
			src.Save()
			src.ShowText("Your game has been saved.")
		Test_Walk()
			set name = "Test Walk"
			if(src.playerFlags & IN_BATTLE)return
			if(src.walker)
				if(!(src.walker in src.party))
					del src.walker
				else
					src.walker.loc = null
			var s
			if( (src.key in Moderator_key) || (src.key in Admin_key) || (src.key in Contributor_key) )
				s = capitalize(capitalize(lowertext(input("Which Pokémon Do you want?","Which one?") as text),"-")," ")
			else
				src << "Only admins and moderators can use this command. Sorry."
				return
			var pos = min(max(src.party.Find(walker),1),6)
			var pokemon/P = get_pokemon(s,src)
			if(isnull(P))
				world << "This Pokémon is either unimplemented or does not exist."
				return
			P.density = src.density
			src.walker = P
			if(pos)
				var pokemon/X = src.party[pos]
				src.party[pos] = src.walker
				del X
				src.party[7] = src.walker
			src.walker.Move(src.prevLoc)
			for(var/player/PL in hearers(src.walker))
				if((PL==src)||(!(src.playerFlags & KARNAGE_LOCKED)))
					PL.client.Audio.addSound(sound(src.walker.cry,channel=15),"200",autoplay=TRUE)
					PL.client.images.Add(src.walker.sprite)
		Test_Evolution()
			if(!src.walker)return
			if((!src.walker.evo) && (src.walker.pName <> "Eevee"))return
			var wentEvo = FALSE
			var tName = "[src.walker.name]"
			var pName = "[src.walker.pName]"
			var oldLevel = src.walker.level
			if(src.walker.pName=="Kirlia")
				if(src.walker.gender=="male")
					if(prob(50))
						var item/normal/stone/Dawn_Stone/S = new
						src.walker.evolve(S)
						wentEvo = TRUE
			else if(src.walker.pName=="Snorunt")
				if(src.walker.gender=="female")
					if(prob(50))
						var item/normal/stone/Dawn_Stone/S = new
						src.walker.evolve(S)
						wentEvo = TRUE
			if(wentEvo==FALSE)
				if(src.walker.evoType in list(LEVEL,DAYTIME,NIGHTTIME))
					src.walker.level = src.walker.evoLevel
					if(src.walker.evoItem)
						src.walker.held = new src.walker.evoItem

				else if(src.walker.evoType==FRIENDSHIP)
					src.walker.friendship = 220

				else if(src.walker.evoType == TRADE)
					if(src.walker.evoItem)
						src.walker.held = new src.walker.evoItem
					src.walker.evolve(new/item/normal/stone,new/obj)
					wentEvo = TRUE
				else if(src.walker.evoType == LEARN_MOVE)
					if(src.walker.evoTriggerMove)
						var pmove/M = src.walker.moves[1]
						src.walker.moves[1] = null // Clear this reference
						del M
						src.walker.moves[1] = new src.walker.evoTriggerMove
				else
					switch(src.walker.pName)
						if("Slowpoke")
							if(prob(50))
								src.walker.level = src.walker.evoLevel
							else
								src.walker.held = new/item/normal/evolve_item/trade/King\'\s_Rock
								src.walker.evolve(new/item/normal/stone,new/obj)
								wentEvo = TRUE
						if("Gloom")
							var theType = pick(/item/normal/stone/Leaf_Stone,/item/normal/stone/Sun_Stone)
							src.walker.evolve(new theType)
							wentEvo = TRUE
						if("Poliwhirl")
							if(prob(50))
								src.walker.evolve(new/item/normal/stone/Water_Stone)
							else
								src.walker.held = new /item/normal/evolve_item/trade/King\'\s_Rock
								src.walker.evolve(new/item/normal/stone,new/obj)
							wentEvo = TRUE
						if("Feebas")
							src.walker.beauty = 200
						if("Clamperl")
							var theItemType = pick(/item/normal/evolve_item/trade/Deep_Sea_Tooth,/item/normal/evolve_item/trade/Deep_Sea_Scale)
							src.walker.held = new theItemType
							src.walker.evolve(new/item/normal/stone,new/obj)

						if("Tyrogue")
							src.walker.level = 20
							src.walker.stat_calculate()
						if("Phione")
							src.walker.beauty = 200
							src.walker.friendship = 220
							src.walker.affection = 100
							src.walker.level = 100
							src.walker.held = new /item/normal/evolve_item/trade/Prisim_Scale
						if("Budew","Riolu")
							src.walker.friendship = 220
						if("Eevee")
							switch(rand(1,5))
								if(1)
									src.walker.friendship = 220
									src.walker.evolve()
								if(2)
									src.walker.affection = 100
									src.walker.moves[2] = new /pmove/Baby\-\Doll_Eyes
									src.walker.evolve()
								if(3)
									var item/normal/stone/Water_Stone/S = new
									src.walker.evolve(S)
								if(4)
									var item/normal/stone/Thunder_Stone/S = new
									src.walker.evolve(S)
								if(5)
									var item/normal/stone/Fire_Stone/S = new
									src.walker.evolve(S)
							wentEvo = TRUE
						if("Pikachu")
							src.walker.evolve(new/item/normal/stone/Thunder_Stone)
							wentEvo = TRUE
						if("Rockruff","Cosmoem")
							src.walker.level = src.walker.evoLevel


			if(src.walker.evoType == STONE)
				var item/normal/stone/S = new
				S.sStone |= src.walker.evoStone
				src.walker.evolve(S)
			else if(!wentEvo)
				src.walker.evolve()
			if(pName == src.walker.pName)
				src << "[src.walker.name] has stopped evolving???"
				src << src.walker.cry
			else
				src << "Congratulations! Your [tName] has evolved into [src.walker.pName]"
				if(oldLevel != src.walker.level)
					src.walker.exp = getRequiredExp(src.walker.expGroup,src.walker.level)
				hearers(src.walker) << src.walker.cry
		Turn_Shiny()
			if(!src.walker)return
			var pokemon/P = src.walker
			if(P.savedFlags & SHINY)return
			P.savedFlags |= SHINY
			P.shineNumber = src.tValue
			if(P.pName != "Arceus")
				var pokemon/R = get_pokemon("[P.pName][P.form]",P.owner,PIDlower=P.PIDlower,PIDhigher=P.PIDhigher,shinyNum=P.shineNumber,formID=P.formID,
				theGenderByte=P.genderByte,noLearn=TRUE)
				animate(P.sprite,icon = R.sprite.icon)
				animate(P.fsprite,icon = R.fsprite.icon)
				animate(P.bsprite,icon = R.bsprite.icon)
				P.menuIcon = R.menuIcon
			else
				P.formChange()