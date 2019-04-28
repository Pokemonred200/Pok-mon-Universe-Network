player
	var
		tmp
			alertInfoData[0]
			alertResponse = null
	verb
		alertResponseOne()
			set hidden = 1
			alertResponse = alertInfoData["answer one"]
			winset(src,"Custom Alert","is-visible=false")
		alertResponseTwo()
			set hidden = 1
			alertResponse = alertInfoData["answer two"]
			winset(src,"Custom Alert","is-visible=false")
		togglecard()
			set hidden = 1
			src.Interface(winget(src,"Trainer Card","is-visible")!="true","Trainer Card")
		whoexit()
			set hidden = 1
			winset(src, "who", "is-visible=false")
		togglestaff()
			set hidden = 1
			src.Interface(winget(src, "stats", "is-visible")!="true", "Stats")

	proc
		customAlert(alertText="Insert Alert Dialog Here",alertBarText="Alert Info",alertResponse1="Yes",alertResponse2="No",icon/iconData)
			src.client.clientFlags |= LOCK_MOVEMENT
			alertResponse = null
			alertInfoData["answer one"] = alertResponse1
			alertInfoData["answer two"] = alertResponse2
			winset(src,"Custom Alert.alertText",list2params(list("text"=alertText)))
			winset(src,"Custom Alert.alertBar",list2params(list("text"=alertBarText)))
			winset(src,"Custom Alert.responseButtonOne",list2params(list("text"=alertResponse1)))
			winset(src,"Custom Alert.responseButtonTwo",list2params(list("text"=alertResponse2)))
			winset(src,"Custom Alert.alertImageData",list2params(list("image"="\ref[fcopy_rsc(iconData)]")))
			winset(src,"Custom Alert","is-visible=true")
			while(isnull(src.alertResponse))sleep TICK_LAG
			src.client.clientFlags &= ~LOCK_MOVEMENT
		Interface(visible, name)
			visible = (visible)?("true"):("false")
			switch(name)
				if("Test")
					winset(src, "button1", "is-visible=[visible]")
				if("Trainer Card")
					winset(src, "Trainer Card", "is-visible=[visible]")
				if("Screen Text")
					winset(src, "Screen Text", "is-visible=[visible]")
					winset(src, "Continue", "is-visible=[visible]")
					winset(src, "Background", "is-visible=[visible]")
				if("InGame")
					winset(src, "partyButton", "is-visible=[visible]")
					winset(src, "bagButton", "is-visible=[visible]")
					winset(src, "savegameButton", "is-visible=[visible]")
					winset(src, "trainerbutton", "is-visible=[visible]")
				if("Stats")
					winset(src, "stats", "is-visible=[visible]")
				if("Tab")
					winset(src, "tab1", "is-visible=[visible]")
				if("Staff")
					winset(src, "staff", "is-visible=[visible]")
				if("ToggleTabDown")
					winset(src, "toggletabdown", "is-visible=[visible]")
				if("ToggleTabUp")
					winset(src, "toggletabup", "is-visible=[visible]")
				if("SayCheck")
					winset(src, "saycheck", "is-visible=[visible]")
				if("OOCCheck")
					winset(src, "ooccheck", "is-visible=[visible]")
				if("Chat")
					winset(src, "chatinput", "is-visible=[visible]")

