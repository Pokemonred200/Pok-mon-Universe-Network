var itemsList[0]

owItem
	parent_type = /obj
	icon = 'Item Overworlds.dmi'
	icon_state = "Regular"
	New()
		. = ..()
		itemsList += src
		if(istext(theItemType))
			theItemType = text2path(theItemType)
		theImage = image('Item Overworlds.dmi',src,"Regular")
		theImage.override = TRUE
		src.icon = null
		src.icon_state = ""
		Load()
	Del()
		itemsList -= src
		Save()
		. = ..()
	var
		players_pickedup[0]
		tmp
			image/theImage
		theItemType
	proc
		Save()
			fdel("World Objects/Overworld Items/Item Ball at [x] [y] [z].esav")
			var savefile/F = new
			src.Write(F)
			text2file(RC5_Encrypt(F.ExportText("/"),md5("overworld item")),"World Objects/Overworld Items/Item Ball at [x] [y] [z].esav")
		Load()
			if(!fexists("World Objects/Overworld Items/Item Ball at [x] [y] [z].esav"))return
			var savefile/F = new
			F.ImportText("/",RC5_Decrypt(file2text("World Objects/Overworld Items/Item Ball at [x] [y] [z].esav"),md5("overworld item")))
			src.Read(F)
	Cross(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			if("[ckeyEx(P.key)]" in players_pickedup)return TRUE
			else return FALSE
		else
			return ..()
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			if(!("[ckeyEx(P.key)]" in players_pickedup))
				if(ispath(theItemType))
					var item/I = new theItemType
					P.bag.addItem(theItemType)
					P.client.images -= src.theImage
					players_pickedup |= "[ckeyEx(P.key)]"
					if(!("Item Pickup" in P.client.Audio.sounds))
						P.client.Audio.addSound(sound('item_found.wav',channel=20),"Item Pickup")
					P.client.Audio.playSound("Item Pickup")
					var loweredData = lowertext("[I.name]")
					P.ShowText(replacetext("You have recieved \a [loweredData]!","[loweredData]","[I.name]"),bold=TRUE)

owTMPickup
	parent_type = /obj
	icon = 'Item Overworlds.dmi'
	icon_state = "TM/HM"
	New()
		. = ..()
		itemsList += src
		if(istext(theItemType))
			theItemType = text2path(theItemType)
		theImage = image('Item Overworlds.dmi',src,"TM/HM")
		theImage.override = TRUE
		src.icon = null
		src.icon_state = ""
		Load()
	Del()
		itemsList -= src
		Save()
		. = ..()
	var
		players_pickedup[0]
		tmp
			image/theImage
		theItemType
	proc
		Save()
			fdel("World Objects/Overworld Items/TM Item Ball at [x] [y] [z].esav")
			var savefile/F = new
			src.Write(F)
			text2file(RC5_Encrypt(F.ExportText("/"),md5("overworld item")),"World Objects/Overworld Items/TM Item Ball at [x] [y] [z].esav")
		Load()
			if(!fexists("World Objects/Overworld Items/TM Item Ball at [x] [y] [z].esav"))return
			var savefile/F = new
			F.ImportText("/",RC5_Decrypt(file2text("World Objects/Overworld Items/TM Item Ball at [x] [y] [z].esav"),md5("overworld item")))
			src.Read(F)
	Cross(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			if("[ckeyEx(P.key)]" in players_pickedup)return TRUE
			else return FALSE
		else
			return ..()
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			if(!("[ckeyEx(P.key)]" in players_pickedup))
				if(ispath(theItemType))
					var item/I = new theItemType
					P.bag.addItem(theItemType)
					P.client.images -= src.theImage
					players_pickedup |= "[ckeyEx(P.key)]"
					if(!("TM Pickup" in P.client.Audio.sounds))
						P.client.Audio.addSound(sound('tm_get.wav',channel=20),"TM Pickup")
					P.client.Audio.playSound("TM Pickup")
					var loweredData = lowertext("[I.name]")
					P.ShowText(replacetext("You have recieved \a [loweredData]!","[loweredData]","[I.name]"),bold=TRUE)

hiddenItem
	parent_type = /obj
	New()
		..()
		itemsList += src
		if(istext(theItemType))
			theItemType = text2path(theItemType)
		Load()
	Del()
		Save()
		..()
	var
		players_pickedup[0]
		theItemType
	proc
		Save()
			fdel("World Objects/Overworld Items/Hidden Item at [x] [y] [z].esav")
			var savefile/F = new
			src.Write(F)
			text2file(RC5_Encrypt(F.ExportText("/"),md5("hidden item")),"World Objects/Overworld Items/Hidden Item at [x] [y] [z].esav")
		Load()
			if(!fexists("World Objects/Overworld Items/Hidden Item at [x] [y] [z].esav"))return
			var savefile/F = new
			F.ImportText("/",RC5_Decrypt(file2text("World Objects/Overworld Items/Hidden Item at [x] [y] [z].esav"),md5("hidden item")))
			src.Read(F)
	Interact(atom/movable/O)
		if(istype(O,/player))
			var player/P = O
			if(!("[ckeyEx(P.key)]" in players_pickedup))
				if(ispath(theItemType))
					var item/I = new theItemType
					P.bag.addItem(theItemType)
					players_pickedup |= "[ckeyEx(P.key)]"
					if(!("Item Pickup" in P.client.Audio.sounds))
						P.client.Audio.addSound(sound('item_found.wav',channel=20),"Item Pickup")
					P.client.Audio.playSound("Item Pickup")
					var loweredData = lowertext("[I.name]")
					P.ShowText(replacetext("You have recieved \a [loweredData]!","[loweredData]","[I.name]"),bold=TRUE)