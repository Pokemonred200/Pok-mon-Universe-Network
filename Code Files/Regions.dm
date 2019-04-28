var bikingMusic = list(
	KANTO=list("Main"='FRLG Bike Theme.ogg',"Sounds"='RBGY Bike Theme.ogg'),
	HOENN=list("Main"='Bike Theme.ogg',"Sounds"='Bike Theme.ogg'),
	SEVII_ISLANDS=list("Main"='FRLG Bike Theme.ogg',"Sounds"='RBGY Bike Theme.ogg'))
var townRoutes[0]

proc
	updateMusic(player/P,area/Town_Route/R)
		if(P.client)
			var sound/S = P.client.Audio.sounds["123"]
			if(!(P.savedPlayerFlags & BIKING))
				if((P.savedPlayerFlags & GB_SOUNDS) && R.routeMusic8Bit)
					if((!S) || (S.file != R.routeMusic8Bit))
						P.client.Audio.addSound(music(R.routeMusic8Bit,repeat=1,channel=4),"123",autoplay=TRUE)
				else
					if((!S) || (S.file != R.routeMusic))
						P.client.Audio.addSound(music(R.routeMusic,repeat=1,channel=4),"123",autoplay=TRUE)
			else
				var whichOne = (P.savedPlayerFlags & GB_SOUNDS)?("Sounds"):("Main")
				var theSoundFile = bikingMusic[P.current_world_region][whichOne]
				if((!S) || (S.file != theSoundFile))
					P.client.Audio.addSound(music(theSoundFile,repeat=1,channel=4),"123",autoplay=TRUE)

area
	Town_Route
		//layer = FLY_LAYER
		New()
			..()
			layer = 8
			townRoutes += src
		Del()
			townRoutes -= src
			..()
		var
			routeMusic
			routeMusic8Bit
			route = ""
			outdoor = TRUE
			regionChange = TRUE
			worldRegion = "Hoenn"
			weather = ""
			weatherChange = TRUE
			flashHere = FALSE
			noBike = FALSE
		Entered(atom/movable/O)
			if(istype(O,/player))
				var player/P = O
				P.route = src.route
				var Label/R = new(P,"default","routeLabel")
				var displayRoute = src.route
				if(findtext(displayRoute,"Route 115")==1)
					displayRoute = "Route 115"
				else if(findtext(displayRoute,"Granite Cave")==1)
					displayRoute = "Granite Cave"
				if(regionChange)
					P.current_world_region = worldRegion
				R.Text("[displayRoute] ([P.current_world_region])")
				P.weatherOverlay.icon_state = weather
				P.weatherOverlay.alpha = 0
				animate(P.weatherOverlay,alpha = 255,time = 20)
				if(noBike)
					P.savedPlayerFlags &= ~BIKING
					P.savedPlayerFlags &= ~MACH
				if(flashHere)
					if(isnull(P.lightArea))
						P.lightArea =  new /image/flashlight
						P.lightArea.loc = P
						P.client.images += P.lightArea
						P.client.screen += flashPlane
				else
					if(!isnull(P.lightArea))
						P.client.images -= P.lightArea
						P.client.screen -= flashPlane
						P.lightArea.loc = null
						P.lightArea = null
				if(P.client)
					updateMusic(P,src)
					if(src.outdoor)
						P.client.screen |= time_overlay
					else
						P.client.screen -= time_overlay
		Exited(atom/movable/O,atom/newloc)
			if(istype(O,/player))
				var player/P = O
				if(locate(/cutBush) in src)
					for(var/cutBush/C in src)
						C.players_passthrough -= "[ckeyEx(P.key)]"
						P.client.images |= C.theImage
				if(locate(/smashBoulder) in src)
					for(var/smashBoulder/S in src)
						S.players_passthrough -= "[ckeyEx(P.key)]"
						P.client.images |= S.theImage
				if(locate(/strengthBoulder) in src)
					for(var/strengthBoulder/ST in src)
						ST.players_passthrough -= "[P.ckey]"
						if(!(P.playerFlags & LOGGING_OUT)) // Deletion is handled in the logging out procedure in this case.
							ST.DestroyCloneBoulder(P,TRUE)
						P.client.images |= ST.theImage
				if(locate(/mob/NPC/NPCTrainer) in src)
					for(var/mob/NPC/NPCTrainer/N in src)
						if("[ckeyEx(P.key)]" in N.imageCache)
							P.client.images -= N.imageCache["[ckeyEx(P.key)]"]
							N.imageCache -= "[ckeyEx(P.key)]"
							P.client.images += N.mainImage
						if("[ckeyEx(P.key)]" in N.cloneCache)
							var mob/M = N.cloneCache["[ckeyEx(P.key)]"]
							M.loc = null
							N.cloneCache -= "[ckeyEx(P.key)]"
		Route_101
			routeMusic = 'Route 101 (DS).ogg'
			routeMusic8Bit = 'Route 101 8-bit.ogg'
			route = ROUTE_101
		Route_102
			routeMusic = 'Route 101 (DS).ogg'
			routeMusic8Bit = 'Route 101 8-bit.ogg'
			route = ROUTE_102
		Route_103
			routeMusic = 'Route 101 (DS).ogg'
			routeMusic8Bit = 'Route 101 8-bit.ogg'
			route = ROUTE_103
		Route_104
			routeMusic = 'Route 104 (DS).ogg'
			route = ROUTE_104
		Route_109
			routeMusic = 'Route 104 (DS).ogg'
			route = ROUTE_109
		Route_110
			routeMusic = 'Route 110.ogg'
			route = ROUTE_110
		Route_111
			routeMusic = 'Route 110.ogg'
			route = ROUTE_111
		Route_111_Desert
			routeMusic = 'Route 111 Desert.ogg'
			route = ROUTE_111_DESERT
			Enter(atom/movable/O)
				if(istype(O,/player))
					var player/P = O
					if(P.bag.hasItem(/item/key/Go\-\Goggles))
						return ..()
					else
						P.ShowText("The sandstorm is too harsh... you can't go this way!")
						return 0
				else
					return ..()
		Route_112
			routeMusic = 'Route 110.ogg'
			route = ROUTE_112
		Route_113
			routeMusic = 'Route 113.ogg'
			route = ROUTE_113
		Route_114
			routeMusic = 'Route 110.ogg'
			route = ROUTE_114
		Route_115_South
			routeMusic = 'Route 104 (DS).ogg'
			route = ROUTE_115_SOUTH
		Route_115_North
			routeMusic = 'Route 104 (DS).ogg'
			route = ROUTE_115_NORTH
		Route_116
			routeMusic = 'Route 104 (DS).ogg'
			route = ROUTE_116
		Route_117
			routeMusic = 'Route 110.ogg'
			route = ROUTE_117
		Littleroot_Town
			routeMusic = 'Littleroot Town.ogg'
			routeMusic8Bit = 'Littleroot Town 8-bit.ogg'
			route = LITTLEROOT_TOWN
		Littleroot_Indoor
			routeMusic = 'Littleroot Town.ogg'
			routeMusic8Bit = 'Littleroot Town 8-bit.ogg'
			route = LITTLEROOT_TOWN
			outdoor = FALSE
			noBike = TRUE
		Oldale_Town
			routeMusic = 'Oldale Town.ogg'
			routeMusic8Bit = 'Oldale Town 8-bit.ogg'
			route = OLDALE_TOWN
		Petalburg_City
			routeMusic = 'Petalburg City.ogg'
			route = PETALBURG_CITY
		Petalburg_Woods
			routeMusic = 'Petalburg Woods.ogg'
			route = PETALBURG_WOODS
		Rustboro_City
			routeMusic = 'Rustboro City.ogg'
			route = RUSTBORO_CITY
		Dewford_Area
			routeMusic = 'Dewford Town.ogg'
			route = DEWFORD_BEACH
		Dewford_Route
			routeMusic = 'Route 104 (DS).ogg'
			route = DEWFORD_BEACH
		Slateport_City
			routeMusic = 'Slateport City.ogg'
			route = SLATEPORT_CITY
		Mauville_City
			routeMusic = 'Rustboro City.ogg'
			route = MAUVILLE_CITY
		Verdanturf_Town
			routeMusic = 'Verdanturf Town.ogg'
			route = VERDANTURF_TOWN
		Lavaridge_Town
			routeMusic = 'Oldale Town.ogg'
			route = LAVARIDGE_TOWN
		Oceanic_Museum
			routeMusic = 'Oceanic Museum.ogg'
			route = OCEANIC_MUSEUM
			outdoor = FALSE
			noBike = TRUE
		Meteor_Falls
			routeMusic = 'Meteor Falls.ogg'
			route = METEOR_FALLS
			outdoor = FALSE
		Jagged_Pass
			routeMusic = 'Petalburg Woods.ogg'
			route = JAGGED_PASS
			outdoor = FALSE
		Firey_Path
			routeMusic = 'Petalburg Woods.ogg'
			route = FIREY_PATH
			outdoor = FALSE
		Mart
			routeMusic = 'Poké Mart.ogg'
			routeMusic8Bit = 'Poké Mart 8-bit.ogg'
			route = POKE_MART
			outdoor = FALSE
			noBike = TRUE
			regionChange = FALSE
		Center
			routeMusic = 'Pokemon Center.ogg'
			routeMusic8Bit = 'Poké Center 8-bit.ogg'
			route = POKE_CENTER
			outdoor = FALSE
			noBike = TRUE
			regionChange = FALSE
		Lab
			routeMusic = 'Birch Lab.ogg'
			route = POKE_LAB_BIRCH
			outdoor = FALSE
			noBike = TRUE
		Pal_Park
			routeMusic = 'Safari Zone.ogg'
			route = PAL_PARK
			worldRegion = SINNOH
		Pal_Park_Field
			routeMusic = 'Great Marsh.ogg'
			route = PAL_PARK_FIELD
			worldRegion = SINNOH
		Pal_Park_Forest
			routeMusic = 'Great Marsh.ogg'
			route = PAL_PARK_FOREST
			worldRegion = SINNOH
		Pal_Park_Sea
			routeMusic = 'Great Marsh.ogg'
			route = PAL_PARK_SEA
			worldRegion = SINNOH
		Pal_Park_Pond
			routeMusic = 'Great Marsh.ogg'
			route = PAL_PARK_POND
			worldRegion = SINNOH
		Pal_Park_Mountain
			routeMusic = 'Great Marsh.ogg'
			route = PAL_PARK_MOUNTAIN
			worldRegion = SINNOH
		Granite_Cave_1F
			routeMusic = 'Petalburg Woods.ogg'
			route = GRANITE_CAVE_1F
			outdoor = FALSE
		Granite_Cave_B1F
			routeMusic = 'Petalburg Woods.ogg'
			route = GRANITE_CAVE_B1F
			outdoor = FALSE
			flashHere = TRUE
		Granite_Cave_B2F
			routeMusic = 'Petalburg Woods.ogg'
			route = GRANITE_CAVE_B2F
			outdoor = FALSE
			flashHere = TRUE
		Granite_Cave_Back_Room
			routeMusic = 'Petalburg Woods.ogg'
			route = GRANITE_CAVE_BACK_ROOM
			outdoor = FALSE
		Rusturf_Tunnel
			routeMusic = 'Petalburg Woods.ogg'
			route = RUSTURF_TUNNEL
			outdoor = FALSE
		Staff_Area
			routeMusic = 'Silph Co FRLG.ogg'
			routeMusic8Bit = 'Silph Co RBY.ogg'
			route = STAFF_AREA
			worldRegion = KANTO
		One_Island
			routeMusic = 'Viridian City.ogg'
			routeMusic8Bit = 'Viridian City 8-bit.ogg'
			route = ONE_ISLAND
			worldRegion = SEVII_ISLANDS
		Two_Island
			routeMusic = 'Viridian City.ogg'
			routeMusic8Bit = 'Viridian City 8-bit.ogg'
			route = TWO_ISLAND
			worldRegion = SEVII_ISLANDS
		Three_Island
			routeMusic = 'Viridian City.ogg'
			routeMusic8Bit = 'Viridian City 8-bit.ogg'
			route = THREE_ISLAND
			worldRegion = SEVII_ISLANDS
		Kindle_Road
			routeMusic = 'Kanto Route 3.ogg'
			routeMusic8Bit = 'Kanto Route 3 8-bit.ogg'
			route = KINDLE_ROAD
			worldRegion = SEVII_ISLANDS
		Treasure_Beach
			routeMusic = 'Kanto Route 3.ogg'
			routeMusic8Bit = 'Kanto Route 3 8-bit.ogg'
			route = TREASURE_BEACH
			worldRegion = SEVII_ISLANDS
		Bond_Bridge
			routeMusic = 'Kanto Route 3.ogg'
			routeMusic8Bit = 'Kanto Route 3 8-bit.ogg'
			route = BOND_BRIDGE
			worldRegion = SEVII_ISLANDS
		Cape_Brink
			routeMusic = 'Kanto Route 3.ogg'
			routeMusic8Bit = 'Kanto Route 3 8-bit.ogg'
			route = CAPE_BRINK
			worldRegion = SEVII_ISLANDS
		Three_Isle_Path
			routeMusic = 'Viridian Forest.ogg'
			routeMusic8Bit = 'Viridian Forest 8-bit.ogg'
			route = THREE_ISLE_PATH
			worldRegion = SEVII_ISLANDS
		Three_Isle_Port
			routeMusic = 'Kanto Route 3.ogg'
			routeMusic8Bit = 'Kanto Route 3 8-bit.ogg'
			route = THREE_ISLE_PORT
			worldRegion = SEVII_ISLANDS
		Birth_Island
			routeMusic = 'Lake of Rage.ogg'
			routeMusic8Bit = 'Lake of Rage 8-bit.ogg'
			route = BIRTH_ISLAND
			worldRegion = SEVII_ISLANDS
		Navel_Rock_Outside
			routeMusic = 'Lake of Rage.ogg'
			routeMusic8Bit = 'Lake of Rage 8-bit.ogg'
			route = NAVEL_ROCK
			worldRegion = SEVII_ISLANDS
		Navel_Rock_Inside
			routeMusic = 'Mt. Moon HGSS.ogg'
			routeMusic8Bit = 'Mt. Moon RBY.ogg'
			route = NAVEL_ROCK
			worldRegion = SEVII_ISLANDS
		Berry_Forest
			routeMusic = 'Viridian Forest.ogg'
			routeMusic8Bit = 'Viridian Forest 8-bit.ogg'
			route = THREE_ISLE_PATH
			worldRegion = SEVII_ISLANDS
		New_Moon_Island
			routeMusic = 'Old Chateau.ogg'
			route = NEW_MOON_ISLAND
			worldRegion = SINNOH

#ifndef FA_REGION
#error "This Project requires Forum_Account's Region Library."
#else
region
	Lugia_Blocker
		Enter(atom/movable/O)
			if(istype(O,/player))
				var player/P = O
				if(P.story.storyFlags2 & CAUGHT_LUGIA)return ..()
				var monNames[0]
				for(var/pokemon/PK in P.party.Copy(1,7))
					monNames += "[PK.pName]"
				if(("Articuno" in monNames) && ("Zapdos" in monNames) && ("Moltres" in monNames))
					return ..()
				else
					P.ShowText("Loud Shrieks seem to plague the area ahead. You tremble in fear and decide not to go that way.")
					return FALSE
			else
				return ..()
	Ho_Oh_Blocker
		Enter(atom/movable/O)
			if(istype(O,/player))
				var player/P = O
				if(P.story.storyFlags2 & CAUGHT_HO_OH)return ..()
				var monNames[0]
				for(var/pokemon/PK in P.party.Copy(1,7))
					monNames += "[PK.pName]"
				if(("Raikou" in monNames) && ("Entei" in monNames) && ("Suicune" in monNames))
					return ..()
				else
					P.ShowText("Loud Screams seem to be frequent in the area ahead. It's too horrifying, so you cower as you decide not to head that way.")
					return FALSE
			else
				return ..()
	Enter_Blocker
		Enter(atom/movable/O)
			if(istype(O,/player))
				var player/P = O
				var foundMon = locate(/pokemon) in P.party
				if( (!foundMon) && (!isnull(P.walker)) )
					foundMon = TRUE

				if(!foundMon)
					var mob/NPC/BlockLady/B = locate()
					B.dir = EAST
					P.ShowText("Janice: Hey, wait, [P]!",RedColor,TRUE)
					P.ShowText("You can't go this way without a pokémon!",RedColor,TRUE)
					spawn(20) B.dir = SOUTH
					return FALSE
				else
					return ..()
			else
				return ..()
	Blocking_102
		Enter(atom/movable/O)
			if(istype(O,/player))
				if(istype(O,/player))
					var player/P = O
					if(!("/mob/NPC/NPCTrainer/Rival" in P.story.defeatedTrainers))
						var{rivalGender;rivalName;rivalGender2}
						if(P.gender==MALE)
							rivalGender = "girl"
							rivalName = "May"
							rivalGender2 = "her"
						else
							rivalGender = "guy"
							rivalName = "Brendan"
							rivalGender2 = "him"
						var /mob/NPC/BlockNerd/B = locate(/mob/NPC/BlockNerd)
						B.dir = SOUTH
						P.ShowText("Hey! Don't walk over here! I'm sketching the footprints of a rare Pokémon!",BlueColor,TRUE)
						P.ShowText("...",bold=TRUE)
						P.ShowText("So you're that [P.name] kid?",BlueColor,TRUE)
						P.ShowText("That [rivalGender] [rivalName] on Route 103 was looking for you.",BlueColor,TRUE)
						P.ShowText("Why don't you go talk to [rivalGender2]?",BlueColor,TRUE)
						return FALSE
					if(1 in P.story.defeatedTrainers["/mob/NPC/NPCTrainer/Rival"])
						return ..()
					else
						var{rivalGender;rivalName;rivalGender2}
						if(P.gender==MALE)
							rivalGender = "girl"
							rivalName = "May"
							rivalGender2 = "her"
						else
							rivalGender = "guy"
							rivalName = "Brendan"
							rivalGender2 = "him"
						P.ShowText("Hey! Don't walk over here! I'm sketching the footprints of a rare Pokémon!",BlueColor,TRUE)
						P.ShowText("...",bold=TRUE)
						P.ShowText("So you're that [P.name] kid?",BlueColor,TRUE)
						P.ShowText("That [rivalGender] [rivalName] on Route 103 was looking for someone that looks like you.",BlueColor,TRUE)
						P.ShowText("Why don't you go talk to [rivalGender2]?",BlueColor,TRUE)
						return FALSE
#endif