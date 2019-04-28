#define BATTLE_BUTTON_WIDTH 115
#define BATTLE_BUTTON_HEIGHT 55

battle
	Move()
		return 0
	layer = 0
	parent_type = /screen
	plane = HUD_PLANE + 5
	icon = 'Battle Buttons.dmi'
	icon_state = "Button"
	maptext_width = 1000
	maptext_height = 1000
	screen_loc = "SOUTH,WEST+18"
	mouse_opacity = 2
	cursorObj
		layer = 1
		icon_state = "Selected"
		var battle/linkButton
		mouse_opacity = 0
	proc
		buttonActivate(player/P)
	Click(location,control,params)
		buttonActivate(usr)
	New()
		maptext_x = 20
		maptext_y = BATTLE_BUTTON_HEIGHT/2
	fightButton
		screen_loc = "15:28,2:23"
		New()
			..()
			maptext = "<font size = 2 face = \"Times New Roman\" color = black>Fight</font>"
		buttonActivate(player/P)
			var battleSystem/battle
			if(istype(P,/player))
				P.switchClose()
				battle = P.client.battle
			else
				usr << "Bad Battle Button"
				del src
			var ourStageValue = battle.getPlayerText(P.client)
			var pokemon/S = battle.activePokemon[ourStageValue]
			if(S.moves.len != 4)S.moves.len = 4 // Just to make sure
			var foundMoveWithPP = FALSE
			for(var/pmove/M in S.moves)
				if(M.PP > 0)
					foundMoveWithPP = TRUE
					break

			if(!foundMoveWithPP)battle.chosenMoveData[battle.getPokemonText(S)]["move"] = battle.getMatchingStruggle(S)

			P.client.screen -= theButtons

			var moveButtonList[] = list(new/battle/movebutton(S.moves[1],1),new/battle/movebutton(S.moves[2],2),
			new/battle/movebutton(S.moves[3],3),new/battle/movebutton(S.moves[4],4))

			P.client.screen.Add(moveButtonList)

			P.client.selectButtons = moveButtonList

			battle.battleStage[ourStageValue] = BATTLE_STAGE_MOVE_SELECT

	runButton
		screen_loc = "19:14,1:1"
		New()
			..()
			maptext = "<font size = 2 face = \"Times New Roman\" color = black>Run</font>"
		buttonActivate(player/P)
			if(istype(P,/player))
				P.switchClose()
				if(P.client.battle)
					var battleSystem/battle = P.client.battle
					if(P.client.battle.flags & WILD_BATTLE)
						battle.chosenMoveData["P1"]["move"] = new /pmove/EscapeProxy
					else
						P.ShowText("HEY! You can't run away from a trainer battle.")
	bagButton
		screen_loc = "15:28,1:1"
		New()
			..()
			maptext = "<font size = 2 face = \"Times New Roman\" color = black>Bag</font>"
		buttonActivate(player/P)
			if(istype(P,/player))
				P.switchClose()
				var battleSystem/battle = P.client.battle
				if(battle)
					if(battle.flags & IMPORT_BATTLE)
						P.ShowText("[battle.E1.name], come back!")
						if(hascaught(battle.P1,battle.E1,new /item/pokeball/Park_Ball,P.client))
							if(!("Success" in P.client.Audio.sounds))
								P.client.Audio.addSound(sound('success.wav',channel=19),"Success")
							P.client.Audio.playSound("Success")
							P.ShowText("[battle.E1] has been returned!")
							var pokemon/PK = battle.E1
							if(!(PK.savedFlags & IMPORTED_FROM_GEN_3))
								PK.caughtWith = ((PK.pName=="Pikachu")&&(PK.form=="-Starter"))?("Pikachu Ball"):("Park Ball")
							transferHolder["[ckeyEx(P.key)]"] -= PK
							caughtTransfers["[ckeyEx(P.key)]"] += PK
							if(!length(transferHolder["[ckeyEx(P.key)]"])) // All Transferred Pokémon have been captured
								fdel("Transfer Files/[ckeyEx(P.key)].esav")
								#ifndef OLD_PC_SYSTEM
								var item/key/Laptop/L = P.bag.getItem(/item/key/Laptop)
								for(var/pokemon/S in caughtTransfers["[ckeyEx(P.key)]"])
									L.comp.depositInEmptySpace(S)
								#else
								var savefile/F
								var boxSaveProxy/theBox
								var lastBox = 0
								for(var/pokemon/S in caughtTransfers["[ckeyEx(P.key)]"])
									box_loop
										for(var/box in 1 to 100)
											if(lastBox != box)
												if(theBox)
													if(fexists("Boxes/Box [lastBox]/[ckeyEx(P.key)].esav"))
														fdel("Boxes/Box [lastBox]/[ckeyEx(P.key)].esav")
													theBox.Write(F)
													text2file(RC5_Encrypt(F.ExportText("/"),md5("martin")),"Boxes/Box [lastBox]/[ckeyEx(P.key)].esav")
													del F
													del theBox
													sleep TICK_LAG
												F = new
												F.ImportText("/",RC5_Decrypt(file2text("Boxes/Box [box]/[ckeyEx(P.key)].esav"),md5("martin")))
												theBox = new
												theBox.Read(F,P)
												lastBox = box
											for(var/x in 1 to 10)
												for(var/y in 1 to 10)
													if(isnull(theBox.boxList[x][y]))
														theBox.boxList[x][y] = S
														break box_loop
											sleep TICK_LAG*3
								if(F)
									theBox.Write(F)
									if(fexists("Boxes/Box [lastBox]/[ckeyEx(P.key)].esav"))
										fdel("Boxes/Box [lastBox]/[ckeyEx(P.key)].esav")
									text2file(RC5_Encrypt(F.ExportText("/"),md5("martin")),"Boxes/Box [lastBox]/[ckeyEx(P.key)].esav")
								#endif
							del P.client.battle
					else
						P.updateBag()
						winset(P,"bagWindow","is-visible=true")
				else
					usr << "Bad battle."
	pkmnButton
		screen_loc = "19:14,2:23"
		New()
			..()
			maptext = "<font size = 2 face = \"Times New Roman\" color = black>Pokémon</font>"
		buttonActivate(player/P)
			P.updatePartySwap()
			P.client.battle.canCancelSwitch[P.client.battle.getPlayerText(P)] = TRUE
			winset(P,"PartySwap","is-visible=true")
	movebutton
		mouse_opacity = 2
		var pmove/theAttack
		var IDnumber
		New(pmove/A,movenum)
			..()
			loc = null
			IDnumber = movenum
			if(isnull(A))
				A = new
				A.name = DEFAULT_ATTACK
			theAttack = A
			maptext = "<font size = 2 face = \"Times New Roman\" color = black>[theAttack.name]</font>"
			var PPLeft = "<font size = 2 face = \"Times New Roman\" color = black>PP: [theAttack.PP]/[theAttack.MaxPP]</font>"
			new /Maptext(PPLeft,1000,1000,src,maptext_x,maptext_y-10)
			switch(movenum)
				if(1)src.screen_loc = "15:28,2:23"
				if(2)src.screen_loc = "19:14,2:23"
				if(3)src.screen_loc = "15:28,1:1"
				if(4)src.screen_loc = "19:14,1:1"
				else src.screen_loc = "19:14,1:1" // Failsafe
		buttonActivate(player/P)
			if(theAttack.name==DEFAULT_ATTACK)return
			if(istype(P,/player))
				if(theAttack.PP==0)return
				var battleSystem/battle
				if(P.client.battle)
					battle = P.client.battle

				if(!(battle.flags & DOUBLE_BATTLE))
					var pokemon/PK = battle.activePokemon[battle.getPlayerText(P.client)]
					if((PK.choiceSlot!=0)&&(IDnumber!=PK.choiceSlot))return
					battle.chosenMoveData[battle.getPokemonText(PK)]["move"] = theAttack
					if(istype(PK.held,/item/normal/choice))
						PK.choiceSlot = IDnumber
				else
					var pokemon/S = battle.activePokemon[battle.getPlayerText(P.client)]
					for(var/battle/movebutton/M in P.client.screen)
						P.client.screen -= M
					var targetButtonList[]
					if(P in list(battle.owner,battle.player3))
						targetButtonList = list(new/battle/targetbutton(battle.P1,S,theAttack,4),new/battle/targetbutton(battle.P2,S,theAttack,3),
						new/battle/targetbutton(battle.E1,S,theAttack,1),new/battle/targetbutton(battle.E2,S,theAttack,2))
					else
						targetButtonList = list(new/battle/targetbutton(battle.E1,S,theAttack,4),new/battle/targetbutton(battle.E2,S,theAttack,3),
						new/battle/targetbutton(battle.P1,S,theAttack,1),new/battle/targetbutton(battle.P2,S,theAttack,2))
					P.client.screen.Add(targetButtonList)
					P.client.selectButtons = targetButtonList
	targetbutton
		var pokemon/P
		var pokemon/K
		var pmove/M
		var IDnumber
		New(pokemon/S,pokemon/PK,pmove/A,targetnum)
			..()
			loc = null
			src.M = A
			K = PK
			IDnumber = targetnum
			if(isnull(S))return
			if(S.status == FAINTED)return
			maptext = "\icon[S.menuIcon] <font size = 2 face = \"Times New Roman\" color = black>[S]</font>"
			switch(targetnum)
				if(1)src.screen_loc = "15:28,2:23"
				if(2)src.screen_loc = "19:14,2:23"
				if(3)src.screen_loc = "15:28,1:1"
				if(4)src.screen_loc = "19:14,1:1"
				else src.screen_loc = "19:14,1:1" // Failsafe
		buttonActivate(player/P)
			if(isnull(src.P))return
			if(src.P.status == FAINTED)return
			if(istype(P,/player))
				M.target = src.P
				var battleSystem/battle = P.client.battle
				if(K==battle.P1)
					battle.chosenMoveData["P1"]["move"] = M
					if((!isnull(battle.P2)) && (battle.P2.status != FAINTED))
						var pmove/useMoves[0]
						var pokemon/validTargets[0]
						for(var/pmove/MO in battle.P2.moves)
							if(MO.PP > 0)
								useMoves += MO
						var pmove/partnerMove
						if(!length(useMoves))
							partnerMove = battle.pstrug2
						else
							partnerMove = pick(useMoves)
						for(var/pokemon/PK in list(battle.E1,battle.E2))
							if(PK.status != FAINTED)
								validTargets += P
						partnerMove.target = pick(validTargets)
						battle.chosenMoveData["P2"]["move"] = partnerMove
				else if(K==battle.P2)
					battle.chosenMoveData["P2"]["move"] = M
				else if(K==battle.E1)
					battle.chosenMoveData["E1"]["move"] = M
					battle.chosenMoveData["E2"]["move"] = pick(battle.E2.moves)
				else
					battle.chosenMoveData["E2"]["move"] = M

atom
	var tmp/Maptext/textThing // often null

Maptext
	parent_type = /atom/movable
	var tmp/atom/object
	New(text,height,width,atom/object,pixel_x,pixel_y)
		src.maptext = text
		src.maptext_height = height
		src.maptext_width = width
		src.maptext_x = pixel_x
		src.maptext_y = pixel_y
		src.layer = object.layer+1 // So it's ALWAYS displayed on top
		src.plane = object.plane
		src.object = object
		src.object.overlays += src
	proc
		ChangeText(text)
			src.maptext = text
