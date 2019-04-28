TradeProxy
	New(player/P,player/S)
		P1 = P
		P2 = S
		P1.tradeProxy = src
		P2.tradeProxy = src
		P1.client.clientFlags |= LOCK_MOVEMENT
		P2.client.clientFlags |= LOCK_MOVEMENT
		P1.playerFlags |= CAN_TRADE
		P2.playerFlags |= CAN_TRADE
		P1.playerFlags |= RESPONDED
		P2.playerFlags |= RESPONDED
		winset(P1,"tradeWindow","is-visible=true")
		winset(P2,"tradeWindow","is-visible=true")
		updateTradeInterface(P1,P2)
		waitForTrade()
	Del()
		P1.client.clientFlags &= ~LOCK_MOVEMENT
		P2.client.clientFlags &= ~LOCK_MOVEMENT
		P1.playerFlags &= ~CAN_TRADE
		P2.playerFlags &= ~CAN_TRADE
		P1.playerFlags &= ~RESPONDED
		P2.playerFlags &= ~RESPONDED
		winset(P1,"tradeWindow","is-visible=false")
		winset(P2,"tradeWindow","is-visible=false")
		..()
	var
		player
			P1
			P2
		player1tradeIndex
		player2tradeIndex
	proc
		waitForTrade()
			set background = 1
			set waitfor = 0
			for(ever)
				sleep TICK_LAG
				if(player1tradeIndex && player2tradeIndex)
					var madeChoice[] = list("player1"=null,"player2"=null)
					waitForChoice(madeChoice,"player1",P1)
					waitForChoice(madeChoice,"player2",P2)
					while(isnull(madeChoice["player1"]) || isnull(madeChoice["player2"]))
						sleep TICK_LAG
					if(madeChoice["player1"] && madeChoice["player2"])
						ProcessTrade()
					else
						player1tradeIndex = null
						player2tradeIndex = null
		waitForChoice(choiceList[],theIndex,player/thePlayer)
			set waitfor = 0
			var player/PL
			var myTradeIndex
			var theirTradeIndex
			if(P1==thePlayer)
				PL = P2
				myTradeIndex = player1tradeIndex
				theirTradeIndex = player2tradeIndex
			else
				PL = P1
				myTradeIndex = player2tradeIndex
				theirTradeIndex = player1tradeIndex
			var
				pokemon
					P = thePlayer.party[myTradeIndex]
					S = PL.party[theirTradeIndex]
			if(alert(thePlayer,"Would you like to trade your [P] for [PL]'s [S]?","Confirm Trade","Yes","No")=="Yes")
				choiceList[theIndex] = TRUE
		ProcessTrade()
			/*
			if(P1.walker)
				P1.walker.loc = null
				P1.walker = null
			if(P2.walker)
				P2.walker.loc = null
				P2.walker = null*/
			var
				pokemon
					PK = P1.party[player1tradeIndex]
					PS = P2.party[player2tradeIndex]

			// If either traded pokémon is shiny, make its shiny value match the new owner's shiny value. Otherwise, make sure it's different.
			var condition
			var variable

			if(istype(PK,/pokemon))
				condition = PK.savedFlags & SHINY
				variable = "shineNumber"
			else if(istype(PK,/Egg))
				var Egg/E = PK
				condition = E.shinyNum == P1.tValue
				variable = "shinyNum"

			if(condition){if(PK.shineNumber != P2.tValue){PK.vars["[variable]"] = P2.tValue}}
			else PK.vars["[variable]"] = 0

			if(istype(PS,/pokemon))
				condition = PK.savedFlags & SHINY
				variable = "shineNumber"
			else if(istype(PS,/Egg))
				var Egg/E = PS
				condition = E.shinyNum == P1.tValue
				variable = "shinyNum"

			if(condition){if(PS.shineNumber != P1.tValue){PS.vars["[variable]"] = P1.tValue}}
			else PS.vars["[variable]"] = 0

			var {x=istype(PK,/pokemon);y=istype(PS,/pokemon)}

			if(x&&y)
				if(((PK.name == "Shelmet") && (PS.name == "Karrablast")) || ((PK.name == "Karrablast") && (PS.name == "Shelmet")))
					if((!istype(PK.held,/item/normal/Everstone)) && (!istype(PS.held,/item/normal/Everstone)))
						PK.pokemonDataFlags |= TRADE_SWAP_EVO
						PS.pokemonDataFlags |= TRADE_SWAP_EVO

			if(x || y)
				var
					turf
						T1 = null
						T2 = null
				if(PK == P1.walker)
					T1 = PK.loc
					PK.loc = null
					P1.walker = null
				if(PS == P2.walker)
					T2 = PS.loc
					PS.loc = null
					P2.walker = null
				if(T1)
					PS.loc = T1
					P2.walker = PK
				if(T2)
					PK.loc = T2
					P1.walker = PS

			PS.owner = P1
			PK.owner = P2

			istype(PS,/pokemon) && PS.evolve(new/item/normal/stone,src)
			istype(PK,/pokemon) && PK.evolve(new/item/normal/stone,src)

			P1.party[player1tradeIndex] = PS
			P2.party[player2tradeIndex] = PK

			player1tradeIndex = null
			player2tradeIndex = null

			updateTradeInterface(P1,P2)

proc
	updateTradeInterface(player/P1,player/P2)
		P1 << browse("","window=browser2")
		P2 << browse("","window=browser2")
		P1 << browse("","window=browser3")
		P2 << browse("","window=browser3")
		var Label/L1 = new(P1,"tradeWindow","theirLabel")
		var Label/L2 = new(P2,"tradeWindow","theirLabel")
		L1.Text("[P2]'s Pokémon")
		L2.Text("[P1]'s Pokémon")
		winset(P1,"tradeWindow.theirLabel",list2params(list("text"="[P2]'s Pokémon")))
		winset(P2,"tradeWindow.theirLabel",list2params(list("text"="[P1]'s Pokemon")))
		for(var/i in 1 to 6)
			var
				Label
					yourPic1 = new(P1,"tradeWindow","yourPic[i]")
					yourMon1 = new(P1,"tradeWindow","yourMon[i]")
					theirPic1 = new(P1,"tradeWindow","theirPic[i]")
					theirMon1 = new(P1,"tradeWindow","theirMon[i]")
					yourPic2 = new(P2,"tradeWindow","yourPic[i]")
					yourMon2 = new(P2,"tradeWindow","yourMon[i]")
					theirPic2 = new(P2,"tradeWindow","theirPic[i]")
					theirMon2 = new(P2,"tradeWindow","theirMon[i]")
			yourPic1.Image("")
			theirPic1.Image("")
			yourPic2.Image("")
			theirPic2.Image("")

			yourMon1.Text("")
			theirMon1.Text("")
			yourMon2.Text("")
			theirMon2.Text("")
		for(var/i in 1 to 6)
			var
				Label
					yourPic1 = new(P1,"tradeWindow","yourPic[i]")
					yourMon1 = new(P1,"tradeWindow","yourMon[i]")
					theirPic1 = new(P1,"tradeWindow","theirPic[i]")
					theirMon1 = new(P1,"tradeWindow","theirMon[i]")
					yourPic2 = new(P2,"tradeWindow","yourPic[i]")
					yourMon2 = new(P2,"tradeWindow","yourMon[i]")
					theirPic2 = new(P2,"tradeWindow","theirPic[i]")
					theirMon2 = new(P2,"tradeWindow","theirMon[i]")
			var pokemon/P = P1.party[i]
			if(!isnull(P))
				var icondata = "\ref[fcopy_rsc(P.menuIcon)]"
				yourPic1.Image(icondata)
				theirPic2.Image(icondata)
				yourMon1.Text("[P]")
				theirMon2.Text("[P]")

			P = P2.party[i]
			if(!isnull(P))
				var icondata = "\ref[fcopy_rsc(P.menuIcon)]"
				yourPic2.Image(icondata)
				theirPic1.Image(icondata)
				yourMon2.Text("[P]")
				theirMon1.Text("[P]")

player
	proc
		OpenTrade(player/partner)
			var TradeProxy/T = new(src,partner)
			src.client.clientFlags |= LOCK_MOVEMENT
			partner.client.clientFlags |= LOCK_MOVEMENT
			src.tradeProxy = T
			partner.tradeProxy = T
			updateTradeInterface(src,partner)
			winset(src,"tradeWindow","is-visible=true")
			winset(partner,"tradeWindow","is-visible=true")
	verb
		cancelTrade()
			set hidden = 1
			del tradeProxy
		tradeButton(index as num)
			set hidden = 1
			if(isnull(src.tradeProxy))return
			var pokemon/P = src.party[index]
			var player/PL
			if(isnull(P))return
			if(src==tradeProxy.P1)
				tradeProxy.player1tradeIndex = index
				PL = tradeProxy.P2
			else
				tradeProxy.player2tradeIndex = index
				PL = tradeProxy.P1

			src << browse_rsc(P.fsprite.icon,"Trade Image 1.gif")
			src << browse_rsc(file("Trade Box 1.css"))
			src << browse(file("Trade Box 1.htm"),"window=browser2")

			PL << browse_rsc(P.fsprite.icon,"Trade Image 2.gif")
			PL << browse_rsc(file("Trade Box 2.css"))
			PL << browse(file("Trade Box 2.htm"),"window=browser3")
		checkButton(index as num)
			set hidden = 1
			if(isnull(src.tradeProxy))return
			var player/PL
			if(src==tradeProxy.P1)
				PL = tradeProxy.P2
			else
				PL = tradeProxy.P1
			var pokemon/P = PL.party[index]
			if(isnull(P))return
			ShowSummary(P)