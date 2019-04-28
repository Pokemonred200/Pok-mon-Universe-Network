Event
	New()
		. = ..()
		if(isnull(realTime))
			realTime = new /BaseCamp/Calendar(-4)
		load()
		eventLoop()
	Del()
		save()
		. = ..()
	var
		events[0]
	proc
		save()
			var savefile/F = new
			src.Write(F)
			fdel("Event Data.esav")
			text2file(RC5_Encrypt(F.ExportText("/"),md5("event")),"Event Data.esav")
		load()
			if(!fexists("Event Data.esav"))return
			var savefile/F = new
			F.ImportText("/",RC5_Decrypt(file2text("Event Data.esav"),md5("event")))
			src.Read(F)
		eventLoop()
			set background = 1
			set waitfor = 0
			for(ever)
				event()
				sleep DAY
		event()
			shineBall()
		shineBall()
			switch(realTime.MonthName())
				if("July")
					if(realTime.Day() in 1 to 4)
						events["shine ball"] = list("active"=TRUE,"players_done"=list())
					else
						events["shine ball"] = list("active"=FALSE,"players_done"=list())
				else
					events["shine ball"] = list("active"=FALSE,"players_done"=list())