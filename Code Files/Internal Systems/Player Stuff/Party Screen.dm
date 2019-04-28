player
	var
		tmp
			switchIndex = null
			pokemon/summaryMon
	proc
		ShowEggSummary(Egg/E)
			if(isnull(E))return
			winset(src,"EggSummary.eggMet",list2params(list("text"="Egg Obtained From: [E.eggMetFrom]")))
			winset(src,"EggSummary.eggDate",list2params(list("text"="Egg Obtained On: [E.eggMetDate]")))
			var eggDesc = ""
			switch(E.eggCycles)
				if(-1.#INF to 5)
					eggDesc = "Sound can be heard coming from inside! This egg will hatch soon!"
				if(6 to 10)
					eggDesc = "It appears to move occasionally. It may be close to hatching."
				if(11 to 40)
					eggDesc = "What Pokémon will hatch from this egg? It doesn't seem to close to hatching."
				else
					eggDesc = "It looks like this egg will take a long time yet to hatch."
			winset(src,"EggSummary.eggDesc",list2params(list("text"="[eggDesc]")))
			winset(src,"EggSummary","is-visible=true")
		ShowSummary(pokemon/P)
			if(isnull(P))return
			summaryMon = P
			P.stat_calculate(TRUE)
			src.client.Audio.addSound(sound(P.cry,channel=42),"1532",TRUE)
			var
				Button
					itemButton = new(src,"PKMNSummary","itemButton")
				Label
					monName = new(src,"PKMNSummary","PKMName")
					itemHeld = new(src,"PKMNSummary","itemLabel")
					hpLabel = new(src,"mainStats","hpLabel")
					atkLabel = new(src,"mainStats","atkLabel")
					defLabel = new(src,"mainStats","defLabel")
					satkLabel = new(src,"mainStats","satkLabel")
					sdefLabel = new(src,"mainStats","sdefLabel")
					speedLabel = new(src,"mainStats","speedLabel")
					hpEVStuff = new(src,"EVs","hpEvVal")
					atkEVStuff = new(src,"EVs","atkEvVal")
					defEVStuff = new(src,"EVs","defEvVal")
					satkEVStuff = new(src,"EVs","satkEvVal")
					sdefEVStuff = new(src,"EVs","sdefEvVal")
					speedEVStuff = new(src,"EVs","speedEvVal")
					hpIvStuff = new(src,"IVs","hpIvVal")
					atkIvStuff = new(src,"IVs","atkIvVal")
					defIvStuff = new(src,"IVs","defIvVal")
					satkIvStuff = new(src,"IVs","satkIvVal")
					sdefIvStuff = new(src,"IVs","sdefIvVal")
					speedIvStuff = new(src,"IVs","speedIvVal")
					beautyStuff = new(src,"Contest Info","beautyVal")
					smartStuff = new(src,"Contest Info","smartVal")
					toughStuff = new(src,"Contest Info","toughVal")
					coolStuff = new(src,"Contest Info","coolVal")
					cuteStuff = new(src,"Contest Info","cuteVal")
					sheenStuff = new(src,"Contest Info","sheenVal")
					caughtLevelLabel = new(src,"mainInfo","caughtLevel")
					natureLabel = new(src,"mainInfo","natureLabel")
					regionLabel = new(src,"mainInfo","caughtRegion")
					levelLabel = new(src,"mainInfo","levelLabel")
					caughtGame = new(src,"mainInfo","caughtGame")
					curExp = new(src,"mainInfo","curEXP")
					nexExp = new(src,"mainInfo","nextEXP")
					caughtRoute = new(src,"mainInfo","caughtLoc")
					abilityDesc = new(src,"mainInfo","abilityDesc")
					abilityName = new(src,"mainInfo","abilityLabel")
					TIDLabel = new(src,"mainInfo","TIDLabel")
					OTLabel = new(src,"mainInfo","OTLabel")
					move1 = new(src,"moves","move1")
					move2 = new(src,"moves","move2")
					move3 = new(src,"moves","move3")
					move4 = new(src,"moves","move4")
				Grid
					ribbonGrid = new(src,"ribbons","ribbonGrid")
			curExp.Text("Current EXP: [commafy(num2text(P.exp,15))]")
			nexExp.Text("EXP Until Next Level: [commafy(num2text(getRequiredExp(P.expGroup,P.level+1) - P.exp,15))]")
			caughtLevelLabel.Text("Caught at Level: [P.caughtLevel]")
			natureLabel.Text("Pokémon Nature: [P.nature]")
			regionLabel.Text("Pokémon Caught In: [P.fromRegion]")
			caughtGame.Text("Caught In Game: [P.importedFrom]")
			monName.Text("[P.name]")
			levelLabel.Text("Pokémon Current Level: [P.level]")
			pkbSprite.icon = icon('Pokéballs.dmi',"[P.caughtWith]")
			src << browse_rsc(P.fsprite.icon,"Status Screen Image.gif")
			src << browse_rsc(file("Status Screen.css"))
			src << browse(file("Status Screen.htm"),"window=browser4")
			winset(src,"PKMNSummary.PokeBallLB",list2params(list("image"=icon('Pokéballs.dmi',"Poké Ball"))))
			//pokeBallSprite.Image(icon('Pokéballs.dmi',"[P.caughtWith]"))
			hpEVStuff.Text("[P.HPEv]")
			atkEVStuff.Text("[P.attackEv]")
			defEVStuff.Text("[P.defenseEv]")
			satkEVStuff.Text("[P.spAttackEv]")
			sdefEVStuff.Text("[P.spDefenseEv]")
			speedEVStuff.Text("[P.speedEv]")
			hpLabel.Text("[P.HP]/[P.maxHP]")
			atkLabel.Text("[P.attack]")
			defLabel.Text("[P.defense]")
			satkLabel.Text("[P.spAttack]")
			sdefLabel.Text("[P.spDefense]")
			speedLabel.Text("[P.speed]")
			hpIvStuff.Text("[P.HPIv]")
			atkIvStuff.Text("[P.attackIv]")
			defIvStuff.Text("[P.defenseIv]")
			satkIvStuff.Text("[P.spAttackIv]")
			sdefIvStuff.Text("[P.spDefenseIv]")
			speedIvStuff.Text("[P.speedIv]")
			abilityName.Text("Ability: [P.ability1]")
			abilityDesc.Text("Ability Description: [getAbilityDesc(P.ability1)]")
			caughtRoute.Text("Pokémon Obtained At: [P.caughtRoute]")
			TIDLabel.Text("Trainer ID: [P.TID]")
			OTLabel.Text("Original Trainer: [P.OT]")
			var Color/C = new("000000")
			if(P.OTgender==MALE)
				C.red = 0
				C.green = 255
				C.blue = 255
				C.alpha = 255
			else
				C.red = 255
				C.green = 192
				C.blue = 203
				C.alpha = 255
			OTLabel.TextColor(C)
			switch(P.gender)
				if(MALE)
					C.red = 0
					C.green = 255
					C.blue = 255
					C.alpha = 255
				if(FEMALE)
					C.red = 255
					C.green = 192
					C.blue = 203
					C.alpha = 255
				else
					C.red = 255
					C.green = 255
					C.blue = 255
					C.alpha = 255
			monName.TextColor(C)
			if(P.moves[1])
				var pmove/M = P.moves[1]
				var icon/I = new
				var power = M.BP
				var accuracy = M.Acc
				if(isnull(power))
					power = "---"
				if(isnull(accuracy))
					accuracy = "---"
				I.Insert(icon('Type Icons.dmi',"[M._type]"),"Type Part")
				I.Insert(icon('Move Types.dmi',"[M.range]"),"Move Part")
				I.Insert(icon('Contest Types.dmi',"[M.contestType]"),"Contest Types")
				move1.Text("Move: [M]\nType: [M._type]\nPP: [M.PP]/[M.MaxPP]\nPower: [power]\nAccuracy: [accuracy]\n\n\nDesc: [M.desc]")
				move1.Image("\ref[fcopy_rsc(I)]")
			else
				move1.Text("")
				move1.Image("")
			if(P.moves[2])
				var pmove/M = P.moves[2]
				var icon/I = new
				var power = M.BP
				var accuracy = M.Acc
				if(isnull(power))
					power = "---"
				if(isnull(accuracy))
					accuracy = "---"
				I.Insert(icon('Type Icons.dmi',"[M._type]"),"Type Part")
				I.Insert(icon('Move Types.dmi',"[M.range]"),"Move Part")
				I.Insert(icon('Contest Types.dmi',"[M.contestType]"),"Contest Types")
				move2.Text("Move: [M]\nType: [M._type]\nPP: [M.PP]/[M.MaxPP]\nPower: [power]\nAccuracy: [accuracy]\n\n\nDesc: [M.desc]")
				move2.Image("\ref[fcopy_rsc(I)]")
			else
				move2.Text("")
				move2.Image("")
			if(P.moves[3])
				var pmove/M = P.moves[3]
				var icon/I = new
				var power = M.BP
				var accuracy = M.Acc
				if(isnull(power))
					power = "---"
				if(isnull(accuracy))
					accuracy = "---"
				I.Insert(icon('Type Icons.dmi',"[M._type]"),"Type Part")
				I.Insert(icon('Move Types.dmi',"[M.range]"),"Move Part")
				I.Insert(icon('Contest Types.dmi',"[M.contestType]"),"Contest Types")
				move3.Text("Move: [M]\nType: [M._type]\nPP: [M.PP]/[M.MaxPP]\nPower: [power]\nAccuracy: [accuracy]\n\n\nDesc: [M.desc]")
				move3.Image("\ref[fcopy_rsc(I)]")
			else
				move3.Text("")
				move3.Image("")
			if(P.moves[4])
				var pmove/M = P.moves[4]
				var icon/I = new
				var power = M.BP
				var accuracy = M.Acc
				if(isnull(power))
					power = "---"
				if(isnull(accuracy))
					accuracy = "---"
				I.Insert(icon('Type Icons.dmi',"[M._type]"),"Type Part")
				I.Insert(icon('Move Types.dmi',"[M.range]"),"Move Part")
				I.Insert(icon('Contest Types.dmi',"[M.contestType]"),"Contest Types")
				move4.Text("Move: [M]\nType: [M._type]\nPP: [M.PP]/[M.MaxPP]\nPower: [power]\nAccuracy: [accuracy]\n\n\nDesc: [M.desc]")
				move4.Image("\ref[fcopy_rsc(I)]")
			else
				move4.Text("")
				move4.Image("")
			itemButton.Command("giveTakeItem")
			if(P.held)
				itemHeld.Text("Item: [P.held]")
				itemButton.Text("Take")
			else
				itemHeld.Text("Item: None")
				itemButton.Text("Give")
			beautyStuff.Text("[P.beauty]")
			cuteStuff.Text("[P.cool]")
			coolStuff.Text("[P.cute]")
			smartStuff.Text("[P.smart]")
			toughStuff.Text("[P.tough]")
			sheenStuff.Text("[P.sheen]")
			winset(src,"mainInfo.caughtDate",list2params(list("text"="Pokémon Obtained On: [P.caughtDate]")))
			winset(src,"PKMNSummary","is-visible=true")
			var
				ribbonListLength = P.ribbons.len
				currentRibbonIndex = 1
				ribbonArgs[] = list("Action"="Display Ribbon","Ribbon Name")
			for(var/x in 1 to 12)
				for(var/y in 1 to 18)
					if((currentRibbonIndex)<=ribbonListLength)
						ribbonArgs["Ribbon Name"] = P.ribbons[currentRibbonIndex]
						ribbonGrid.Cell(y,x,"<a href=?[list2params(ribbonArgs)]>\icon[icon('Ribbons.dmi',P.ribbons[currentRibbonIndex])]</a>")
						++currentRibbonIndex
					else
						ribbonGrid.Cell(y,x,"")
			var icon/typeIcon = new
			var friendshipValue = min(round((P.friendship/255)*100),100)
			typeIcon.Insert(icon('Type Icons.dmi',"[P.type1]"),"Type1")
			if(P.type2)
				typeIcon.Insert(icon('Type Icons.dmi',"[P.type2]"),"Type2")
				if(P.type3)
					typeIcon.Insert(icon('Type Icons.dmi',"[P.type3]"),"Type3")
			winset(src,"PKMNSummary.typeLabel","image=\ref[fcopy_rsc(typeIcon)]")
			winset(src,"PKMNSummary.friendship","value=[friendshipValue]")
			if(P.pokerus)
				var icon/pokerusIcon
				if(getPokerusLength(P)>0)
					pokerusIcon = icon('Pokérus.dmi',"Pokérus")
				else
					pokerusIcon = icon('Pokérus.dmi',"Cured")
				winset(src,"PKMNSummary.pokerusLabel","image=\ref[fcopy_rsc(pokerusIcon)]")
			else
				winset(src,"PKMNSummary.pokerusLabel","image=")
	verb
		closeSummary()
			set hidden = 1
			summaryMon = null
		giveTakeItem()
			set hidden = 1
			if(isnull(summaryMon))return
			var Label/itemHeld = new(src,"PKMNSummary","itemLabel")
			var Button/itemButton = new(src,"PKMNSummary","itemButton")
			itemButton.Command("giveTakeItem")
			if(isnull(summaryMon.held))
				updateBag()
				winset(src,"bagWindow","is-visible=true")
				return
			else
				if(alert(src,"Are you sure you want to take the [summaryMon.held] from [summaryMon]?","Take this item.","Yes","No")=="Yes")
					var item/I = summaryMon.held
					src.bag.addItem(I.type)
					summaryMon.held = null
					if(summaryMon.pName in list("Groudon","Kyogre","Giratina","Arceus","Silvally"))
						summaryMon.formChange()
					itemHeld.Text("Item: None")
					itemButton.Text("Give")
					src.ShowText("You have taken the [I] from [summaryMon].")
		PartyOpen()
			set hidden = 1
			var Button/partyButtons[6]
			for(var/x in 1 to 6)
				var Button/B = new(src,"partyThing","party[x]")
				B.Image("")
				winset(src,"partyThing.party[x]","command=PartyAccess+%22[x]%22")
				partyButtons[x] = B
			for(var/x in 1 to 6)
				var pokemon/P = src.party[x]
				if(isnull(P))break
				var Button/B = partyButtons[x]
				var icon/I = P.menuIcon
				B.Image("\ref[fcopy_rsc(I)]")
			winset(src,"partyThing","is-visible=true")
			src.client.clientFlags |= LOCK_MOVEMENT
		PartyAccess(partyPos as text)
			set hidden = 1
			partyPos = text2num(partyPos)
			var pokemon/P = src.party[partyPos]
			if((!src.withdrawIndexX) && (!withdrawIndexY))
				if(!(src.playerFlags & USING_PC_BOX))
					if(!src.switchIndex)
						if(isnull(P))return
						else if(istype(P,/pokemon))
							var options = list("Show Summary","Switch Position","Walk","Rename")
							if(src.lightArea && (locate(/pmove/Flash) in P.moves))
								options += "Flash"
							if(src.escape_loc && (locate(/pmove/Dig) in P.moves))
								options += "Dig"
							switch(input(src,"Which would you like to do with this Pokémon?","Party") as null|anything in options)
								if("Show Summary")
									ShowSummary(P)
								if("Switch Position")
									src.switchIndex = src.party.Find(P)
								if("Walk")
									var turf/theLoc
									if(src.walker)
										theLoc = src.walker.loc
										src.walker.loc = null
									else
										theLoc = src.prevLoc
									src.walker = P
									src.walker.Move(theLoc)
									src.client.images |= P.sprite
									for(var/player/PL in global.online_players)
										PL.client.images |= P.sprite
								if("Rename")
									if(P.withOT())
										var renamed = FALSE
										var newName
										do
											newName = input(src,"What will you rename [P] to?","Rename this Pokémon") as text
											renamed = (alert(src,"Are you sure you will rename [P] to [newName]?","Rename this Pokémon","Yes!",
											"No...")=="Yes!")
										while(!renamed)
										P.name = newName
									else
										src.ShowText("[P] will not answer to a new name, as it will not have been given by [P.OT].")
								if("Flash")
									if(src.lightArea.flashed)
										src.ShowText("This area has already been flashed!")
									else
										src.ShowText("[P] used Flash to brighten up the area!")
										animate(src.lightArea,transform=matrix()*3,time=30)
										src.lightArea.flashed = TRUE
								if("Dig")
									var turf/T = locate(src.escape_loc)
									var turf/D = null
									switch(src.escape_dir)
										if(NORTH)
											D = locate(T.x,T.y+1,T.z)
										if(SOUTH)
											D = locate(T.x,T.y-1,T.z)
										if(EAST)
											D = locate(T.x+1,T.y,T.z)
										if(WEST)
											D = locate(T.x-1,T.y,T.z)
										else
											D = locate(T.x,T.y-1,T.z)
									src.Move(D)
									src.escape_loc = ""
									src.escape_dir = null
									src.ShowText("[P] helps [src] escape with [genderGet(P,"his")] Dig!")
						else if(istype(P,/Egg))
							switch(input(src,"What would you like to do with this egg?","Party") as null|anything in list("Show Summary","Switch Position"))
								if("Show Summary")
									ShowEggSummary(P)
								if("Switch Position")
									src.switchIndex = src.party.Find(P)
					else
						if(isnull(P))return
						src.party.Swap(src.switchIndex,partyPos)
						src.switchIndex = initial(src.switchIndex)
						var Button/partyButtons[6]
						for(var/x in 1 to 6)
							var Button/B = new(src,"partyThing","party[x]")
							winset(src,"partyThing.party[x]","command=PartyAccess+%22[x]%22")
							B.Image("")
							partyButtons[x] = B
						for(var/x in 1 to 6)
							var Button/B = partyButtons[x]
							var pokemon/PK = src.party[x]
							if(isnull(PK))break
							var icon/I = PK.menuIcon
							B.Image("\ref[fcopy_rsc(I)]")
				else
					if(isnull(P))return
					var pokemonCount = 0
					for(var/i in 1 to 6)
						if(istype(src.party[i],/pokemon))
							++pokemonCount
					if(pokemonCount > 1)
						if(alert(src,"Deposit This Pokémon?","Deposit","Yes","No")=="Yes")
							src.switchIndex = partyPos
							winset(src,"partyThing","is-visible=false")
					else
						alert(src,"You can't deposit your last pokémon!","Deposit")
						return
			else
				var thePos = min(max(partyPos-1,1),6)
				if(isnull(P) && isnull(src.party[thePos]))return
				var item/key/Laptop/L = src.bag.getItem(/item/key/Laptop)
				L.comp.SwapInPC(src.withdrawIndexX,src.withdrawIndexY,partyPos)
				for(var/x in 1 to 6)
					winset(src,"partyThing.party[x]","image=\"\"")
				for(var/x in 1 to 6)
					var pokemon/PK = src.party[x]
					if(PK)
						var icon/I = PK.menuIcon
						winset(src,"partyThing.party[x]","image=\ref[fcopy_rsc(I)]")
				for(var/x in 1 to 10)
					for(var/y in 1 to 10)
						winset(src,"boxWindow.box[x]x[y]","image=\"\"")
				for(var/x in 1 to 10)
					for(var/y in 1 to 10)
						var pokemon/PK = L.comp.boxData.boxList[x][y]
						if(PK)
							var icon/I = PK.menuIcon
							winset(src,"boxWindow.box[x]x[y]","image=\ref[fcopy_rsc(I)]")
				src.withdrawIndexX = null
				src.withdrawIndexY = null
				winset(src,"partyThing","is-visible=false")
		PartyClose()
			set hidden = 1
			winset(src,"partyThing","is-visible=false")
			for(var/x in 1 to 6)
				winset(src,"partyThing.party[x]","background-color=#fff")
			src.switchIndex = null
			src.client.clientFlags &= ~LOCK_MOVEMENT
		useEvolutionaryStone(partypos as num,usability as num,stonename as text,stonetype as text)
			set hidden = 1
			var pokemon/P = src.party[partypos]
			if(!usability)
				src.ShowText("[P] can't evolve by using the [stonename].")
			else
				if(alert(src,"Do you want to evolve [P] using the [stonename]?","Evolutionary Stone","Yes!","No...")=="Yes!")
					P.evolve(src.bag.getItem(text2path(stonetype)))
			PartyClose()
		TeachTMMove(partypos as num,learnvalue as num,movetype as text,movename as text,tmtype as text)
			set hidden = 1
			var pokemon/P = src.party[partypos]
			switch(learnvalue)
				if(0)
					src.ShowText("[P] and [movename] are completely incompatible. [movename] cannot be learned.")
				if(1)
					P.moves.len = 4
					var movepos = P.moves.Find(null)
					var thetype = text2path(movetype)
					var pmove/M = new thetype
					if(movepos)
						P.moves[movepos] = M
						src.ShowText("[P] just learned the move [movename]!")
					else
						src.ShowText("[P] is trying to learn the move [movename]")
						src.ShowText("But [genderGet(P,"he")] already knows four moves.")
						src.ShowText("Delete a move to make room for [movename]?")
						if(alert(src,"Delete A Move to make room for [movename]?","Delete A Move?","Yes!","No...")=="Yes!")
							var deleted = FALSE
							do
								var pmove/MO = input(src,"Which move will you Delete?","Which Move?") as null|anything in P.moves
								if(isnull(MO))break
								if(!MO.canForget(P.owner))
									src.ShowText("It doesn't seem like it's a good idea to forget this move right now.")
									deleted = FALSE
									continue
								var thePos = P.moves.Find(MO)
								P.moves[thePos] = M
								del MO
								deleted = TRUE
								src.ShowTextInstant("1...")
								src.ShowTextInstant("1... 2...")
								src.ShowTextInstant("1... 2... 3... Poof!")
								src.ShowText("[src] has forgotten the move [MO] and learned [movename]!")
							while(!deleted)
							if(deleted)src.bag.getItem(text2path(tmtype))
				if(2)
					src.ShowText("[P] already knows how to use [movename]. Teaching it again isn't needed.")
			PartyClose()
