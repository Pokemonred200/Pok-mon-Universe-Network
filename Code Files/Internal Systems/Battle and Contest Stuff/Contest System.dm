proc
	startcontest(player/participants[],pokemon/contestants[],options)
		if(istext(participants))
			new /contesthandler(participants) // process as paramater text
		else
			if((participants.len==4) && (contestants.len==4))
				if(istext(options))
					options = params2list(options)
					if(("contest type" in options) && ("rank" in options))
						new /contesthandler(participants+contestants+options)

contesthandler
	New(contestInfo)
		if(istext(contestInfo))
			contestInfo = params2list(contestInfo)
			contestRank = text2num(contestInfo["rank"])
			for(var/i in 1 to 4)
				contestInfo["player [i]"] = locate(contestInfo["player [i]"])
				contestInfo["pokemon [i]"] = locate(contestInfo["player [i]"])
		contestType = contestInfo["contest type"]
		if(!(contestType in list(BEAUTY,COOL,CUTE,SMART,TOUGH)))
			del src
			return
		for(var/i in 1 to 4)
			src.vars["player[i]"] = contestInfo["player [i]"]
			src.vars["P[i]"] = contestInfo["pokemon [i]"]
			if(!istype(src.vars["players[i]"],/player))
				del src
				return
			if(!istype(src.vars["P[i]"],/pokemon))
				del src
				return
		contestRank = contestInfo["rank"]
	var
		player
			player1
			player2
			player3
			player4
		pokemon
			P1
			P2
			P3
			P4
		contestPoints1 = 0
		contestPoints2 = 0
		contestPoints3 = 0
		contestPoints4 = 0
		contestType
		rounds = 0
		contestRank = 0 // 0 for Normal, 1 for Great, 2 for Ultra, and 3 for Master.
	proc
		contest_loop()