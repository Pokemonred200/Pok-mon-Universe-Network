/* Red (Pokemonred200) (With credit to Forum_Account)*/

var
	ScrNumber
		displayHour = new("",list(),"20,14:27")
		displayMinute = new("",list(),"21:12,14:27",2)
	ScrText
		displayAPM = new("",list(),2,"22:13,14:27")

proc
	updateClock()
		set background = 1
		set waitfor = 0
		for(ever)
			var hour = text2num(gameTime.Hour())
			var AP
			if(hour == 0)
				hour = 12
				AP = "AM"
			else if(hour > 12)
				hour -= 12
				AP = "PM"
			else if(hour == 12)
				AP = "PM"
			else
				AP = "AM"

			displayHour.ChangeNum(hour)
			displayMinute.ChangeNum(text2num(gameTime.Minute()))
			displayAPM.ChangeText(AP)
			sleep TICK_LAG*60

client
	var audiohandler/Audio
	var Label/moneyLabel
	North()
	South()
	East()
	West()
	Northeast()
	Southeast()
	Northwest()
	Southwest()
	New()
		if(isnull(gameTime))
			gameTime = new /BaseCamp/Calendar(-4)
			gameTime.setTimeSpeed(4)
		src.Audio = new
		src.movement_loop()
		displayHour.addClient(src)
		displayMinute.addClient(src)
		displayAPM.addClient(src)
		..()
		src.Audio.owner = src.mob
		winset(src,"bar1","value=10");
		changeVolume()
	proc
		movement_loop()
			set waitfor = 0
			set background = 1
			for(ever)
				movement()
				sleep TICK_LAG
		movement()
			var dir = 0
			var player/P = src.mob
			if(isnull(P))return
			if((P.playerFlags & IN_LOGIN) || (P.playerFlags & IN_BATTLE) || (P.ContinueText!=0) || (src.clientFlags & LOCK_MOVEMENT) )
				if((P.savedPlayerFlags & BIKING) && (P.active_costume.costume_state != COSTUME_BIKE_IDLE))
					P.active_costume.costume_state = COSTUME_BIKE_IDLE
					P.sprite.icon = P.active_costume.bike_idle
				else if((!(P.savedPlayerFlags & BIKING)) && (P.active_costume.costume_state != COSTUME_WALKING))
					P.active_costume.costume_state = COSTUME_WALKING
					P.sprite.icon = icon(P.active_costume.icon,P.active_costume.icon_state)
				return
			if(keys["w"]||keys["north"])dir |= NORTH
			if(keys["s"]||keys["south"])dir |= SOUTH
			if(keys["a"]||keys["west"])dir |= WEST
			if(keys["d"]||keys["east"])dir |= EAST

			if(!keys["x"])
				if(dir)
					step(P,dir)
					if((keys["b"]) && (!isnull(P.active_costume.running_image)))
						if(P.active_costume.costume_state != COSTUME_RUNNING)
							P.active_costume.costume_state = COSTUME_RUNNING
							P.sprite.icon = P.active_costume.running_image
							P.sprite.icon_state = ""
					else
						if(P.active_costume.costume_state != COSTUME_WALKING)
							P.active_costume.costume_state = COSTUME_WALKING
							P.sprite.icon = P.active_costume.icon
							P.sprite.icon_state = P.active_costume.icon_state
				else if(P.savedPlayerFlags & BIKING)
					if(P.active_costume.bike_image)
						if(P.active_costume.costume_state != COSTUME_BIKE_IDLE)
							P.active_costume.costume_state = COSTUME_BIKE_IDLE
							P.sprite.icon = P.active_costume.bike_idle
							P.sprite.icon_state = ""
					else
						P.savedPlayerFlags &= ~BIKING
						if(P.active_costume.costume_state != COSTUME_WALKING)
							P.active_costume.costume_state = COSTUME_WALKING
							P.sprite.icon = P.active_costume.icon
							P.sprite.icon_state = P.active_costume.icon_state
				else
					if(P.active_costume.costume_state != COSTUME_WALKING)
						P.active_costume.costume_state = COSTUME_WALKING
						P.sprite.icon = P.active_costume.icon
						P.sprite.icon_state = P.active_costume.icon_state
			else
				P.dir = dir

			if(!(P.savedPlayerFlags & BIKING))
				if(!(keys["b"]))
					P.move_delay = 0.75
				else
					P.move_delay = 0.5
			else
				if(dir)
					if(P.active_costume.bike_image)
						if(P.active_costume.costume_state != COSTUME_BIKE_MOVING)
							P.active_costume.costume_state = COSTUME_BIKE_MOVING
							P.sprite.icon = P.active_costume.bike_image
							P.sprite.icon_state = ""
					else
						if(P.active_costume.costume_state != COSTUME_WALKING)
							P.active_costume.costume_state = COSTUME_WALKING
							P.sprite.icon = P.active_costume.icon
							P.sprite.icon_state = P.active_costume.icon_state
						P.savedPlayerFlags &= ~BIKING
						if(!(keys["b"]))
							P.move_delay = 0.75
						else
							P.move_delay = 0.5
				else
					if(P.active_costume.bike_idle)
						if(P.active_costume.costume_state != COSTUME_BIKE_IDLE)
							P.active_costume.costume_state = COSTUME_BIKE_IDLE
							P.sprite.icon = P.active_costume.bike_idle
							P.sprite.icon_state = ""
					else
						if(P.active_costume.costume_state != COSTUME_WALKING)
							P.active_costume.costume_state = COSTUME_WALKING
							P.sprite.icon = P.active_costume.icon
							P.sprite.icon_state = P.active_costume.icon_state
						P.savedPlayerFlags &= ~BIKING
				if(!(P.savedPlayerFlags & MACH))P.move_delay = 0.25
				else P.move_delay = 0
			if(P.walker)
				P.walker.move_delay = P.move_delay
			sleep P.move_delay