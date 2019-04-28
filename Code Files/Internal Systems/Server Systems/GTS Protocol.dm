GTSProtocol
	var
		GTSSettings/gtsSettings
		DBConnection/database
		databaseSettings[]
	New()
		Load()
		var databaseInfo[] = databaseSettings["database_info"]
		database = new
		database.Connect("dbi:mysql:[databaseInfo["name"]]:[databaseInfo["ip"]]:[databaseInfo["port"]]",databaseInfo["username"],databaseInfo["password"])
	proc
		Save()
			fdel("Settings/GTS.pset")
			text2file("Settings/GTS.pset",json_encode(databaseSettings))
		Load()
			if(fexists("Settings/GTS.pset"))
				databaseSettings = json_decode(file2text("Settings/GTS.pset"))
			else
				databaseSettings = list("database_info"=list(
				"name"="GTS Table",
				"ip"="mysql.byondpanel.com",
				"port"="3306",
				"username"="TFStudios",
				"password"="YcMYdVHqhEVTunBR"))