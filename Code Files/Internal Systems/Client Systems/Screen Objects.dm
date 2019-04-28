screen
	parent_type = /atom/movable
	plane = HUD_PLANE
	battleIcon
	MajorButton
		MouseEntered()
			animate(src, transform = matrix()*1.2, alpha = 240, time = 5, easing = SINE_EASING)
		MouseExited()
			animate(src, transform = null, alpha = 255, time = 5, easing = SINE_EASING)
		NewButton
			icon = 'New.png'
			screen_loc = "1:64,1:320"
			Click()
				var player/P = usr
				if(P.playerFlags & DID_MENU_STUFF)return
				P.playerFlags |= DID_MENU_STUFF
				P.FileNew()
		LoadButton
			icon = 'Load.png'
			screen_loc = "1:64,1:224"
			Click()
				var player/P = usr
				if(P.playerFlags & DID_MENU_STUFF)return
				P.playerFlags |= DID_MENU_STUFF
				P.FileLoad()
		DeleteButton
			icon = 'Delete.png'
			screen_loc = "1:64,1:128"
			Click()
				var player/P = usr
				if(P.playerFlags & DID_MENU_STUFF)return
				P.playerFlags |= DID_MENU_STUFF
				P.FileDelete()
		BoyButton
			icon = 'Gender.dmi'
			icon_state = "Boy"
			screen_loc = "1:256,1:192"
			Click()
				var player/P = usr
				var screen/MajorButton/GirlButton/G = locate() in P.client.screen
				P.TmpGender = "Boy"
				P.client.screen.Remove(G,src)
		GirlButton
			icon = 'Gender.dmi'
			icon_state = "Girl"
			screen_loc = "1:512,1:192"
			Click()
				var player/P = usr
				var screen/MajorButton/BoyButton/B = locate() in P.client.screen
				P.TmpGender = "Girl"
				P.client.screen.Remove(B,src)

screen_fade
	parent_type = /atom/movable
	icon =	'Screen Fade Effects.dmi'
	screen_loc = "SOUTHEAST to NORTHWEST"
	plane = HUD_PLANE
	layer = FLY_LAYER + 2

	screen_fade_out/icon_state = "Screen Fade Out"

	screen_fade_in/icon_state = "Screen Fade In"

background
	parent_type = /atom/movable
	plane = HUD_PLANE
	screen_loc = "1,1"

screen
	lighting_plane
		plane = 3
		screen_loc = "1,1"
		blend_mode = BLEND_MULTIPLY
		appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR
		mouse_opacity = 0
		color = list(null,null,null,null,"#000f")

image
	flashlight
		var flashed = FALSE
		plane = 3
		icon = 'Flash Spotlight.dmi'
		blend_mode = BLEND_ADD
		pixel_x = -32
		pixel_y = -32

player
	proc
		ScreenFade(fadeType)
			var/screen_fade/IO
			switch(fadeType)
				if("In")
					IO = new/screen_fade/screen_fade_in
				if("Out")
					IO = new/screen_fade/screen_fade_out
			src.client.screen.Add(IO)
			sleep(20)
			src.client.screen.Remove(IO)

HPBar
	parent_type = /obj
	#ifdef USE_OLD
	var HP_thing/pixels[0]
	#else
	var HP_thing/hpBar
	#endif
	var ScrNumber/number
	layer = 11
	plane = HUD_PLANE
	var client/clients[]
	var pokemon/P
	var ScrGender/SCG
	var ScrText/sname
	var ScrStatus/status
	New(pokemon/PK,client/CS[])
		if(isnull(PK) || isnull(CS))return
		. = ..()
		src.loc = null
		src.clients = CS
		src.P = PK
		SCG = new(P)
		#ifndef USE_OLD
		hpBar = new /HP_thing
		#endif
		for(var/client/C in clients)
			C.screen += src
			C.screen += SCG
	Del()
		if(!isnull(number))
			number.Unsync()
		if(!isnull(sname))
			sname.Unsync()
		if(!isnull(status))
			status.Unsync()
		for(var/client/C in clients)
			C.screen -= src
			#ifdef USE_OLD
			C.screen -= pixels
			#else
			C.screen -= hpBar
			C.screen -= SCG
			#endif
			..()
	proc
		updateBar()
		changePKMN(pokemon/PK)
			src.P = PK
			SCG.ChangeAtom(PK)
			sname.Unsync()
			number.Unsync()
			status.Unsync()
			sname.ChangeText(PK.name)
			number.ChangeNum(PK.level)
			status.ChangePKMN(PK)
			sname.Sync()
			number.Sync()
			updateBar()
		addClient(client/C)
			if(C in clients)return
			src.clients += C
			C.screen += src
			#ifdef USE_OLD
			C.screen += src.pixels
			#else
			C.screen += src.hpBar
			#endif

HPBarPlayer
	parent_type = /HPBar
	icon = 'HP Player Bar.dmi'
	icon_state = "HP Bar"
	screen_loc = "15,5:13"
	var
		expPixels[0]
		ScrNumber/curHP
		ScrNumber/MaxHP
	addClient(client/C)
		if(C in clients)return
		. = ..()
		C.screen += src.expPixels
	changePKMN(pokemon/PK)
		MaxHP.Unsync()
		MaxHP.ChangeNum(P.maxHP)
		MaxHP.Sync()

		curHP.Unsync()
		curHP.ChangeNum(P.HP)
		curHP.Sync()
		. = ..()
	New(pokemon/PK,client/C[])
		if(isnull(PK) || isnull(C))return
		. = ..(PK,C)
		SCG.screen_loc = "22:15,7:5"
		number = new(PK.level,C,"21:25,7:9")
		number.Sync()
		MaxHP = new(PK.maxHP,C,"21:28,6")
		MaxHP.Sync()
		curHP = new(PK.HP,C,"19:27,6")
		curHP.Sync()
		status = new(PK,C,"17:8,6:13")
		var pname
		switch(P.pName)
			if("Nidoran-M")
				if(P.name == P.pName)
					pname = "Nidoran%"
				else
					pname = PK.name
			if("Nidoran-F")
				if(P.name == P.pName)
					pname = "Nidoran^"
				else
					pname = PK.name
			else
				pname = PK.name
		sname = new(pname,C,15,"19:15,7:10")
		sname.Sync()
		#ifndef USE_OLD
		hpBar.screen_loc = "19:16,6:19"
		#endif
	Del()
		MaxHP.Unsync()
		curHP.Unsync()
		number.Unsync()
		for(var/client/C in src.clients)
			C.screen -= expPixels
		. = ..()
	updateBar()
		MaxHP.Unsync()
		MaxHP.ChangeNum(P.maxHP)
		MaxHP.Sync()

		curHP.Unsync()
		curHP.ChangeNum(P.HP)
		curHP.Sync()

		number.Unsync()
		number.ChangeNum(P.level)
		number.Sync()

		status.Unsync()
		status.UpdateStatus()
		status.Sync()

		for(var/client/C in src.clients)
			C.screen |= src
			#ifdef USE_OLD
			C.screen -= pixels
			C.screen -= expPixels
			#else
			C.screen -= hpBar
			C.screen -= expPixels
			#endif
		var
			total = min(round((P.HP/P.maxHP)*100),100)
			info1 = getRequiredExp(P.expGroup,P.level+1)-getRequiredExp(P.expGroup,P.level)
			info2 = P.exp - getRequiredExp(P.expGroup,P.level)
			expTotal = min((info2 / info1)*100,100)
			barColor
		if(total > 50)barColor = "Green"
		else if(total > 20)barColor = "Yellow"
		else barColor = "Red"
		#ifdef USE_OLD
		var HP_thing/newpixels[total]
		for(var/x in 1 to total)
			var HP_thing/H = new /HP_thing
			H.icon_state = barColor
			H.screen_loc = "19:[15+x],6:19"
			newpixels[x] = H
		var newExpPixels[expTotal*2]
		for(var/x in 1 to length(newExpPixels))
			var HP_thing/E1 = new /HP_thing
			E1.icon_state = "Blue"
			E1.screen_loc = "16:[15+x],5:19"
			newExpPixels[x] = E1
		expPixels = newExpPixels
		pixels = newpixels
		for(var/client/C in src.clients)
			C.screen += pixels
			C.screen += expPixels
		#else
		hpBar.icon_state = barColor
		var matrix/M = matrix()
		M.Scale(total,1)
		M.Translate(floor(total/2),0)
		hpBar.transform = M
		var newExpPixels[expTotal*2]
		for(var/x in 1 to length(newExpPixels))
			var HP_thing/E1 = new /HP_thing
			E1.icon_state = "Blue"
			E1.screen_loc = "16:[15+x],5:19"
			newExpPixels[x] = E1
		expPixels = newExpPixels
		M = matrix()
		//M.Scale(expTotal*2,1)
		//M.Translate(floor(expTotal/2),0)
		//expBar.transform = M
		for(var/client/C in src.clients)
			//C.screen += expBar
			C.screen += hpBar
			C.screen += expPixels
		#endif

HPBarEnem
	parent_type = /HPBar
	icon = 'HP Bar.dmi'
	icon_state = "HBP"
	screen_loc = "NORTHWEST"
	New(pokemon/PK,client/C[])
		if(isnull(PK)||isnull(C))return
		var matrix/M = matrix()
		M.Translate(0,-90)
		src.transform = M
		. = ..(PK,C)
		number = new(PK.level,C)
		number.Sync()
		var pname
		switch(P.pName)
			if("Nidoran-M")
				if(P.name == P.pName)
					pname = "Nidoran%"
				else
					pname = PK.name
			if("Nidoran-F")
				if(P.name == P.pName)
					pname = "Nidoran^"
				else
					pname = PK.name
			else
				pname = PK.name
		sname = new(pname,C,15,"4:23,14:11")
		sname.Sync()
		status = new(P,C,"2:1,13:20")
		SCG.screen_loc = "7:7,14:10"
		#ifndef USE_OLD
		hpBar.screen_loc = "4:4,13:22"
		#endif

	updateBar()
		for(var/client/C in src.clients)
			C.screen += src
			#ifdef USE_OLD
			C.screen -= pixels
			#else
			C.screen -= hpBar
			#endif
		status.Unsync()
		status.UpdateStatus()
		status.Sync()
		var
			total = min(round((P.HP/P.maxHP)*100),100)
			barColor

		if(total > 50)barColor = "Green"
		else if(total > 20)barColor = "Yellow"
		else barColor = "Red"

		#ifdef USE_OLD
		var HP_thing/newpixels[total]
		for(var/x in 1 to total)
			var HP_thing/H = new /HP_thing
			H.icon_state = barColor
			H.screen_loc = "4:[3+x],13:22"
			newpixels[x] = H
		pixels = newpixels
		for(var/client/C in src.clients)
			C.screen += pixels
		#else
		hpBar.icon_state = barColor
		var matrix/M = matrix()
		M.Scale(total,1)
		M.Translate(floor(total/2),0)
		hpBar.transform = M
		for(var/client/C in src.clients)
			C.screen += hpBar
		#endif


ScrStatus
	parent_type = /obj
	plane = HUD_PLANE
	var client/clients[]
	layer = 12
	var pokemon/P
	icon = 'status.dmi'
	New(pokemon/PK,client/C[],pos="17:8,6:13")
		src.loc = null
		clients = C
		src.screen_loc = pos
		ChangePKMN(PK)
	proc
		ChangePKMN(PKMN)
			P = PKMN
			UpdateStatus()
		Sync()
			for(var/client/C in clients)
				C.screen += src
		Unsync()
			for(var/client/C in clients)
				C.screen -= src
		UpdateStatus()
			switch(P.status)
				if(POISONED)
					icon_state = "Poison"
				if(BAD_POISON)
					icon_state = "Bad Poison"
				if(BURNED)
					icon_state = "Burn"
				if(ASLEEP)
					icon_state = "Sleep"
				if(FAINTED)
					icon_state = "Faint"
				if(FROZEN)
					icon_state = "Freeze"
				if(PARALYZED)
					icon_state = "Paralyze"
				else
					icon_state = ""

ScrNumber
	var startpos = "6:24,14:12"
	var SNum/theData[0]
	var client/clients[0]
	var minNum
	New(number,client/C[],startpos="6:24,14:12",min_num=1)
		src.startpos = startpos
		clients = C
		src.minNum = min_num
		ChangeNum(number)
	Del()
		src.Unsync()
		. = ..()
	proc
		addClient(client/C)
			clients += C
			C.screen += theData
		removeClient(client/C)
			if(C in clients)
				clients -= C
				C.screen -= theData
		ChangeNum(number)
			if(istext(number))
				number = text2num(number)
			else if(isnull(number))
				number = 0
			number = reverse(num2text(abs(number)))
			var numlen = length(number)
			while(numlen<minNum)
				++numlen
				number = "[number]0"
			if(theData.len==0)
				theData.len = numlen
				for(var/i in 1 to numlen)
					theData[i] = generateNewNumber(copytext(number,i,i+1),i)
				src.Sync()
			else if(theData.len>numlen)
				for(var/i in (numlen+1) to theData.len)
					for(var/client/C in clients)
						C.screen -= theData[i]
				theData.len = numlen
				for(var/i in 1 to theData.len)
					var SNum/S = theData[i]
					S.icon_state = copytext(number,i,i+1)
			else if(theData.len==numlen)
				for(var/i in 1 to theData.len)
					var SNum/S = theData[i]
					S.icon_state = copytext(number,i,i+1)
			else
				var oldlen = theData.len
				theData.len = numlen
				for(var/i in (oldlen+1) to numlen)
					theData[i] = generateNewNumber(copytext(number,i,i+1),i)
					for(var/client/C in clients)
						C.screen += theData[i]
				for(var/i in 1 to oldlen)
					var SLet/S = theData[i]
					S.icon_state = copytext(number,i,i+1)
		generateNewNumber(number,index)
			var matrix/M = matrix()
			M.Translate((-15*index)+16,-5)
			return new /SNum(number,startpos,M)
		Sync()
			for(var/client/C in clients)
				C.screen += theData
		Unsync()
			for(var/client/C in clients)
				C.screen -= theData

SNum
	parent_type = /obj
	icon = 'Numbers.dmi'
	icon_state = "0"
	layer = 12
	plane = HUD_PLANE
	New(state,sloc,matrix)
		loc = null
		icon_state = state
		screen_loc = sloc
		transform = matrix

ScrText
	var limit = 15
	var startpos = "19:15,7:10"
	var client/clients[0]
	var SLet/theData[0]
	var inSync = FALSE
	New(text,client/C[],limit=15,startpos="19:15,7:10")
		src.startpos = startpos
		src.limit = limit
		src.clients = C
		ChangeText(text)
		src.Sync()
	Del()
		src.Unsync()
		. = ..()
	proc
		addClient(client/C)
			clients += C
			C.screen += theData
		removeClient(client/C)
			clients -= C
			C.screen -= theData
		ChangeText(text)
			text = reverse(copytext(text,1,limit+1))
			var textlen = length(text)
			if(theData.len==0)
				theData.len = textlen
				for(var/i in 1 to textlen)
					theData[i] = generateNewLetter(copytext(text,i,i+1),i)
				src.Sync()
			else if(theData.len>textlen)
				for(var/i in (textlen+1) to theData.len)
					for(var/client/C in clients)
						C.screen -= theData[i]
				theData.len = textlen
				for(var/i in 1 to theData.len)
					var SLet/S = theData[i]
					S.icon_state = copytext(text,i,i+1)
			else if(theData.len==textlen)
				for(var/i in 1 to theData.len)
					var SLet/S = theData[i]
					S.icon_state = copytext(text,i,i+1)
			else
				var oldlen = theData.len
				theData.len = textlen
				for(var/i in (oldlen+1) to textlen)
					theData[i] = generateNewLetter(copytext(text,i,i+1),i)
					for(var/client/C in clients)
						C.screen += theData[i]
				for(var/i in 1 to oldlen)
					var SLet/S = theData[i]
					S.icon_state = copytext(text,i,i+1)
			for(var/x in 1 to theData.len)
				var SLet/S = theData[x]
				var matrix/M = matrix()
				M.Translate((-12*x)+16,-5)
				if(S.icon_state in list("y","j","q","p","g"))
					M.Translate(0,-4)
				S.transform = M
		generateNewLetter(letter,index)return new /SLet(letter,startpos,matrix(),3)
		Sync()
			inSync = TRUE
			for(var/client/C in clients)
				C.screen += theData
		Unsync()
			inSync = FALSE
			for(var/client/C in clients)
				C.screen -= theData

SLet
	parent_type = /obj
	icon = 'font2.dmi'
	icon_state = "A"
	plane = HUD_PLANE
	layer = 12
	New(state,sloc,matrix,font="2")
		loc = null
		font = "[font]"
		if(font=="3")
			font = 'font3.dmi'
		else
			font = 'font2.dmi'
		screen_loc = sloc
		transform = matrix
		icon = font
		icon_state = state

ScrGender
	parent_type = /obj
	plane = HUD_PLANE
	layer = 12
	icon = 'Genders.dmi'
	icon_state = "Male"
	proc
		ChangeAtom(atom/movable/O)
			if(istype(O,/pokemon))
				var pokemon/P = O
				if(P.pName in list("Nidoran-M","Nidoran-F"))
					if(P.name == P.pName)
						icon_state = ""
						return
			switch(O.gender)
				if(MALE)
					icon_state = "Male"
				if(FEMALE)
					icon_state = "Female"
				else
					icon_state = ""
	New(atom/movable/O)
		src.loc = null
		ChangeAtom(O)

HP_thing
	parent_type = /atom/movable
	layer = 12
	plane = HUD_PLANE
	icon = 'HP Thing.dmi'