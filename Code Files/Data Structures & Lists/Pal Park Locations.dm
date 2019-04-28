var
	palParkList[][] = list(
	"Field"=list("Bulbasaur","Ivysaur","Venusaur","Charmander","Charmeleon","Charizard","Pidgey","Pidgeotto","Pidgeot","Rattata","Raticate","Spearow","Fearow","Nidoran-F","Nidorina",
	"Nidoqueen","Nidoran-M","Nidorino","Nidoking","Vulpix","Ninetales","Jigglypuff","Wigglytuff","Meowth","Persian","Growlithe","Arcanine","Abra","Kadabra","Alakazam","Ponyta","Rapidash",
	"Farfetch'd","Doduo","Dodrio","Grimer","Muk","Voltorb","Electrode","Lickitung","Chansey","Kangaskhan","Mr. Mime","Scyther","Jynx","Tauros","Ditto","Eevee","Vaporeon","Jolteon",
	"Flareon","Porygon","Snorlax","Mewtwo","Chikorita","Bayleef","Meganium","Cyndaquil","Quilava","Typhlosion","Sentret","Furret","Ledyba","Ledian","Spinarak","Ariados","Pichu","Cleffa",
	"Igglybuff","Togepi","Togetic","Mareep","Flaaffy","Ampharos","Hoppip","Skiploom","Jumpluff","Sunkern","Sunflora","Yanma","Espeon","Umbreon","Wobbuffet","Girafarig","Snubbull",
	"Granbull","Granbull","Scizor","Porygon2","Stantler","Smeargle","SMoochum","Miltank","Blissey","Torchic","Combusken","Blaziken","Poochyena","Mightyena","Zigzagoon","Linoone","Taillow",
	"Swellow","Ralts","Kirlia","Gardevoir","Skitty","Delcatty","Electrike","Manectric","Plusle","Minun","Roselia","Spoink","Grumpig","Spinda","Swablu","Altaria","Zangoose","Castform",
	"Wynaut","Latias","Latios","Rayquaza"),

	"Forest"=list("Catepie","Metapod","Butterfree","Weedle","Kakuna","Beedrill","Ekans","Arbok","Pikachu","Raichu","Oddish","Gloom","Vileplume","Paras","Parasect","Venonat","Venomoth",
	"Bellsprout","Weepinbell","Victreebel","Gastly","Haunter","Gengar","Drowzee","Hypno","Exeggcute","Exeggutor","Tangela","Pinsir","Mew","Hoothoot","Noctowl","Natu","Xatu","Bellossom",
	"Aipom","Murkrow","Misdreavus","Unown","Pineco","Forretress","Dunsparce","Heracross","Teddiursa","Ursaring","Celebi","Treecko","Grovyle","Sceptile","Wurmple","Silcoon","Beautifly",
	"Cascoon","Dustox","Seedot","Nuzleaf","Shiftry","Shroomish","Breloom","Slakoth","Vigoroth","Slaking","Nincada","Ninjask","Shedinja","Gulpin","Swalot","Seviper","Kecleon","Shuppet",
	"Banette","Duskull","Dusclops","Tropius"),

	"Pond"=list("Squirtle","Wartortle","Blastoise","Psyduck","Golduck","Poliwag","Poliwhirl","Poliwrath","Slowpoke","Slowbro","Goldeen","Seaking","Magikarp","Gyarados","Dratini",
	"Dragonair","Totodile","Croconaw","Marill","Azumarill","Politoed","Wooper","Quagsire","Slowking","Mudkip","Marshtomp","Swampert","Lotad","Lombre","Ludicolo","Surskit","Masquerain",
	"Azurill","Barboach","Whiscash","Corphish","Crawdaunt"),

	"Mountain"=list("Sandshrew","Sandslash","Clefairy","Clefable","Zubat","Golbat","Diglett","Dugtrio","Mankey","Primeape","Machop","Machoke","Machamp","Geodude","Graveler","Golem",
	"Magnemite","Magneton","Onix","Cubone","Marowak","Hitmonlee","Hitmonchan","Koffing","Weezing","Rhyhorn","Rhydon","Electabuzz","Magmar","Aerodactyl","Articuno","Zapdos","Moltres",
	"Dragonite","Feraligatr","Crobat","Sudowoodo","Gligar","Steelix","Sneasel","Slugma","Magcargo","Swinub","Piloswine","Delibird","Skarmory","Houndour","Houndoom","Phanpy","Donphan",
	"Tyrogue","Hitmontop","Elekid","Magby","Raikou","Entei","Suicune","Larvitar","Pupitar","Tyranitar","Lugia","Ho-Oh","Whismur","Loudred","Exploud","Makuhita","Hariyama","Nosepass",
	"Sableye","Mawile","Aron","Lairon","Aggron","Meditite","Medicham","Volbeat","Illumise","Numel","Camerupt","Torkoal","Trapinch","Vibrava","Flygon","Cacnea","Cacturne","Lunatone",
	"Solrock","Baltoy","Claydol","Chimecho","Absol","Snorunt","Glalie","Bagon","Shelgon","Salamence","Beldum","Metang","Metagross","Regirock","Regice","Registeel","Groudon","Jirachi",
	"Deoxys"),

	"Sea"=list("Tentacool","Tentacruel","Seel","Dewgong","Shellder","Cloyster","Krabby","Kingler","Horsea","Seadra","Staryu","Starmie","Lapras","Omanyte","Omastar","Kabuto","Kabutops",
	"Chinchou","Lanturn","Qwilfish","Shuckle","Corsola","Remoraid","Octillery","Mantine","Kingdra","Wingull","Pelipper","Carvanha","Sharpedo","Wailmer","Wailord","Lileep","Cradily",
	"Anorith","Armaldo","Feebas","Milotic","Spheal","Sealeo","Walrien","Clamperl","Huntail","Gorebyss","Relicanth","Luvdisc","Kyogre")
	)