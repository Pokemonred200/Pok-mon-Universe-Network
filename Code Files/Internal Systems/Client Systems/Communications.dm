/* Red (Pokemonred200) */

#define CENSOR_ON 1
#define IGNORE_OOC 2
#define IGNORE_PMS 4

var chat_log_file = file("Chat Log.txt")

communications
	New(player/M)
		. = ..()
		mob = M
		channel = 1
	var
		tmp/player/mob
		ignoreList[0]
		flags = 0
		static/badWords = list("motherfucker","shit","fuck"," ass ","pussy","cunt","slut","whore","bitch","semen","son of a motherless goat")
		tmp/channel
		chatColor = "#C0C0C0"
		language = "English"
	proc
		toggleCensor()
			flags ^= CENSOR_ON
			mob << "You turned your censor [(flags & CENSOR_ON)?("on"):("off")]."
		Command_Process(t)
			var data[] = splittext(t," ")
			switch(data[1])
				if("/stuck")
					if(!mob.client.battle)
						mob.playerFlags &= ~IN_BATTLE
					mob.ContinueText = 0
				if("/help")
					mob << "You can talk to NPCs by pressing TAB while facing them."
					mob << "Battling is currently under the works, but is in good progress."
					mob << "The shine ball event occurs four times per year."
					mob << "The HP natures are my (Pokemonred200's) idea. I like them."
					mob << "To raise/lower sound, use the + button to raise sound and the - button to lower it."
					mob << "To mute/unmute sound, press the 'm' key."
				if("/commands")
					mob << "/help: gives a help menu."
					mob << "/commands: shows commands."
					mob << "/gamemode: changes game spawn mode. (Admin only)"
				if("/gamemode")
					if(mob.key in Admin_key)
						var newMode
						if(length(data) < 2)
							mob << "<font color = red><b>usage: /gamemode \<mode\> \[player\]</b></font>"
							return
						data[2] = lowertext(data[2])
						switch(data[2])
							if("ruby","r","0")
								newMode = "Ruby"
							if("sapphire","s","1")
								newMode = "Sapphire"
							if("emerald","e","2")
								newMode = "Emerald"
							else
								data[2] = text2num(data[2])
								if(data[2])
									if(data[2] > 2)
										newMode = "Emerald"
									if(data[2] < 0)
										newMode = "Ruby"
						if(length(data) >= 3)
							var player/P = playerCkeys["[ckey(data[3])]"]
							if(!isnull(P))
								var oldMode = P.mode
								P.mode = newMode
								if(P==mob)
									world << "<b>[mob] ([mob.key]) changed [genderGet(mob,"his")] gamemode from [oldMode] to [newMode])"
								else
									world << "<b>[mob] ([mob.key]) changed [P.name] ([P.key])'s gamemode from [oldMode] to [newMode]."
								updateEvents(P)
						else
							var oldMode = mob.mode
							mob.mode = newMode
							updateEvents(mob)
							world << "<b>[mob.name] ([mob.key]) changed [genderGet(mob,"his")] gamemode from [oldMode] to [newMode]."
					else
						mob << "<font color = red><b>You must be an admin to use this command.</b></font>"
				else
					mob << "<font color = red><b> command not found.</b></font>"
		Censor_Text(t)
			if(!istext(t))return null
			var/X = ""
			for(var/L in badWords)
				for(var/i in 1 to length(L))
					if(copytext(L,i,i+1) != " ") // so 'ass' is censored as *** and not *****
						X += "*"
					else
						X += " "
				t = replacetext(t,L,X)
				X = ""
			return t
		OOC(t)
			if(!t)return
			t = html_encode(t)
			chat_log_file << "<B>[mob.name]([mob.key]) OOC</B>: [t]"
			var v = Censor_Text(t)
			if(copytext(t,1,2)=="/")
				Command_Process(t)
				return
			if(findtext(t,"How do I talk to")||findtext(t,"How do I interact"))
				src.ReceiveData("<b><font color=red>***System Reminder***: You can talk to/interact with NPCs and objects by pressing the 'TAB' Key.</b></font>")
			for(var/player/P in global.online_players)
				if(P.com.flags & IGNORE_OOC || (src.channel != P.com.channel) || (src.language != P.com.language) || (src.mob.key in P.com.ignoreList))continue
				if(P.com.flags & CENSOR_ON)
					if(mob.Staff_num == 3){P.com.ReceiveData("\icon[mob.sprite]<span style=\"font_weight:bold\"><span style=\"color:#FF0000\">(Admin)</span>\
					[mob.name]([mob.key]) OOC</span>: <div style=\"color:[chatColor]\">[v]</div>", "worldchat")}
					else if(mob.Staff_num == 2){P.com.ReceiveData("\icon[mob.sprite]<span style=\"font_weight:bold\"><span style=\"color:#0000FF\">(Mod)</span>\
					[mob.name]([mob.key]) OOC</span>: <div style=\"color:[chatColor]\">[v]</div>", "worldchat")}
					else if(mob.Staff_num == 1){P.com.ReceiveData("\icon[mob.sprite]<span style=\"font_weight:bold\"><span style=\"color:#00FF00\">(Con)</span>\
					[mob.name]([mob.key]) OOC</span>: <div style=\"color:[chatColor]\">[v]</div>", "worldchat")}
					else P.com.ReceiveData("\icon[mob.sprite]<span style=\"font_weight:bold\">[mob.name]([mob.key]) OOC</span>: <div style=\"color:[chatColor]\">\
					[v]</div>","worldchat")
				else
					if(mob.Staff_num == 3){P.com.ReceiveData("\icon[mob.sprite]<span style=\"font_weight:bold\"><span style=\"color:#FF0000\">(Admin)</span>\
					[mob.name]([mob.key]) OOC</span>: <div style=\"color:[chatColor]\">[t]</div>", "worldchat")}
					else if(mob.Staff_num == 2){P.com.ReceiveData("\icon[mob.sprite]<span style=\"font_weight:bold\"><span style=\"color:#0000FF\">(Mod)</span>\
					[mob.name]([mob.key]) OOC</span>: <div style=\"color:[chatColor]\">[t]</div>", "worldchat")}
					else if(mob.Staff_num == 1){P.com.ReceiveData("\icon[mob.sprite]<span style=\"font_weight:bold\"><span style=\"color:#00FF00\">(Con)</span>\
					[mob.name]([mob.key]) OOC</span>: <div style=\"color:[chatColor]\">[t]</div>", "worldchat")}
					else P.com.ReceiveData("\icon[mob.sprite]<span style=\"font_weight:bold\">[mob.name]([mob.key]) OOC</span>: <div style=\"color:[chatColor]\">\
					[t]</div>", "worldchat")
					winset(mob,null,"flash=-1")

		Say(t)
			if(!t)return
			t = html_encode(t)
			chat_log_file << "[mob.name]([mob.key]) Says: [t]"
			if(copytext(t,1,2)=="/")
				Command_Process(t)
				return
			if(findtext(t,"How do I talk to")||findtext(t,"How do I interact"))
				src.ReceiveData("<b><div style=red>***System Reminder***: You can talk to/interact with NPCs and objects by pressing the 'TAB' Key.</b></font>")
			var v = Censor_Text(t)
			for(var/player/P in hearers(mob))
				if((src.language != P.com.language) || (src.channel != P.com.channel))continue
				if(P.com.flags & CENSOR_ON)
					P.com.ReceiveData("\icon[mob.sprite]<span style=\"font_weight:bold\"><span style=\"color:#FFFFFF\">[mob.name]([mob.key]) Says:</span></span> \
					<div style=\"color:[chatColor]\">[v]</div>","worldchat")
				else P.com.ReceiveData("\icon[mob.sprite]<span style=\"font_weight:bold\"><span style=\"color:#FFFFFF\">[mob.name]([mob.key]) Says:</span></span> \
				<div style=\"color:[chatColor]\">[t]</div>","worldchat")
				winset(mob,null,"flash=-1")

		teamChat(t)
			if(!t)return
			t = html_encode(t)

		ReceiveData(t,control="",adminStuff=null)
			set waitfor = 0
			if(!adminStuff)
				if(istext(t))
					mob << output(t,control); mob << output(t)
				else if(isfile(t))
					mob << ftp(t)
				else
					mob << t