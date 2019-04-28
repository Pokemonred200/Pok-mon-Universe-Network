atom
	movable
		var exit_target = ""
		var just_teleported = FALSE

turf
	portal
		plane = -100
		parent_type = /obj
		exit_portal
			Crossed(atom/movable/O)
				if(O.just_teleported == TRUE)return ..()
				var turf/T = locate("[O.exit_target]")
				if(!isnull(T))
					O.just_teleported = TRUE
					spawn(TICK_LAG) O.just_teleported = FALSE
					if(istype(T,/atom/movable))
						T = T.loc
					O.Move(T)
					O.exit_target = ""
					if(istype(O,/player))
						var player/P = O
						P.client.Audio.addSound(sound('enter.wav',channel=15),"ENTER PLACE",TRUE)
				else
					src << "The exit could not be found. Teleporting back to Player House."
					O.Move(locate("HouseRespawn"))
				. = ..()
		enter_portal
			var target_tag = ""
			Crossed(atom/movable/O)
				if(O.just_teleported == TRUE)return ..()
				if(O.atomMovFlags & LAST_TILE_TELEPORT)return ..()
				var turf/T = locate("[src.target_tag]")
				if(istype(T,/atom/movable))
					T = T.loc
				if(!isnull(T))
					O.just_teleported = TRUE
					O.atomMovFlags |= LAST_TILE_TELEPORT
					spawn(TICK_LAG) O.just_teleported = FALSE
					if("[src.target_tag]"=="CenterEnter2")
						if(istype(O,/player))
							var player/P = O
							var turf/RP = P.loc
							RP = locate(RP.x,RP.y-1,RP.z)
							P.respawnpoint = RP
					O.Move(T)
					O.exit_target = src.tag
					if(istype(O,/player))
						var player/P = O
						P.client.Audio.addSound(sound('enter.wav',channel=15),"ENTER PLACE",TRUE)
				. = ..()