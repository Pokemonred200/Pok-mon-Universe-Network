proc
	getTMInfo(movename)
		switch(movename)
			if("Focus Punch")return list()

			if("Dragon Claw")return list()

			if("Calm Mind")return list()

			if("Bulk Up")return list()

			if("Flash")return getHMInfo("Flash")

			if("Rock Smash")return getHMInfo("Rock Smash")

			if("Hidden Power")return "ALL"

			if("Rest")return list("ALLEXCEPT","Regigigas")

			if("Protect")return "ALL"

			if("Attract")return "ALLGENDERED"

			if("Captivate")return "ALLGENDERED"

			if("Earthquake")return list("Venusaur","Charizard","Blastoise","Ekans","Arbok","Sandshrew","Sandshrew-Al","Sandslash","Sandslash-Al","Nidoqueen","Nidoking",
			"Diglett","Diglett-Al","Dugtrio","Dugtrio-Al","Mankey","Primeape","Poliwhirl","Poliwrath","Machop","Machoke","Machamp","Geodude","Geodude-Al","Graveler",
			"Graveler-Al","Golem","Golem-Al","Slowpoke","Slowbro","Onix","Exeggutor-Al","Cubone","Marowak","Marowak-Al","Hitmonlee","Hitmonchan","Lickitung","Rhyhorn",
			"Rhydon","Chansey","Kangaskhan","Pinsir","Tauros","Gyarados","Snorlax","Drgonite","Mewtwo","Mew","Meganium","Typhlosion","Feraligatr","Sudowoodo","Politoed",
			"Wooper","Quagsire","Slowking","Girafarig","Pineco","Forretress","Dunsparce","Gligar","Steelix","Snubbull","Granbull","Shuckle","Heracross","Teddiursa",
			"Ursaring","Magcargo","Swinub","Piloswine","Corsola","Mantine","Phanpy","Donphan","Stantler","Tyrogue","Hitmontop","Miltank","Blissey","Larvitar","Pupitar",
			"Tyranitar","Lugia","Ho-Oh","Sceptile","Blaziken","Marshtomp","Swampert","Vigoroth","Slaking","Loudred","Exploud","Makuhita","Hariyama","Nosepass","Aron",
			"Lairon","Aggron","Swalot","Sharpedo","Wailmer","Wailord","Numel","Camerupt","Torkoal","Trapinch","Vibrava","Flygon","Altaria","Seviper","Lunatone",
			"Solrock","Barboach","Whiscash","Baltoy","Claydol","Cradily","Armaldo","Dusclops","Tropius","Glalie","Spheal","Sealeo","Walrein","Relicanth","Salamence",
			"Metang","Metagross","Regirock","Regice","Registeel","Latias","Latios","Kyogre","Groudon","Rayquaza","Torterra","Infernape","Empoleon","Cranidos","Rampardos",
			"Shieldon","Bastiodon","Wormadam-Sandy","Gastrodon","Bronzor","Bronzong","Gible","Gabite","Garchomp","Munchlax","Riolu","Lucario","Hippopotas","Hippowdon",
			"Drapion","Croagunk","Toxicroak","Mantyke","Abomasnow","Lickilicky","Rhyperior","Tangrowth","Electivire","Magmortar","Gliscor","Mamoswne","Gallade",
			"Probopass","Dusknoir","Dialga","Palkia","Heatran","Regigigas","Giratina","Arceus","Serperior","Emboar","Samurott","Roggenrola","Boldore","Gigalith","Drilbur",
			"Excadrill","Conkeldurr","Seismitoad","Throh","Sawk","Scolipede","Sandile","Krokorok","Krookodile","Darmanitan","Dwebble","Crustle","Tirtouga","Carracosta",
			"Archen","Archeops","Haxorus","Stunfisk","Druddigon","Golett","Golurk","Bouffalant","Hydreigon","Terrakion","Landorus","Chesnaught","Delphox","Greninja",
			"Bunnelby","Diggersby","Gogoat","Pangoro","Binacle","Barbaracle","Tyrunt","Tyrantrum","Aurorus","Goodra","Trevenant","Avalugg","Zygarde","Volcanion",
			"Decidueye","Incineroar","Primarina","Yungoos","Gumshoos","Crabrawler","Crabominable","Wishiwashi","Mudbray","Mudsdale","Stufful","Bewear","Oranguru",
			"Passimian","Sandygast","Palossand","Minior","Komala","Turtonator","Drampa","Dhelmise","Jangmo-o","Hakamo-o","Kommo-o","Solgaleo","Lunala","Buzzwole",
			"Pheromosa","Celesteela","Guzzlord","Necrozma")

			if("Shadow Claw")return list("Charmander","Charmeleon","Charizard","Sandshrew","Sandslash","Nidoran-F","Nidorina","Nidoqueen","Nidoran-M","Nidorino",
			"Nidoking","Diglett","Dugtrio","Meowth","Persian","Psyduck","Golduck","Haunter","Gengar","Rhydon","Kangaskhan","Mew","Typhlosion","Totodile","Coconaw",
			"Feraligatr","Sentret","Furret","Aipom","Sneasel","Teddiursa","Ursaring","Tyranitar","Torchic","Combusken","Blaziken","Linoone","Slakoth","Vigoroth",
			"Slaking","Shedinja","Sableye","Aron","Lairon","Aggron","Zangoose","Kecleon","Banette","Absol","Bagon","Shelgon","Salamence","Registeel","Latias",
			"Latios","Groudon","Rayquaza","Chimchar","Monferno","Infernape","Prinplup","Empoleon","Ambipom","Glameow","Purugly","Stunky","Skuntank","Gible",
			"Gabite","Garchomp","Riolu","Lucario","Weavile","Rhyperior","Dialga","Palkia","Giratina","Darkrai","Arceus","Purrloin","Liepard","Pansage","Simisage",
			"Pansear","Simisear","Panpour","Simipour","Srilbur","Excadrill","Leavanny","Krokorok","Krookodile","Dwebble","Crustle","Archen","Archeops","Zoroark",
			"Ferrothorn","Fraxure","Haxorus","Cubchoo","Beartic","Druddigon","Pawniard","Bisharp","Rufflet","Braviary","Heatmor","Durant","Reshiram","Zekrom",
			"Kyurem","Meloetta","Genesect","Chespin","Quilladin","Chesnaught","Pancham","Pangoro","Honedge","Doublade","Aegislash","Binacle","Barbaracle",
			"Phantump","Trevenant","Noibat","Noivern","Yveltal")

	getHMInfo(movename)
		switch(movename)
			if("Cut")return list("Bulbasaur","Ivysaur","Venusaur","Charmander","Charmeleon","Charizard","Beedrill","Rattata","Raticate","Sandshrew","Sandslash",
			"Nidoran-F","Nidorina","Nidoqueen","Nidoran-M","Nidorino","Nidoking","Oddish","Gloom","Vileplume","Paras","Parasect","Diglett","Dugtrio","Meowth",
			"Persian","Bellsprout","Weepinbell","Victreebel","Tentacool","Tentacruel","Farfetch'd","Krabby","Kingler","Lickitung","Rhydon","Tangela","Kangaskhan",
			"Scyther","Pinsir","Kabutops","Dragonite","Mew","Chikorita","Bayleef","Meganium","Cyndaquil","Quilava","Typhlosion","Totodile","Croconaw","Feraligatr",
			"Sentret","Furret","Bellossom","Aipom","Sunkern","Sunflora","Espeon","Umbreon","Gligar","Steelix","Scizor","Heracross","Sneasel","Teddiursa","Ursaring",
			"Skarmory","Raikou","Entei","Suicune","Tyranitar","Celebi","Treecko","Grovyle","Sceptile","Torchic","Combusken","Blaziken","Zugzagoon","Linoone",
			"Nuzleaf","Shiftry","Breloom","Slakoth","Vigoroth","Slaking","Nincada","Ninjask","Shedinja","Sableye","Aron","Lairon","Aggron","Roselia","Cacnea",
			"Cacturne","Corphish","Crawdaunt","Anorith","Armaldo","Kecleon","Tropius","Absol","Bagon","Shelgon","Salamence","Metang","Metagross","Latias","Latios",
			"Groudon","Deoxys","Turtwig","Grotle","Torterra","Chimchar","Monferno","Infernape","Piplup","Prinplup","Empoleon","Bidoof","Bibarel","Kricketune","Budew",
			"Roserade","Rampardos","Vespiquen","Pachirisu","Ambipom","Drifloon","Drifblim","Buneary","Lopunny","Glameow","Purugly","Stunky","Skuntank","Gible",
			"Gabite","Garchomp","Skorupi","Drapion","Toxicroak","Carnivine","Weavile","Lickilicky","Rhyperior","Tangrowth","Gliscor","Gallade","Dialga","Palkia",
			"Giratina","Darkrai","Arceus","Snivy","Servine","Serperior","Oshawott","Dewott","Samurott","Patrat","Watchog","Purrloin","Liepard","Pansage","Simisage",
			"Pansear","Simisear","Panpour","Simipour","Drilbur","Excadrill","Sewaddle","Swadloon","Leavanny","Scolipede","Petilil","Lilligant","Basculin","Sandile",
			"Krokorok","Krookodile","Dwebble","Crustle","Archen","Archeops","Zorua","Zorark","Sawsbuck","Emolga","Karrablast","Escavalier","Joltik","Galvantula",
			"Ferrothorn","Ferrothorn","Eelektross","Axew","Fraxure","Haxorus","Cubchoo","Beartic","Druddion","Pawniard","Bisharp","Bouffalant","Rufflet","Braviary",
			"Vullaby","Mandibuzz","Heatmor","Durant","Cobalion","Terrakion","Virizion","Reshiram","Zekrom","Kyurem","Keldeo","Chespin","Quilladin","Chesnaught",
			"Fennekin","Braixen","Delphox","Froakie","Frogadier","Greninja","Bunnelby","Diggersby","Pancham","Pangoro","Espurr","Meowstic","Honedge","Doublade",
			"Aegislash","Inkay","Malamar","Binacle","Barbaracle","Clauncher","Clawitzer","Helioptile","Heliolisk","Hawlucha","Dedenne","Klefki","Phantump","Tevenant",
			"Noibat","Noivern","Xerneas","Yveltal","Volcanion","Kartana")

			if("Fly")return list("Charizard","Pidgey","Pidgeotto","Pidgeot","Spearow","Fearow","Pikachu","Raichu","Raichu-Al","Zubat","Golbat","Farfetch'd","Doduo",
			"Dodrio","Aerodactyl","Articuno","Zapdos","Moltres","Dragonite","Mew","Hoothoot","Noctowl","Crobat","Togetic","Xatu","Murkrow","Delibird","Skarmory",
			"Lugia","Ho-Oh","Taillow","Swellow","Wingull","Pelipper","Vibrava","Flygon","Swablu","Altaria","Tropius","Salamence","Latias","Latios","Rayquaza",
			"Starly","Staravia","Staraptor","Drifblim","Honchkrow","Chatot","Togekiss","Giratina","Arceus","Pidove","Tranquill","Unfezant","Woobat","Swoobat",
			"Sigilyph","Archeops","Ducklett","Swanna","Golurk","Rufflet","Braviary","Vullaby","Mandibuzz","Hydreigon","Volarona","Tornadus","Thundurus","Reshiram",
			"Zekrom","Landorus","Kyurem","Genesect","Fletchling","Fletchinder","Talonflame","Hawlucha","Noibat","Noivern","Yveltal","Pikipek","Trumbeak","Toucannon",
			"Oricorio","Drampa","Tapu Koko","Lunala","Celesteela")

			if("Surf")return list("Squirtle","Wartortle","Blastoise","Pikachu","Raichu","Raichu-Al","Nidoqueen","Nidoking","Psyduck","Golduck","Poliwag","Poliwhirl",
			"Poliwrath","Tentacool","Tentacruel","Slowpoke","Slowbro","Seel","Dewgong","Shellder","Cloyster","Krabby","Kingler","Lickitung","Rhydon","Kangaskhan",
			"Horsea","Seadra","Goldeen","Seaking","Staryu","Starmie","Tauros","Gyarados","Lapras","Vaporeon","Omanyte","Omastar","Kabuto","Kabutops","Snorlax",
			"Dratini","Dragonair","Dragonite","Totodile","Croconaw","Feraligatr","Sentret","Furret","Chinchou","Lanturn","Marill","Azumarill","Politoed","Wooper",
			"Quagsire","Slowking","Qwilfish","Sneasel","Corsola","Remoraid","Octillery","Mantine","Kingdra","Miltank","Suicune","Tyranitar","Lugia","Mudkip",
			"Marshtomp","Swampert","Zigzagoon","Linoone","Lotad","Lombre","Ludicolo","Pelipper","Exploud","Makuhita","Hariyama","Azurill","Aggron","Carvanha",
			"Sharpedo","Wailmer","Wailord","Barboach","Whiscash","Corphish","Crawdaunt","Feebas","Milotic","Spheal","Sealeo","Walrein","Clamperl","Huntail",
			"Gorebyss","Luvdisc","Latias","Latios","Kyogre","Rayquaza","Piplup","Prinplup","Empoleon","Bibarel","Rampardos","Buizel","Floatzel","Shellos","Gastrodon",
			"Garchomp","Munchlax","Finneon","Lumineon","Mantyke","Weavile","Lickilicky","Rhyperior","Palkia","Phione","Manaphy","Arceus","Oshawott","Dewott",
			"Samurott","Herdier","Stoutland","Panpour","Simipour","Audino","Tympole","Palpitoad","Seismitoad","Basculin","Tirtouga","Carracosta","Ducklett","Swanna",
			"Frillish","Jellicent","Alomomola","Haxorus","Cubchoo","Beartic","Stunfisk","Druddigon","Bouffalant","Hydreigon","Keldeo","Froakie","Frogadier","Greninja",
			"Bunnelby","Diggersby","Skiddo","Gogoat","Pancham","Pangoro","Furfrou","Swirlix","Slurpuff","Binacle","Barbaracle","Skrelp","Dragalge","Clauncher",
			"Clawitzer","Helioptile","Heliolisk","Bergmite","Avalugg","Popplio","Brionne","Primarina","Wishiwashi","Mareanie","Toxapex","Dewpider","Araquanid",
			"Wimpod","Golisopod","Silvally","Bruxish","Drampa","Dhelmise","Tapu Fini")

			if("Strength")return list("Bulbasaur","Ivysaur","Venusaur","Charmander","Charmeleon","Charizard","Squirtle","Wartortle","Blastoise","Raticate","Raticate-Al",
			"Ekans","Arbok","Pikachu","Raichu","Sandshrew","Sandslash","Nidoran-F","Nidorina","Nidoqueen","Nidoran-M","Nidorino","Nidoking","Clefairy","Clefable",
			"Jigglypuff","Wigglytuff","Psyduck","Golduck","Mankey","Primeape","Growlithe","Arcanine","Poliwhirl","Poliwrath","Machop","Machoke","Machamp","Geodude",
			"Geodude-Al","Graveler","Graveler-Al","Golem","Golem-Al","Ponyta","Rapidash","Slowpoke","Slowbro","Seel","Dewgong","Grimer","Grimer-Al","Muk","Muk-Al","Onix",
			"Krabby","Kingler","Exeggcute","Exeggutor","Exeggutor-Al","Cubone","Marowak","Marowal-Al","Hitmonlee","Hitmonchan","Lickitung","Rhyhorn","Rhydon","Chansey",
			"Kangaskhan","Electabuzz","Magmar","Pinsir","Tauros","Gyarados","Lapras","Vaporeon","Jolteon","Flareon","Aerodactyl","Snorlax","Dragonite","Mewtwo","Mew",
			"Bayleef","Meganium","Quilava","Typhlosion","Croconaw","Feraligatr","Furret","Ledian","Flaaffy","Ampharos","Marill","Azumarill","Sudowoodo","Politoed",
			"Aipom","Quagsire","Slowking","Girafarig","Pineco","Forretress","Dunsparce","Gligar","Steelix","Snubbull","Granbull","Scizor","Shuckle","Heracross","Sneasel",
			"Teddiursa","Ursaring","Magcargo","Swinub","Piloswine","Corsola","Houndoom","Phanpy","Donphan","Tyrogue","Hitmontop","Miltank","Blissey","Raikou","Entei",
			"Tyranitar","Lugia","Ho-Oh","Treecko","Grovyle","Sceptile","Torchic","Combusken","Blaziken","Mudkip","Marshtomp","Swampert","Mightyena","Linoone","Lombre",
			"Ludicolo","Nuzlaf","Shiftry","Breloom","Slakoth","Vigoroth","Slaking","Loudred","Exploud","Makuhita","Hariyama","Nosepass","Probopass","Delcatty","Mawile",
			"Aron","Lairon","Aggron","Meditite","Medicham","Electrike","Manectric","Gulpin","Swalot","Sharpedo","Wailmer","Wailord","Numel","Camerupt","Torkoal","Spinda",
			"Trapinch","Vibrava","Flygon","Cacturne","Zangoose","Seviper","Whiscash","Corphish","Crawdaunt","Claydol","Cradily","Armaldo","Kecleon","Dusclops","Tropius",
			"Absol","Spheal","Sealeo","Walrein","Bagon","Shelgon","Salamence","Metang","Metagross","Regirock","Regice","Registeel","Kyogre","Groudon","Rayquaza","Deoxys",
			"Turtwig","Grotle","Torterra","Chimchar","Monferno","Infernape","Prinplup","Empoleon","Bibarel","Kricketune","Shinx","Luxio","Luxray","Cranidos","Rampardos",
			"Shieldon","Bastiodon","Buizel","Floatzel","Gastrodon","Ambipom","Lopunny","Skuntank","Bronzong","Gible","Gabite","Garchomp","Munchlax","Riolu","Lucario",
			"Hippopotas","Hippowdon","Skorupi","Drapion","Croagunk","Toxicroak","Abomasnow","Weavile","Lickilicky","Rhyperior","Tangrowth","Electivire","Magmortar",
			"Leafeon","Glaceon","Gliscor","Mamoswine","Gallade","Probopass","Dusknoir","Dialga","Palkia","Giratina","Heatran","Regigigas","Giratina","Darkrai","Arceus",
			"Serperior","Tepig","Pignite","Emboar","Samurott","Watchog","Herdier","Stoutland","Roggenrola","Boldore","Gigalith","Drilbur","Excadrill","Timburr","Gurdurr",
			"Conkeldurr","Seismitoad","Throh","Sawk","Scolipede","Krokorok","Krookodile","Darumaka","Darmanitan","Dwebble","Crustle","Scraggy","Scrafty","Tirtouga",
			"Carracosta","Reuniclus","Ferrothorn","Eelektross","Axew","Fraxure","Haxorus","Cubchoo","Beartic","Meinfoo","Mienshao","Druddigon","Golett","Golurk",
			"Bouffalant","Rufflet","Braviary","Durant","Deino","Zweilous","Hydreigon","Cobalion","Terrakion","Virizion","Tornadus","Thundurus","Reshiram","Zekrom",
			"Landorus","Kyurem","Keldeo","Meloetta","Chespin","Quilladin","Chesnaught","Froakie","Frogadier","Greninja","Bunnelby","Diggersby","Litleo","Pyroar","Skiddo",
			"Gogoat","Pancham","Pangoro","Binacle","Barbaracle","Tyrunt","Tyrantrum","Hawlucha","Goodra","Phantump","Trevenant","Bergmite","Avalugg","Zygarde","Volcanion")

			if("Flash")return list("Bulbasaur","Ivysaur","Venusaur","Butterfree","Beedrill","Pikachu","Raichu","Clefairy","Clefable","Jigglypuff","Wigglytuff",
			"Oddish","Gloom","Vileplume","Paras","Parasect","Venonat","Venomoth","Meowth","Persian","Psyduck","Golduck","Abra","Kadabra","Alakazam","Bellsprout",
			"Weepinbell","Victreebel","Slowpoke","Slowbro","Magnemite","Magneton","Drowzee","Hypno","Exeggcute","Exeggutor","Koffing","Weezing","Chansey","Tangela",
			"Staryu","Starmie","Mr. Mime","Jynx","Electabuzz","Jolteon","Porygon","Zapdos","Mewtwo","Mew","Chikorita","Bayleef","Meganium","Hoothoot","Noctowl",
			"Ledyba","Ledian","Spinarak","Ariados","Chinchou","Lanturn","Pichu","Cleffa","Igglybuff","Togepi","Togetic","Natu","Xatu","Mareep","Flaaffy","Ampharos",
			"Bellossom","Hoppip","Skiploom","Jumpluff","Sunkern","Sunflora","Yanma","Wooper","Quagsire","Espeon","Umbreon","Slowking","Misdreavus","Girafarig",
			"Shuckle","Skarmory","Porygon2","Stantler","Smoochum","Elekid","Blissey","Raikou","Entei","Lugia","Ho-Oh","Celebi","Treecko","Grovyle","Sceptile",
			"Beautifly","Dustox","Lotad","Lombre","Ludicolo","Seedot","Nuzleaf","Shiftry","Ralts","Kirlia","Gardevoir","Surskit","Masquerain","Shroomish","Breloom",
			"Nincada","Ninjask","Shedinja","Skitty","Delcatty","Sableye","Meditite","Medicham","Electrike","Manectric","Plusle","Minun","Volbeat","Illumise","Roselia",
			"Spoink","Grumpig","Spinda","Cacnea","Cacturne","Lunatone","Solrock","Baltoy","Claydol","Lileep","Cradily","Castform","Kecleon","Shuppet","Banette",
			"Duskull","Dusclops","Tropius","Chimecho","Absol","Snorunt","Glalie","Metang","Metagross","Latias","Latios","Jirachi","Deoxys","Turtwig","Grotle",
			"Torterra","Kriketune","Shinx","Luxio","Luxray","Budew","Roserade","Wormadam","Mothim","Vespiquen","Pachirisu","Cherubi","Cherrim","Gasrodon","Drifloon",
			"Drifblim","Mismagius","Glameow","Purugly","Chingling","Bronzor","Bronzong","Mime Jr.","Happiny","Spiritomb","Skorupi","Drapion","Carnivine","Finneon",
			"Lumineon","Snover","Abomasnow","Magnezone","Tangrowth","Electivire","Togekiss","Yanmega","Leafeon","Porygon-Z","Gallade","Dusknoir","Froslass","Rotom",
			"Uxie","Mesprit","Azelf","Dialga","Cresselia","Manaphy","Darkrai","Shaymin","Arceus","Victini","Snivy","Servine","Serperior","Watchog","Pansage",
			"Simisage","Munna","Musharna","Blitzle","Zebstrika","Woobat","Swoobat","Audino","Sewaddle","Swadloon","Leavanny","Cottonee","Whimsicott","Petilil",
			"Lilligant","Sigilyph","Yamask","Cofagrigus","Gothita","Gothorita","Gothitelle","Solosis","Duosion","Reuniclus","Deerling","Sawsbuck","Emolga","Foongus",
			"Amoongus","Frillish","Jellicent","Joltik","Galvantula","Ferroseed","Ferrothorn","Eelektrik","Eelektross","Elgyem","Beheeyem","Litwick","Lampent",
			"Chandelure","Stunfisk","Golett","Golurk","Virizion","Zekrom","Meloetta","Genesect","Chespin","Quilladin","Chesnaught","Vivillon","Flabébé","Floette",
			"Florges","Furfrou","Espurr","Meowstic","Spritzee","Aromatisse","Swirlix","Slurpuff","Inkay","Malamar","Helioptile","Heliolisk","Amaura","Aurorus",
			"Sylveon","Dedenne","Carbink","Pumpkaboo","Gourgeist","Bergmite","Avalugg","Xerneas","Diancie","Hoopa")

			if("Waterfall")return list("Squirtle","Wartortle","Blastoise","Psyduck","Golduck","Poliwag","Poliwhirl","Poliwrath","Tentacool","Tentacruel","Seel",
			"Dewgong","Horsea","Seadra","Goldeen","Seaking","Staryu","Starmie","Gyarados","Lapras","Vaporeon","Omanyte","Omastar","Kabuto","Kabutops","Dratini",
			"Dragonair","Dragonite","Mew","Totodile","Croconaw","Feraligatr","Chinchou","Lanturn","Marill","Azumarill","Politoed","Wooper","Quagsire","Qwilfish",
			"Remoraid","Octillery","Mantine","Kingdra","Suicune","Lugia","Mudkip","Marshtomp","Swampert","Lombre","Ludicolo","Azurill","Carvanha","Sharpedo",
			"Wailmer","Wailord","Barboach","Whiscash","Corphish","Crawdaunt","Feebas","Milotic","Spheal","Sealeo","Walrein","Clamperl","Huntail","Gorebyss",
			"Relicanth","Luvdisc","Latias","Latios","Kyogre","Rayquaza","Piplup","Prinplup","Empoleon","Bibarel","Buizel","Floatzel","Gastrodon","Finneon",
			"Lumineon","Mantyke","Phione","Manaphy","Arceus","Oshawott","Dewott","Samurott","Panpour","Simipour","Basculin","Tirtouga","Carracosta","Frillish",
			"Jellicent","Alomomola","Froakie","Frogadier","Greninja","Skrelp","Dragalge","Clauncher","Clawitzer","Popplio","Brionne","Primarina","Wishiwashi",
			"Dewpider","Araquanid","Wimpod","Golisopod","Bruxish","Tapu Fini")

			if("Rock Smash")return list("Bulbasaur","Ivysaur","Venusaur","Charmander","Charmeleon","Charizard","Squirtle","Wartortle","Blastoise","Beedrill","Rattata",
			"Raticate","Pikachu","Raichu","Sandshrew","Sandslash","Nidoran-F","Nidorina","Nidoqueen","Nidoran-M","Nidorino","Nidoking","Clefairy","Clefable","Paras",
			"Parasect","Diglett","Dugtrio","Psyduck","Golduck","Mankey","Primeape","Growlithe","Arcanine","Poliwhirl","Poliwrath","Machop","Machoke","Machamp","Geodude",
			"Graveler","Golem","Slowbro","Muk","Gengar","Onix","Krabby","Kingler","Cubone","Marowak","Hitmonlee","Hitmonchan","Lickitung","Rhyhorn","Rhydon","Chansey",
			"Tangela","Kangaskhan","Scyther","Magmar","Pinsir","Tauros","Gyarados","Lapras","Vaporeon","Jolteon","Flareon","Omanyte","Omastar","Kabuto","Kabutops",
			"Aerodactyl","Snorlax","Articuno","Zapdos","Moltres","Dragonite","Mewtwo","Mew","Bayleef","Meganium","Quilava","Typhlosion","Croconaw","Feraligatr","Furret",
			"Ledian","Togepi","Togetic","Flaaffy","Ampharos","Marill","Azumarill","Sudowoodo","Politoed","Aipom","Wooper","Quagsire","Slowking","Girafarig","Pineco",
			"Forretress","Dunsparce","Steelix","Snubbull","Granbull","Scizor","Sneasel","Teddiursa","Ursaring","Slugma","Magcargo","Swinub","Piloswine","Corsola",
			"Skarmory","Houndour","Houndoom","Phanpy","Donphan","Tyrouge","Hitmontop","Elekid","Magby","Miltank","Blissey","Raikou","Entei","Suicune","Larvitar","Pupitar",
			"Tyranitar","Lugia","Ho-Oh","Treecko","Grovyle","Sceptile","Torchic","Combusken","Blaziken","Mudkip","Marshtomp","Swampert","Poochyena","Mightyena","Zigzagoon",
			"Linoone","Lotad","Lombre","Ludicolo","Seedot","Nuzleaf","Shiftry","Breloom","Slakoth","Vigoroth","Slaking","Loudred","Exploud","Makuhita","Hariyama",
			"Nosepass","Delcatty","Sableye","Mawile","Aron","Lairon","Aggron","Meditite","Medicham","Gulpin","Swalot","Sharpedo","Wailmer","Wailord","Numel","Camerupt",
			"Torkoal","Spinda","Trapinch","Vibrava","Flygon","Altaria","Zangoose","Seviper","Whiscash","Corphish","Crawdaunt","Clawdol","Lileep","Cradily","Anorith",
			"Armaldo","Kecleon","Dusclops","Tropius","Absol","Spheal","Sealeo","Walrien","Relicanth","Wailord","Bagon","Shelgon","Salamence","Metang","Metagross","Regirock",
			"Regice","Registeel","Kyogre","Groudon","Rayquaza","Deoxys","Turtwig","Grotle","Torterra","Chimchar","Monferno","Infernape","Prinplup","Empoleon",
			"Bidoof","Bibarel","Kricketune","Cranidos","Rampardos","Shieldon","Bastiodon","Buizel","Floatzel","Gastrodon","Buneary","Lopunny","Stunky","Skuntank","Bronzong",
			"Gible","Gabite","Garchomp","Munchlax","Riolu","Lucario","Hippopotas","Hippowdon","Skorupi","Drapion","Croagunk","Toxicroak","Abomasnow","Weavile","Lickylicky",
			"Rhyperior","Tangrowth","Electivire","Magmortar","Togekiss","Leafeon","Glaceon","Gliscor","Mamoswine","Gallade","Probopass","Dusknoir","Dialga","Palkia",
			"Heatran","Regigigas","Giratina","Darkrai","Arceus","Victini","Tepig","Pignite","Emboar","Oshawott","Dewott","Samurott","Watchog","Lillipup","Herdier",
			"Stoutland","Liepard","Pansage","Simisage","Pansear","Simisear","Panpour","Simipour","Zebstrika","Roggenrola","Boldore","Drilbur","Excadrill","Timburr",
			"Gurdurr","Conkeldurr","Palpitoad","Seismitoad","Throh","Sawk","Venipede","Whirlipede","Scolipede","Krokorok","Krookodile","Darumaka","Darmanitan","Dwebble",
			"Crustle","Scraggy","Scrafty","Tirtouga","Carracosta","Archen","Archeops","Zoroark","Reuniclus","Sawsbuck","Escavalier","Ferroseed","Ferrothorn","Klink","Klang",
			"Klinklang","Eelektross","Axew","Fraxure","Haxorus","Cubchoo","Beartic","Mienfoo","Mienshao","Druddigon","Golett","Golurk","Pawniard","Bisharp","Bouffalant",
			"Rufflet","Braviary","Vullaby","Mandibuzz","Heatmor","Durant","Deino","Zweilous","Hydreigon","Cobalion","Terrakion","Virizion","Tornadus","Thundurus","Reshiram",
			"Zekrom","Landorus","Kyurem","Keldeo","Meloetta","Chespin","Quilladin","Chesnaught","Froakie","Frogadier","Greninja","Bunnelby","Diggersby","Litleo","Pyroar",
			"Skiddo","Gogoat","Pancham","Pangoro","Furfrou","Honedge","Doublade","Aegislash","Binacle","Barbaracle","Tyrunt","Tyranrum","Amaura","Aurorus","Hawlucha",
			"Goodra","Phantump","Trevenant","Pumpkaboo","Gourgeist","Bergmite","Avalugg","Zygarde","Volcanion")

			if("Dive")return list("Sqirtle","Wartortle","Blastoise","Psyduck","Golduck","Poliwag","Poliwhirl","Poliwrath","Tentacool","Tentacruel","Slowpoke","Slowbro",
			"Seel","Dewgong","Shellder","Cloyster","Krabby","Kingler","Horsea","Seadra","Goldeen","Seaking","Staryu","Starmie","Lapras","Vaporeon","Omanyte","Omastar",
			"Kabutops","Dragonite","Mewtwo","Mew","Totodile","Croconaw","Feraligatr","Chinchou","Lanturn","Marill","Azumarill","Politoed","Wooper","Quagsire","Slowking",
			"Qwilfish","Remoraid","Octillery","Mantine","Kingdra","Suicune","Lugia","Mudkip","Marshtomp","Swampert","Lombre","Ludicolo","Carvanha","Sharpedo","Wailmer",
			"Wailord","Barboach","Whiscash","Crawdaunt","Feebas","Milotic","Spheal","Sealeo","Walrein","Clamperl","Huntail","Gorebyss","Relicanth","Luvdisc","Kyogre",
			"Rayquaza","Piplup","Prinplup","Empoleon","Bibarel","Buizel","Floatzel","Shellos","Gastrodon","Finneon","Lumineon","Mantyke","Palkia","Phione","Manaphy",
			"Arceus","Oshawott","Dewott","Samurott","Panpour","Simipour","Basculin","Tirtouga","Carracosta","Ducklett","Swanna","Frillish","Jellicent","Alomomola",
			"Beartic","Froakie","Frogadier","Greninja","Skrelp","Dragalge","Clauncher","Clawitzer","Popplio","Brionne","Primarina","Wishiwashi","Mareanie","Toxapex",
			"Dewpider","Araquanid","Wimpod","Golisopod","Silvally","Bruxish","Drampa","Tapu Fini")
