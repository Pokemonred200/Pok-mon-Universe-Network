/* Rai (Cart12) */


player
	var tmp/TmpGender = TRUE
turf
	introduction
		Background/icon = 'Icon Files/Turf/Introduction Design/Background.dmi'
		Professor_Rowan/icon = 'Icon Files/Turf/Introduction Design/Professor Birch.dmi'

var image/professor_image = new/image('Professor Birch.dmi',"Sendout")

player
	proc
		RemoveLoginObjects()
			var theButtons[] = list(
			locate(/screen/MajorButton/NewButton) in src.client.screen,
			locate(/screen/MajorButton/LoadButton) in src.client.screen,
			locate(/screen/MajorButton/DeleteButton) in src.client.screen)
			src.client.screen -= theButtons
			winset(src, "Title", "is-visible=false")
		AddLoginObjects()
			src.RemoveLoginObjects()
			src.playerFlags &= ~DID_MENU_STUFF
			winset(src, "Title", "is-visible=true")
			src.client.Audio.addSound(music('Title Theme.ogg',channel=4),"123",TRUE)
			src.client.screen.Add(new/screen/MajorButton/NewButton,new/screen/MajorButton/LoadButton,new/screen/MajorButton/DeleteButton)
		FileNew()
			set background = 1
			src.RemoveLoginObjects()
			if(fexists("Savefiles/[ckeyEx(src.key)].esav"))
				src.ShowText("You already have a savefile! You must delete your old one to continue.")
				src.AddLoginObjects()
				return
			src.client.Audio.addSound(music('Introduction Theme.ogg',channel=4),"123",TRUE)
			src.ScreenFade("In"); src.client.eye = locate(11, 8, 7); src.client.perspective = EYE_PERSPECTIVE; src.client.screen -= time_overlay ;src.ScreenFade("Out")
			src.ShowText("Hello there! It's so very nice to meet you! Welcome to the world of Pokémon!")
			src.ShowText("I'm the one and only Professor Birch of Hoenn!")
			var image/I = image('Professor Birch.dmi',locate(10,7,7),"Sendout")
			src.client.images += I
			spawn(6){src << sound('298 Azurill.wav')}
			src.ShowText("This world is widely inhabited by creatures known as Pokémon.")
			src.ShowText("We humans live alongside Pokémon as friends. At times we play together, and at other times we work together. Some people use their Pokémon to battle and develop closer bonds with them. What do I do? I conduct research so that we may learn more about Pokémon.")
			src.ShowText("Now, why don't you tell me a little bit about yourself? Are you a boy? Or are you a girl?")
			src.client.screen.Add(new/screen/MajorButton/BoyButton,new/screen/MajorButton/GirlButton)
			while(TmpGender == TRUE){sleep TICK_LAG}
			src.ShowText("All right, so you're a [lowertext(TmpGender)]?")
			var trueName = FALSE
			do
				src.name = input(src,"What is your name?","Enter Your Name",src.key) as text
				trueName = (!(alert("So your name is [src.name]?","Are You Sure?","Yes!","No...")=="Yes!"))
			while(trueName)

			src.ShowText("Alright, [src.name], the time has come. Your very own tale of grand adventure is about to unfold. On your journey, you will meet countless Pokémon and people. I'm sure that along the way you will discover many things, perhaps even something about yourself. Now, go on, leap into the world of Pokémon!")
			var costume/C
			if(src.TmpGender == "Boy")
				src.gender = "male"
				C = new/costume/special_costume/RSE_character/icon_male_02
			else
				src.gender = "female"
				C = new/costume/special_costume/RSE_character/icon_female_02
			C.Switch(src)
			add_costumes()
			if(alert("Which Game Encounter List will you use?\nThis will decide which spawn lists the game uses. \n\
			For Example, you'd find Seedot in Ruby mode and Lotad in Sapphire Mode.","Game Encounter","Ruby","Sapphire")=="Ruby")
				var item/key/mode_gems/Ruby/ruby = new
				ruby.Use(src)
				src.bag.addItem(ruby.type)
			else
				var item/key/mode_gems/Sapphire/sapphire = new
				sapphire.Use(src)
				src.bag.addItem(sapphire.type)
			src.ShowText("You will encounter Pokémon from the various [(src.mode=="Ruby")?("first"):("second")] version Pokémon games.")
			src.ShowText("Press the TAB key to interact.")
			src.Save()
			src.display()
			src.Move(locate("BedroomSpawn"))
			//textThing.ChangeText("<font color=black size = 2 face = \"Times New Roman\">[src.name]</font>")
			src.ScreenFade("In"); src.client.images.Remove(I); src.playerFlags &= ~IN_LOGIN; src.client.eye = src; src.client.perspective = EYE_PERSPECTIVE
			src.ScreenFade("Out");src.Interface(1, "Test");src.Interface(1, "InGame")
			Staff(src)
			//src.client.Audio.addSound(music('Littleroot Town.ogg',repeat=1,channel=4),"123",autoplay=TRUE)
			winset(src,"default.routeLabel","is-visible=true")
			if(world.IsSubscribed(src,"BYOND"))
				src.money = 6000
			else
				src.money = 3000
			src.client.moneyLabel.Text("[src.money]")
			src.client.images -= I
			Process_Transfer(src)
		FileLoad()
			src.RemoveLoginObjects()
			src.Load()
			Staff(src)
		FileDelete()
			src.RemoveLoginObjects()
			if(fexists("Savefiles/[ckeyEx(src.key)].esav"))
				if(alert("Are you sure you want to delete your savefile?","Deleting the saves","Yes","No")=="Yes")
					fdel("Savefiles/[ckeyEx(src.key)].esav")
					for(var/PCBox in 1 to 100)
						if(fexists("Boxes/Box [PCBox]/[ckeyEx(src.key)].esav"))
							fdel("Boxes/Box [PCBox]/[ckeyEx(src.key)].esav")
					for(var/turf/outdoor/berry_stuff/B in berry_trees)
						B.initalize_for_player(src.key)
					for(var/owItem/O in itemsList)
						O.players_pickedup -= "[ckeyEx(src.key)]"
					for(var/owTMPickup/O in itemsList)
						O.players_pickedup -= "[ckeyEx(src.key)]"
					for(var/hiddenItem/O in itemsList)
						O.players_pickedup -= "[ckeyEx(src.key)]"
					fdel("Storyline Data/[ckeyEx(src.key)].esav")
					ShowText("You have deleted your savefile.")
				else
					ShowText("You did not delete your savefile.")
			else
				ShowText("You don't have a savefile to delete!")
			src.AddLoginObjects()
			Staff(src)