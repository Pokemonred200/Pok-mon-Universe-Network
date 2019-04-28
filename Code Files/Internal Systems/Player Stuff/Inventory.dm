/* Group Project, I guess. Red (Pokemonred200). Help appreciated here. */

inventory
	var
		item/key/keyItems[0]
		item/normal/mainItems[0]
		item/pokeball/pokeballs[0]
		item/battle/battleItems[0]
		item/berry/berries[0]
		item/medicine/medicine[0]
		item/tm/tmList[0]
	proc
		addItem(tItem,count=1)
			var item/theItem
			if(ispath(tItem,/item/normal))
				if(!(locate(tItem) in mainItems))
					mainItems += new tItem
					theItem = mainItems[length(mainItems)]
				else
					var item/normal/I = locate(tItem) in mainItems
					I.itemstack += count
			else if(ispath(tItem,/item/medicine))
				if(!(locate(tItem) in medicine))
					medicine += new tItem
					theItem = mainItems[length(mainItems)]
				else
					var item/medicine/I = locate(tItem) in medicine
					I.itemstack += count
			else if(ispath(tItem,/item/key))
				if(!(locate(tItem) in keyItems))
					keyItems += new tItem
			else if(ispath(tItem,/item/tm))
				if(ispath(tItem,/item/tm/permanent) || ispath(tItem,/item/tm/hm))
					if(!(locate(tItem) in tmList))
						var item/I = new tItem
						I.itemstack = 1
						tmList += I
				else if(ispath(tItem,/item/tm/disposable))
					if(!(locate(tItem) in tmList))
						tmList += new tItem
						theItem = tmList[length(tmList)]
					else
						var item/tm/disposable/I = locate(tItem)
						I.itemstack += count
			else if(ispath(tItem,/item/pokeball))
				if(!(locate(tItem) in pokeballs))
					pokeballs += new tItem
					theItem = pokeballs[length(pokeballs)]
				else
					var item/pokeball/I = locate(tItem) in pokeballs
					I.itemstack += count
			else if(ispath(tItem,/item/battle))
				if(!(locate(tItem) in battleItems))
					battleItems += new tItem
					theItem = battleItems[length(battleItems)]
				else
					var item/battle/I = locate(tItem) in battleItems
					I.itemstack += count
			else if(ispath(tItem,/item/berry))
				if(!(locate(tItem) in berries))
					berries += new tItem
					theItem = berries[length(berries)]
				else
					var item/berry/I = locate(tItem) in berries
					I.itemstack += count
			else if(ispath(tItem,/item/apricorn))
				var temp = src.hasItem(/item/key/Apricorn_Box)
				if(!temp)
					src.addItem(/item/key/Apricorn_Box)
					temp = src.hasItem(/item/key/Apricorn_Box)
				var item/key/Apricorn_Box/box = src.hasItem(/item/key/Apricorn_Box)
				if(!(locate(tItem) in box.apricorns))
					box.apricorns += new tItem
					theItem = box.apricorns[length(box.apricorns)]
				else
					var item/apricorn/I = locate(tItem) in box.apricorns
					I.itemstack += count
			else if(istype(tItem,/item)) // actual item type
				.(tItem:type)
			if(theItem)
				theItem.itemstack = count
		hasItem(tItem)
			if(ispath(tItem,/item/normal))
				return locate(tItem) in mainItems
			else if(ispath(tItem,/item/medicine))
				return locate(tItem) in medicine
			else if(ispath(tItem,/item/key))
				return locate(tItem) in keyItems
			else if(ispath(tItem,/item/pokeball))
				return locate(tItem) in pokeballs
			else if(ispath(tItem,/item/battle))
				return locate(tItem) in battleItems
			else if(ispath(tItem,/item/berry))
				return locate(tItem) in berries
			else if(ispath(tItem,/item/tm))
				return locate(tItem) in tmList
			else if(ispath(tItem,/item/apricorn))
				if(!src.hasItem(/item/key/Apricorn_Box))return null
				var item/key/Apricorn_Box/box = src.hasItem(/item/key/Apricorn_Box)
				return locate(tItem) in box.apricorns
			else if(istype(tItem,/item))
				return .(tItem:type)
		removeItem(tItem,amount=1) // removes an amount of a certain items from the player's inventory.
			var item/I
			var originalAmount
			. = 0 // this proc returns the amount of (tItem) that was actually removed. This should usually equal (amount).
			if(ispath(tItem,/item/normal))
				I = locate(tItem) in mainItems
				if(I)
					originalAmount = I.itemstack
					I.itemstack = max(I.itemstack-amount,0)
					. = originalAmount - I.itemstack
					if(I.itemstack==0)
						mainItems -= I
			else if(ispath(tItem,/item/medicine))
				I = locate(tItem) in medicine
				if(I)
					originalAmount = I.itemstack
					I.itemstack = max(I.itemstack-amount,0)
					. = originalAmount - I.itemstack
					if(I.itemstack==0)
						medicine -= I
			else if(ispath(tItem,/item/key))
				I = locate(tItem) in keyItems
				if(I)
					. = 1
					keyItems -= I
			else if(ispath(tItem,/item/tm/disposable))
				I = locate(tItem) in tmList
				if(I)
					originalAmount = I.itemstack
					I.itemstack = max(I.itemstack-amount,0)
					. = originalAmount - I.itemstack
					if(I.itemstack==0)
						tmList -= I
			else if(ispath(tItem,/item/pokeball))
				I = locate(tItem) in pokeballs
				if(I)
					originalAmount = I.itemstack
					I.itemstack = max(I.itemstack-amount,0)
					. = originalAmount - I.itemstack
					if(I.itemstack==0)
						pokeballs -= I
			else if(ispath(tItem,/item/battle))
				I = locate(tItem) in battleItems
				if(I)
					originalAmount = I.itemstack
					I.itemstack = max(I.itemstack-amount,0)
					. = originalAmount - I.itemstack
					if(I.itemstack==0)
						battleItems -= I
			else if(ispath(tItem,/item/berry))
				I = locate(tItem) in berries
				if(I)
					originalAmount = I.itemstack
					I.itemstack = max(I.itemstack-amount,0)
					. = originalAmount - I.itemstack
					if(I.itemstack==0)
						berries -= I
			else if(ispath(tItem,/item/apricorn))
				var temp = src.hasItem(/item/key/Apricorn_Box)
				if(!temp)return null
				else
					var item/key/Apricorn_Box/box = temp
					I = locate(tItem) in box.apricorns
					if(I)
						originalAmount = I.itemstack
						I.itemstack = max(I.itemstack-amount,0)
						. = originalAmount - I.itemstack
						if(I.itemstack==0)
							box.apricorns -= I
			else if(istype(tItem,/item))
				.(tItem:type)
		getItem(tItem)
			var item/I
			if(ispath(tItem,/item/normal))
				I = locate(tItem) in mainItems
				if(I)
					if((--I.itemstack) == 0)
						mainItems -= I
					return new I.type
				else
					return null
			else if(ispath(tItem,/item/medicine))
				I = locate(tItem) in medicine
				if(I)
					if((--I.itemstack) == 0)
						medicine -= I
					return new I.type
				else
					return null
			else if(ispath(tItem,/item/key))
				return locate(tItem) in keyItems
			else if(ispath(tItem,/item/tm))
				if(ispath(tItem,/item/tm/permanent) || ispath(tItem,/item/tm/hm))
					return locate(tItem) in tmList
				else if(ispath(tItem,/item/tm/disposable))
					I = locate(tItem) in tmList
					if(I)
						if((--I.itemstack)==0)
							tmList -= I
						return new I.type
					else
						return null
			else if(ispath(tItem,/item/pokeball))
				I = locate(tItem) in pokeballs
				if(I)
					if((--I.itemstack)==0)
						pokeballs -= I
					return new I.type
				else
					return null
			else if(ispath(tItem,/item/battle))
				I = locate(tItem) in battleItems
				if(I)
					if((--I.itemstack)==0)
						battleItems -= I
					return new I.type
				else
					return null
			else if(ispath(tItem,/item/berry))
				I = locate(tItem) in berries
				if(I)
					if((--I.itemstack)==0)
						berries -= I
					return new I.type
				else
					return null
			else if(ispath(tItem,/item/apricorn))
				if(!src.hasItem(/item/key/Apricorn_Box))return null
				var item/key/Apricorn_Box/box = src.hasItem(/item/key/Apricorn_Box)
				I = locate(tItem) in box.apricorns
				if(I)
					if((--I.itemstack)==0)
						box.apricorns -= I
					return new I.type
				else
					return null
			else if(istype(tItem,/item))
				return .(tItem:type)
		/*
		getItemStack(tItem,count=1) // used for selling items and converting multiple apricorns. if count = 1, this will call getItem().
			if(count==1)return getItem(tItem)
			if(ispath(tItem))
				var item/I
				if(ispath(tItem,/item/normal))
					I = new tItem
					var item/J = locate(tItem) in mainItems
					I.itemstack = min(count,J.itemstack)
					J.itemstack -= J.itemstack
					if(J.itemstack == 0)
						mainItems -= J
					return I
				else if(ispath(tItem,/item/key))
					return locate(tItem) in keyItems
				else if(ispath(tItem,/item
		*/

player
	verb
		togglebag()
			set hidden = 1
			var i = !(winget(src,"bagWindow","is-visible") == "true")
			if(i)
				updateBag()
			winshow(src,"bagWindow",i)
	proc
		updateApricorns()
			var item/key/Apricorn_Box/box = bag.hasItem(/item/key/Apricorn_Box)
			if(box)
				var
					item
						apricorn
							Red_Apricorn/red = locate(/item/apricorn/Red_Apricorn) in box.apricorns
							Blue_Apricorn/blue = locate(/item/apricorn/Blue_Apricorn) in box.apricorns
							Green_Apricorn/green = locate(/item/apricorn/Green_Apricorn) in box.apricorns
							Yellow_Apricorn/yellow = locate(/item/apricorn/Yellow_Apricorn) in box.apricorns
							Pink_Apricorn/pink = locate(/item/apricorn/Pink_Apricorn) in box.apricorns
							Orange_Apricorn/orange = locate(/item/apricorn/Orange_Apricorn) in box.apricorns
							Black_Apricorn/black = locate(/item/apricorn/Black_Apricorn) in box.apricorns
							White_Apricorn/white = locate(/item/apricorn/White_Apricorn) in box.apricorns

				world << "The apricorn box contains:"

				if(red)
					world << "[red.itemstack] [red]\s"
					winset(src,"apricornBox.redApricornTotal",list2params(list("text"=num2text(red.itemstack))))
				else
					winset(src,"apricornBox.redApricornTotal","text=0")

				if(blue)
					world << "[blue.itemstack] [blue]\s"
					winset(src,"apricornBox.blueApricornTotal",list2params(list("text"=num2text(blue.itemstack))))
				else
					winset(src,"apricornBox.blueApricornTotal","text=0")

				if(green)
					world << "[green.itemstack] [green]\s"
					winset(src,"apricornBox.greenApricornTotal",list2params(list("text"=num2text(green.itemstack))))
				else
					winset(src,"apricornBox.greenApricornTotal","text=0")

				if(yellow)
					world << "[yellow.itemstack] [yellow]\s"
					winset(src,"apricornBox.yellowApricornTotal",list2params(list("text"=num2text(yellow.itemstack))))
				else
					winset(src,"apricornBox.yellowApricornTotal","text=0")

				if(pink)
					world << "[pink.itemstack] [pink]\s"
					winset(src,"apricornBox.pinkApricornTotal",list2params(list("text"=num2text(pink.itemstack))))
				else
					winset(src,"apricornBox.pinkApricornTotal","text=0")

				if(orange)
					world << "[orange.itemstack] [orange]\s"
					winset(src,"apricornBox.orangeApricornTotal",list2params(list("text"=num2text(orange.itemstack))))
				else
					winset(src,"apricornBox.orangeApricornTotal","text=0")

				if(black)
					world << "[black.itemstack] [black]\s"
					winset(src,"apricornBox.blackApricornTotal",list2params(list("text"=num2text(black.itemstack))))
				else
					winset(src,"apricornBox.blackApricornTotal","text=0")

				if(white)
					world << "[white.itemstack] [white ]\s"
					winset(src,"apricornBox.whiteApricornTotal",list2params(list("text"=num2text(white.itemstack))))
				else
					winset(src,"apricornBox.whiteApricornTotal","text=0")
		updateBag()
			src << output(null,"items.itemGrid")
			src << output(null,"berries.berryGrid")
			src << output(null,"keyItems.keyItemGrid")
			src << output(null,"tms.tmGrid")
			src << output(null,"pokeballs.pokeballGrid")
			src << output(null,"medicine.medicineGrid")
			src << output(null,"battleItems.battleItemGrid")
			var Grid/G = new("items","itemGrid",src)
			var len = length(src.bag.mainItems)
			for(var/index in 1 to len)
				var item/normal/I = src.bag.mainItems[index]
				G.Cell(1,index,"\icon[I]")
				G.Cell(2,index,"[I]")
				G.Cell(3,index,"<a href='?src=\ref[I];action=use;tMob=\ref[src]'>Use</a>")
				G.Cell(4,index,"Count: [I.itemstack]")
				if(I.canHold)
					G.Cell(5,index,"<a href='?src=\ref[I];action=give;tMob=\ref[src]'>Give</a>")
				else
					G.Cell(5,index,"Cannot be held.")
			G.Cells(new/Size(5,len))
			len = length(src.bag.berries)
			G = new("berries","berryGrid",src)
			for(var/index in 1 to len)
				var item/berry/I = src.bag.berries[index]
				G.Cell(1,index,"\icon[I]")
				G.Cell(2,index,"[I]")
				G.Cell(3,index,"<a href='?src=\ref[I];action=use;tMob=\ref[src]'>Use</a>")
				G.Cell(4,index,"Count: [I.itemstack]")
				G.Cell(5,index,"<a href='?src=\ref[I];action=give;tMob=\ref[src]'>Give</a>")
			G.Cells(new/Size(5,len))
			len = length(src.bag.keyItems)
			G = new("keyItems","keyItemGrid",src)
			for(var/index in 1 to len)
				var item/key/I = src.bag.keyItems[index]
				G.Cell(1,index,"\icon[I]")
				G.Cell(2,index,"[I]")
				G.Cell(3,index,"<a href='?src=\ref[I];action=use;tMob=\ref[src]'>Use</a>")
				G.Cell(4,index,"<a href='?src=\ref[I];action=register;tMob=\ref[src]'>Register</a>")
			G.Cells(new/Size(4,len))
			G = new("medicine","medicineGrid",src)
			len = length(src.bag.medicine)
			for(var/index in 1 to len)
				var item/medicine/I = src.bag.medicine[index]
				G.Cell(1,index,"\icon[I]")
				G.Cell(2,index,"[I]")
				G.Cell(3,index,"<a href='?src=\ref[I];action=use;tMob=\ref[src]'>Use</a>")
				G.Cell(4,index,"Count: [I.itemstack]")
				if(I.canHold)
					G.Cell(5,index,"<a href='?src=\ref[I];action=give;tMob=\ref[src]'>Give</a>")
				else
					G.Cell(5,index,"Cannot be held")
			G.Cells(new/Size(5,len))
			G = new("battleItems","battleItemGrid",src)
			len = length(src.bag.battleItems)
			for(var/index in 1 to len)
				var item/battle/I = src.bag.battleItems[index]
				G.Cell(1,index,"\icon[I]")
				G.Cell(2,index,"[I]")
				G.Cell(3,index,"<a href='?src=\ref[I];action=use;tMob=\ref[src]'>Use</a>")
				G.Cell(4,index,"Count: [I.itemstack]")
				if(I.canHold)
					G.Cell(5,index,"<a href='?src=\ref[I];action=give;tMob=\ref[src]'>Give</a>")
				else
					G.Cell(5,index,"Cannot be Held")
			G.Cells(new/Size(5,len))
			len = length(src.bag.tmList)
			G = new("tms","tmGrid",src)
			for(var/index in 1 to len)
				var item/tm/I = src.bag.tmList[index]
				G.Cell(1,index,"\icon[I]")
				G.Cell(2,index,"[I]")
				G.Cell(3,index,"<a href='?src=\ref[I];action=use;tMob=\ref[src]'>Use</a>")
				if(I.canHold)
					G.Cell(4,index,"<a href='?src=\ref[I];acttion=give;tMob=\ref[src]'>Give</a>")
				else
					G.Cell(4,index,"Cannot be held.")
				if(istype(I,/item/tm/permanent) || istype(I,/item/tm/hm))
					G.Cell(5,index,"Count: 1")
				else
					G.Cell(5,index,"Count: [I.itemstack]")
			G.Cells(new/Size(5,len))
			len = length(src.bag.pokeballs)
			G = new("pokeballs","pokeballGrid",src)
			for(var/index in 1 to len)
				var item/pokeball/I = src.bag.pokeballs[index]
				G.Cell(1,index,"\icon[I]")
				G.Cell(2,index,"[I]")
				G.Cell(3,index,"Count: [I.itemstack]")
				G.Cell(4,index,"<a href='?src=\ref[I];action=give;tMob=\ref[src]'>Give</a>")
				if(src.client.battle)
					G.Cell(5,index,"<a href='?src=\ref[I];action=use;tMob=\ref[src]'>Use</a>")
			if(src.client.battle)
				G.Cells(new/Size(5,len))
			else
				G.Cells(new/Size(4,len))
