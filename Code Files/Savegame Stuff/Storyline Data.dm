Storyline
	New(player/P)
		. = ..()
		owner = P
	var
		/*
			This list stores the IDs of Team Aqua and Team Magma grunts that have been defeated.
			It allows compatibility between Ruby, Sapphire, and Emerald modes.
		*/
		gruntsDefeated[0]
		badgesObtained[0] // This List Stores the names of Obtained badges.
		itemPickups[0]
		defeatedTrainers[0]
		starterData[] = list("Starter"="","Chosen"=FALSE)
		storyFlags = 0
		storyFlags2 = 0
		itemsGivenFlags = 0
		tmp
			player/owner
	proc
		save()
			fdel("Storyline Data/[ckeyEx(owner.key)].esav")
			var savefile/F = new
			src.Write(F)
			text2file(RC5_Encrypt(F.ExportText("/"),md5("Super Data")),"Storyline Data/[ckeyEx(owner.key)].esav")
		load()
			var savefile/F = new
			F.ImportText("/",RC5_Decrypt(file2text("Storyline Data/[ckeyEx(owner.key)].esav"),md5("Super Data")))
			src.Read(F)