/* Staff Log Location definition in this DM File */
#define Staff_LOG "Log Files/Staff Log.html"

player
	Admin
		verb
			Start_Event()
				set category = "Admin"
				var events[] = list("shiny beldum")
				var possibleEvents[0]
				for(var/x in events)
					if((!(x in event.events)) || (!event.events[x]["active"]))
						possibleEvents += x
				if(length(possibleEvents))
					var chosenEvent = input(src,"Which event will you start?","Event") as null|anything in possibleEvents
					if(isnull(chosenEvent))return
					if(alert(src,"Are you sure you want to start the [capitalize(chosenEvent," ")] event?","Event","Yes","No")=="Yes")
						event.events["[chosenEvent]"] = list("active"=TRUE,"players_done"=list())
				else
					alert(src,"There are no events to start.","Event")
			End_Event()
				set category = "Admin"
				var possibleEvents[0]
				for(var/x in event.events)
					if(x in list("shine ball"))continue
					if(event.events[x]["active"]==TRUE)
						possibleEvents += x
				if(length(possibleEvents))
					var chosenEvent = input(src,"Which event will you end?","Event") as null|anything in possibleEvents
					if(isnull(chosenEvent))return
					if(alert(src,"Are you sure you want to end the [capitalize(chosenEvent," ")] event?","Event","Yes","No")=="Yes")
						event.events["[chosenEvent]"] = list("active"=FALSE,"players_done"=list())
				else
					alert(src,"There are no events to end.","Event")
			Profiler()
				set category = "Admin"
				winset(usr,null,"command=.command")
			Give_Admin()
				set category = "Admin"
				if(length(playerKeys-Admin_key)==0)return
				var choice = input("Who are you going to promote to an admin?","Promote!") as null|anything in (playerKeys-Admin_key)
				if(choice==null)return
				Admin_key |= choice
				if(choice in Moderator_key)
					Moderator_key -= choice
				global.online_players << "[src.name]([src.key]) has promoted [choice] to admin!"
				var player/P = playerKeys["[choice]"]
				if(!isnull(P))Staff(P)
			Remove_Admin()
				set category = "Admin"
				var choice = input("Who are you going to remove admin powers from?","Remove!") as null|anything in (Admin_key-src.key)
				if(choice==src.key)
					src << "You can't take your own administrator ability away!"
					return
				switch(choice)
					if(null)return
					if("Pokemonred200","Vexxen","Harzar","Kittikatt","Lugias Soul","Sara13243","Lossetta","Syxoul","WorldWideDuelist")
						src << "You can't take this person's administrator ability away because they're admin by default."
					if("Yucide","Jaylovekiller","Sarahthesmexy","LargeExodia","ROBERTTHEKILLER")
						Admin_key -= choice
						Moderator_key |= choice
						global.online_players << "[src] ([src.key]) has demoted [choice] from Admin to moderator!"
						var player/P = playerKeys["[choice]"]
						if(!isnull(P))Staff(P)
					else
						world << "[src] ([src.key]) has removed admin status for [choice]."
						Admin_key -= choice
						var player/P = playerKeys["[choice]"]
						if(!isnull(P))Staff(P)
			Give_Mod()
				set category = "Admin"
				if(length(playerKeys-Moderator_key)==0)return
				var choice = input("Who are you going to promote to a moderator?","Promote!") as null|anything in (playerKeys-Moderator_key)
				if(isnull(choice))return
				else if(choice in Admin_key)
					if(choice in list("Pokemonred200","Vexxen","Harzar","Kittikatt","Lugias Soul","Sara13243","Lossetta","Syxoul","WorldWideDuelist"))
						src << "You can't remove [choice]'s admin powers as they are one of the default admins!"
					else
						Admin_key -= choice
						Moderator_key |= choice
						global.online_players << "<b><font color=red face='Times New Roman' size=-1>[src]([src.key]) demoted [choice] from Admin to Moderator!</font></b>"
				else
					Moderator_key |= choice
					global.online_players << "[src.name]([src.key]) has promoted [choice] to moderator!"
					var player/P = playerKeys["[choice]"]
					if(!isnull(P))Staff(P)
			Remove_Mod()
				set category = "Admin"
				var choice = input("Who are you going to remove moderation powers from?","Remove!") as null|anything in Moderator_key
				switch(choice)
					if(null)return
					if("Yucide","Jaylovekiller","Sarahthesmexy","LargeExodia","ROBERTTHEKILLER")
						src << "You can't remove this person's mod as they're mod by default."
					else
						world << "[src.name] ([src.key]) has removed moderator status for [choice]."
						Moderator_key -= choice
						var player/P = playerKeys["[choice]"]
						if(!isnull(P))
							Staff(P)
						else
							playerKeys -= "[choice]"
			Set_Password()
				set category = "Admin"
				var chosePassword = FALSE
				var newPassword
				do
					newPassword = input("What do you want the server password to be?","Choose a Password.") as text
					if(alert("Are you sure you want [newPassword] as your password?","Choose a Password.","Yes","No")=="Yes")
						chosePassword = TRUE
				while(chosePassword != FALSE)
				connect_password = md5(newPassword)
			Announcement()
				set category = "Admin"
				set name = "Announcement"
				var/Announcement = input(usr, "What is your Announcement?")as null|message
				if(!Announcement){return}
				for(var/player/P in global.online_players)
					P << output("<CENTER><B>\red[usr.name] Announces:<BR><B>\white[html_decode(Announcement)]</CENTER>")
					P << output("<CENTER><B>\red[usr.name] Announces:<BR><B>\white[html_decode(Announcement)]</CENTER>", "announcement")
				text2file("<B>[time2text(world.realtime)]</B>: [usr.name] made an announcement!</font color><BR>", Staff_LOG)
				return

			MuteUnmuteWorld()
				set category = "Admin"
				set name = "Mute/Unmute World"
				if(!World_muted){World_muted = TRUE; Admin("[usr.name] muted the world!</font color></B>")}
				else
					World_muted = FALSE; Admin("[usr.name] unmuted the world!</font color></B>")

			Toggle_EXP_Formula()
				set category = "Admin"
				gameFlags ^= USE_SCALED_EXP_FORMULA
				var oldVal
				var newVal
				if(gameFlags & USE_SCALED_EXP_FORMULA)
					oldVal = "flat"
					newVal = "scaled"
				else
					oldVal = "scaled"
					newVal = "flat"
				for(var/player/P in global.online_players)
					P << output("<CENTER><B>\red[usr.name] has toggled the EXP formula from [oldVal] mode to [newVal] mode.</B></CENTER>")
					P << output("<CENTER><B>\red[usr.name] has toggled the EXP formula from [oldVal] mode to [newVal] mode.</B></CENTER>","announcement")

			Toggle_HP_Natures()
				set category = "Admin"
				gameFlags ^= TOGGLE_HP_NATURES
				var on = (gameFlags & TOGGLE_HP_NATURES)?("on"):("off")
				global.online_players << output("<CENTER><B>\red[usr.name] has turned the HP natures [on].</B></CENTER>")
				global.online_players << output("<CENTER><B>\red[usr.name] has turned the HP natures [on].</B></CENTER>","announcement")

			Toggle_Poison_Damage()
				set category = "Admin"
				gameFlags ^= TOGGLE_OVERWORLD_POISON
				var on = (gameFlags & TOGGLE_OVERWORLD_POISON)?("on"):("off")
				global.online_players << output("<center><b>\red[usr.name] has turned out-of-battle posion damage [on].</b></center>")
				global.online_players << output("<center><b>\red[usr.name] has turned out-of-battle poison damage [on].</b></center>","announcement")

			WorldOptions()
				set category = "Admin"
				set name = "World Options"
				var/Option = input(usr, "What will you like to do?", "World Options") as null|anything in list ("Toggle Server Private", "Stop Ongoing Shutdown", "Stop Ongoing Reboot", "Shutdown", "Reboot", "Quick Reboot", "Repopulate")
				switch(Option)
					if(null){return}
					if("Toggle Server Private")
						if(!Server_Private)
							Server_Private = TRUE
							Admin("[usr.name] makes the server private!</font color></B>")
						else
							Server_Private = FALSE
							Admin("[usr.name] makes the server playable!</font color></B>")
					if("Stop Ongoing Shutdown")
						if(Is_Shutdown)
							Is_Shutdown = FALSE
							Admin("[usr.name] stops the ongoing shutdown, the world will not shutdown!</font color></B>")
						else
							alert(usr, "There are no ongoing shutdowns going on!", "**Alert**")
					if("Stop Ongoing Reboot")
						if(Is_Reboot)
							Is_Reboot = FALSE
							Admin("[usr.name] stops the ongoing reboot, the world will not reboot!</font color></B>")
						else
							alert(usr, "There are no ongoing reboots going on!", "**Alert**")
					if("Repopulate")
						Admin("[usr.name] repopulated the world!</font color></B>")
						world.Repop()
						return
					if("Quick Reboot")
						Admin("[usr.name] did a quick reboot!</font color></B>")
						spawn(10){world.Reboot()}
						return
					if("Shutdown")
						if(Is_Shutdown)
							alert(usr, "The world is already preparing to shutdown!", "**Alert**"); return
						if(Is_Reboot)
							alert(usr, "The world is already preparing to reboot, can't shutdown!", "**Alert**"); return
						Is_Shutdown = TRUE
						Admin("[usr.name] prepares to shutdown world!</font color></B>")
						for(var/player/P in global.online_players){P << output("\red<B>(Staff)</B>World will shutdown in 1 minutes, please save!</font color></B>"); P << output("\red<B>(Staff)</B>World will shutdown in 1 minutes, please save!</font color></B>", "announcement")}
						spawn(600){if(Is_Shutdown){Admin("[usr.name] successfully shut down the world!</font color></B>"); shutdown()}}
						return
					if("Reboot")
						if(Is_Reboot)
							alert(usr, "The world is already preparing to reboot!", "**Alert**"); return
						if(Is_Shutdown)
							alert(usr, "The world is already preparing to shutdown, can't reboot!", "**Alert**"); return
						Is_Reboot = TRUE
						Admin("[usr.name] prepares to reboot world!</font color></B>")
						for(var/player/P in global.online_players){P << output("\red<B>(Staff)</B>World will reboot in 1 minutes, please save!</font color></B>"); P << output("\red<B>(Staff)</B>World will reboot in 1 minutes, please save!</font color></B>", "announcement")}
						spawn(600){if(Is_Reboot){Admin("[usr.name] successfully reboots the world!</font color></B>"); world.Reboot()}}
						return
				return

			DeleteAtom(atom/M in world)
				set category = "Admin"
				set name = "Delete Atom"
				if(istype(M,/mob))
					var mob/X = M
					if(X.client)
						usr << "You cannot delete players."
						return
				text2file("<B>[time2text(world.realtime)]</B>: [usr] deleted [M]{[M.type]}<BR>", Staff_LOG); del(M); return

			Rename()
				set category = "Admin"
				set name = "Rename"
				var/player/P = input(usr, "Who will you like to rename?", "Rename") as null|anything in playerKeys
				if(!P){return}
				P = playerKeys[P]
				var/OldName = P.name
				var newName = input(usr, "What will be [OldName]'s new name?", "Name?")as text
				if(length(newName) > 20)
					alert(usr, "New name can't be longer than 20 characters...", "**Alert**")
					return
				if(!newName)
					alert(usr, "Can't leave their name empty...", "**Alert**")
					return
				if(P == usr)
					Admin("[P] renamed \herself to [newName]([P.key])!</font color></B>")
					P.name = newName
				else {P.name=newName;Admin("[usr.name] renamed [OldName] to [P.name]([P.key])!</font color></B>")}
				//P.textThing.ChangeText("<font color=black size = 2 face = \"Times New Roman\">[src.name]</font>")
				return
			CreateAtom()
				set category = "Admin"
				set name = "Create Atom"
				var/Atom = null
				switch(input(usr, "What do you want to create?","Create") as null|anything in list("Object","Mob","Turf"))
					if(null){return}
					if("Object"){Atom = input(usr, "What do you want to make?","Create obj") as null|anything in typesof(/obj)}
					if("Mob"){Atom = input(usr, "What do you want to make?","Create mob") as null|anything in typesof(/mob)}
					if("Turf"){Atom = input(usr, "What do you want to make?","Create turf") as null|anything in typesof(/turf)}
				if(isnull(Atom)){return}
				new Atom(locate(usr.x,usr.y,usr.z))
				text2file("<B>[time2text(world.realtime)]</B>: [usr] creates \a [lowertext(Atom)]!<BR>", Staff_LOG)
				return

	Special
		verb
			StaffChat()
				set category = "Special"
				set name = "Staff Chat"
				var/Text = input(src, "What will you like to say to your fellow staff members?", "Staff Chat")as text|null
				if(isnull(Text))return
				if(!Text){return}
				for(var/player/C in global.online_players)
					if(C.Is_staff){C << output("\icon[src.sprite]<B>\red[usr.name]([usr.key]) Staff Chat:</B>\white [html_encode(Text)]"); C << output("<B>\red[usr.name]([usr.key]) Staff Chat:</B>\white [html_encode(Text)]", "worldchat")}
				return
			Teleport_To_Staff_Area()
				set category = "Special"
				src.Move(locate("Staff Building"))

			Set_Staff_Room_Spawn_Rate()
				set category = "Special"
				var previousGrindRate = src.staffRoomGrindRate
				src.staffRoomGrindRate = min(max(input(src,"How often do you want wild Grinding Magikarp to spawn in the Staff Room?","Staff Info") as null|num,0),100)
				if(isnull(src.staffRoomGrindRate))
					src.staffRoomGrindRate = previousGrindRate
				else
					src.ShowText("Wild Grindikarp will now spawn in the staff area at a rate of [src.staffRoomGrindRate]%.")

	Moderator
		verb
			Mute_Settings()
				set category = "Moderator"

			Kick()
				set category = "Moderator"
				set name = "Kick"
				var/player/C = input(usr, "Select a player to kick", "Kick") as null|anything in global.online_players
				if(isnull(C) || (usr == C || (!C)))return
				var/player/T = usr; if(T.Staff_num <= C.Staff_num){alert(usr, "You are unable to do this...", "**Alert**"); return}
				if(alert(usr, "Kick [C.name]?", "Kick?","Yes","No")=="Yes")
					Admin("[usr.name] kicked [C.name]([C.key]) off the server!</font color></B>")
					del(C)
					return
				return

			Summon()
				set category = "Moderator"
				set name = "Summon"
				var/player/C = input(usr, "Select a player to summon", "Summon")as null|anything in global.online_players
				if(isnull(C) || (usr == C || (!C)))return
				C.Move(locate(usr.x, usr.y, usr.z))
				text2file("<B>[time2text(world.realtime)]</B>: [usr.name] summoned [C.name]([C.key])!<BR>", Staff_LOG)
				return

			Teleport()
				set category = "Moderator"
				set name = "Teleport"
				var player/C = input(usr, "Select a player to teleport to", "Teleport") as null|anything in global.online_players
				if(isnull(C) || (usr == C || (!C))){return}
				usr.Move(locate(C.x, C.y, C.z))
				text2file("<B>[time2text(world.realtime)]</B>: [usr.name] teleported to [C.name]([C.key])!<BR>", Staff_LOG)
				return

			WarnPlayer()
				set category = "Moderator"
				set name = "Warn Player"
				var/player/C = input(usr, "Warn who?", "Warn Player")as null|anything in global.online_players
				if(isnull(C)){return}
				if(usr == C || !C) {return}
				var/Warning = input(usr, "What are you warning [C.name] for?")as message
				if(!Warning){return}
				Admin("\red[usr.name] warned [C.name]([C.key]) - </B>\white[Warning]!</font color></B>")
				return

			ToggleDensity()
				set category = "Moderator"
				set name = "Toggle Density"
				src.density = !src.density
				if(src.walker)src.walker.density = src.density
				text2file("<B>[time2text(world.realtime)]</B>: [usr.name] uses the toggles density to [usr.density]!</font color><BR>", Staff_LOG)
				src << output("You toggle density to <B>[usr.density]</b>.")
				return

			MKCheck()
				set category = "Moderator"
				set name = "Multikey Check"
				text2file("<B>[time2text(world.realtime)]</B>: [usr.name] does a multikey check!<BR>", Staff_LOG)
				var/f = 0
				for(var/player/C1 in global.online_players)
					for(var/player/C2 in global.online_players)
						if(C1.client.address == C2.client.address && C1 != C2)
							f ++
							usr << "\red<B>[f].)</B>[C1.name]([C1.key]) && [C2.name]([C2.key])"
				if(!f)
					usr << "<font color = red><B>NO</B> multikeying activity found!"
				else
					usr << "<font color = red><b>[f]</b> accounts are being used for multikeying."
				return


			Spy()
				set category = "Moderator"
				set name = "Spy Options"
				var/Spy = input(usr, "What will you like to do?", "Spy Options") as null|anything in list("Spy", "Spy(Off)")
				switch(Spy)
					if(null){return}
					if("Spy")
						var/player/C = input(usr, "Spy who?", "Spy") as null|anything in global.online_players
						if(C == "Cancel"){return}
						if(usr == C || !C) {return}
						var/player/T = usr; if(T.Staff_num <= C.Staff_num){alert(usr, "You are unable to do this...", "**Alert**"); return}
						text2file("<B>[time2text(world.realtime)]</B>: [usr.name] spys on [C.name]([C.key])!<BR>", Staff_LOG)
						usr.client.perspective = EYE_PERSPECTIVE ; usr.client.eye = C
						return
					if("Spy(Off)")
						usr.client.perspective = EYE_PERSPECTIVE ; usr.client.eye = usr
						return

			StaffLog()
				set category = "Moderator"
				set name = "Staff Log"
				usr << browse(file2text(Staff_LOG), "window=Staff_LOG;size=425x425")
				return
