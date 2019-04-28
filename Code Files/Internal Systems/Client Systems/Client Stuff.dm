client
	var
		battleSystem/battle
		selectButtons[]
		clientFlags = 0
	//preload_rsc = "http://download1601.mediafire.com/b77yigd4afgg/ol0u5rej0jscy6k/Pok%C3%A9mon+Universe+Network_rsc.zip"
	fps = 60
	New()
		..()
		src << browse_rsc(file("PUN Help.css"))
		src << browse(file("PUN Help.htm"),"window=browser1")

	Del()
		global.online_players.Remove(mob)
		..()
	Click(object,location,control,params)
		. = ..()
		//src << "the object is [object]"
		if(clientFlags & SCREEN_LOC_DEBUG)src << params2list(params)["screen-loc"]
	Topic(href,href_list[],hsrc)
		switch(href_list["Action"])
			if("Display Ribbon")
				var icon/I = icon('Ribbons.dmi',href_list["Ribbon Name"])
				winset(src,"ribbonInfo.ribbonImage",list2params(list("image"="\ref[fcopy_rsc(I)]")))
				winset(src,"ribbonInfo.ribbonName",list2params(list("text"=href_list["Ribbon Name"])))
				winset(src,"ribbonInfo.ribbonDesc",list2params(list("text"=ribbonDesc(href_list["Ribbon Name"]))))
				winset(src,"ribbonInfo","is-visible=true")
			else
				. = ..()
	verb
		checkScreen()
			set name = "Check Screen"
			for(var/atom/movable/A in src.screen)
				src << "there is a [A] on the screen with a mouse_opacity of [A.mouse_opacity] on plane [A.plane] layer [A.layer]"
		changeVolume()
			set hidden = 1
			var value = floor(text2num(winget(src,"bar1","value")))
			src.Audio.setGlobalVolume(value)
			winset(src,"label13",list2params(list("text" = "Volume: [value]")))
		toggle_screen_loc_debug()
			clientFlags ^= SCREEN_LOC_DEBUG
		toggleInversion()
			set hidden = 1
			src.clientFlags &= ~(GRAYSCALE_MODE)
			src.clientFlags ^= INVERSION_MODE
			if(src.clientFlags & INVERSION_MODE)
				animate(src,color = list(-1,0,0, 0,-1,0, 0,0,-1, 1,1,1),time = 10)
			else
				animate(src,color = null,time = 10)
		toggleGrayscale()
			set hidden = 1
			src.clientFlags &= ~(INVERSION_MODE)
			src.clientFlags ^= GRAYSCALE_MODE
			if(src.clientFlags & GRAYSCALE_MODE)
				animate(src,color = list(0.3,0.3,0.3,0,
								0.59,0.59,0.59,0,
								0.11,0.11,0.11,0,
								0,0,0,1),time=10)
			else
				animate(src,color = null,time=10)
	proc
		goBackInBattle()
			if(battle)
				var x = battle.getPlayerText(src)
				if(battle.battleStage[x]==BATTLE_STAGE_MOVE_SELECT)
					battle.battleStage[x] = BATTLE_STAGE_ACTION_SELECT
					src.screen += theButtons
					for(var/battle/movebutton/MB in src.screen)
						src.screen -= MB
		getButtonByNum(number)
			switch(battle.battleStage[battle.getPlayerText(src)])
				if(BATTLE_STAGE_MOVE_SELECT)
					for(var/battle/movebutton/M in selectButtons)
						if(M.IDnumber==number)return M
				if(BATTLE_STAGE_TARGET_SELECT)
					for(var/battle/targetbutton/T in selectButtons)
						if(T.IDnumber==number)return T
		getCursorPos()
			var selectedData = battle.selectedItem[battle.getPlayerText(src)]
			for(var/x in 1 to 2)
				for(var/y in 1 to 2)
					if(selectedData[x][y]==1)
						return list("cursorX"=x,"cursorY"=y)
			return list("cursorX"=1,"cursorY"=1)
		setCursorPos(cursorX,cursorY,oldPos,animateIt=TRUE)
			if(isnull(battle) || (!(locate(/battle) in src.screen)))
				return
			var playerText = battle.getPlayerText(src)
			var selectedData = battle.selectedItem[playerText]
			if(!isnull(oldPos))
				selectedData[oldPos["cursorX"]][oldPos["cursorY"]] = 0
			selectedData[cursorX][cursorY] = 1
			var battle/cursorObj/CO = locate(/battle/cursorObj) in src.screen
			if(isnull(CO))
				CO = new
				src.screen += CO
			var matrix/M = matrix()
			if((cursorX==1)&&(cursorY==1))
				M.Translate(-100,55)
				switch(battle.battleStage[playerText])
					if(BATTLE_STAGE_ACTION_SELECT)
						CO.linkButton = locate(/battle/fightButton) in src.screen
					if(BATTLE_STAGE_MOVE_SELECT,BATTLE_STAGE_TARGET_SELECT)
						CO.linkButton = getButtonByNum(1)
			else if((cursorX==1)&&(cursorY==2))
				M.Translate(14,55)
				switch(battle.battleStage[playerText])
					if(BATTLE_STAGE_ACTION_SELECT)
						CO.linkButton = locate(/battle/pkmnButton) in src.screen
					if(BATTLE_STAGE_MOVE_SELECT,BATTLE_STAGE_TARGET_SELECT)
						CO.linkButton = getButtonByNum(2)
			else if((cursorX==2)&&(cursorY==1))
				M.Translate(-100,1)
				switch(battle.battleStage[playerText])
					if(BATTLE_STAGE_ACTION_SELECT)
						CO.linkButton = locate(/battle/bagButton) in src.screen
					if(BATTLE_STAGE_MOVE_SELECT,BATTLE_STAGE_TARGET_SELECT)
						CO.linkButton = getButtonByNum(3)
			else
				M.Translate(14,1)
				switch(battle.battleStage[playerText])
					if(BATTLE_STAGE_ACTION_SELECT)
						CO.linkButton = locate(/battle/runButton) in src.screen
					if(BATTLE_STAGE_MOVE_SELECT,BATTLE_STAGE_TARGET_SELECT)
						CO.linkButton = getButtonByNum(4)
			if(!isnull(oldPos))
				animate(CO,transform=M,time=3)
			else
				CO.transform = M
	key_down(k)
		switch(k)
			if("north","w")
				if(battle)
					var selectedData = battle.selectedItem[battle.getPlayerText(src)]
					var allZeroes = TRUE
					for(var/x in 1 to 2)
						for(var/y in 1 to 2)
							if(selectedData[x][y]==1)
								allZeroes = FALSE
								break
					if(allZeroes)
						setCursorPos(1,1,null,FALSE)
					else
						var cursorPos = getCursorPos()
						if(cursorPos["cursorX"]==2)
							setCursorPos(1,cursorPos["cursorY"],cursorPos,TRUE)
			if("south","s")
				if(battle)
					var selectedData = battle.selectedItem[battle.getPlayerText(src)]
					var allZeroes = TRUE
					for(var/x in 1 to 2)
						for(var/y in 1 to 2)
							if(selectedData[x][y]==1)
								allZeroes = FALSE
								break
					if(allZeroes)
						setCursorPos(1,1,null,FALSE)
					else
						var cursorPos = getCursorPos()
						if(cursorPos["cursorX"]==1)
							setCursorPos(2,cursorPos["cursorY"],cursorPos,TRUE)
			if("east","d")
				if(battle)
					var selectedData = battle.selectedItem[battle.getPlayerText(src)]
					var allZeroes = TRUE
					for(var/x in 1 to 2)
						for(var/y in 1 to 2)
							if(selectedData[x][y]==1)
								allZeroes = FALSE
								break
					if(allZeroes)
						setCursorPos(1,1,null,FALSE)
					else
						var cursorPos = getCursorPos()
						if(cursorPos["cursorY"]==1)
							setCursorPos(cursorPos["cursorX"],2,cursorPos,TRUE)
			if("west","a")
				if(battle)
					var selectedData = battle.selectedItem[battle.getPlayerText(src)]
					var allZeroes = TRUE
					for(var/x in 1 to 2)
						for(var/y in 1 to 2)
							if(selectedData[x][y]==1)
								allZeroes = FALSE
								break
					if(allZeroes)
						setCursorPos(1,1,null,FALSE)
					else
						var cursorPos = getCursorPos()
						if(cursorPos["cursorY"]==2)
							setCursorPos(cursorPos["cursorX"],1,cursorPos,TRUE)
			if("n")
				var player/P = mob
				if(!battle)
					P.playerFlags &= ~IN_BATTLE
				P.ContinueText = 0
			if("tab")
				var player/P = src.mob
				if(P.ContinueText==2)
					P.Continue()
				else if(battle)
					var battle/cursorObj/cursorObj = locate() in src.screen
					if(!isnull(cursorObj))
						cursorObj.linkButton.buttonActivate(src.mob)
						src.screen -= cursorObj
						cursorObj.linkButton = null
						battle.selectedItem[battle.getPlayerText(src)] = list(list(0,0),list(0,0))
				else
					if(!(P.playerFlags & IN_BATTLE))src.mob.Interact()
			if("b")
				goBackInBattle()
			if("m")
				Audio.toggleMute()
		..()