
item
	parent_type = /obj
	var
		itemstack = 1
		tmp
			canHold = TRUE
			canUse = TRUE
			canUseInBattle = FALSE
			cost = 200
			consume = FALSE
	icon = 'Main Items.dmi'
	Crossed(atom/movable/O)
		. = ..()
		if(istype(O,/player))
			var player/P = O
			P.bag.addItem(src.type)
			src.loc = null
	Topic(href,href_list[])
		switch(href_list["action"])
			if("buy")
				var player/tMob = locate(href_list["tMob"])
				if(isnull(tMob))return
				var count = input(tMob,"How much [src.name]\s would you like to buy?","How Much?",1) as num|null
				if(!count)return
				if(alert(tMob,"Are you sure you want to buy [count] [src.name]\s?","Are You Sure?","Yes","No")=="Yes")
					src.Buy(tMob,count)
			if("use")
				var player/P = locate(href_list["tMob"])
				if(isnull(P))return
				if(src.canUse)src.Use(P)
				else P.ShowText("Professor Oak's voice echoed in your head: You cannot use that item now.")
			if("give")
				var
					player/P = locate(href_list["tMob"])
					Label/itemHeld = new(P,"PKMNSummary","itemLabel")
					Button/itemButton = new(P,"PKMNSummary","itemButton")
					pokemon/SK
				if(!isnull(P.summaryMon))
					if(alert(P,"Are you sure you want to give \the [src] to [P.summaryMon]?","Give the Item","Yes","No")=="Yes")
						P.summaryMon.held = P.bag.getItem(src.type)
						SK = P.summaryMon
						winset(P.client,"bagWindow","is-visible=false")
						itemHeld.Text("Item: [src]")
						itemButton.Text("Take")
				else
					var thePokemon[0]
					for(var/i in 1 to 6)
						var pokemon/PK = P.party[i]
						if(istype(PK,/pokemon))
							thePokemon["Party Slot [i] - [PK.name]"] = PK
					if(!length(thePokemon))return
					var pokemon/PK = input(P,"Which Pokémon will you give the [src] to?","Give the Item") as null|anything in thePokemon
					if(isnull(PK))return
					PK = thePokemon[PK]
					if(!isnull(PK.held))
						P.bag.addItem(PK.held.type)
					PK.held = P.bag.getItem(src.type)
					SK = PK
					P.updateBag()
					itemHeld.Text("Item: [src]")
					itemButton.Text("Take")
				if(SK)
					if(SK.pName in list("Groudon","Kyogre","Giratina","Arceus","Silvally"))
						SK.formChange()
			else
				return
	proc
		battleUse(player/P,pokemon/A,pokemon/D)
		Use(player/P)
			if(canUse)
				if(P.client.battle)
					if(canUseInBattle)
						winset(P,"bagWindow","is-visible=false")
						return TRUE
					else
						return FALSE
				else
					winset(P,"bagWindow","is-visible=false")
					return TRUE
			else
				return FALSE
		Buy(player/P,count=1)
			if(istype(P,/player))
				if(P.money >= (src.cost*count))
					P.ShowText("You have bought [count] [src.name]\s.")
					P.bag.addItem(src.type,count)
					P.money -= (src.cost*count)
					P.client.moneyLabel.Text("[P.money]")
					return TRUE
				else
					P.ShowText("You don't have enough money.")
					return FALSE
		Sell(player/P,count=1)
		Trash(player/P)
	medicine
		var tmp/pokemon/useTarget
		proc
			activate(player/P)
		battleUse(player/P,pokemon/A,pokemon/D)return activate(P)
		Use(player/P)
			. = ..()
			if(.)
				for(var/x in 1 to 6)
					winset(P,"PartySwap.partySwap[x]","command=useItem+[x]+%22\ref[src]%22")
					if(!isnull(P.party[x]))
						var pokemon/PK = P.party[x]
						winset(P,"PartySwap.partyBattle[x]",list2params(list("text"="[PK.name]")))
						winset(P,"PartySwap.partySwap[x]","image=\ref[fcopy_rsc(PK.menuIcon)]")
						var barValue
						if(istype(PK,/Egg))
							barValue = 0
						else
							barValue = min(round((PK.HP/PK.maxHP)*100),100)
						winset(P,"PartySwap.healthBar[x]","is-visible=true")
						winset(P,"PartySwap.healthBar[x]","value=[barValue]")
						if(barValue > 50)
							winset(P,"PartySwap.healthBar[x]","bar-color=#00FF00")
						else if(barValue > 20)
							winset(P,"PartySwap.healthBar[x]","bar-color=#FFFF00")
						else
							winset(P,"PartySwap.healthBar[x]","bar-color=#FF0000")
						if(istype(PK,/pokemon))
							var statusColor
							switch(PK.status)
								if(BURNED)
									statusColor = "ff6600"
								if(FROZEN)
									statusColor = "#add8e6"
								if(ASLEEP)
									statusColor = "#d3d3d3"
								if(POISONED)
									statusColor = "#ff00ff"
								if(BAD_POISON)
									statusColor = "#551a8b"
								if(PARALYZED)
									statusColor = "#ffff00"
								if(FAINTED)
									statusColor = "#800000"
								else
									statusColor = "#ffffff"
							winset(P,"PartySwap.partySwap[x]","background-color=[statusColor]")
						else
							winset(P,"PartySwap.partySwap[x]","background-color=#FFFFFF")
					else
						winset(P,"PartySwap.partyBattle[x]","text=")
						winset(P,"PartySwap.partySwap[x]","image=")
						winset(P,"PartySwap.healthBar[x]","is-visible=false")
				winset(P,"PartySwap.partyClose",list2params(list("text"="Nevermind")))
				winset(P,"PartySwap","is-visible=true")
				P.playerFlags |= USING_ITEM
		icon = 'Main Items.dmi'
		canUseInBattle = TRUE
		canUse = TRUE
		consume = TRUE
		Potion
			icon_state = "Potion"
			cost = 300
			activate(player/P)
				if(!istype(useTarget,/pokemon))return FALSE
				if(useTarget.HP<useTarget.maxHP)
					P.ShowText("[P] heals [useTarget] with a Potion!")
					var oldHP = useTarget.HP
					useTarget.HP = min(useTarget.HP+20,useTarget.maxHP)
					P.ShowText("[useTarget] has recovered [useTarget.HP-oldHP] health!")
					return TRUE
				else
					P.ShowText("The Potion has no effect...")
					return FALSE
		Super_Potion
			icon_state = "Super Potion"
			cost = 700
			activate(player/P)
				if(!istype(useTarget,/pokemon))return FALSE
				if(useTarget.HP<useTarget.maxHP)
					P.ShowText("[P] heals [useTarget] with a Super Potion!")
					var oldHP = useTarget.HP
					useTarget.HP = min(useTarget.HP+50,useTarget.maxHP)
					P.ShowText("[useTarget] has recovered [useTarget.HP-oldHP] health!")
					return TRUE
				else
					P.ShowText("The Super Potion had no effect...")
					return FALSE
		Hyper_Potion
			icon_state = "Hyper Potion"
			cost = 1200
			activate(player/P)
				if(!istype(useTarget,/pokemon))return FALSE
				if(useTarget.HP<useTarget.maxHP)
					P.ShowText("[P] heals [useTarget] with a Hyper Potion!")
					var oldHP = useTarget.HP
					useTarget.HP = min(useTarget.HP+200,useTarget.maxHP)
					P.ShowText("[useTarget] has recovered [useTarget.HP-oldHP] health!")
					return TRUE
				else
					P.ShowText("The Hyper Potion had no effect...")
					return FALSE
		Max_Potion
			icon_state = "Max Potion"
			cost = 2500
			activate(player/P)
				if(!istype(useTarget,/pokemon))return FALSE
				if(useTarget.HP<useTarget.maxHP)
					P.ShowText("[P] heals [useTarget] with a Max Potion!")
					var oldHP = useTarget.HP
					useTarget.HP = useTarget.maxHP
					P.ShowText("[useTarget] has recovered [useTarget.HP-oldHP] health!")
					return TRUE
				else
					P.ShowText("The Max Potion had no effect...")
					return FALSE
		Full_Restore
			icon_state = "Full Restore"
			cost = 3000
			activate(player/P)
				if(!istype(useTarget,/pokemon))return FALSE
				. = FALSE
				if(useTarget.HP<useTarget.maxHP)
					useTarget.HP = useTarget.maxHP
					. = TRUE
				if(useTarget.status!=FAINTED)
					useTarget.status = ""
					. = TRUE
				if(useTarget.volatileStatus["Confusion"]>0)
					useTarget.volatileStatus["Confusion"] = 0
					. = TRUE
				if(!.)
					P.ShowText("The Full Restore had no effect...")
				else
					P.ShowText("[useTarget] has fully recovered due to [P]'s Full Restore!")
		Antidote
			icon_state = "Antidote"
			cost = 200
			activate(player/P)
				if(!istype(useTarget,/pokemon))return FALSE
				if(useTarget.status in list(POISONED,BAD_POISON))
					useTarget.status = ""
					P.ShowText("[useTarget] recovered from poisoning with [P]'s Antidote!")
					return TRUE
				else
					P.ShowText("The Antidote had no effect...")
					return FALSE
		Burn_Heal
			icon_state = "Burn Heal"
			cost = 250
			activate(player/P)
				if(!istype(useTarget,/pokemon))return FALSE
				if(useTarget.status==BURNED)
					useTarget.status = ""
					P.ShowText("[useTarget]'s burn is no more thanks to [P]'s Burn Heal!")
					return TRUE
				else
					P.ShowText("The Burn Heal had no effect...")
					return FALSE
		Ice_Heal
			icon_state = "Ice Heal"
			cost = 250
			activate(player/P)
				if(!istype(useTarget,/pokemon))return FALSE
				if(useTarget.status==FROZEN)
					useTarget.status = ""
					P.ShowText("[useTarget]'s not frozen anymore because of [P]'s Ice Heal!")
					return TRUE
				else
					P.ShowText("The Ice Heal had no effect...")
					return FALSE
		Awakening
			icon_state = "Awakening"
			cost = 250
			activate(player/P)
				if(!istype(useTarget,/pokemon))return FALSE
				if(useTarget.status==ASLEEP)
					useTarget.status = ""
					P.ShowText("[P]'s Awakening made [useTarget] wake up!")
					return TRUE
				else
					P.ShowText("The Awakening had no effect...")
					return FALSE
		Paralyze_Heal
			icon_state = "Paralyze Heal"
			cost = 200
			activate(player/P)
				if(!istype(useTarget,/pokemon))return
				if(useTarget.status==ASLEEP)
					useTarget.status = ""
					P.ShowText("[useTarget] is no longer paralyzed because of [P]'s Paralyze Heal!")
					return TRUE
				else
					P.ShowText("The Paralyze Heal had no effect...")
					return FALSE
		Full_Heal
			icon_state = "Full Heal"
			cost = 600
			activate(player/P)
				. = FALSE
				if(!istype(useTarget,/pokemon))return FALSE
				if(useTarget.status!=FAINTED)
					if(useTarget.status!="")
						useTarget.status = ""
						. = TRUE
					if(useTarget.volatileStatus["Confusion"]>0)
						useTarget.volatileStatus["Confusion"] = 0
						. = TRUE
				if(!.)
					P.ShowText("The Full Heal had no effect...")
				else
					P.ShowText("[useTarget] is fully healthy because of [P]'s Full Heal!")
		Revive
			icon_state = "Revive"
			cost = 1500
			activate(player/P)
				if(!istype(useTarget,/pokemon))return FALSE
				if(useTarget.status==FAINTED)
					useTarget.status = ""
					useTarget.HP = floor(useTarget.maxHP/2)
					for(var/vstatus in useTarget.volatileStatus)
						useTarget.volatileStatus[vstatus] = 0
					P.ShowText("[useTarget] has been revived!")
					return TRUE
				else
					P.ShowText("[useTarget] is not dead and cannot be revived.")
					return FALSE
		Max_Revive
			icon_state = "Max Revive"
			cost = 3000
			activate(player/P)
				if(!istype(useTarget,/pokemon))return FALSE
				if(useTarget.status==FAINTED)
					useTarget.status = ""
					useTarget.HP = useTarget.maxHP
					for(var/vstatus in useTarget.volatileStatus)
						useTarget.volatileStatus[vstatus] = 0
					P.ShowText("[useTarget] has been fully revived!")
					return TRUE
				else
					P.ShowText("[useTarget] has not fainted and cannot be revived.")
					return FALSE
		Fresh_Water
			icon_state = "Fresh Water"
			cost = 200
			activate(player/P)
				if(!istype(useTarget,/pokemon))return FALSE
				if(useTarget.HP<useTarget.maxHP)
					P.ShowText("[useTarget] drinks some Fresh Water!")
					var oldHP = useTarget.HP
					useTarget.HP = min(useTarget.HP+50,useTarget.maxHP)
					P.ShowText("[useTarget] recovered [useTarget.HP-oldHP] health!")
					return TRUE
				else
					P.ShowText("[useTarget] is too full to drink anything...")
					return FALSE
		Soda_Pop
			icon_state = "Soda Pop"
			cost = 300
			activate(player/P)
				if(!istype(useTarget,/pokemon))return FALSE
				if(useTarget.HP<useTarget.maxHP)
					var sodaType = pick(prob(95);"Soda Pop",prob(1);"Orange Crush",prob(1);"Baja Blast",prob(1);"Sprite",prob(1);"Pepsi",
					prob(1);"Orange Fanta")
					var displayString = lowertext(sodaType)
					displayString = replacetext("\a [displayString]","[displayString]",sodaType)
					P.ShowText("[useTarget] drank [displayString]! It's really energizing.")
					var oldHP = useTarget.HP
					useTarget.HP = min(useTarget.HP+60,useTarget.maxHP)
					P.ShowText("[useTarget] recovered [useTarget.HP-oldHP] health!")
					return TRUE
				else
					P.ShowText("[useTarget] is too full to drink anything...")
					return FALSE
		Lemonade
			icon_state = "Lemonade"
			activate(player/P)
				if(!istype(useTarget,/pokemon))return FALSE
				if(useTarget.HP<useTarget.maxHP)
					var lemonadeType = pick(prob(48.5);"Lemonade",prob(1);"Strawberry Lemonade",prob(1);"Pomegranite Lemonade",prob(48.5);"Limeade",
					prob(1);"Cherry Limeade")
					P.ShowText("[useTarget] drank some [lemonadeType]! [genderGet(useTarget,"He")] really seemed to enjoy it.")
					var oldHP = useTarget.HP
					useTarget.HP = min(useTarget.HP+80,useTarget.maxHP)
					P.ShowText("[useTarget] recovered [useTarget.HP-oldHP] health!")
					return TRUE
				else
					P.ShowText("[useTarget] is too full to drink anything...")
					return FALSE
		Moomoo_Milk
			icon_state = "Moomoo Milk"
			cost = 100
			activate(player/P)
				if(!istype(useTarget,/pokemon))return FALSE
				if(useTarget.HP<useTarget.maxHP)
					P.ShowText("[useTarget] drank some Moomoo Milk!")
					var oldHP = useTarget.HP
					useTarget.HP = min(useTarget.HP+100,useTarget.maxHP)
					P.ShowText("[useTarget] recovered [useTarget.HP-oldHP] health!")
					return TRUE
				else
					P.ShowText("[useTarget] is too full to drink anything...")
					return FALSE
		Rage_Candy_Bar
			icon_state = "Rage Candy Bar"
			activate(player/P)
				if(!istype(useTarget,/pokemon))return FALSE
				if(useTarget.HP<useTarget.maxHP)
					P.ShowText("[useTarget] eats [P]'s Rage Candy Bar!")
					var oldHP = useTarget.HP
					useTarget.HP = min(useTarget.HP+80,useTarget.maxHP)
					P.ShowText("[useTarget] has recovered [useTarget.HP-oldHP] health!")
					return TRUE
				else
					P.ShowText("The Rage Candy Bar has no effect...")
					return FALSE
		Rare_Candy
			icon_state = "Rare Candy"
			canUseInBattle=FALSE
			activate(player/P)
				if(!istype(useTarget,/pokemon))return FALSE
				if(useTarget.level<100)
					P.ShowText("[useTarget] grew to level [useTarget.level+1]!")
					useTarget.exp = getRequiredExp(useTarget.expGroup,useTarget.level+1)
					useTarget.levelUp(TRUE,FALSE)
					if(useTarget.status==FAINTED)
						useTarget.HP = 1
						useTarget.status = ""
					return TRUE
				else
					return FALSE
		Ether{icon_state = "Ether";cost=1200;canUse=FALSE}
		Max_Ether{icon_state = "Max Ether";cost=2000;canUse=FALSE}
		Elixir
			icon_state = "Elixir"
			cost = 3000
			activate(player/P)
				. = FALSE
				if(!istype(useTarget,/pokemon))return FALSE
				for(var/pmove/M in useTarget.moves)
					if(M.PP<M.MaxPP)
						. = TRUE
						M.PP = min(M.PP+10,M.MaxPP)
				if(!.)
					P.ShowText("The Elixir has no effect...")
				else
					P.ShowText("[useTarget] had some of [genderGet(useTarget,"his")] PP restored because of an Elixir!")
		Max_Elixir
			icon_state = "Max Elixir"
			cost = 4500
			activate(player/P)
				. = FALSE
				if(!istype(useTarget,/pokemon))return FALSE
				for(var/pmove/M in useTarget.moves)
					if(M.PP<M.MaxPP)
						. = TRUE
						M.PP = M.MaxPP
				if(!.)
					P.ShowText("The Max Elixir has no effect...")
				else
					P.ShowText("[useTarget] had all of [genderGet(useTarget,"his")] PP restored because of a Max Elixir!")
		PP_Up{icon_state="PP Up";cost=9800;canUseInBattle=FALSE}
		PP_Max{icon_state="PP Max";cost=29800;canUseInBattle=FALSE}
		HP_Up{icon_state="HP Up";cost=9800;canUseInBattle=FALSE}
		Iron{icon_state="Iron";cost=9800;canUseInBattle=FALSE}
		Zinc{icon_state="Zinc";cost=9800;canUseInBattle=FALSE}
		Carbos{icon_state="Carbos";cost=9800;canUseInBattle=FALSE}
		Calcium{icon_state="Calcium";cost=9800;canUseInBattle=FALSE}
		Protien{icon_state="Protien";cost=9800;canUseInBattle=FALSE}
		Sacred_Ash{icon_state="Sacred Ash";canUseInBattle=FALSE}
		Berry_Juice
			icon_state = "Berry Juice"
			cost = 1500
			activate(player/P)
				if(!istype(useTarget,/pokemon))return FALSE
				if(useTarget.HP<useTarget.maxHP)
					P.ShowText("[useTarget] drank the Berry Juice!")
					var oldHP = useTarget.HP
					useTarget.HP = min(useTarget.HP+20,useTarget.maxHP)
					P.ShowText("[useTarget] recovered [useTarget.HP-oldHP] health!")
					return TRUE
				else
					P.ShowText("[useTarget] is too full to drink anything...")
					return FALSE
		Lava_Cookie
			icon_state="Lava Cookie"
			activate(player/P)
				. = FALSE
				if(!istype(useTarget,/pokemon))return FALSE
				if(useTarget.status!=FAINTED)
					if(useTarget.status!="")
						useTarget.status = ""
						. = TRUE
					if(useTarget.volatileStatus["Confusion"]>0)
						useTarget.volatileStatus["Confusion"] = 0
						. = TRUE
				if(!.)
					P.ShowText("The Lava Cookie won't have any effect...")
				else
					P.ShowText("[useTarget] ate a Lava Cookie and recovered fully!")
		herb
			Heal_Powder
				icon_state = "Heal Powder"
				cost = 450
				activate(player/P)
					. = FALSE
					if(!istype(useTarget,/pokemon))return FALSE
					if(useTarget.status!=FAINTED)
						if(useTarget.status!="")
							useTarget.status = ""
							. = TRUE
						if(useTarget.volatileStatus["Confusion"]>0)
							useTarget.volatileStatus["Confusion"] = 0
							. = TRUE
					if(!.)
						P.ShowText("The Heal Powder won't have any effect...")
					else
						P.ShowText("[useTarget] recovered fully with some Healing Powder!")
			Energy_Powder
				icon_state="Energy Powder"
				cost = 500
				activate(player/P)
					if(!istype(useTarget,/pokemon))return
					if(useTarget.HP<useTarget.maxHP)
						P.ShowText("[useTarget] ate some Energy Powder!")
						var oldHP = useTarget.HP
						useTarget.HP = min(useTarget.HP+50,useTarget.maxHP)
						P.ShowText("[useTarget] has recovered [useTarget.HP-oldHP] health!")
						return TRUE
					else
						P.ShowText("The Energy Powder didn't have any effect...")
						return FALSE
			Energy_Root
				icon_state = "Energy Root"
				cost = 800
				activate(player/P)
					if(!istype(useTarget,/pokemon))return FALSE
					if(useTarget.HP<useTarget.maxHP)
						P.ShowText("[useTarget] ate an Energy Root!")
						var oldHP = useTarget.HP
						useTarget.HP = min(useTarget.HP+200,useTarget.maxHP)
						P.ShowText("[useTarget] has recovered [useTarget.HP-oldHP] health!")
						return TRUE
					else
						return FALSE
			Revival_Herb
				icon_state = "Revival Herb"
				cost = 2800
				activate(player/P)
					if(!istype(useTarget,/pokemon))return FALSE
					if(useTarget.status==FAINTED)
						useTarget.status = ""
						useTarget.HP = useTarget.maxHP
						for(var/vstatus in useTarget.volatileStatus)
							useTarget.volatileStatus[vstatus] = 0
	tm
		var
			number
			movetext
			movetype
		Use(player/P)
			. = ..()
			if(.)
				if(istype(src,/item/tm/hm))
					P.ShowText("Booted up an HM.")
				else
					P.ShowText("Booted up a TM.")
				P.ShowText("It contains the move [movetext].")
				P.ShowText("Teach the move [movetext] to a Pokémon?")
				if(alert(P,"Teach the move [movetext] to a Pokémon?","Delete A Move?","Yes!","No...")!="Yes!")return
				var typedata = text2path(movetype)
				if(!typedata)
					P.ShowText("This [(istype(src,/item/tm/hm))?("HM"):("TM")]'s software crashed!")
					return
				for(var/x in 1 to 6)
					var pokemon/PK = P.party[x]
					if(!isnull(PK))
						if(!istype(PK,/pokemon))
							if(istype(PK,/datum) && ("menuIcon" in PK.vars))
								winset(P,"partyThing.party[x]","image=\ref[fcopy_rsc(PK.vars["menuIcon"])];command=")
							else
								winset(P,"partyThing.party[x]","image=\"\";command=")
						else
							var learnvalue
							if(istype(src,/item/tm/hm))
								learnvalue = (canLearnThis(PK,movetext,"HM"))?(!((locate(typedata) in PK.moves))?(1):(2)):(0)
							else
								learnvalue = (canLearnThis(PK,movetext,"TM"))?(!((locate(typedata) in PK.moves))?(1):(2)):(0)
							var thecolor
							switch(learnvalue)
								if(0)
									thecolor = "#f00"
								if(1)
									thecolor = "#0f0"
								if(2)
									thecolor = "#00f"
							var paramdata = list("background-color"=thecolor,"image"="\ref[fcopy_rsc(PK.menuIcon)]",
							"command"="TeachTMMove [x] [learnvalue] \"[movetype]\" \"[movetext]\" \"[src.type]\"")
							winset(P,"partyThing.party[x]",list2params(paramdata))
					else
						winset(P,"partyThing.party[x]","image=\"\";command=")
				winset(P,"partyThing","is-visible=true")
		NeverSave(L[])
			return ..(L+list("name"))
		permanent
			New()
				src.name = "TM([number]): [movetext]"
			TM01{icon_state="Dark TM";number="01";movetext="Hone Claws";movetype="/pmove/Hone_Claws"}
			TM02{icon_state="Dragon TM";number="02";movetext="Dragon Claw";movetype="/pmove/Dragon_Claw"}
			TM03{icon_state="Psychic TM";number="03";movetext="Psyshock";movetype="/pmove/Psyshock"}
			TM04{icon_state="Psychic TM";number="04";movetext="Calm Mind";movetype="/pmove/Calm_Mind"}
			TM05{icon_state="Normal TM";number="05";movetext="Roar";movetype="/pmove/Roar"}
			TM06{icon_state="Poison TM";number="06";movetext="Toxic";movetype="/pmove/Toxic"}
			TM07{icon_state="Ice TM";number="07";movetext="Hail";movetype="/pmove/Hail"}
			TM08{icon_state="Fighting TM";number="08";movetext="Bulk Up";movetype="/pmove/Bulk_Up"}
			TM09{icon_state="Poison TM";number="09";movetext="Venoshock";movetype="/pmove/Venoshock"}
			TM10{icon_state="Normal TM";number="10";movetext="Hidden Power";movetype="/pmove/Hidden_Power"}
			TM11{icon_state="Fire TM";number="11";movetext="Sunny Day";movetype="/pmove/Sunny_Day"}
			TM12{icon_state="Dark TM";number="12";movetext="Taunt";movetype="/pmove/Taunt"}
			TM13{icon_state="Ice TM";number="13";movetext="Ice Beam";movetype="/pmove/Ice_Beam"}
			TM14{icon_state="Ice TM";number="14";movetext="Blizzard";movetype="/pmove/Blizzard"}
			TM15{icon_state="Normal TM";number="15";movetext="Hyper Beam";movetype="/pmove/Hyper_Beam"}
			TM16{icon_state="Psychic TM";number="16";movetext="Light Screen";movetype="/pmove/Light_Screen"}
			TM17{icon_state="Normal TM";number="17";movetext="Protect";movetype="/pmove/Protect"}
			TM18{icon_state="Water TM";number="18";movetext="Rain Dance";movetype="/pmove/Rain_Dance"}
			TM19{icon_state="Flying TM";number="19";movetext="Roost";movetype="/pmove/Roost"}
			TM20{icon_state="Normal TM";number="20";movetext="Safeguard";movetype="/pmove/Safeguard"}
			TM21{icon_state="Normal TM";number="21";movetext="Frustration";movetype="/pmove/Frustration"}
			TM22{icon_state="Grass TM";number="22";movetext="Solar Beam";movetype="/pmove/Solar_Beam"}
			TM23{icon_state="Rock TM";number="23";movetext="Smack Down";movetype="/pmove/Smack_Down"}
			TM24{icon_state="Electric TM";number="24";movetext="Thunderbolt";movetype="/pmove/Thunderbolt"}
			TM25{icon_state="Electric TM";number="25";movetext="Thunder";movetype="/pmove/Thunder"}
			TM26{icon_state="Ground TM";number="26";movetext="Earthquake";movetype="/pmove/Earthquake"}
			TM27{icon_state="Normal TM";number="27";movetext="Return";movetype="/pmove/Return"}
			TM28{icon_state="Ground TM";number="28";movetext="Dig";movetype="/pmove/Dig"}
			TM29{icon_state="Psychic TM";number="29";movetext="Psychic";movetype="/pmove/Psychic"}
			TM30{icon_state="Ghost TM";number="30";movetext="Shadow Ball";movetype="/pmove/Shadow_Ball"}
			TM31{icon_state="Fighting TM";number="31";movetext="Brick Break";movetype="/pmove/Brick_Break"}
			TM32{icon_state="Normal TM";number="32";movetext="Double Team";movetype="/pmove/Double_Team"}
			TM33{icon_state="Psychic TM";number="33";movetext="Reflect";movetype="/pmove/Reflect"}
			TM34{icon_state="Poison TM";number="34";movetext="Sludge Wave";movetype="/pmove/Sludge_Wave"}
			TM35{icon_state="Fire TM";number="35";movetext="Flamethrower";movetype="/pmove/Flamethrower"}
			TM36{icon_state="Poison TM";number="36";movetext="Sludge Bomb";movetype="/pmove/Sludge_Bomb"}
			TM37{icon_state="Rock TM";number="37";movetext="Sandstorm";movetype="/pmove/Sandstorm"}
			TM38{icon_state="Fire TM";number="38";movetext="Fire Blash";movetype="/pmove/Fire_Blast"}
			TM39{icon_state="Rock TM";number="39";movetext="Rock Tomb";movetype="/pmove/Rock_Tomb"}
			TM40{icon_state="Flying TM";number="40";movetext="Aerial Ace";movetype="/pmove/Aerial_Ace"}
			TM41{icon_state="Dark TM";number="41";movetext="Torment";movetype="/pmove/Torment"}
			TM42{icon_state="Normal TM";number="42";movetext="Facade";movetype="/pmove/Facade"}
			TM43{icon_state="Fire TM";number="43";movetext="Flame Charge";movetype="/pmove/Flame_Charge"}
			TM44{icon_state="Psychic TM";number="44";movetext="Rest";movetype="/pmove/Rest"}
			TM45{icon_state="Normal TM";number="45";movetext="Attract";movetype="/pmove/Attract"}
			TM46{icon_state="Dark TM";number="46";movetext="Thief";movetype="/pmove/Thief"}
			TM47{icon_state="Fighting TM";number="47";movetext="Low Sweep";movetype="/pmove/Low_Sweep"}
			TM48{icon_state="Normal TM";number="48";movetext="Round";movetype="/pmove/Round"}
			TM49{icon_state="Normal TM";number="49";movetext="Echoed Voice";movetype="/pmove/Echoed_Voice"}
			TM50{icon_state="Fire TM";number="50";movetext="Overheat";movetype="/pmove/Overheat"}
			TM51{icon_state="Steel TM";number="51";movetext="Steel Wing";movetype="/pmove/Steel_Wing"}
			TM52{icon_state="Fighting TM";number="52";movetext="Focus Blast";movetype="/pmove/Focus_Blast"}
			TM53{icon_state="Grass TM";number="53";movetext="Energy Ball";movetype="/pmove/Energy_Ball"}
			TM54{icon_state="Normal TM";number="54";movetext="False Swipe";movetype="/pmove/False_Swipe"}
			TM55{icon_state="Water TM";number="55";movetext="Scald";movetype="/pmove/Scald"}
			TM56{icon_state="Dark TM";number="56";movetext="Fling";movetype="/pmove/Fling"}
			TM57{icon_state="Electric TM";number="57";movetext="Charge Beam";movetype="/pmove/Charge_Beam"}
			TM58{icon_state="Flying TM";number="58";movetext="Sky Drop";movetype="/pmove/Sky_Drop"}
			TM59{icon_state="Fire TM";number="59";movetext="Incinerate";movetype="/pmove/Incinerate"}
			TM60{icon_state="Dark TM";number="60";movetext="Quash";movetype="/pmove/Quash"}
			TM61{icon_state="Fire TM";number="61";movetext="Will-O-Wisp";movetype="/pmove/Will-O-Wisp"}
			TM62{icon_state="Flying TM";number="62";movetext="Acrobatics";movetype="/pmove/Acrobatics"}
			TM63{icon_state="Dark TM";number="63";movetext="Embargo";movetype="/pmove/Embargo"}
			TM64{icon_state="Normal TM";number="64";movetext="Explosion";movetype="/pmove/Explosion"}
			TM65{icon_state="Ghost TM";number="65";movetext="Shadow Claw";movetype="/pmove/Shadow_Claw"}
			TM66{icon_state="Dark TM";number="66";movetext="Payback";movetype="/pmove/Payback"}
			TM67{icon_state="Normal TM";number="67";movetext="Retaliate";movetype="/pmove/Retaliate"}
			TM68{icon_state="Normal TM";number="68";movetext="Giga Impact";movetype="/pmove/Giga_Impact"}
			TM69{icon_state="Rock TM";number="69";movetext="Rock Polish";movetype="/pmove/Rock_Polish"}
			TM70{icon_state="Dragon TM";number="70";movetext="Dragon Pulse";movetype="/pmove/Dragon_Pulse"}
			TM71{icon_state="Rock TM";number="71";movetext="Stone Edge";movetype="/pmove/Stone_Edge"}
			TM72{icon_state="Electric TM";number="72";movetext="Volt Switch";movetype="/pmove/Volt_Switch"}
			TM73{icon_state="Electric TM";number="73";movetext="Thunder Wave";movetype="/pmove/Thunder_Wave"}
			TM74{icon_state="Steel TM";number="74";movetext="Gyro Ball";movetype="/pmove/Gyro_Ball"}
			TM75{icon_state="Normal TM";number="75";movetext="Swords Dance";movetype="/pmove/Swords_Dance"}
			TM76{icon_state="Bug TM";number="76";movetext="Struggle Bug";movetype="/pmove/Struggle_Bug"}
			TM77{icon_state="Normal TM";number="77";movetext="Psych Up";movetype="/pmove/Psych_Up"}
			TM78{icon_state="Ground TM";number="78";movetext="Bulldoze";movetype="/pmove/Bulldoze"}
			TM79{icon_state="Ice TM";number="79";movetext="Frost Breath";movetype="/pmove/Frost_Breath"}
			TM80{icon_state="Rock TM";number="80";movetext="Rock Slide";movetype="/pmove/Rock_Slide"}
			TM81{icon_state="Bug TM";number="81";movetext="X-Scissor";movetext="/pmove/X-Scissor"}
			TM82{icon_state="Dragon TM";number="82";movetext="Dragon Tail";movetype="/pmove/Dragon_Tail"}
			TM83{icon_state="Bug TM";number="83";movetext="Infestation";movetype="/pmove/Infestation"}
			TM84{icon_state="Poison TM";number="84";movetext="Poison Jab";movetype="/pmove/Poison_Jab"}
			TM85{icon_state="Psychic TM";number="85";movetext="Dream Eater";movetype="/pmove/Dream_Eater"}
			TM86{icon_state="Grass TM";number="86";movetext="Grass Knot";movetype="/pmove/Grass_Knot"}
			TM87{icon_state="Normal TM";number="87";movetext="Swagger";movetype="/pmove/Swagger"}
			TM88{icon_state="Normal TM";number="88";movetext="Sleep Talk";movetype="/pmove/Sleep Talk"}
			TM89{icon_state="Bug TM";number="89";movetext="U-turn";movetype="/pmove/U-turn"}
			TM90{icon_state="Normal TM";number="90";movetext="Substitute";movetype="/pmove/Substitute"}
			TM91{icon_state="Steel TM";number="91";movetext="Flash Cannon";movetype="/pmove/Flash_Cannon"}
			TM92{icon_state="Psychic TM";number="92";movetext="Trick Room";movetype="/pmove/Trick_Room"}
			TM93{icon_state="Electric TM";number="93";movetext="Wild Charge";movetype="/pmove/Wild_Charge"}
			TM94{icon_state="Normal TM";number="94";movetext="Secret Power";movetype="/pmove/Secret_Power"}
			TM95{icon_state="Dark TM";number="95";movetext="Snarl";movetype="/pmove/Snarl"}
			TM96{icon_state="Normal TM";number="96";movetext="Nature Power";movetype="/pmove/Nature_Power"}
			TM97{icon_state="Dark TM";number="97";movetext="Dark Pulse";movetype="/pmove/Dark_Pulse"}
			TM98{icon_state="Fighting TM";number="98";movetext="Power-Up Punch";movetype="/pmove/Power-Up_Punch"}
			TM99{icon_state="Psychic TM";number="99";movetext="Dazzling_Gleam";movetype="/pmove/Dazzling_Gleam"}
			TM100{icon_state="Normal TM";number="100";movetext="Confide";movetype="/pmove/Confide"}
			TM101{icon_state="Rock TM";number="101";movetext="Stealth Rock";movetype="/pmove/Stealth_Rock"}
		disposable
			TM2 // Unobtainable within gameplay on PUN. Must be imported from Generation 1 or Generation 2 games.
				New()
					src.name = "TM2([number]): [movetext]"
				TM01{icon_state="Fighting TM";number="01";movetext="Dynamic Punch";movetype="/pmove/Dynamic_Punch"}
				TM02{icon_state="Normal TM";number="02";movetext="Headbutt";movetype="/pmove/Headbutt"}
				TM03{icon_state="Ghost TM";number="03";movetext="Curse";movetype="/pmove/Curse"}
				TM04{icon_state="Rock TM";number="04";movetext="Rollout";movetype="/pmove/Rollout"}
				TM05{icon_state="Normal TM";number="05";movetext="Roar";movetype="/pmove/Roar"}
				TM06{icon_state="Poison TM";number="06";movetext="Toxic";movetype="/pmove/Toxic"}
				TM07{icon_state="Electric TM";number="07";movetext="Zap Cannon";movetype="/pmove/Zap_Cannon"}
				TM08{icon_state="Fighting TM";number="08";movetext="Rock Smash";movetype="/pmove/Rock_Smash"}
				TM09{icon_state="Normal TM";number="09";movetext="Psych Up";movetype="/pmove/Psych_Up"}
				TM10{icon_state="Normal TM";number="10";movetext="Hidden Power";movetype="/pmove/Hidden_Power"}
				TM11{icon_state="Fire TM";number="11";movetext="Sunny Day";movetype="/pmove/Sunny_Day"}
				TM12{icon_state="Normal TM";number="12";movetext="Sweet Scent";movetype="/pmove/Sweet_Scent"}
				TM13{icon_state="Normal TM";number="13";movetext="Snore";movetype="/pmove/Snore"}
				TM14{icon_state="Ice TM";number="14";movetext="Blizzard";movetype="/pmove/Blizzard"}
				TM15{icon_state="Normal TM";number="15";movetext="Hyper Beam";movetype="/pmove/Hyper_Beam"}
				TM16{icon_state="Ice TM";number="16";movetext="Icy Wind";movetype="/pmove/Icy_Wind"}
				TM17{icon_state="Normal TM";number="17";movetext="Protect";movetype="/pmove/Protect"}
				TM18{icon_state="Water TM";number="18";movetext="Rain Dance";movetype="/pmove/Rain_Dance"}
				TM19{icon_state="Grass TM";number="19";movetext="Giga Drain";movetype="/pmove/Giga_Drain"}
				TM20{icon_state="Normal TM";number="20";movetext="Endure";movetype="/pmove/Endure"}
				TM21{icon_state="Normal TM";number="21";movetext="Frustration";movetype="/pmove/Frustration"}
				TM22{icon_state="Grass TM";number="22";movetext="Solar Beam";movetype="/pmove/Solar_Beam"}
				TM23{icon_state="Steel TM";number="23";movetext="Iron Tail";movetype="/pmove/Iron_Tail"}
				TM24{icon_state="Dragon TM";number="24";movetext="Dragon Breath";movetype="/pmove/Dragon_Breath"}
				TM25{icon_state="Electric TM";number="25";movetext="Thunder";movetype="/pmove/Thunder"}
				TM26{icon_state="Ground TM";number="26";movetext="Earthquake";movetype="/pmove/Earthquake"}
				TM27{icon_state="Normal TM";number="27";movetext="Return";movetype="/pmove/Return"}
				TM28{icon_state="Ground TM";number="28";movetext="Dig";movetype="/pmove/Dig"}
				TM29{icon_state="Psychic TM";number="29";movetext="Psychic";movetype="/pmove/Psychic"}
				TM30{icon_state="Ghost TM";number="30";movetext="Shadow Ball";movetype="/pmove/Shadow_Ball"}
				TM31{icon_state="Ground TM";number="31";movetext="Mud-Slap";movetype="/pmove/Mud-Slap"}
				TM32{icon_state="Normal TM";number="32";movetext="Double Team";movetype="/pmove/Double_Team"}
				TM33{icon_state="Ice TM";number="33";movetext="Ice Punch";movetype="/pmove/Ice_Punch"}
				TM34{icon_state="Normal TM";number="34";movetext="Swagger";movetype="/pmove/Swagger"}
				TM35{icon_state="Normal TM";number="35";movetext="Sleep Talk";movetype="/pmove/Sleep_Talk"}
				TM36{icon_state="Poison TM";number="36";movetext="Sludge Bomb";movetype="/pmove/Sludge_Bomb"}
				TM37{icon_state="Rock TM";number="37";movetext="Sandstorm";movetype="/pmove/Sandstorm"}
				TM38{icon_state="Fire TM";number="38";movetext="Fire Blast";movetype="/pmove/Fire_Blast"}
				TM39{icon_state="Normal TM";number="39";movetext="Swift";movetype="/pmove/Swift"}
				TM40{icon_state="Normal TM";number="40";movetext="Defense Curl";movetype="/pmove/Defense_Curl"}
				TM41{icon_state="Electric TM";number="41";movetext="Thunder Punch";movetype="/pmove/Thunder Punch"}
				TM42{icon_state="Psychic TM";number="42";movetext="Dream Eater";movetype="/pmove/Dream_Eater"}
				TM43{icon_state="Fighting TM";number="43";movetext="Detect";movetype="/pmove/Detect"}
				TM44{icon_state="Psychic TM";number="44";movetext="Rest";movetype="/pmove/Rest"}
				TM45{icon_state="Normal TM";number="45";movetext="Attract";movetype="/pmove/Attract"}
				TM46{icon_state="Dark TM";number="46";movetext="Thief";movetype="/pmove/Thief"}
				TM47{icon_state="Steel TM";number="47";movetext="Steel Wing";movetype="/pmove/Steel_Wing"}
				TM48{icon_state="Fire TM";number="48";movetext="Fire Punch";movetype="/pmove/Fire_Punch"}
				TM49{icon_state="Bug TM";number="49";movetext="Fury Cutter";movetype="/pmove/Fury_Cutter"}
				TM50{icon_state="Ghost TM";number="50";movetext="Nightmare";movetype="/pmove/Nightmare"}
			TM3 // Unobtainable within gameplay on PUN. Must be imported from Generation 3 or Generation 4 games.
				New()
					src.name = "TM3([number]): [movetext]"
				TM01{icon_state="Fighting TM";number="01";movetext="Focus Punch";movetype="/pmove/Focus_Punch"}
				TM02{icon_state="Dragon TM";number="02";movetext="Dragon Claw";movetype="/pmove/Dragon_Claw"}
				TM03{icon_state="Water TM";number="03";movetext="Water Pulse";movetype="/pmove/Water_Pulse"}
				TM04{icon_state="Psychic TM";number="04";movetext="Calm Mind";movetype="/pmove/Calm_Mind"}
				TM05{icon_state="Normal TM";number="05";movetext="Roar";movetype="/pmove/Roar"}
				TM06{icon_state="Poison TM";number="06";movetext="Toxic";movetype="/pmove/Toxic"}
				TM07{icon_state="Ice TM";number="07";movetext="Hail";movetype="/pmove/Hail"}
				TM08{icon_state="Fighting TM";number="08";movetext="Bulk Up";movetype="/pmove/Bulk_Up"}
				TM09{icon_state="Grass TM";number="09";movetext="Bullet Seed";movetype="/pmove/Bullet_Seed"}
				TM10{icon_state="Normal TM";number="10";movetext="Hidden Power";movetype="/pmove/Hidden_Power"}
				TM11{icon_state="Fire TM";number="11";movetext="Sunny Day";movetype="/pmove/Sunny_Day"}
				TM12{icon_state="Dark TM";number="12";movetext="Taunt";movetype="/pmove/Taunt"}
				TM13{icon_state="Ice TM";number="13";movetext="Ice Beam";movetype="/pmove/Ice_Beam"}
				TM14{icon_state="Ice TM";number="14";movetext="Blizzard";movetype="/pmove/Blizzard"}
				TM15{icon_state="Normal TM";number="15";movetext="Hyper Beam";movetype="/pmove/Hyper_Beam"}
				TM16{icon_state="Psychic TM";number="16";movetext="Light Screen";movetype="/pmove/Light_Screen"}
				TM17{icon_state="Normal TM";number="17";movetext="Protect";movetype="/pmove/Protect"}
				TM18{icon_state="Water TM";number="18";movetext="Rain Dance";movetype="/pmove/Rain_Dance"}
				TM19{icon_state="Grass TM";number="19";movetext="Giga Drain";movetype="/pmove/Giga_Drain"}
				TM20{icon_state="Normal TM";number="20";movetext="Safeguard";movetype="/pmove/Safeguard"}
				TM21{icon_state="Normal TM";number="21";movetext="Frustration";movetype="/pmove/Frustration"}
				TM22{icon_state="Grass TM";number="22";movetext="Solar Beam";movetype="/pmove/Solar_Beam"}
				TM23{icon_state="Steel TM";number="23";movetext="Iron Tail";movetype="/pmove/Iron_Tail"}
				TM24{icon_state="Electric TM";number="24";movetext="Thunderbolt";movetype="/pmove/Thunderbolt"}
				TM25{icon_state="Electric TM";number="25";movetext="Thunder";movetype="/pmove/Thunder"}
				TM26{icon_state="Ground TM";number="26";movetext="Earthquake";movetype="/pmove/Earthquake"}
				TM27{icon_state="Normal TM";number="27";movetext="Return";movetype="/pmove/Return"}
				TM28{icon_state="Ground TM";number="28";movetext="Dig";movetype="/pmove/Dig"}
				TM29{icon_state="Psychic TM";number="29";movetext="Psychic";movetype="/pmove/Psychic"}
				TM30{icon_state="Ghost TM";number="30";movetext="Shadow Ball";movetype="/pmove/Shadow_Ball"}
				TM31{icon_state="Fighting TM";number="31";movetext="Brick Break";movetype="/pmove/Brick_Break"}
				TM32{icon_state="Normal TM";number="32";movetext="Double Team";movetype="/pmove/Double_Team"}
				TM33{icon_state="Psychic TM";number="33";movetext="Reflect";movetype="/pmove/Reflect"}
				TM34{icon_state="Electric TM";number="34";movetext="Shock Wave";movetype="/pmove/Shock_Wave"}
				TM35{icon_state="Fire TM";number="35";movetext="Flamethrower";movetype="/pmove/Flamethrower"}
				TM36{icon_state="Poison TM";number="36";movetext="Sludge Bomb";movetype="/pmove/Sludge_Bomb"}
				TM37{icon_state="Rock TM";number="37";movetext="Sandstorm";movetype="/pmove/Sandstorm"}
				TM38{icon_state="Fire TM";number="38";movetext="Fire Blash";movetype="/pmove/Fire_Blast"}
				TM39{icon_state="Rock TM";number="39";movetext="Rock Tomb";movetype="/pmove/Rock_Tomb"}
				TM40{icon_state="Flying TM";number="40";movetext="Aerial Ace";movetype="/pmove/Aerial_Ace"}
				TM41{icon_state="Dark TM";number="41";movetext="Torment";movetype="/pmove/Torment"}
				TM42{icon_state="Normal TM";number="42";movetext="Facade";movetype="/pmove/Facade"}
				TM43{icon_state="Normal TM";number="43";movetext="Secret Power";movetype="/pmove/Secret_Power"}
				TM44{icon_state="Psychic TM";number="44";movetext="Rest";movetype="/pmove/Rest"}
				TM45{icon_state="Normal TM";number="45";movetext="Attract";movetype="/pmove/Attract"}
				TM46{icon_state="Dark TM";number="46";movetext="Thief";movetype="/pmove/Thief"}
				TM47{icon_state="Steel TM";number="47";movetext="Steel Wing";movetype="/pmove/Steel_Wing"}
				TM48{icon_state="Psychic TM";number="48";movetext="Skill Swap";movetype="/pmove/Skill_Swap"}
				TM49{icon_state="Dark TM";number="49";movetext="Snatch";movetype="/pmove/Snatch"}
				TM50{icon_state="Fire TM";number="50";movetext="Overheat";movetype="/pmove/Overheat"}
				TM51{icon_state="Flying TM";number="51";movetext="Roost";movetype="/pmove/Roost"}
				TM52{icon_state="Fighting TM";number="52";movetext="Focus Blast";movetype="/pmove/Focus_Blast"}
				TM53{icon_state="Grass TM";number="53";movetext="Energy Ball";movetype="/pmove/Energy_Ball"}
				TM54{icon_state="Normal TM";number="54";movetext="False Swipe";movetype="/pmove/False_Swipe"}
				TM55{icon_state="Water TM";number="55";movetext="Brine";movetype="/pmove/Brine"}
				TM56{icon_state="Dark TM";number="56";movetext="Fling";movetype="/pmove/Fling"}
				TM57{icon_state="Electric TM";number="57";movetext="Charge Beam";movetype="/pmove/Charge_Beam"}
				TM58{icon_state="Normal TM";number="58";movetext="Endure";movetype="/pmove/Endure"}
				TM59{icon_state="Dragon TM";number="59";movetext="Dragon Pulse";movetype="/pmove/Dragon_Pulse"}
				TM60{icon_state="Fighting TM";number="60";movetext="Drain Punch";movetype="/pmove/Drain_Punch"}
				TM61{icon_state="Fire TM";number="61";movetext="Will-O-Wisp";movetype="/pmove/Will-O-Wisp"}
				TM62{icon_state="Bug TM";number="62";movetext="Silver Wind";movetype="/pmove/Silver_Wind"}
				TM63{icon_state="Dark TM";number="63";movetext="Embargo";movetype="/pmove/Embargo"}
				TM64{icon_state="Normal TM";number="64";movetext="Explosion";movetype="/pmove/Explosion"}
				TM65{icon_state="Ghost TM";number="65";movetext="Shadow Claw";movetype="/pmove/Shadow_Claw"}
				TM66{icon_state="Dark TM";number="66";movetext="Payback";movetype="/pmove/Payback"}
				TM67{icon_state="Normal TM";number="67";movetext="Recycle";movetype="/pmove/Recycle"}
				TM68{icon_state="Normal TM";number="68";movetext="Giga Impact";movetype="/pmove/Giga_Impact"}
				TM69{icon_state="Rock TM";number="69";movetext="Rock Polish";movetype="/pmove/Rock_Polish"}
				TM70{icon_state="Light TM";number="70";movetext="Flash";movetype="/pmove/Flash"}
				TM71{icon_state="Rock TM";number="71";movetext="Stone Edge";movetype="/pmove/Stone_Edge"}
				TM72{icon_state="Ice TM";number="72";movetext="Avalanche";movetype="/pmove/Avalanche"}
				TM73{icon_state="Electric TM";number="73";movetext="Thunder Wave";movetype="/pmove/Thunder_Wave"}
				TM74{icon_state="Steel TM";number="74";movetext="Gyro Ball";movetype="/pmove/Gyro_Ball"}
				TM75{icon_state="Normal TM";number="75";movetext="Swords Dance";movetype="/pmove/Swords_Dance"}
				TM76{icon_state="Rock TM";number="76";movetext="Stealth Rock";movetype="/pmove/Stealth_Rock"}
				TM77{icon_state="Normal TM";number="77";movetext="Psych Up";movetype="/pmove/Psych_Up"}
				TM78{icon_state="Normal TM";number="78";movetext="Captivate";movetype="/pmove/Captivate"}
				TM79{icon_state="Dark TM";number="79";movetext="Dark Pulse";movetype="/pmove/Dark_Pulse"}
				TM80{icon_state="Rock TM";number="80";movetext="Rock Slide";movetype="/pmove/Rock_Slide"}
				TM81{icon_state="Bug TM";number="81";movetext="X-Scissor";movetext="/pmove/X-Scissor"}
				TM82{icon_state="Normal TM";number="82";movetext="Sleep Talk";movetype="/pmove/Sleep_Talk"}
				TM83{icon_state="Normal TM";number="83";movetext="Natural Gift";movetype="/pmove/Natural_Gift"}
				TM84{icon_state="Poison TM";number="84";movetext="Poison Jab";movetype="/pmove/Poison_Jab"}
				TM85{icon_state="Psychic TM";number="85";movetext="Dream Eater";movetype="/pmove/Dream_Eater"}
				TM86{icon_state="Grass TM";number="86";movetext="Grass Knot";movetype="/pmove/Grass_Knot"}
				TM87{icon_state="Normal TM";number="87";movetext="Swagger";movetype="/pmove/Swagger"}
				TM88{icon_state="Flying TM";number="88";movetext="Pluck";movetype="/pmove/Pluck"}
				TM89{icon_state="Bug TM";number="89";movetext="U-turn";movetype="/pmove/U-turn"}
				TM90{icon_state="Normal TM";number="90";movetext="Substitute";movetype="/pmove/Substitute"}
				TM91{icon_state="Steel TM";number="91";movetext="Flash Cannon";movetype="/pmove/Flash_Cannon"}
				TM92{icon_state="Psychic TM";number="92";movetext="Trick Room";movetype="/pmove/Trick_Room"}
		hm
			New()
				..()
				name = "HM[number]: [movetext]"
			HM01{icon_state="Grass HM";number="01";movetext="Cut";movetype="/pmove/Cut"}
			HM02{icon_state="Flying HM";number="02";movetext="Fly";movetype="/pmove/Fly"}
			HM03{icon_state="Water HM";number="03";movetext="Surf";movetype="/pmove/Surf"}
			HM04{icon_state="Fighting HM";number="04";movetext="Strength";movetype="/pmove/Strength"}
			HM05{icon_state="Light HM";number="05";movetext="Flash";movetype="/pmove/Flash"}
			HM06{icon_state="Water HM";number="06";movetext="Waterfall";movetype="/pmove/Waterfall"}
			HM07{icon_state="Fighting HM";number="07";movetext="Rock Smash";movetype="/pmove/Rock_Smash"}
			HM08{icon_state="Water HM";number="08";movetext="Dive";movetype="/pmove/Dive"}
			HM09{icon_state="Water HM";number="09";movetext="Whirlpool";movetype="/pmove/Whirlpool"}
			HM10{icon_state="Rock HM";number="10";movetext="Rock Climb";movetype="/pmove/Rock_Climb"}
			HM11{icon_state="Flying HM";number="11";movetext="Defog";movetype="/pmove/Defog"}
	normal
		flute
			canUseInBattle=TRUE
			Blue_Flute{icon_state="Blue Flute"}
			Yellow_Flute{icon_state="Yellow Flute"}
			Red_Flute{icon_state="Red Flute"}
			Black_Flute{icon_state="Black Flute"}
			White_Flute{icon_state="White Flute"}
		repellent
			var repelsteps
			Use(player/P)
				. = ..()
				if(.)
					if(P.repelsteps > 0)
						P.ShowText("The effects of a Repel still linger from earlier...")
					else
						P.repelsteps = repelsteps
						P.ShowText("You sprayed yourself with the [src]")
						P.bag.getItem(src.type)
			Repel{icon_state="Repel";repelsteps=100;cost=350}
			Super_Repel{icon_state = "Super Repel";repelsteps = 200;cost=500}
			Max_Repel{icon_state = "Max Repel";repelsteps = 250;cost=700}
		fossil
			Dome_Fossil{icon_state="Dome Fossil"}
			Helix_Fossil{icon_state="Helix Fossil"}
			Old_Amber{icon_state="Old Amber"}
			Root_Fossil{icon_state="Root Fossil"}
			Claw_Fossil{icon_state="Claw Fossil"}
			Armor_Fossl{icon_state="Armor Fossil"}
			Skull_Fossil{icon_state="Skull Fossil"}
			Plume_Fossil{icon_state="Plume Fossil"}
			Cover_Fossil{icon_state="Cover Fossil"}
			Jaw_Fossil{icon_state="Jaw Fossil"}
			Sail_Fossil{icon_state="Sail Fossil"}
		stat_item
			Eviolite{icon_state = "Eviolite"}
			Muscle_Band{icon_state = "Muscle Band"}
			Wise_Glasses{icon_state = "Wise Glasses"}
			Soft_Sand{icon_state = "Soft Sand"}
			Hard_Stone{icon_state = "Hard Stone"}
			Miracle_Seed{icon_state = "Miracle Seed"}
			Black_Glasses{icon_state = "Black Glasses"}
			Black_Belt{icon_state = "Black Belt"}
			Magnet{icon_state = "Magnet"}
			Mystic_Water{icon_state = "Mystic Water"}
			Sharp_Beak{icon_state = "Sharp Beak"}
			Poison_Barb{icon_state = "Poison Barb"}
			Never\-\Melt_Ice{icon_state = "Never-Melt Ice"}
			Spell_Tag{icon_state = "Spell Tag"}
			Twisted_Spoon{icon_state = "Twisted Spoon"}
			Charcoal{icon_state = "Charcoal"}
			Dragon_Fang{icon_state = "Dragon Fang"}
			Silk_Scarf{icon_state = "Silk Scarf"}
			Soul_Dew{icon_state = "Soul Dew"}
			Light_Ball{icon_state = "Light Ball"}
			Adamant_Orb{icon_state = "Adamant Orb"}
			Lustrous_Orb{icon_state = "Lustrous Orb"}
			Griseous_Orb{icon_state = "Griseous Orb"}
		mega_stone
			icon = 'Mega Stones.dmi'
			icon = 'Mega Stones.dmi'
			Abomasite{icon_state="Abomasite"}
			Absolite{icon_state="Absolite"}
			Aerodactylite{icon_state="Aerodactylite"}
			Aggronite{icon_state="Aggronite"}
			Alakazite{icon_state="Alakazite"}
			Altarianite{icon_state="Altarianite"}
			Ampharosite{icon_state="Ampharosite"}
			Audinite{icon_state="Audinite"}
			Banettite{icon_state="Banettite"}
			Beedrillite{icon_state="Beedrillite"}
			Blastoisinite{icon_state="Blastoisinite"}
			Blazikenite{icon_state="Blazikenite"}
			Cameruptite{icon_state="Cameruptite"}
			Charizardite\-\X{icon_state="Charizardite-X"}
			Charizardite\-\Y{icon_state="Charizardite-Y"}
			Diancite{icon_state="Diancite"}
			Galladite{icon_state="Galladite"}
			Garchompite{icon_state="Garchompite"}
			Gengarite{icon_state="Gengarite"}
			Glalite{icon_state="Glalite"}
			Gyaradosite{icon_state="Gyaradosite"}
			Heracronite{icon_state="Heracronite"}
			Houndoominite{icon_state="Houndoominite"}
			Kangaskhanite{icon_state="Kangaskhanite"}
			Latiasite{icon_state="Latiasite"}
			Latiosite{icon_state="Latiosite"}
			Lopunnite{icon_state="Lopunnite"}
			Manectite{icon_state="Manectite"}
			Mawilite{icon_state="Mawilite"}
			Medichamite{icon_state="Medichamite"}
			Metagrossite{icon_state="Metagrossite"}
			Mewtwonite\-\X{icon_state="Mewtwonite-X"}
			Mewtwonite\-\Y{icon_state="Mewtwonite-Y"}
			Pidgeotite{icon_state="Pidgeotite"}
			Pinsirite{icon_state="Pinsirite"}
			Sablenite{icon_state="Sablenite"}
			Salamencite{icon_state="Salamencite"}
			Seceptilite{icon_state="Sceptilite"}
			Scizorite{icon_state="Scizorite"}
			Sharpedonite{icon_state="Sharpedonite"}
			Slowbronite{icon_state="Slowbronite"}
			Steelixite{icon_state="Steelixite"}
			Swampertite{icon_state="Swampertite"}
			Tyranitarite{icon_state="Tyranitarite"}
			Venusaurite{icon_state="Venusaurite"}
		evolve_item
			level
				Razor_Fang{icon_state="Razor Fang"}
				Razor_Claw{icon_state="Razor Claw"}
				Oval_Stone{icon_state="Oval Stone"}
			trade
				Reaper_Cloth{icon_state="Reaper Cloth"}
				Whipped_Dream{icon_state="Whipped Dream"}
				Metal_Coat{icon_state="Metal Coat"}
				Prisim_Scale{icon_state="Prisim Scale"}
				Dragon_Scale{icon_state="Dragon Scale"}
				Up\-\Grade{icon_state="Up-Grade"}
				Deep_Sea_Tooth{icon_state="Deep Sea Tooth"}
				Deep_Sea_Scale{icon_state="Deep Sea Scale"}
				Magmarizer{icon_state="Magmarizer"}
				Electirizer{icon_state="Electirizer"}
				Satchet{icon_state="Satchet"}
				Synthesizer{icon_state="Synthesizer"}
				Protector{icon_state="Protector"}
				King\'\s_Rock{icon_state="King's Rock"}
		Destiny_Knot{icon_state="Destiny Knot"}
		Amulet_Coin{icon_state="Amulet Coin"}
		Air_Balloon{icon_state="Air Balloon"}
		Shoal_Salt{icon_state="Shoal Salt"}
		Shoal_Shell{icon_state="Shoal Shell"}
		Shell_Bell{icon_state="Shell Bell"}
		Silver_Powder{icon_state="Silver Powder"}
		Scope_Lens{icon_state="Scope Lens"}
		Black_Sludge{icon_state="Black Sludge"}
		shard
			Red_Shard{icon_state="Red Shard"}
			Blue_Shard{icon_state="Blue Shard"}
			Yellow_Shard{icon_state="Green Shard"}
			Green_Shard{icon_state="Yellow Shard"}
		power
			Power_Weight{icon_state="Power Weight"}
			Power_Bracer{icon_state="Power Anklet"}
			Power_Belt{icon_state="Power Belt"}
			Power_Lens{icon_state="Power Lens"}
			Power_Band{icon_state="Power Belt"}
			Power_Anklet{icon_state="Power Anklet"}
		Ring_Target{icon_state="Ring Target"}
		Escape_Rope
			icon_state="Escape Rope"
			cost=550
			Use(player/P)
				. = ..()
				if(.)
					if(P.escape_loc)
						. = TRUE
						var turf/T = locate(P.escape_loc)
						var turf/D = null
						switch(P.escape_dir)
							if(NORTH)
								D = locate(T.x,T.y+1,T.z)
							if(SOUTH)
								D = locate(T.x,T.y-1,T.z)
							if(EAST)
								D = locate(T.x+1,T.y,T.z)
							if(WEST)
								D = locate(T.x-1,T.y,T.z)
							else
								D = locate(T.x,T.y-1,T.z)
						P.Move(D)
						P.escape_loc = ""
						P.escape_dir = null
						P.bag.getItem(/item/normal/Escape_Rope)
						P.ShowText("[P.name] escapes with the Escape Rope!")
					else
						P.ShowText("You can't escape from here!")
		Nugget{icon_state="Nugget"}
		Big_Nugget{icon_state="Big Nugget"}
		Heart_Scale{icon_state="Heart Scale"}
		Honey{icon_state="Honey"}
		Iron_Ball{icon_state="Iron Ball"}
		Leftovers{icon_state="Leftovers"}
		Kappa{icon_state="Kappa"}
		Golden_Kappa{icon_state="Golden Kappa"}
		Slowpoke_Tail{icon_state="Slowpoke Tail"}
		stone /* Red (Pokemonred200) */
			icon = 'Main Items.dmi'
			cost = 2100
			var sStone = 0
			Use(player/P)
				. = ..()
				if(.)
					P.ShowText("Use this [src]?")
					if(alert(P,"Use this [src]?","Evolutionary Stones","Yes!","No")=="Yes!")
						for(var/x in 1 to 6)
							var pokemon/PK = P.party[x]
							if(!isnull(PK))
								if(!istype(PK,/pokemon))
									if(istype(PK,/datum) && ("menuIcon" in PK.vars))
										winset(P,"partyThing.party[x]","background-color=#fff;command=;image=\ref[fcopy_rsc(PK.vars["menuIcon"])]")
									else
										winset(P,"partyThing.party[x]","background-color=#fff;image=\"\";command=")
								else
									var theType = "[src.type]"
									if(PK.evoStone & sStone)
										winset(P,"partyThing.party[x]","background-color=#0f0")
									else
										winset(P,"partyThing.party[x]","background-color=#f00")
									winset(P,"partyThing.party[x]","image=\ref[fcopy_rsc(PK.menuIcon)])")
									var verbPass = list("command"="useEvolutionaryStone [x] [(PK.evoStone & sStone)] \"[src.name]\" \"[theType]\"")
									winset(P,"partyThing.party[x]",list2params(verbPass))
							else
								winset(P,"partyThing.party[x]","background-color=#fff;image=\"\";command=")
						winset(P,"partyThing","is-visible=true")
			Water_Stone
				name = "Water Stone"
				icon_state = "Water Stone"
				sStone = WATER_STONE
			Fire_Stone
				name = "Fire Stone"
				icon_state = "Fire Stone"
				sStone = FIRE_STONE
			Leaf_Stone
				name = "Leaf Stone"
				icon_state = "Leaf Stone"
				sStone = LEAF_STONE
			Thunder_Stone
				name = "Thunder Stone"
				icon_state = "Thunder Stone"
				sStone = THUNDER_STONE
			Moon_Stone
				name = "Moon Stone"
				icon_state = "Moon Stone"
				sStone = MOON_STONE
			Dusk_Stone
				name = "Dusk Stone"
				icon_state = "Dusk Stone"
				sStone = DUSK_STONE
			Dawn_Stone
				name = "Dawn Stone"
				icon_state = "Dawn Stone"
				sStone = DAWN_STONE
			Sun_Stone
				name = "Sun Stone"
				icon_state = "Sun Stone"
				sStone = SUN_STONE
			Shiny_Stone
				name = "Shiny Stone"
				icon_state = "Shiny Stone"
				sStone = SHINY_STONE
			Ice_Stone
				name = "Ice Stone"
				icon_state = "Ice Stone"
				sStone = ICE_STONE
		Tiny_Mushroom{icon_state="Tiny Mushroom"}
		Big_Mushroom{icon_state="Big Mushroom"}
		Pearl{icon_state="Pearl"}
		Big_Pearl{icon_state="Big Pearl"}
		Star_Dust{icon_state="Star Dust"}
		Star_Piece{icon_state="Star Piece"}
		Nugget{icon_state="Nugget"}
		Heart_Scale{icon_state="Heart Scale"}
		Smoke_Ball{icon_state="Smoke Ball"}
		Focus_Band{icon_state="Focus Band"}
		Everstone{icon_state="Everstone"}
		Cleanse_Tag{icon_state="Cleanse Tag"}
		Quick_Claw{icon_state="Quick Claw"}
		Soothe_Bell{icon_state="Soothe Bell"}
		Bright_Powder{icon_state="Bright Powder"}
		Macho_Brace{icon_state="Macho Brace"}
		Mental_Herb{icon_state="Mental Herb"}
		Lucky_Punch{icon_state="Lucky Punch"}
		Metal_Powder{icon_state="Metal Powder"}
		White_Herb{icon_state="White Herb"}
		Thick_Club{icon_state="Thick Club"}
		Stick{icon_state="Stick"}
		scarf
			Red_Scarf{icon_state="Red Scarf"}
			Blue_Scarf{icon_state="Blue Scarf"}
			Pink_Scarf{icon_state="Pink Scarf"}
			Green_Scarf{icon_state="Green Scarf"}
			Yellow_Scarf{icon_state="Yellow Scarf"}
		incense
			icon = 'Incenses.dmi'
			Full_Incense{icon_state="Full Incense"}
			Lax_Incense{icon_state="Lax Incense"}
			Luck_Incense{icon_state="Luck Incense"}
			Odd_Incense{icon_state="Odd Incense"}
			Pure_Incense{icon_state="Pure Incense"}
			Rock_Incense{icon_state="Rock Incense"}
			Rose_Incense{icon_state="Rose Incense"}
			Sea_Incense{icon_state="Sea Incense"}
			Wave_Incense{icon_state="Wave Incense"}
		gem
			icon = 'Gems.dmi'
			Normal_Gem{icon_state="Normal Gem"}
			Fire_Gem{icon_state="Fire Gem"}
			Water_Gem{icon_state="Water Gem"}
			Grass_Gem{icon_state="Grass Gem"}
			Electric_Gem{icon_state="Electric Gem"}
			Rock_Gem{icon_state="Rock Gem"}
			Ghost_Gem{icon_state="Ghost Gem"}
			Fighting_Gem{icon_state="Fighting Gem"}
			Poison_Gem{icon_state="Poison Gem"}
			Flying_Gem{icon_state="Flying Gem"}
			Fairy_Gem{icon_state="Fairy Gem"}
			Dragon_Gem{icon_state="Dragon Gem"}
			Ice_Gem{icon_state="Ice Gem"}
			Bug_Gem{icon_state="Bug Gem"}
			Steel_Gem{icon_state="Steel Gem"}
			Ground_Gem{icon_state="Ground Gem"}
			Dark_Gem{icon_state="Dark Gem"}
			Psychic_Gem{icon_state="Psychic Gem"}
		mulch
			cost = 200
			Growth_Mulch{icon_state="Growth Mulch"}
			Stable_Mulch{icon_state="Stable Mulch"}
			Damp_Mulch{icon_state="Damp Mulch"}
			Gooey_Mulch{icon_state="Gooey Mulch"}
			Amaze_Mulch{icon_state="Amaze Mulch"}
			Boost_Mulch{icon_state="Boost Mulch"}
			Surprise_Mulch{icon_state="Surprise Mulch"}
			Rich_Mulch{icon_state="Rich Mulch"}
		exp_item
			Lucky_Egg{icon_state = "Lucky Egg"}
			Exp_Share{name="Exp. Share";icon_state="EXP. Share"}
		Red_Orb{icon_state="Red Orb"}
		Blue_Orb{icon_state="Blue Orb"}
		Flame_Orb{icon_state="Flame Orb"}
		Toxic_Orb{icon_state="Toxic Orb"}
		choice
			icon = 'Main Items.dmi'
			Choice_Band{icon_state="Choice Band";name="Choice Band"}
			Choice_Scarf{icon_state="Choice Scarf";name="Choice Scarf"}
			Choice_Specs{icon_state="Choice Specs";name="Choice Specs"}
		plate
			icon = 'Main Items.dmi'
			Flame_Plate{icon_state = "Flame Plate"}
			Splash_Plate{icon_state = "Splash Plate"}
			Meadow_Plate{icon_state = "Meadow Plate"}
			Insect_Plate{icon_state = "Insect Plate"}
			Draco_Plate{icon_state = "Draco Plate"}
			Icicle_Plate{icon_state = "Icicle Plate"}
			Sky_Plate{icon_state = "Sky Plate"}
			Toxic_Plate{icon_state = "Toxic Plate"}
			Iron_Plate{icon_state = "Iron Plate"}
			Fist_Plate{icon_state = "Fist Plate"}
			Mind_Plate{icon_state = "Mind Plate"}
			Stone_Plate{icon_state = "Stone Plate"}
			Earth_Plate{icon_state = "Earth Plate"}
			Shock_Plate{icon_state = "Shock Plate"}
			Spooky_Plate{icon_state = "Spooky Plate"}
			Dread_Plate{icon_state = "Dread Plate"}
			Pixie_Plate{icon_state = "Pixie Plate"}
			Shine_Plate{icon_state = "Shine Plate"} // Does not change Arceus's form; will use normal arceus sprites.
		memory
			icon = 'Memory.dmi'
			Bug_Memory{icon_state = "Bug Memory"}
			Dark_Memoy{icon_state = "Dark Memory"}
			Dragon_Memory{icon_state = "Dragon Memory"}
			Electric_Memory{icon_state = "Electric Memory"}
			Fairy_Memory{icon_state = "Fairy Memory"}
			Fighting_Memory{icon_state = "Fighting Memory"}
			Fire_Memory{icon_state = "Fire Memory"}
			Flying_Memory{icon_state = "Flying Memory"}
			Ghost_Memory{icon_state = "Ghost Memory"}
			Grass_Memory{icon_state = "Grass Memory"}
			Ground_Memory{icon_state = "Ground Memory"}
			Ice_Memory{icon_state = "Ice Memory"}
			Light_Memory{icon_state = "Light Memory"}
			Poison_Memory{icon_state = "Poison Memory"}
			Psychic_Memory{icon_state = "Psychic Memory"}
			Rock_Memory{icon_state = "Rock Memory"}
			Steel_Memory{icon_state = "Steel Memory"}
			Water_Memory{icon_state = "Water Memory"}
	pokeball
		icon = 'Pokéballs.dmi'
		var rate = 1
		canUseInBattle = TRUE
		Use(player/P)
			. = ..()
			if(.)
				if(P.client.battle.flags & TRAINER_BATTLE)
					P.ShowText("That pokémon is already Owned! Don't be a thief!")
				else
					var pokemon/S = P.client.battle.activePokemon[P.client.battle.getPlayerText(P.client)]
					var pmove/CaptureProxy/CP = new
					CP.ball = src
					P.client.battle.chosenMoveData[P.client.battle.getPokemonText(S)]["move"] = CP
		Poke_Ball
			name = "Poké Ball"
			icon_state = "Poké Ball"
			cost = 200
			Buy(player/P,count)
				. = ..()
				if(.)
					if(count>=10)
						count = round(count/10)
						if(count)
							P.bag.addItem(/item/pokeball/Premier_Ball,count)
							P.ShowText("You recieved [count] Premier Ball\s as a bonus!")
		Premier_Ball
			name = "Premier Ball"
			icon_state = "Premier Ball"
			cost = 200
		Great_Ball
			name = "Great Ball"
			icon_state = "Great Ball"
			rate = 1.5
			cost = 600
		Ultra_Ball
			name = "Ultra Ball"
			icon_state = "Ultra Ball"
			rate = 2
			cost = 1200
		Master_Ball
			name = "Master Ball"
			icon_state = "Master Ball"
			rate = 255
		Shine_Ball
			name = "Shine Ball"
			icon_state = "Shine Ball"
			rate = 255
		Friend_Ball
			name = "Friend Ball"
			icon_state = "Friend Ball"
			rate = 1
		Level_Ball
			name = "Level Ball"
			icon_state = "Level Ball"
			rate = 1
		Lure_Ball
			name = "Lure Ball"
			icon_state = "Lure Ball"
			rate = 1
		Moon_Ball
			name = "Moon Ball"
			icon_state = "Moon Ball"
			rate = 1
		Love_Ball
			name = "Love Ball"
			icon_state = "Love Ball"
			rate = 1
		Heavy_Ball
			name = "Heavy Ball"
			icon_state = "Heavy Ball"
			rate = 1
		Fast_Ball
			name = "Fast Ball"
			icon_state = "Fast Ball"
			rate = 1
		Net_Ball
			name = "Net Ball"
			icon_state = "Net Ball"
			rate = 1
		Nest_Ball
			name = "Nest Ball"
			icon_state = "Nest Ball"
			rate = 1
		Timer_Ball
			name = "Timer Ball"
			icon_state = "Timer Ball"
			rate = 1
		Quick_Ball
			name = "Quick Ball"
			icon_state = "Quick Ball"
			rate = 1
		Luxury_Ball
			name = "Luxury Ball"
			icon_state = "Luxury Ball"
			rate = 1
		Sport_Ball
			name = "Sport Ball"
			icon_state = "Sport Ball"
			rate = 1.5
		Safari_Ball
			name = "Safari Ball"
			icon_state = "Safari Ball"
			rate = 1.5
		Dive_Ball
			name = "Dive Ball"
			icon_state = "Dive Ball"
			rate = 1
		Repeat_Ball
			name = "Repeat Ball"
			icon_state = "Repeat Ball"
			rate = 1
		Park_Ball
			name = "Park Ball"
			icon_state = "Park Ball"
			rate = 255
		Dream_Ball
			name = "Dream Ball"
			icon_state = "Dream Ball"
			rate = 255
		Beast_Ball
			name = "Beast Ball"
			icon_state = "Beast Ball"
			rate = 0.1
	battle
		Guard_Special{icon_state="Guard Special"}
		Dire_Hit{icon_state="Dire Hit"}
		X_Attack{icon_state="X Attack"}
		X_Defend{icon_state="X Defend"}
		X_Speed{icon_state="X Speed"}
		X_Accuracy{icon_state="X Accuracy"}
		X_Special{icon_state="X Special"}
		Poke_Doll{name="Poké Doll";icon_state="Poké Doll"}
		Fluffy_Tail{icon_state="Fluffy Tail"}
	berry
		icon = 'Berries.dmi'
		var
			tree_type
			stage_time = 4
			berry_min = 2
			berry_max = 5
		Cheri_Berry
			name = "Cheri Berry"
			tree_type = "Cheri"
			icon_state = "Cheri Berry"
			stage_time = 16
		Chesto_Berry
			name = "Chesto Berry"
			tree_type = "Chesto"
			icon_state = "Chesto Berry"
			stage_time = 16
		Pecha_Berry
			name = "Pecha Berry"
			tree_type = "Pecha"
			icon_state = "Pecha Berry"
			stage_time = 16
		Rawst_Berry
			name = "Rawst Berry"
			tree_type = "Rawst"
			icon_state = "Rawst Berry"
			stage_time = 16
		Aspear_Berry
			name = "Aspear Berry"
			tree_type = "Aspear"
			icon_state = "Aspear Berry"
			stage_time = 16
		Leppa_Berry
			name = "Leppa Berry"
			tree_type = "Leppa"
			icon_state = "Leppa Berry"
			stage_time = 16
		Oran_Berry
			name = "Oran Berry"
			tree_type = "Oran"
			icon_state = "Oran Berry"
			stage_time = 16
		Persim_Berry
			name  = "Persim Berry"
			tree_type = "Persim"
			icon_state = "Persim Berry"
			stage_time = 16
		Lum_Berry
			name = "Lum Berry"
			tree_type = "Lum"
			icon_state = "Lum Berry"
			stage_time = 32
		Sitrus_Berry
			name = "Sitrus Berry"
			tree_type = "Sitrus"
			icon_state = "Sitrus Berry"
			stage_time = 32
		Figy_Berry
			name = "Figy Berry"
			tree_type = "Figy"
			icon_state = "Figy Berry"
			stage_time = 16
		Wiki_Berry
			name = "Wiki Berry"
			tree_type = "Wiki"
			icon_state="Wiki Berry"
			stage_time = 16
		Mago_Berry
			name = "Mago Berry"
			tree_type = "Mago"
			icon_state="Mago Berry"
			stage_time = 16
		Aguav_Berry
			name = "Aguav Berry"
			tree_type = "Aguav"
			icon_state = "Aguav Berry"
			stage_time = 16
		Iapapa_Berry
			name = "Iapapa Berry"
			tree_type = "Iapapa"
			icon_state = "Iapapa Berry"
			stage_time = 16
		Razz_Berry
			name = "Razzy Berry"
			tree_type = "Razz"
			icon_state = "Razz Berry"
			stage_time = 16
		Bluk_Berry
			name = "Bluk Berry"
			tree_type = "Bluk"
			icon_state = "Bluk Berry"
			stage_time = 16
		Nanab_Berry
			name = "Nanab Berry"
			tree_type = "Nanab"
			icon_state = "Nanab Berry"
			stage_time = 16
		Wepear_Berry
			name = "Wepear Berry"
			tree_type = "Wepear"
			icon_state = "Wepear Berry"
			stage_time = 16
		Pinap_Berry
			name = "Pinap Berry"
			tree_type = "Pinap"
			icon_state = "Pinap Berry"
			stage_time = 16
		Pomeg_Berry
			name = "Pomeg Berry"
			tree_type = "Pomeg"
			icon_state = "Pomeg Berry"
			stage_time = 32
		Kelpsy_Berry
			name = "Kelpsy Berry"
			tree_type = "Kelpsy"
			icon_state = "Kelpsy Berry"
			stage_time = 32
		Qualot_Berry
			name = "Qualot Berry"
			tree_type = "Qualot"
			icon_state = "Qualot Berry"
			stage_time = 32
		Hondew_Berry
			name = "Hondew Berry"
			tree_type = "Hondew"
			icon_state = "Hondew Berry"
			stage_time = 32
		Grepa_Berry
			name = "Grepa Berry"
			tree_type = "Grepa"
			icon_state = "Grepa Berry"
			stage_time = 32
		Tomato_Berry
			name = "Tomato Berry"
			tree_type = "Tomato"
			icon_state = "Tomato Berry"
			stage_time = 32
		Cornn_Berry
			name = "Cornn Berry"
			tree_type = "Cornn"
			icon_state = "Cornn Berry"
			stage_time = 16
		Magost_Berry
			name = "Magost Berry"
			tree_type = "Magost"
			icon_state = "Magost Berry"
			stage_time = 16
		Rabuta_Berry
			name = "Rabuta Berry"
			tree_type = "Rabuta"
			icon_state = "Rabuta Berry"
			stage_time = 16
		Nomel_Berry
			name = "Nomel Berry"
			tree_type = "Nomel"
			icon_state = "Nomel Berry"
			stage_time = 16
		Spelon_Berry
			name = "Spelon Berry"
			tree_type = "Spelon"
			icon_state = "Spelon Berry"
			stage_time = 16
		Pamtre_Berry
			name = "Pamtre Berry"
			tree_type = "Pamtre"
			icon_state = "Pamtre Berry"
			stage_time = 16
		Watmel_Berry
			name = "Watmel Berry"
			tree_type = "Watmel"
			icon_state = "Watmel Berry"
			stage_time = 16
		Durin_Berry
			name = "Durin Berry"
			tree_type = "Durin"
			icon_state = "Durin Berry"
			stage_time = 16
		Belue_Berry
			name = "Belue Berry"
			tree_type = "Belue"
			icon_state = "Belue Berry"
			stage_time = 16
		Occa_Berry
			name = "Occa Berry"
			tree_type = "Occa"
			icon_state = "Occa Berry"
			stage_time = 32
		Passho_Berry
			name = "Passho Berry"
			tree_type = "Passho"
			icon_state = "Passho Berry"
			stage_time = 32
		Wacan_Berry
			name = "Wacan Berry"
			tree_type = "Wacan"
			icon_state = "Wacan Berry"
			stage_time = 32
		Rindo_Berry
			name = "Rindo Berry"
			tree_type = "Rindo"
			icon_state = "Rindo Berry"
			stage_time = 32
		Yache_Berry
			name = "Yache Berry"
			tree_type = "Yache"
			icon_state = "Yache Berry"
			stage_time = 32
		Chople_Berry
			name = "Chople Berry"
			tree_type = "Chople"
			icon_state = "Chople Berry"
			stage_time = 32
		Kebia_Berry
			name = "Kebia Berry"
			tree_type = "Kebia"
			icon_state = "Kebia Berry"
			stage_time = 32
		Shuca_Berry
			name = "Shuca Berry"
			tree_type = "Shuca"
			icon_state = "Shuca Berry"
			stage_time = 32
		Coba_Berry
			name = "Coba Berry"
			tree_type = "Coba"
			icon_state = "Coba Berry"
			stage_time = 32
		Payapa_Berry
			name = "Payapa Berry"
			tree_type = "Payapa"
			icon_state = "Payapa Berry"
			stage_time = 32
		Tanga_Berry
			name = "Tanga Berry"
			tree_type = "Tanga"
			icon_state = "Tanga Berry"
			stage_time = 32
		Charti_Berry
			name = "Charti Berry"
			tree_type = "Charti"
			icon_state = "Charti Berry"
			stage_time = 32
		Kasib_Berry
			name = "Kasib Berry"
			tree_type = "Kasib"
			icon_state = "Kasib Berry"
			stage_time = 32
		Haban_Berry
			name = "Haban Berry"
			tree_type = "Haban"
			icon_state = "Haban Berry"
			stage_time = 32
		Colbur_Berry
			name = "Colbur Berry"
			tree_type = "Colbur"
			icon_state = "Colbur Berry"
			stage_time = 32
		Babiri_Berry
			name = "Babiri Berry"
			tree_type = "Babiri"
			icon_state = "Babiri Berry"
			stage_time = 32
		Chilan_Berry
			name = "Chilan Berry"
			tree_type = "Chilan"
			icon_state = "Chilan Berry"
			stage_time = 32
		Liechi_Berry
			name = "Liechi Berry"
			tree_type = "Liechi"
			icon_state = "Liechi Berry"
			stage_time = 48
			berry_min = 1
		Ganlon_Berry
			name = "Ganlon Berry"
			tree_type = "Ganlon"
			icon_state = "Ganlon Berry"
			stage_time = 48
		Salac_Berry
			name = "Salac Berry"
			tree_type = "Salac"
			icon_state = "Salac Berry"
			stage_time = 48
		Petaya_Berry
			name = "Petaya Berry"
			tree_type = "Petaya"
			icon_state = "Petaya Berry"
			stage_time = 48
		Apicot_Berry
			name = "Apicot Berry"
			tree_type = "Apicot"
			icon_state = "Apicot Berry"
			stage_time = 48
		Lansat_Berry
			name = "Lansat Berry"
			tree_type = "Lansat"
			icon_state = "Lansat Berry"
			stage_time = 48
		Starf_Berry
			name = "Starf Berry"
			tree_type = "Starf"
			icon_state = "Starf Berry"
			stage_time = 48
		Enigma_Berry
			name = "Enigma Berry"
			tree_type = "Enigma"
			icon_state = "Enigma Berry"
			stage_time = 48
		Micle_Berry
			name = "Micle Berry"
			tree_type = "Micle"
			icon_state = "Micle Berry"
			stage_time = 48
		Custap_Berry
			name = "Custap Berry"
			tree_type = "Custap"
			icon_state = "Custap Berry"
			stage_time = 48
		Jaboca_Berry
			name = "Jaboca Berry"
			tree_type = "Jaboca"
			icon_state = "Jaboca Berry"
			stage_time = 48
		Rowap_Berry
			name = "Rowap Berry"
			tree_type = "Rowap"
			icon_state = "Rowap Berry"
			stage_time = 48
	key
		Apricorn_Box
			icon_state = "Apricorn Box"
			var item/apricorn/apricorns[0]
			Use(player/P)
				P.updateApricorns()
				winset(P,"apricornBox","is-visible=true")
		watering_can
			Sprinklotad{icon_state="Sprinklotad"}
			Squirtbottle{icon_state="Squirtbottle"}
			Sprayduck{icon_state="Sprayduck"}
			Wailmer_Pail{icon_state="Wailmer Pail"}
		Go\-\Goggles
			icon_state = "Go Goggles"
			desc = "This item makes it possible to see in harsh sandstoms without getting your eyes hurt. It's really useful on Route 111."
		Laptop
			name = "PC Box Access Card"
			icon_state = "Card Key"
			var
				charge = 5000
				computer/comp
			New(player/P)
				. = ..()
				comp = new(P)
			Use(player/P)
				P.ShowText("PC Box Access Card for [P.name]([P.key]). It allows you to access your PC Box data.")
		key_stone
			Mega_Cuff{icon_state="Mega Cuff"}
			Mega_Charm{icon_state="Mega Charm"}
			Mega_Ring{icon_state="Mega Ring"}
			Mega_Bracelet{icon_state="Mega Bracelet"}
		bike
			icon = 'Main Items.dmi'
			Mach_Bike
				icon_state = "Mach Bike"
				Use(player/P)
					. = ..()
					if(.)
						var turf/T = P.loc
						var area/A = T.loc
						if(istype(A,/area/Town_Route))
							if(A:noBike==TRUE)
								P.ShowText("Officer Jenny's Voice Echoed: I'll beat your ass if you break the law and ride that damn bike inside!",RedColor,TRUE)
								return
						if(!(P.savedPlayerFlags & BIKING))
							P.savedPlayerFlags |= (BIKING | MACH)
						else
							P.savedPlayerFlags &= ~(BIKING | MACH)
						updateMusic(P,A)
			Acro_Bike
				icon_state = "Acro Bike"
				Use(player/P)
					. = ..()
					if(.)
						var turf/T = P.loc
						var area/A = T.loc
						if(istype(A,/area/Town_Route))
							if(A:noBike==TRUE)
								P.ShowText("Officer Jenny's Voice Echoed: I'll beat your ass if you break the law and ride that damn bike inside!",RedColor,TRUE)
								return
						if(!(P.savedPlayerFlags & BIKING))
							P.savedPlayerFlags |= BIKING
							P.savedPlayerFlags &= ~MACH
						else
							P.savedPlayerFlags &= ~(BIKING | MACH)
						updateMusic(P,A)
		VS_Seeker
			icon = 'Vs. Seeker.dmi'
			icon_state = "Vs. Seeker Blue"
			name = "Vs. Seeker"
			Use(player/P)
				. = ..()
				if(.)
					var message
					if(P.rechargeSteps == 0)
						var trainersWannaRematch = FALSE
						for(var/mob/NPC/NPCTrainer/T in range(P))
							if(istype(T,/mob/NPC/NPCTrainer/GymLeader))continue
							if(prob(60))
								if(T.theID in P.story.defeatedTrainers["[T.type]"])
									P.story.defeatedTrainers["[T.type]"] -= T.theID
								trainersWannaRematch = TRUE
						if(trainersWannaRematch)
							P.rechargeSteps = 250
							message = "There are trainers around who are itching to battle!"
						else
							message = "None of the trainers in the area appear to wish to battle currently. Try searching somewhere else!"
					else
						message = "The Vs. Seeker has not finished Charging! You still need to walk [P.rechargeSteps] more steps!"
					P.ShowText("[message]")
			seeker_red{icon_state="Vs. Seeker Red"}
			seeker_blue{icon_state="Vs. Seeker Blue"}
			seeker_green{icon_state="Vs. Seeker Green"}
			seeker_yellow{icon_state="Vs. Seeker Yellow"}
			seeker_gold{icon_state="Vs. Seeker Gold"}
			seeker_silver{icon_state="Vs. Seeker Silver"}
			seeker_crystal{icon_state="Vs. Seeker Crystal"}
			seeker_ruby{icon_state="Vs. Seeker Ruby"}
			seeker_sapphire{icon_state="Vs. Seeker Sapphire"}
			seeker_emerald{icon_state="Vs. Seeker Emerald"}
			seeker_orange{icon_state="Vs. Seeker Orange"}
			seeker_pink{icon_state="Vs. Seeker Pink"}
			seeker_purple{icon_state="Vs. Seeker Purple"}
			seeker_magenta{icon_state="Vs. Seeker Magenta"}
			seeker_maroon{icon_state="Vs. Seeker Maroon"}
			seeker_cyan{icon_state="Vs. Seeker Cyan"}
			seeker_black{icon_state="Vs. Seeker Black"}
			seeker_white{icon_state="Vs. Seeker White"}
		Oval_Charm{icon_state="Oval Charm"}
		Shiny_Charm{icon_state="Shiny Charm"}
		Coin_Case{icon_state="Coin Case"}
		Soot_Sack{icon_state="Soot Sack";var totalSoot=0}
		ticket
			icon = 'Ticket Things.dmi'
			Rainbow_Pass{icon_state = "Rainbow Pass"}
			Tri_Pass{icon_state = "Tri Pass"}
			Eon_Ticket{icon_state = "Eon Ticket"}
			Mystic_Ticket{icon_state = "Mystic Ticket"}
			Aurora_Ticket{icon_state = "Aurora Ticket"}
			Old_Sea_Map{icon_state = "Old Sea Map"}
			S\.\S\.\_Ticket{icon_state = "S.S. Ticket"}
			Liberty_Pass{icon_state = "Liberty Pass"}
		event
			icon = 'Ticket Things.dmi'
			Azure_Flute{icon_state = "Azure Flute"}
			Member_Card{icon_state = "Member Card"}
			Oak\'\s_Letter{icon_state = "Oak's Letter"}
			GS_Ball{icon_state = "GS Ball"}
			Enigma_Stone{icon_state = "Enigma Stone"}
		Game_Boy_Player
			icon = 'Main Items.dmi'
			icon_state = "GB Player"
			desc = "A Game Boy Advance fitted into the shell of an Original Game Boy. It holds the game mode and allows switching between 8-bit music and normal music."
			Use(player/P)
				. = ..()
				if(.)
					P.savedPlayerFlags ^= GB_SOUNDS
					var theFlagData = P.savedPlayerFlags & GB_SOUNDS
					src << "You turned [(theFlagData)?("on"):("off")] the power to the GB Player!"
					var turf/T = P.loc
					if(istype(T,/turf))
						var area/Town_Route/R = T.loc
						updateMusic(P,R)
		mode_gems
			icon = 'Main Items.dmi'
			Ruby
				icon_state = "Ruby Cartridge"
				desc = "A copy of Pokémon Ruby Version. It allows the player to switch to Ruby Game Mode."
				name = "Pokémon Ruby"
				Use(player/P)
					. = ..()
					if(.)
						if(P.mode != "Ruby")
							P.mode = "Ruby"
							updateEvents(P)
							P.ShowText("The Game Boy has been fit with a copy of Pokémon Ruby Version. You are now in Ruby game mode.")
			Sapphire
				icon_state = "Sapphire Cartridge"
				desc = "A copy of Pokémon Sapphire Version. It allows the player to switch to Sapphire game mode."
				name = "Pokémon Sapphire"
				Use(player/P)
					. = ..()
					if(.)
						if(P.mode != "Sapphire")
							P.mode = "Sapphire"
							updateEvents(P)
							P.ShowText("The Game Boy has been fit with a copy of Pokémon Sapphire Version. You are now in Sapphire Game Mode.")
			Emerald
				icon_state = "Emerald Cartridge"
				desc = "A copy of Pokémon Emerald Version. It allows the player to switch to Emerald game mode."
				name = "Pokémon Emerald"
				Use(player/P)
					. = ..()
					if(.)
						if(P.mode != "Emerald")
							P.mode = "Emerald"
							updateEvents(P)
							P.ShowText("The Game Boy has been fit with a copy of Pokémon Emerald Version. You are now in Emerald Game Mode.")
	apricorn
		Red_Apricorn{icon='Red Apricorn.dmi'}
		Blue_Apricorn{icon='Blue Apricorn.dmi'}
		Pink_Apricorn{icon='Pink Apricorn.dmi'}
		Green_Apricorn{icon='Green Apricorn.dmi'}
		Black_Apricorn{icon='Black Apricorn.dmi'}
		White_Apricorn{icon='White Apricorn.dmi'}
		Yellow_Apricorn{icon='Yellow Apricorn.dmi'}
		Orange_Apricorn{icon='Orange Apricorn.dmi'}