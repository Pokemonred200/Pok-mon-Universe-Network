/* Rai (Cart12) */

/* Staff Log Location definition in this DM File */
#define Staff_LOG "Log Files/Staff Log.html"

var

	/* Admins */
	list
		Admin_key = list("Pokemonred200","Vexxen","Harzar","Lugias Soul","Lossetta","Syxoul")

	/* Moderators */
		Moderator_key = list("Yucide","Jaylovekiller","LargeExodia")
		Contributor_key = list("XSky RiderX","Kitasame Yurikaro","Kittikatt","Bakkstory")

		Testing_LIST = list()

	World_muted    = FALSE
	Is_Reboot      = FALSE
	Is_Shutdown    = FALSE
	Server_Private = FALSE

proc
	/* Writes down Staff activity into a Staff Log while announcing it to the world */
	Admin(t)
		if(!t){return}
		text2file("</font color><B>[time2text(world.realtime)]</B>: [t]<BR>", Staff_LOG)
		for(var/player/P in global.online_players){P << output("\red<B>(Staff)</B>[t]"); P << output("\red<B>(Staff)</B>[t]", "announcement")}
		return

player
	var
		Is_staff      = FALSE
		Staff_num     = 0 // Staff Number Rank, 0 as player, 1 as moderator, 2 as admin & 3 as contributor

proc

	Load_Staff()
		if(!fexists("Game Staff.esav"))return
		var savefile/staffLoad = new
		staffLoad.ImportText("/",RC5_Decrypt(file2text("Game Staff.esav"),md5("125")))
		var alist[0]
		var mlist[0]
		staffLoad["Admins"] >> alist
		staffLoad["Mods"] >> mlist
		Admin_key.Add(alist)
		Moderator_key.Add(mlist)
	Save_Staff()
		if(fexists("Game Staff.esav"))
			fdel("Game Staff.esav")
		var savefile/staffSaver = new
		staffSaver["Admins"] << Admin_key
		staffSaver["Mods"] << Moderator_key
		text2file(RC5_Encrypt(staffSaver.ExportText("/"),md5("125")),"Game Staff.esav")

	/* Detects if player/Player is located in /list/List(Any list), if yes return 1 else return 0 */
	Check(player/Player, list/List)
		if(List.Find(Player.key)){return 1}
		else return 0

	/* Detects if player/Player is staff */
	Staff(player/Player)
		if(Check(Player, Admin_key))
			Player.Interface(1, "Staff")
			Player.Is_staff = TRUE
			Player.Staff_num = 3
			Verbs(Player, /player/Admin/verb)
			Verbs(Player, /player/Moderator/verb)
			Verbs(Player, /player/Special/verb)
		else if(Check(Player, Moderator_key))
			Player.Interface(1, "Staff")
			Player.Staff_num = 2
			Player.Is_staff = TRUE
			Verbs(Player, /player/Moderator/verb)
			Verbs(Player, /player/Special/verb)
		else if(Check(Player, Contributor_key))
			Player.Staff_num = 1
			Verbs(Player, /player/Special/verb)
		else
			Player.Staff_num = 0
			Player.Interface(0,"Staff")
			Player.verbs.Remove(typesof(/player/Admin/verb),typesof(/player/Moderator/verb),typesof(/player/Special/verb))

		return

	/* Gives player/Player verbs of typesof any Path */
	Verbs(player/P, verbPath)
		for(var/C in typesof(verbPath)){new C(P)}