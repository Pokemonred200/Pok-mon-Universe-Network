var organization/orgList[0]

organization
	var
		leaderKey = ""
		memberList[0]
		membersOnline[0]
		name
		teamChatLog
		verbRanks[] = list("Leader"=list(/organization/verb/addMember,/organization/verb/removeMember,/organization/verb/promoteToBodyguard,/organization/verb/leave,
			/organization/verb/teamChat),"Co-Leader"=list(/organization/verb/addMember,/organization/verb/removeMember,/organization/verb/promoteToBodyguard,
			/organization/verb/leave,/organization/verb/teamChat),"Commander"=list(/organization/verb/addMember,/organization/verb/removeMember,
			/organization/verb/promoteToBodyguard,/organization/verb/leave,/organization/verb/teamChat),"Executive"=list(/organization/verb/promoteToBodyguard,
			/organization/verb/leave,/organization/verb/teamChat),"Bodyguard"=list(/organization/verb/leave,/organization/verb/teamChat),"Grunt"=list(
			/organization/verb/leave,/organization/verb/teamChat))
	New(player/P,orgName,extraReturn/returnVal)
		if(isnull(P))
			if(!orgList["[orgName]"])
				tag = "@organization: [orgName]"
				name = orgName
				leaderKey = P.key
				memberList["[P.key]"] = "Leader"
				membersOnline += P
				P.teamName = src.name
				P.myTeam = src
				teamChatLog = file("Team Chat Logs/[name].txt")
				orgList["[orgName]"] = src
				returnVal.value = TRUE
				alert(P,"You have created the team [orgName].","Team Creation.")
			else
				alert(P,"An organization with the name [orgName] already exists.","Team Creation")
				returnVal.value = FALSE
	Read(savefile/F)
		. = ..()
		teamChatLog = file("Team Chat Logs/[name].txt")
	verb
		addMember(player/PR as null|anything in playerKeys)
			set hidden = 1
			if(isnull(PR))return
			else PR = playerKeys["[PR]"]
			if(istype(usr,/player))
				var {player/P = usr;rank}
				rank = capitalize(input(P,"What ","What's The Rank?","Grunt") as null|text,"-")
				if(isnull(rank))return
				switch(rank)
					if("Leader")
						alert(P,"You can't assign someone the 'Leader' position!","Team Assignment")
						return
					if("Co-Leader")
						if(memberList["[P.key]"]!="Leader")
							alert(P,"Only the team leader (Account Key: [leaderKey]) can assign someone the 'Co-Leader' position.","Team Assignment.")
							return
					if("Commander")
						if(!(memberList["[P.key]"] in list("Leader","Co-Leader")))
							alert(P,"Only the team leader (Account Key: [leaderKey]) or a Co-Leader can assign someone the 'Commander' position.","Team Assignment")
					if("Executive")
						if(!(memberList["[P.key]"] in list("Leader","Co-Leader","Commander")))
							alert(P,"Only the team leader (Account Key: [leaderKey]), a Co-Leader, or a Commander can assign  someone the 'Executive' position.",
							"Team Assignment")
							return
				if(rank in verbRanks)
					P.verbs += verbRanks[rank]
				else
					P.verbs += list(/organization/verb/leave,/organization/verb/teamChat)
				memberList["[PR.key]"] = rank
				membersOnline += PR
		removeMember()
		leave()
		promoteToBodyguard()
		disband()
		teamChat(t as text)
			if(istype(usr,/player))
				var player/P = usr
				P.com.teamChat(t)

Bank
	var
		money
		interestBase
		interestType = "Simple"
		interestRate = 0.01
		bankFlags = 0
	proc
		applyInterest()
			if(interestRate=="Simple")
				money += interestBase*interestRate
			else
				money += money*interestBase
		deposit(amount,player/P)
			if((amount>P.money) || (amount < 1))
				alert(P,"You cannot deposit that much money.","Bank Vault.")
				return
			money += amount
			P.money -= amount
			P.client.moneyLabel.Text("[P.money]")
			if(interestType=="Simple")
				interestBase = money
		withdraw(amount,player/P)

proc
	get_organization(orgName)
		return locate("@organization: [orgName]")