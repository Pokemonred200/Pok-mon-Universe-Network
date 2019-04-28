proc
	fmove(originalFile,newFile)
		if(fexists(originalFile) && (!fexists(newFile)))
			fcopy(originalFile,newFile)
			fdel(originalFile)
			return 1
		return 0
	fswap(file1,file2)
		if(fexists(file1) && fexists(file2))
			var
				tmpfile1 = fcopy(file1,"tmp1.txt")
				tmpfile2 = fcopy(file2,"tmp2.txt")
			fdel(file1)
			fdel(file2)
			fcopy("tmp2.txt",tmpfile1)
			fcopy("tmp1.txt",tmpfile2 )

player
	var withdrawIndexX = null
	var withdrawIndexY = null
	verb
		switchBoxLeft()
			set hidden = 1
			var item/key/Laptop/L = bag.getItem(/item/key/Laptop)
			if(isnull(L) || isnull(L.comp))return
			var newBox = L.comp.currentBox - 1
			if(newBox<1)
				newBox = 100
			L.comp.closePC()
			for(var/x in 1 to 10)
				for(var/y in 1 to 10)
					winset(src,"boxWindow.box[x]x[y]","command=boxInfo+[x]+[y];image=\"\"")
			L.comp.loadBox(newBox)
		switchBoxRight()
			set hidden = 1
			var item/key/Laptop/L = bag.getItem(/item/key/Laptop)
			if(isnull(L) || isnull(L.comp))return
			var newBox = L.comp.currentBox + 1
			if(newBox>100)
				newBox = 1
			L.comp.closePC()
			for(var/x in 1 to 10)
				for(var/y in 1 to 10)
					winset(src,"boxWindow.box[x]x[y]","command=boxInfo+[x]+[y];image=\"\"")
			L.comp.loadBox(newBox)
		boxInfo(xpos as num,ypos as num)
			set hidden = 1
			var item/key/Laptop/L = src.bag.getItem(/item/key/Laptop)
			if(!L)return
			if(!L.comp){L.comp = new(src);L.comp.loadBox(1)}
			if(isnull(L.comp.boxData))return
			var pokemon/P = L.comp.boxData.boxList[xpos][ypos]
			if(!src.switchIndex)
				if(!isnull(P))
					switch(alert(src,"Which action would you like to perform?","PC Box","Summary","Withdraw","Release"))
						if("Summary")
							ShowSummary(P)
						if("Withdraw")
							withdrawIndexX = xpos
							withdrawIndexY = ypos
							PartyOpen()
						if("Release")
							if(alert(src,"Are you sure you want to release [P]?","PC Box","Yes!","No...")=="Yes!")
								src.ShowText("Goodbye, [P]!",TRUE)
								L.comp.boxData.boxList[xpos][ypos] = null
								P = null
								L.comp.refreshBox()
			else
				if(src.party[src.switchIndex]==src.walker)
					src.walker.loc = null
					src.walker = null
					src.party[7] = null
				L.comp.SwapInPC(xpos,ypos,src.switchIndex)
				src.switchIndex = initial(src.switchIndex)
				var newPartyList[0]
				for(var/i in 1 to 6)
					var pokemon/PK = src.party[i]
					if(!isnull(PK))
						newPartyList |= PK
				newPartyList.len = 7
				newPartyList[7] = src.walker
				src.party.Cut()
				src.party += newPartyList
				for(var/x in 1 to 10)
					for(var/y in 1 to 10)
						var pokemon/PK = L.comp.boxData.boxList[x][y]
						if(!isnull(PK))
							var icon/I = PK.menuIcon
							winset(src,"boxWindow.box[x]x[y]","image=\ref[fcopy_rsc(I)]")
						else
							winset(src,"boxWindow.box[x]x[y]","image=\"\"")
		closeBox()
			set hidden = 1
			winset(src,"PCBox","is-visible=false")
			if(!("PC Off" in src.client.Audio.sounds))
				src.client.Audio.addSound(sound('PC_off.wav',channel=19),"PC Off")
			src.client.Audio.playSound("PC Off")
			src.client.clientFlags &= ~LOCK_MOVEMENT
			src.playerFlags &= ~USING_PC_BOX
			src.Save()
			var item/key/Laptop/L = bag.getItem(/item/key/Laptop)
			if(L)
				if(L.comp)
					if(L.comp.currentBox && L.comp.boxData)
						L.comp.closePC()
						del L.comp.boxData

PCInteract
	parent_type = /obj
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			if(!("PC On" in P.client.Audio.sounds))
				P.client.Audio.addSound(sound('PC_turnon.wav',channel=19),"PC On")
			P.client.Audio.playSound("PC On")
			P.ShowText("You have activated the PC.")
			var item/key/Laptop/L = P.bag.getItem(/item/key/Laptop)
			if(isnull(L))
				if(!("Item Pickup" in P.client.Audio.sounds))
					P.client.Audio.addSound(sound('item_found.wav',channel=20),"Item Pickup")
				P.client.Audio.playSound("Item Pickup")
				P.ShowText("You have recieved a PC Box access card!")
				P.bag.addItem(/item/key/Laptop)
				L = P.bag.getItem(/item/key/Laptop)
				L.comp = new(P)
			if(!L.comp)
				L.comp = new(P)
			for(var/x in 1 to 10)
				for(var/y in 1 to 10)
					winset(P,"boxWindow.box[x]x[y]","command=boxInfo+[x]+[y];image=\"\"")
			L.comp.loadBox(1)
			P.playerFlags |= USING_PC_BOX
			P.client.clientFlags |= LOCK_MOVEMENT
			winset(P,"PCBox","is-visible=true")

computer
	New(player/P)
		. = ..()
		owner = P
	var
		tmp
			player/owner
			boxSaveProxy/boxData
		currentBox
	proc
		loadBox(PCBox)
			PCBox = min(max(PCBox,1),100)
			src.boxData = new(src)
			src.currentBox = PCBox
			owner.withdrawIndexX = null
			owner.withdrawIndexY = null
			winset(owner,"partyThing","is-visible=false")
			winset(owner,"PCBox.boxName",list2params(list("text"="Box [PCBox]")))
			#ifdef OLD_PC_SYSTEM
			var savefile/F = new
			F.ImportText("/",RC5_Decrypt(file2text("Boxes/Box [PCBox]/[ckeyEx(owner.key)].esav"),md5("martin")))
			#else
			boxData.loadBox(owner,PCBox)
			#endif
			refreshBox()
		#ifndef OLD_PC_SYSTEM
		checkSlot(box,xpos,ypos)
			if(fexists("Boxes/Box [box]/[owner.ckey]/slot [xpos] [ypos].eboxslot"))return TRUE
			else return FALSE
		clearSlot(box,xpos,ypos)
			if(checkSlot(box,xpos,ypos))
				fdel("Boxes/Box [box]/[owner.ckey]/slot [xpos] [ypos].eboxslot")
		swapSpots(box,xpos,ypos)  // if box == currentBox,
		depositInEmptySpace(pokemon/P,box=0)
			set background = 1
			set waitfor = 0
			var savefile/F = new
			if(box)
				box = min(max(box,1),100)
				for(var/x in 1 to 10)
					for(var/y in 1 to 10)
						if(!checkSlot(box,x,y))
							P.Write(F)
							text2file(RC5_Encrypt(F.ExportText("/"),md5("martin")),"Boxes/Box [box]/[owner.ckey]/slot [x] [y].eboxslot")
							return TRUE
			else
				for(box in 1 to 100)
					for(var/x in 1 to 10)
						for(var/y in 1 to 10)
							if(!checkSlot(box,x,y))
								P.Write(F)
								text2file(RC5_Encrypt(F.ExportText("/"),md5("martin")),"Boxes/Box [box]/[owner.ckey]/slot [x] [y].eboxslot")
								return TRUE
			return FALSE
		checkSpace(box=0) // if box == 0, all 100 boxes are checked. Otherwise, only the specified box is checked.
			set background = 1
			set waitfor = 0
			if(box)
				box = min(max(box,1),100)
				for(var/x in 1 to 10)
					for(var/y in 1 to 10)
						if(!checkSlot(box,x,y))return TRUE
						sleep -1
				return FALSE
			else
				for(var/theBox in 1 to 100)
					for(var/x in 1 to 10)
						for(var/y in 1 to 10)
							if(checkSlot(theBox,x,y))return TRUE
							sleep -1
				return FALSE
		#endif
		refreshBox()
			for(var/x in 1 to 10)
				for(var/y in 1 to 10)
					var pokemon/P = boxData.boxList[x][y]
					if(P)
						var icon/I = P.menuIcon
						winset(owner,"boxWindow.box[x]x[y]","image=\ref[fcopy_rsc(I)]")
		SwapInPC(indexX,indexY,partyIndex)
			var pokemon/boxMon = boxData.boxList[indexX][indexY]
			var pokemon/partyMon = owner.party[partyIndex]
			boxData.boxList[indexX][indexY] = partyMon
			owner.party[partyIndex] = boxMon
		closePC()
			#ifdef OLD_PC_SYSTEM
			var savefile/F = new
			if(fexists("Boxes/Box [currentBox]/[ckeyEx(owner.key)].esav"))
				fdel("Boxes/Box [currentBox]/[ckeyEx(owner.key)].esav")
			boxData.Write(F)
			text2file(RC5_Encrypt(F.ExportText("/"),md5("martin")),"Boxes/Box [currentBox]/[ckeyEx(owner.key)].esav")
			#else
			boxData.saveBox(owner,currentBox)
			#endif
			boxData = null

boxSaveProxy
	New(computer/thePC)
		linkedPC = thePC
	var
		partyMon/boxList[10][10]
		computer/linkedPC
	#ifndef OLD_PC_SYSTEM
	proc
		saveBox(player/P,box)
			set waitfor = 0
			set background = 1
			var partyMon/S
			var savefile/F
			for(var/x in 1 to 10)
				for(var/y in 1 to 10)
					S = boxList[x][y]
					if(isnull(S))
						linkedPC.clearSlot(box,x,y)
					else
						linkedPC.clearSlot(box,x,y)
						F = new
						F["pokemon"] << S
						text2file(RC5_Encrypt(F.ExportText("/"),md5("Box123")),"Boxes/Box [box]/[P.ckey]/slot [x] [y].eboxslot")
		loadBox(player/P,box)
			var partyMon/S
			var savefile/F
			for(var/x in 1 to 10)
				for(var/y in 1 to 10)
					if(linkedPC.checkSlot(box,x,y))
						F = new
						F.ImportText("/",RC5_Decrypt(file2text("Boxes/Box [box]/[P.ckey]/slot [x] [y].eboxslot"),md5("Box123")))
						F["pokemon"] >> S
						S.owner = P
						if(istype(S,/pokemon))
							var pokemon/X = S
							X.reload(P,TRUE)
						boxList[x][y] = S
	#else
	Read(savefile/F,player/PL)
		for(var/x in 1 to 10)
			for(var/y in 1 to 10)
				var pokemon/S = boxList[x][y]
				if(isnull(S))continue
				S.owner = PL
				if(istype(S,/Egg))continue
				S.reload(PL,TRUE)
	#endif