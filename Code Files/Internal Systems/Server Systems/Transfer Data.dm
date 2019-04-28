transferproxy
	var
		transfermon/mons[0]
		gen3transfer = FALSE

// Used for Transfers of Pokémon from Generation III Pokémon Games
transfermon3
	var
		name
		pName
		PIDlower
		PIDhigher
		formID
		HPIv
		attackIv
		defenseIv
		spAttackIv
		spDefenseIv
		speedIv
		HPEv
		attackEv
		defenseEv
		spAttackEv
		spDefenseEv
		speedEv
		friendship
		pokerus
		TID
		SID
		exp
		itemIndex
		fromGame
		fromRegion
		metAt
		OT
		nature
		shiny
		beauty
		cool
		cute
		tough
		smart
		sheen
		caughtLevel
		caughtBall
		OTgender
		language
		genderByte
		ribbons[]
		moveIndex1
		moveIndex2
		moveIndex3
		moveIndex4
		PPbonus1
		PPbonus2
		PPbonus3
		PPbonus4

// Used for transfer of pokémon from Generation I & Generation II pokémon games
transfermon
	var
		name
		pName
		PIDlower
		PIDhigher
		HPIv
		attackIv
		defenseIv
		spAttackIv
		spDefenseIv
		speedIv
		friendship
		pokerus
		formID
		level
		TID
		exp
		starterPikachu = FALSE
		itemIndex
		fromGame
		OT
		caughtdata
		moveIndex1
		moveIndex2
		moveIndex3
		moveIndex4
		PPbonus1
		PPbonus2
		PPbonus3
		PPbonus4

var transferHolder[0]
var caughtTransfers[0]

proc
	Process_Transfer(player/PL)
		if(fexists("Transfer Files/[ckeyEx(PL.key)].esav"))
			var savefile/F = new
			var transferproxy/T = new
			F.ImportText("/",RC5_Decrypt(file2text("Transfer Files/[ckeyEx(PL.key)].esav"),md5("#muffins")))
			T.Read(F)
			transferHolder["[ckeyEx(PL.key)]"] = list()
			caughtTransfers["[ckeyEx(PL.key)]"] = list()
			if(!T.gen3transfer)
				for(var/transfermon/TP in T.mons)
					transferHolder["[ckeyEx(PL.key)]"] += Transfer2RealMon(TP,PL)
			else
				for(var/transfermon3/TP in T.mons)
					transferHolder["[ckeyEx(PL.key)]"] += Transfer2RealMon3(TP,PL)
	Transfer2RealMon3(transfermon3/T,player/PL)
		var shineNum = (T.shiny)?(PL.tValue):(PL.tValue+1)
		var pokemon/P = get_pokemon(T.pName,PL,PIDlower=T.PIDlower,PIDhigher=T.PIDhigher,shinyNum=shineNum,formID=T.formID,theGenderByte=T.genderByte)
		P.savedFlags |= (IMPORTED | IMPORTED_FROM_GEN_3)
		P.ribbons = T.ribbons.Copy()
		P.name = T.name
		for(var/stat in list("HP","attack","defense","spAttack","spDefense","speed"))
			P.vars["[stat]Iv"] = T.vars["[stat]Iv"]
			P.vars["[stat]Ev"] = T.vars["[stat]Ev"]
		P.friendship = T.friendship
		P.beauty = T.beauty
		P.cool = T.cool
		P.tough = T.tough
		P.cute = T.cute
		P.cool = T.cool
		P.smart = T.smart
		P.sheen = T.sheen
		P.caughtRoute = T.metAt
		P.caughtWith = replacetext(T.caughtBall,"Poke Ball","Poké Ball")
		P.OTgender = T.OTgender
		P.OT = T.OT
		P.friendship = T.friendship
		P.TID = T.TID
		P.SID = T.SID
		P.language = T.language
		P.fromRegion = T.fromRegion
		P.pokerus = T.pokerus
		P.importedFrom = replacetext(T.fromGame,"Pokemon","Pokémon")
		P.moves[1] = GetMoveByIndex(T.moveIndex1,T.PPbonus1)
		P.moves[2] = GetMoveByIndex(T.moveIndex2,T.PPbonus2)
		P.moves[3] = GetMoveByIndex(T.moveIndex3,T.PPbonus3)
		P.moves[4] = GetMoveByIndex(T.moveIndex4,T.PPbonus4)
		P.level = 1
		P.caughtLevel = T.caughtLevel
		P.nature = T.nature
		P.exp = T.exp
		while( (P.level <= 100) && (P.exp>=getRequiredExp(P.expGroup,P.level+1)) )
			++P.level
		P.stat_calculate()
		P.HP = P.maxHP
		P.held = GetItemByIndexGen3(T.itemIndex)
		. = P
	Transfer2RealMon(transfermon/T,player/PL)
		var pokemon/P
		if((T.pName=="Pikachu") && (T.starterPikachu))
			P = get_pokemon("Pikachu-Starter",PL,PIDhigher=T.PIDhigher,PIDlower=T.PIDlower,hidden=TRUE,formID=T.formID)
		else
			P = get_pokemon(T.pName,PL,PIDhigher=T.PIDhigher,PIDlower=T.PIDlower,hidden=TRUE,formID=T.formID)
		P.name = T.name
		P.HPIv = T.HPIv
		P.attackIv = T.attackIv
		P.defenseIv = T.defenseIv
		P.spAttackIv = T.spAttackIv
		P.spDefenseIv = T.spDefenseIv
		P.speedIv = T.speedIv
		P.friendship = T.friendship // Eh, what the heck?
		P.pokerus = T.pokerus
		switch(T.fromGame)
			if("Red/Blue/Green/Yellow","Red/Blue/Green","Yellow")
				P.fromRegion = "Kanto"
			if("Gold/Silver","Crystal")
				P.fromRegion = "Johto"
		P.importedFrom = "Pokémon [T.fromGame]"
		P.level = T.level
		P.OT = T.OT
		P.TID = T.TID
		P.SID = 65535
		P.exp = P.exp
		P.moves[1] = GetMoveByIndex(T.moveIndex1,T.PPbonus1)
		P.moves[2] = GetMoveByIndex(T.moveIndex2,T.PPbonus2)
		P.moves[3] = GetMoveByIndex(T.moveIndex3,T.PPbonus3)
		P.moves[4] = GetMoveByIndex(T.moveIndex4,T.PPbonus4)
		P.held = GetItemByIndex(T.itemIndex)
		P.savedFlags |= IMPORTED
		P.caughtRoute = "Area Unknown."
		. = P
	GetItemByIndexGen3(itemIndex)
		switch(itemIndex)
			if(0x0001). = new /item/pokeball/Master_Ball
			if(0x0002). = new /item/pokeball/Ultra_Ball
			if(0x0003). = new /item/pokeball/Great_Ball
			if(0x0004). = new /item/pokeball/Poke_Ball
			if(0x0005). = new /item/pokeball/Safari_Ball
			if(0x0006). = new /item/pokeball/Net_Ball
			if(0x0007). = new /item/pokeball/Dive_Ball
			if(0x0008). = new /item/pokeball/Nest_Ball
			if(0x0009). = new /item/pokeball/Repeat_Ball
			if(0x000A). = new /item/pokeball/Timer_Ball
			if(0x000B). = new /item/pokeball/Luxury_Ball
			if(0x000C). = new /item/pokeball/Premier_Ball
			if(0x000D). = new /item/medicine/Potion
			if(0x000E). = new /item/medicine/Antidote
			if(0x000F). = new /item/medicine/Burn_Heal
			if(0x0010). = new /item/medicine/Ice_Heal
			if(0x0011). = new /item/medicine/Awakening
			if(0x0012). = new /item/medicine/Paralyze_Heal
			if(0x0013). = new /item/medicine/Full_Restore
			if(0x0014). = new /item/medicine/Max_Potion
			if(0x0015). = new /item/medicine/Hyper_Potion
			if(0x0016). = new /item/medicine/Super_Potion
			if(0x0017). = new /item/medicine/Full_Heal
			if(0x0018). = new /item/medicine/Revive
			if(0x0019). = new /item/medicine/Max_Revive
			if(0x001A). = new /item/medicine/Fresh_Water
			if(0x001B). = new /item/medicine/Soda_Pop
			if(0x001C). = new /item/medicine/Lemonade
			if(0x001D). = new /item/medicine/Moomoo_Milk
			if(0x001E). = new /item/medicine/herb/Energy_Powder
			if(0x001F). = new /item/medicine/herb/Energy_Root
			if(0x0020). = new /item/medicine/herb/Heal_Powder
			if(0x0021). = new /item/medicine/herb/Revival_Herb
			if(0x0022). = new /item/medicine/Ether
			if(0x0023). = new /item/medicine/Max_Ether
			if(0x0024). = new /item/medicine/Elixir
			if(0x0025). = new /item/medicine/Max_Elixir
			if(0x0026). = new /item/medicine/Lava_Cookie
			if(0x0027). = new /item/normal/flute/Blue_Flute
			if(0x0028). = new /item/normal/flute/Yellow_Flute
			if(0x0029). = new /item/normal/flute/Red_Flute
			if(0x002A). = new /item/normal/flute/Black_Flute
			if(0x002B). = new /item/normal/flute/White_Flute
			if(0x002C). = new /item/medicine/Berry_Juice
			if(0x002D). = new /item/medicine/Sacred_Ash
			if(0x002E). = new /item/normal/Shoal_Salt
			if(0x002F). = new /item/normal/Shoal_Shell
			if(0x0030). = new /item/normal/shard/Red_Shard
			if(0x0031). = new /item/normal/shard/Blue_Shard
			if(0x0032). = new /item/normal/shard/Yellow_Shard
			if(0x0033). = new /item/normal/shard/Green_Shard
			if(0x003F). = new /item/medicine/HP_Up
			if(0x0040). = new /item/medicine/Protien
			if(0x0041). = new /item/medicine/Iron
			if(0x0042). = new /item/medicine/Carbos
			if(0x0043). = new /item/medicine/Calcium
			if(0x0044). = new /item/medicine/Rare_Candy
			if(0x0045). = new /item/medicine/PP_Up
			if(0x0046). = new /item/medicine/Zinc
			if(0x0047). = new /item/medicine/PP_Max
			if(0x0049). = new /item/battle/Guard_Special
			if(0x004A). = new /item/battle/Dire_Hit
			if(0x004B). = new /item/battle/X_Attack
			if(0x004C). = new /item/battle/X_Defend
			if(0x004D). = new /item/battle/X_Speed
			if(0x004E). = new /item/battle/X_Accuracy
			if(0x004F). = new /item/battle/X_Special
			if(0x0050). = new /item/battle/Poke_Doll
			if(0x0051). = new /item/battle/Fluffy_Tail
			if(0x0053). = new /item/normal/repellent/Super_Repel
			if(0x0054). = new /item/normal/repellent/Max_Repel
			if(0x0055). = new /item/normal/Escape_Rope
			if(0x0056). = new /item/normal/repellent/Repel
			if(0x005D). = new /item/normal/stone/Sun_Stone
			if(0x005E). = new /item/normal/stone/Moon_Stone
			if(0x005F). = new /item/normal/stone/Fire_Stone
			if(0x0060). = new /item/normal/stone/Thunder_Stone
			if(0x0061). = new /item/normal/stone/Water_Stone
			if(0x0062). = new /item/normal/stone/Leaf_Stone
			if(0x0067). = new /item/normal/Tiny_Mushroom
			if(0x0068). = new /item/normal/Big_Mushroom
			if(0x006A). = new /item/normal/Pearl
			if(0x006B). = new /item/normal/Big_Pearl
			if(0x006C). = new /item/normal/Star_Dust
			if(0x006D). = new /item/normal/Star_Piece
			if(0x006E). = new /item/normal/Nugget
			if(0x006F). = new /item/normal/Heart_Scale
			if(0x0085). = new /item/berry/Cheri_Berry
			if(0x0086). = new /item/berry/Chesto_Berry
			if(0x0087). = new /item/berry/Pecha_Berry
			if(0x0088). = new /item/berry/Rawst_Berry
			if(0x0089). = new /item/berry/Aspear_Berry
			if(0x008A). = new /item/berry/Leppa_Berry
			if(0x008B). = new /item/berry/Oran_Berry
			if(0x008C). = new /item/berry/Persim_Berry
			if(0x008D). = new /item/berry/Lum_Berry
			if(0x008E). = new /item/berry/Sitrus_Berry
			if(0x008F). = new /item/berry/Figy_Berry
			if(0x0090). = new /item/berry/Wiki_Berry
			if(0x0091). = new /item/berry/Mago_Berry
			if(0x0092). = new /item/berry/Aguav_Berry
			if(0x0093). = new /item/berry/Iapapa_Berry
			if(0x0094). = new /item/berry/Razz_Berry
			if(0x0095). = new /item/berry/Bluk_Berry
			if(0x0096). = new /item/berry/Nanab_Berry
			if(0x0097). = new /item/berry/Wepear_Berry
			if(0x0098). = new /item/berry/Pinap_Berry
			if(0x0099). = new /item/berry/Pomeg_Berry
			if(0x009A). = new /item/berry/Kelpsy_Berry
			if(0x009B). = new /item/berry/Qualot_Berry
			if(0x009C). = new /item/berry/Hondew_Berry
			if(0x009D). = new /item/berry/Grepa_Berry
			if(0x009E). = new /item/berry/Tomato_Berry
			if(0x009F). = new /item/berry/Cornn_Berry
			if(0x00A0). = new /item/berry/Magost_Berry
			if(0x00A1). = new /item/berry/Rabuta_Berry
			if(0x00A2). = new /item/berry/Nomel_Berry
			if(0x00A3). = new /item/berry/Spelon_Berry
			if(0x00A4). = new /item/berry/Pamtre_Berry
			if(0x00A5). = new /item/berry/Watmel_Berry
			if(0x00A6). = new /item/berry/Durin_Berry
			if(0x00A7). = new /item/berry/Belue_Berry
			if(0x00A8). = new /item/berry/Liechi_Berry
			if(0x00A9). = new /item/berry/Ganlon_Berry
			if(0x00AA). = new /item/berry/Salac_Berry
			if(0x00AB). = new /item/berry/Petaya_Berry
			if(0x00AC). = new /item/berry/Apicot_Berry
			if(0x00AD). = new /item/berry/Lansat_Berry
			if(0x00AE). = new /item/berry/Starf_Berry
			if(0x00AF). = new /item/berry/Enigma_Berry
			if(0x00B3). = new /item/normal/Bright_Powder
			if(0x00B4). = new /item/normal/White_Herb
			if(0x00B5). = new /item/normal/Macho_Brace
			if(0x00B6). = new /item/normal/exp_item/Exp_Share
			if(0x00B7). = new /item/normal/Quick_Claw
			if(0x00B8). = new /item/normal/Soothe_Bell
			if(0x00B9). = new /item/normal/Mental_Herb
			if(0x00BA). = new /item/normal/choice/Choice_Band
			if(0x00BB). = new /item/normal/evolve_item/trade/King\'\s_Rock
			if(0x00BC). = new /item/normal/Silver_Powder
			if(0x00BD). = new /item/normal/Amulet_Coin
			if(0x00BE). = new /item/normal/Cleanse_Tag
			if(0x00BF). = new /item/normal/stat_item/Soul_Dew
			if(0x00C0). = new /item/normal/evolve_item/trade/Deep_Sea_Tooth
			if(0x00C1). = new /item/normal/evolve_item/trade/Deep_Sea_Scale
			if(0x00C2). = new /item/normal/Smoke_Ball
			if(0x00C3). = new /item/normal/Everstone
			if(0x00C4). = new /item/normal/Focus_Band
			if(0x00C5). = new /item/normal/exp_item/Lucky_Egg
			if(0x00C6). = new /item/normal/Scope_Lens
			if(0x00C7). = new /item/normal/evolve_item/trade/Metal_Coat
			if(0x00C8). = new /item/normal/Leftovers
			if(0x00C9). = new /item/normal/evolve_item/trade/Dragon_Scale
			if(0x00CA). = new /item/normal/stat_item/Light_Ball
			if(0x00CB). = new /item/normal/stat_item/Soft_Sand
			if(0x00CC). = new /item/normal/stat_item/Hard_Stone
			if(0x00CD). = new /item/normal/stat_item/Miracle_Seed
			if(0x00CE). = new /item/normal/stat_item/Black_Glasses
			if(0x00CF). = new /item/normal/stat_item/Black_Belt
			if(0x00D0). = new /item/normal/stat_item/Magnet
			if(0x00D1). = new /item/normal/stat_item/Mystic_Water
			if(0x00D2). = new /item/normal/stat_item/Sharp_Beak
			if(0x00D3). = new /item/normal/stat_item/Poison_Barb
			if(0x00D4). = new /item/normal/stat_item/Never\-\Melt_Ice
			if(0x00D5). = new /item/normal/stat_item/Spell_Tag
			if(0x00D6). = new /item/normal/stat_item/Twisted_Spoon
			if(0x00D8). = new /item/normal/stat_item/Charcoal
			if(0x00D9). = new /item/normal/stat_item/Silk_Scarf
			if(0x00DA). = new /item/normal/evolve_item/trade/Up\-\Grade
			if(0x00DB). = new /item/normal/Shell_Bell
			if(0x00DC). = new /item/normal/incense/Sea_Incense
			if(0x00DD). = new /item/normal/incense/Lax_Incense
			if(0x00DE). = new /item/normal/Lucky_Punch
			if(0x00DF). = new /item/normal/Metal_Powder
			if(0x00E0). = new /item/normal/Thick_Club
			if(0x00FE). = new /item/normal/scarf/Red_Scarf
			if(0x00FF). = new /item/normal/scarf/Blue_Scarf
			if(0x0100). = new /item/normal/scarf/Pink_Scarf
			if(0x0101). = new /item/normal/scarf/Green_Scarf
			if(0x0102). = new /item/normal/scarf/Yellow_Scarf
			if(0x0121). = new /item/tm/disposable/TM3/TM01
			if(0x0122). = new /item/tm/disposable/TM3/TM02
			if(0x0123). = new /item/tm/disposable/TM3/TM03
			if(0x0124). = new /item/tm/disposable/TM3/TM04
			if(0x0125). = new /item/tm/disposable/TM3/TM05
			if(0x0126). = new /item/tm/disposable/TM3/TM06
			if(0x0127). = new /item/tm/disposable/TM3/TM07
			if(0x0128). = new /item/tm/disposable/TM3/TM08
			if(0x0129). = new /item/tm/disposable/TM3/TM09
			if(0x012A). = new /item/tm/disposable/TM3/TM10
			if(0x012B). = new /item/tm/disposable/TM3/TM11
			if(0x012C). = new /item/tm/disposable/TM3/TM12
			if(0x012D). = new /item/tm/disposable/TM3/TM13
			if(0x012E). = new /item/tm/disposable/TM3/TM14
			if(0x012F). = new /item/tm/disposable/TM3/TM15
			if(0x0130). = new /item/tm/disposable/TM3/TM16
			if(0x0131). = new /item/tm/disposable/TM3/TM17
			if(0x0132). = new /item/tm/disposable/TM3/TM18
			if(0x0133). = new /item/tm/disposable/TM3/TM19
			if(0x0134). = new /item/tm/disposable/TM3/TM20
			if(0x0135). = new /item/tm/disposable/TM3/TM21
			if(0x0136). = new /item/tm/disposable/TM3/TM22
			if(0x0137). = new /item/tm/disposable/TM3/TM23
			if(0x0138). = new /item/tm/disposable/TM3/TM24
			if(0x0139). = new /item/tm/disposable/TM3/TM25
			if(0x013A). = new /item/tm/disposable/TM3/TM26
			if(0x013B). = new /item/tm/disposable/TM3/TM27
			if(0x013C). = new /item/tm/disposable/TM3/TM28
			if(0x013D). = new /item/tm/disposable/TM3/TM29
			if(0x013E). = new /item/tm/disposable/TM3/TM30
			if(0x013F). = new /item/tm/disposable/TM3/TM31
			if(0x0140). = new /item/tm/disposable/TM3/TM32
			if(0x0141). = new /item/tm/disposable/TM3/TM33
			if(0x0142). = new /item/tm/disposable/TM3/TM34
			if(0x0143). = new /item/tm/disposable/TM3/TM35
			if(0x0144). = new /item/tm/disposable/TM3/TM36
			if(0x0145). = new /item/tm/disposable/TM3/TM37
			if(0x0146). = new /item/tm/disposable/TM3/TM38
			if(0x0147). = new /item/tm/disposable/TM3/TM39
			if(0x0148). = new /item/tm/disposable/TM3/TM40
			if(0x0149). = new /item/tm/disposable/TM3/TM41
			if(0x014A). = new /item/tm/disposable/TM3/TM42
			if(0x014B). = new /item/tm/disposable/TM3/TM43
			if(0x014C). = new /item/tm/disposable/TM3/TM44
			if(0x014D). = new /item/tm/disposable/TM3/TM45
			if(0x014E). = new /item/tm/disposable/TM3/TM46
			if(0x014F). = new /item/tm/disposable/TM3/TM47
			if(0x0150). = new /item/tm/disposable/TM3/TM48
			if(0x0151). = new /item/tm/disposable/TM3/TM49
			if(0x0152). = new /item/tm/disposable/TM3/TM50
	GetItemByIndex(itemIndex)
		switch(itemIndex)
			if(0x00). = null
			if(0x01). = new /item/pokeball/Master_Ball
			if(0x02). = new /item/pokeball/Ultra_Ball
			if(0x04). = new /item/pokeball/Great_Ball
			if(0x05). = new /item/pokeball/Poke_Ball
			if(0x08). = new /item/normal/stone/Moon_Stone
			if(0x09). = new /item/medicine/Antidote
			if(0x0A). = new /item/medicine/Burn_Heal
			if(0x0B). = new /item/medicine/Ice_Heal
			if(0x0C). = new /item/medicine/Awakening
			if(0x0D). = new /item/medicine/Paralyze_Heal
			if(0x0E). = new /item/medicine/Full_Restore
			if(0x0F). = new /item/medicine/Max_Potion
			if(0x10). = new /item/medicine/Hyper_Potion
			if(0x11). = new /item/medicine/Super_Potion
			if(0x12). = new /item/medicine/Potion
			if(0x13). = new /item/normal/Escape_Rope
			if(0x14). = new /item/normal/repellent/Repel
			if(0x15). = new /item/medicine/Max_Elixir
			if(0x16). = new /item/normal/stone/Fire_Stone
			if(0x17). = new /item/normal/stone/Thunder_Stone
			if(0x18). = new /item/normal/stone/Water_Stone
			if(0x19). = new /item/normal/Leftovers
			if(0x1A). = new /item/medicine/HP_Up
			if(0x1B). = new /item/medicine/Protien
			if(0x1C). = new /item/medicine/Iron
			if(0x1D). = new /item/medicine/Carbos
			if(0x1E). = new /item/normal/Lucky_Punch
			if(0x1F). = new /item/medicine/Calcium
			if(0x20). = new /item/medicine/Rare_Candy
			if(0x21). = new /item/battle/X_Accuracy
			if(0x22). = new /item/normal/stone/Leaf_Stone
			if(0x23). = new /item/normal/Metal_Powder
			if(0x24). = new /item/normal/Nugget
			if(0x25). = new /item/battle/Poke_Doll
			if(0x26). = new /item/medicine/Full_Heal
			if(0x27). = new /item/medicine/Revive
			if(0x28). = new /item/medicine/Max_Revive
			if(0x29). = new /item/battle/Guard_Special
			if(0x2A). = new /item/normal/repellent/Super_Repel
			if(0x2B). = new /item/normal/repellent/Max_Repel
			if(0x2C). = new /item/battle/Dire_Hit
			if(0x2D). = new /item/berry/Persim_Berry
			if(0x2E). = new /item/medicine/Fresh_Water
			if(0x2F). = new /item/medicine/Soda_Pop
			if(0x30). = new /item/medicine/Lemonade
			if(0x31). = new /item/battle/X_Attack
			if(0x32). = new /item/berry/Sitrus_Berry
			if(0x33). = new /item/battle/X_Defend
			if(0x34). = new /item/battle/X_Speed
			if(0x35). = new /item/battle/X_Special
			if(0x39). = new /item/normal/exp_item/Exp_Share
			if(0x3E). = new /item/medicine/PP_Up
			if(0x3F). = new /item/medicine/Ether
			if(0x40). = new /item/medicine/Max_Ether
			if(0x41). = new /item/medicine/Elixir
			if(0x48). = new /item/medicine/Moomoo_Milk
			if(0x49). = new /item/normal/Quick_Claw
			if(0x4A). = new /item/berry/Pecha_Berry
			if(0x4C). = new /item/normal/stat_item/Soft_Sand
			if(0x4D). = new /item/normal/stat_item/Sharp_Beak
			if(0x4E). = new /item/berry/Cheri_Berry
			if(0x4F). = new /item/berry/Aspear_Berry
			if(0x50). = new /item/berry/Rawst_Berry
			if(0x51). = new /item/normal/stat_item/Poison_Barb
			if(0x52). = new /item/normal/evolve_item/trade/King\'\s_Rock
			if(0x53). = new /item/berry/Persim_Berry
			if(0x54). = new /item/berry/Chesto_Berry
			if(0x56). = new /item/normal/Tiny_Mushroom
			if(0x57). = new /item/normal/Big_Mushroom
			if(0x58). = new /item/normal/Silver_Powder
			if(0x5B). = new /item/normal/Amulet_Coin
			if(0x5F). = new /item/normal/stat_item/Mystic_Water
			if(0x60). = new /item/normal/stat_item/Twisted_Spoon
			if(0x61). = new /item/normal/stat_item/Black_Belt
			if(0x66). = new /item/normal/stat_item/Black_Glasses
			if(0x67). = new /item/normal/Slowpoke_Tail
			if(0x69). = new /item/normal/Stick
			if(0x6A). = new /item/normal/Smoke_Ball
			if(0x6B). = new /item/normal/stat_item/Never\-\Melt_Ice
			if(0x6C). = new /item/normal/stat_item/Magnet
			if(0x6D). = new /item/berry/Lum_Berry
			if(0x6E). = new /item/normal/Pearl
			if(0x6F). = new /item/normal/Big_Pearl
			if(0x70). = new /item/normal/Everstone
			if(0x71). = new /item/normal/stat_item/Spell_Tag
			if(0x72). = new /item/medicine/Rage_Candy_Bar
			if(0x75). = new /item/normal/stat_item/Miracle_Seed
			if(0x76). = new /item/normal/Thick_Club
			if(0x77). = new /item/normal/Focus_Band
			if(0x79). = new /item/medicine/herb/Energy_Powder
			if(0x7A). = new /item/medicine/herb/Energy_Root
			if(0x7B). = new /item/medicine/herb/Heal_Powder
			if(0x7C). = new /item/medicine/herb/Revival_Herb
			if(0x7D). = new /item/normal/stat_item/Hard_Stone
			if(0x7E). = new /item/normal/exp_item/Lucky_Egg
			if(0x83). = new /item/normal/Star_Dust
			if(0x84). = new /item/normal/Star_Piece
			if(0x8A). = new /item/normal/stat_item/Charcoal
			if(0x8B). = new /item/medicine/Berry_Juice
			if(0x8C). = new /item/normal/Scope_Lens
			if(0x8F). = new /item/normal/evolve_item/trade/Metal_Coat
			if(0x90). = new /item/normal/stat_item/Dragon_Fang
			if(0x92). = new /item/normal/Leftovers
			if(0x96). = new /item/berry/Leppa_Berry
			if(0x97). = new /item/normal/evolve_item/trade/Dragon_Scale
			if(0x9C). = new /item/medicine/Sacred_Ash
			if(0x9D). = new /item/pokeball/Heavy_Ball
			if(0x9F). = new /item/pokeball/Level_Ball
			if(0xA0). = new /item/pokeball/Lure_Ball
			if(0xA1). = new /item/pokeball/Fast_Ball
			if(0xA3). = new /item/normal/stat_item/Light_Ball
			if(0xA4). = new /item/pokeball/Friend_Ball
			if(0xA5). = new /item/pokeball/Moon_Ball
			if(0xA6). = new /item/pokeball/Love_Ball
			if(0xAC). = new /item/normal/evolve_item/trade/Up\-\Grade
			if(0xAD). = new /item/berry/Oran_Berry
			if(0xAE). = new /item/berry/Sitrus_Berry
			if(0xB1). = new /item/pokeball/Sport_Ball
			if(0xBF). = new /item/tm/disposable/TM2/TM01
			if(0xC0). = new /item/tm/disposable/TM2/TM02
			if(0xC1). = new /item/tm/disposable/TM2/TM03
			if(0xC2). = new /item/tm/disposable/TM2/TM04
			if(0xC4). = new /item/tm/disposable/TM2/TM05
			if(0xC5). = new /item/tm/disposable/TM2/TM06
			if(0xC6). = new /item/tm/disposable/TM2/TM07
			if(0xC7). = new /item/tm/disposable/TM2/TM08
			if(0xC8). = new /item/tm/disposable/TM2/TM09
			if(0xC9). = new /item/tm/disposable/TM2/TM10
			if(0xCA). = new /item/tm/disposable/TM2/TM11
			if(0xCB). = new /item/tm/disposable/TM2/TM12
			if(0xCC). = new /item/tm/disposable/TM2/TM13
			if(0xCD). = new /item/tm/disposable/TM2/TM14
			if(0xCE). = new /item/tm/disposable/TM2/TM15
			if(0xCF). = new /item/tm/disposable/TM2/TM16
			if(0xD0). = new /item/tm/disposable/TM2/TM17
			if(0xD1). = new /item/tm/disposable/TM2/TM18
			if(0xD2). = new /item/tm/disposable/TM2/TM19
			if(0xD3). = new /item/tm/disposable/TM2/TM20
			if(0xD4). = new /item/tm/disposable/TM2/TM21
			if(0xD5). = new /item/tm/disposable/TM2/TM22
			if(0xD6). = new /item/tm/disposable/TM2/TM23
			if(0xD7). = new /item/tm/disposable/TM2/TM24
			if(0xD8). = new /item/tm/disposable/TM2/TM25
			if(0xD9). = new /item/tm/disposable/TM2/TM26
			if(0xDA). = new /item/tm/disposable/TM2/TM27
			if(0xDB). = new /item/tm/disposable/TM2/TM28
			if(0xDD). = new /item/tm/disposable/TM2/TM29
			if(0xDE). = new /item/tm/disposable/TM2/TM30
			if(0xDF). = new /item/tm/disposable/TM2/TM31
			if(0xE0). = new /item/tm/disposable/TM2/TM32
			if(0xE1). = new /item/tm/disposable/TM2/TM33
			if(0xE2). = new /item/tm/disposable/TM2/TM34
			if(0xE3). = new /item/tm/disposable/TM2/TM35
			if(0xE4). = new /item/tm/disposable/TM2/TM36
			if(0xE5). = new /item/tm/disposable/TM2/TM37
			if(0xE6). = new /item/tm/disposable/TM2/TM38
			if(0xE7). = new /item/tm/disposable/TM2/TM39
			if(0xE8). = new /item/tm/disposable/TM2/TM40
			if(0xE9). = new /item/tm/disposable/TM2/TM41
			if(0xEA). = new /item/tm/disposable/TM2/TM42
			if(0xEB). = new /item/tm/disposable/TM2/TM43
			if(0xEC). = new /item/tm/disposable/TM2/TM44
			if(0xED). = new /item/tm/disposable/TM2/TM45
			if(0xEE). = new /item/tm/disposable/TM2/TM46
			if(0xEF). = new /item/tm/disposable/TM2/TM47
			if(0xF0). = new /item/tm/disposable/TM2/TM48
			if(0xF1). = new /item/tm/disposable/TM2/TM49
			if(0xF2). = new /item/tm/disposable/TM2/TM50
			else . = /item/berry/Oran_Berry
	GetMoveByIndex(moveIndex,PPBonus=0)
		switch(moveIndex)
			if(1). = new /pmove/Pound
			if(2). = new /pmove/Karate_Chop
			if(3). = new /pmove/Double_Slap
			if(4). = new /pmove/Comet_Punch
			if(5). = new /pmove/Mega_Punch
			if(6). = new /pmove/Pay_Day
			if(7). = new /pmove/Fire_Punch
			if(8). = new /pmove/Ice_Punch
			if(9). = new /pmove/Thunder_Punch
			if(10). = new /pmove/Scratch
			if(11). = new /pmove/Vice_Grip
			if(12). = new /pmove/Guillotine
			if(13). = new /pmove/Razor_Wind
			if(14). = new /pmove/Swords_Dance
			if(15). = new /pmove/Cut
			if(16). = new /pmove/Gust
			if(17). = new /pmove/Wing_Attack
			if(18). = new /pmove/Whirlwind
			if(19). = new /pmove/Fly
			if(20). = new /pmove/Bind
			if(21). = new /pmove/Slam
			if(22). = new /pmove/Vine_Whip
			if(23). = new /pmove/Stomp
			if(24). = new /pmove/Double_Kick
			if(25). = new /pmove/Mega_Kick
			if(26). = new /pmove/Jump_Kick
			if(27). = new /pmove/Rolling_Kick
			if(28). = new /pmove/Sand_Attack
			if(29). = new /pmove/Headbutt
			if(30). = new /pmove/Horn_Attack
			if(31). = new /pmove/Fury_Attack
			if(32). = new /pmove/Horn_Drill
			if(33). = new /pmove/Tackle
			if(34). = new /pmove/Body_Slam
			if(35). = new /pmove/Wrap
			if(36). = new /pmove/Take_Down
			if(37). = new /pmove/Thrash
			if(38). = new /pmove/Double\-\Edge
			if(39). = new /pmove/Tail_Whip
			if(40). = new /pmove/Poison_Sting
			if(41). = new /pmove/Twineedle
			if(42). = new /pmove/Pin_Missile
			if(43). = new /pmove/Leer
			if(44). = new /pmove/Bite
			if(45). = new /pmove/Growl
			if(46). = new /pmove/Roar
			if(47). = new /pmove/Sing
			if(48). = new /pmove/Supersonic
			if(49). = new /pmove/Sonic_Boom
			if(50). = new /pmove/Disable
			if(51). = new /pmove/Acid
			if(52). = new /pmove/Ember
			if(53). = new /pmove/Flamethrower
			if(54). = new /pmove/Mist
			if(55). = new /pmove/Water_Gun
			if(56). = new /pmove/Hydro_Pump
			if(57). = new /pmove/Surf
			if(58). = new /pmove/Ice_Beam
			if(59). = new /pmove/Blizzard
			if(60). = new /pmove/Psybeam
			if(61). = new /pmove/Bubble_Beam
			if(62). = new /pmove/Aurora_Beam
			if(63). = new /pmove/Hyper_Beam
			if(64). = new /pmove/Peck
			if(65). = new /pmove/Drill_Peck
			if(66). = new /pmove/Submission
			if(67). = new /pmove/Low_Kick
			if(68). = new /pmove/Counter
			if(69). = new /pmove/Seismic_Toss
			if(70). = new /pmove/Strength
			if(71). = new /pmove/Absorb
			if(72). = new /pmove/Mega_Drain
			if(73). = new /pmove/Leech_Seed
			if(74). = new /pmove/Growth
			if(75). = new /pmove/Razor_Leaf
			if(76). = new /pmove/Solar_Beam
			if(77). = new /pmove/Poison_Powder
			if(78). = new /pmove/Stun_Spore
			if(79). = new /pmove/Sleep_Powder
			if(80). = new /pmove/Petal_Dance
			if(81). = new /pmove/String_Shot
			if(82). = new /pmove/Dragon_Rage
			if(83). = new /pmove/Fire_Spin
			if(84). = new /pmove/Thunder_Shock
			if(85). = new /pmove/Thunderbolt
			if(86). = new /pmove/Thunder_Wave
			if(87). = new /pmove/Thunder
			if(88). = new /pmove/Rock_Throw
			if(89). = new /pmove/Earthquake
			if(90). = new /pmove/Fissure
			if(91). = new /pmove/Dig
			if(92). = new /pmove/Toxic
			if(93). = new /pmove/Confusion
			if(94). = new /pmove/Psychic
			if(95). = new /pmove/Hypnosis
			if(96). = new /pmove/Meditate
			if(97). = new /pmove/Agility
			if(98). = new /pmove/Quick_Attack
			if(99). = new /pmove/Rage
			if(100). = new /pmove/Teleport
			if(101). = new /pmove/Night_Shade
			if(102). = new /pmove/Mimic
			if(103). = new /pmove/Screech
			if(104). = new /pmove/Double_Team
			if(105). = new /pmove/Recover
			if(106). = new /pmove/Harden
			if(107). = new /pmove/Minimize
			if(108). = new /pmove/Smokescreen
			if(109). = new /pmove/Confuse_Ray
			if(110). = new /pmove/Withdraw
			if(111). = new /pmove/Defense_Curl
			if(112). = new /pmove/Barrier
			if(113). = new /pmove/Light_Screen
			if(114). = new /pmove/Haze
			if(115). = new /pmove/Reflect
			if(116). = new /pmove/Focus_Energy
			if(117). = new /pmove/Bide
			if(118). = new /pmove/Metronome
			if(119). = new /pmove/Mirror_Move
			if(120). = new /pmove/Self\-\Destruct
			if(121). = new /pmove/Egg_Bomb
			if(122). = new /pmove/Lick
			if(123). = new /pmove/Smog
			if(124). = new /pmove/Sludge
			if(125). = new /pmove/Bone_Club
			if(126). = new /pmove/Fire_Blast
			if(127). = new /pmove/Waterfall
			if(128). = new /pmove/Clamp
			if(129). = new /pmove/Swift
			if(130). = new /pmove/Skull_Bash
			if(131). = new /pmove/Spike_Cannon
			if(132). = new /pmove/Constrict
			if(133). = new /pmove/Amnesia
			if(134). = new /pmove/Kinesis
			if(135). = new /pmove/Soft\-\Boiled
			if(136). = new /pmove/High_Jump_Kick
			if(137). = new /pmove/Glare
			if(138). = new /pmove/Dream_Eater
			if(139). = new /pmove/Poison_Gas
			if(140). = new /pmove/Barrage
			if(141). = new /pmove/Leech_Life
			if(142). = new /pmove/Lovely_Kiss
			if(143). = new /pmove/Sky_Attack
			if(144). = new /pmove/Transform
			if(145). = new /pmove/Bubble
			if(146). = new /pmove/Dizzy_Punch
			if(147). = new /pmove/Spore
			if(148). = new /pmove/Flash
			if(149). = new /pmove/Psywave
			if(150). = new /pmove/Splash
			if(151). = new /pmove/Acid_Armor
			if(152). = new /pmove/Crabhammer
			if(153). = new /pmove/Explosion
			if(154). = new /pmove/Fury_Swipes
			if(155). = new /pmove/Bonemerang
			if(156). = new /pmove/Rest
			if(157). = new /pmove/Rock_Slide
			if(158). = new /pmove/Hyper_Fang
			if(159). = new /pmove/Sharpen
			if(160). = new /pmove/Conversion
			if(161). = new /pmove/Tri_Attack
			if(162). = new /pmove/Super_Fang
			if(163). = new /pmove/Slash
			if(164). = new /pmove/Substitute
			if(165). = new /pmove/Struggle
			if(166). = new /pmove/Sketch
			if(167). = new /pmove/Triple_Kick
			if(168). = new /pmove/Thief
			if(169). = new /pmove/Spider_Web
			if(170). = new /pmove/Mind_Reader
			if(171). = new /pmove/Nightmare
			if(172). = new /pmove/Flame_Wheel
			if(173). = new /pmove/Snore
			if(174). = new /pmove/Curse
			if(175). = new /pmove/Flail
			if(176). = new /pmove/Conversion_2
			if(177). = new /pmove/Aeroblast
			if(178). = new /pmove/Cotton_Spore
			if(179). = new /pmove/Reversal
			if(180). = new /pmove/Spite
			if(181). = new /pmove/Powder_Snow
			if(182). = new /pmove/Protect
			if(183). = new /pmove/Mach_Punch
			if(184). = new /pmove/Scary_Face
			if(185). = new /pmove/Feint_Attack
			if(186). = new /pmove/Sweet_Kiss
			if(187). = new /pmove/Belly_Drum
			if(188). = new /pmove/Sludge_Bomb
			if(189). = new /pmove/Mud\-\Slap
			if(190). = new /pmove/Octazooka
			if(191). = new /pmove/Spikes
			if(192). = new /pmove/Zap_Cannon
			if(193). = new /pmove/Foresight
			if(194). = new /pmove/Destiny_Bond
			if(195). = new /pmove/Perish_Song
			if(196). = new /pmove/Icy_Wind
			if(197). = new /pmove/Detect
			if(198). = new /pmove/Bone_Rush
			if(199). = new /pmove/Lock\-\On
			if(200). = new /pmove/Outrage
			if(201). = new /pmove/Sandstorm
			if(202). = new /pmove/Giga_Drain
			if(203). = new /pmove/Endure
			if(204). = new /pmove/Charm
			if(205). = new /pmove/Rollout
			if(206). = new /pmove/False_Swipe
			if(207). = new /pmove/Swagger
			if(208). = new /pmove/Milk_Drink
			if(209). = new /pmove/Spark
			if(210). = new /pmove/Fury_Cutter
			if(211). = new /pmove/Steel_Wing
			if(212). = new /pmove/Mean_Look
			if(213). = new /pmove/Attract
			if(214). = new /pmove/Sleep_Talk
			if(215). = new /pmove/Heal_Bell
			if(216). = new /pmove/Return
			if(217). = new /pmove/Present
			if(218). = new /pmove/Frustration
			if(219). = new /pmove/Safeguard
			if(220). = new /pmove/Pain_Split
			if(221). = new /pmove/Sacred_Fire
			if(222). = new /pmove/Magnitude
			if(223). = new /pmove/Dynamic_Punch
			if(224). = new /pmove/Megahorn
			if(225). = new /pmove/Dragon_Breath
			if(226). = new /pmove/Encore
			if(227). = new /pmove/Baton_Pass
			if(228). = new /pmove/Pursuit
			if(229). = new /pmove/Rapid_Spin
			if(230). = new /pmove/Sweet_Scent
			if(231). = new /pmove/Iron_Tail
			if(232). = new /pmove/Metal_Claw
			if(233). = new /pmove/Vital_Throw
			if(234). = new /pmove/Morning_Sun
			if(235). = new /pmove/Synthesis
			if(236). = new /pmove/Moonlight
			if(237). = new /pmove/Hidden_Power
			if(238). = new /pmove/Cross_Chop
			if(239). = new /pmove/Twister
			if(240). = new /pmove/Rain_Dance
			if(241). = new /pmove/Sunny_Day
			if(242). = new /pmove/Crunch
			if(243). = new /pmove/Mirror_Coat
			if(244). = new /pmove/Psych_Up
			if(245). = new /pmove/Extreme_Speed
			if(246). = new /pmove/Ancient_Power
			if(247). = new /pmove/Shadow_Ball
			if(248). = new /pmove/Future_Sight
			if(249). = new /pmove/Rock_Smash
			if(250). = new /pmove/Whirlpool
			if(251). = new /pmove/Beat_Up
			if(252). = new /pmove/Fake_Out
			if(253). = new /pmove/Uproar
			if(254). = new /pmove/Stockpile
			if(255). = new /pmove/Spit_Up
			if(256). = new /pmove/Swallow
			if(257). = new /pmove/Heat_Wave
			if(258). = new /pmove/Hail
			if(259). = new /pmove/Torment
			if(260). = new /pmove/Flatter
			if(261). = new /pmove/Will\-\O\-\Wisp
			if(262). = new /pmove/Memento
			if(263). = new /pmove/Facade
			if(264). = new /pmove/Focus_Punch
			if(265). = new /pmove/Smelling_Salts
			if(266). = new /pmove/Follow_Me
			if(267). = new /pmove/Nature_Power
			if(268). = new /pmove/Charge
			if(269). = new /pmove/Taunt
			if(270). = new /pmove/Helping_Hand
			if(271). = new /pmove/Trick
			if(272). = new /pmove/Role_Play
			if(273). = new /pmove/Wish
			if(274). = new /pmove/Assist
			if(275). = new /pmove/Ingrain
			if(276). = new /pmove/Superpower
			if(277). = new /pmove/Magic_Coat
			if(278). = new /pmove/Recycle
			if(279). = new /pmove/Revenge
			if(280). = new /pmove/Brick_Break
			if(281). = new /pmove/Yawn
			if(282). = new /pmove/Knock_Off
			if(283). = new /pmove/Endeavor
			if(284). = new /pmove/Eruption
			if(285). = new /pmove/Skill_Swap
			if(286). = new /pmove/Imprison
			if(287). = new /pmove/Refresh
			if(288). = new /pmove/Grudge
			if(289). = new /pmove/Snatch
			if(290). = new /pmove/Secret_Power
			if(291). = new /pmove/Dive
			if(292). = new /pmove/Arm_Thrust
			if(293). = new /pmove/Camouflage
			if(294). = new /pmove/Tail_Glow
			if(295). = new /pmove/Luster_Purge
			if(296). = new /pmove/Mist_Ball
			if(297). = new /pmove/Feather_Dance
			if(298). = new /pmove/Teeter_Dance
			if(299). = new /pmove/Blaze_Kick
			if(300). = new /pmove/Mud_Sport
			if(301). = new /pmove/Ice_Ball
			if(302). = new /pmove/Needle_Arm
			if(303). = new /pmove/Slack_Off
			if(304). = new /pmove/Hyper_Voice
			if(305). = new /pmove/Poison_Fang
			if(306). = new /pmove/Crush_Claw
			if(307). = new /pmove/Blast_Burn
			if(308). = new /pmove/Hydro_Cannon
			if(309). = new /pmove/Meteor_Mash
			if(310). = new /pmove/Astonish
			if(311). = new /pmove/Weather_Ball
			if(312). = new /pmove/Aromatherapy
			if(313). = new /pmove/Fake_Tears
			if(314). = new /pmove/Air_Cutter
			if(315). = new /pmove/Overheat
			if(316). = new /pmove/Odor_Sleuth
			if(317). = new /pmove/Rock_Tomb
			if(318). = new /pmove/Silver_Wind
			if(319). = new /pmove/Metal_Sound
			if(320). = new /pmove/Grass_Whistle
			if(321). = new /pmove/Tickle
			if(322). = new /pmove/Cosmic_Power
			if(323). = new /pmove/Water_Spout
			if(324). = new /pmove/Signal_Beam
			if(325). = new /pmove/Shadow_Punch
			if(326). = new /pmove/Extrasensory
			if(327). = new /pmove/Sky_Uppercut
			if(328). = new /pmove/Sand_Tomb
			if(329). = new /pmove/Sheer_Cold
			if(330). = new /pmove/Muddy_Water
			if(331). = new /pmove/Bullet_Seed
			if(332). = new /pmove/Aerial_Ace
			if(333). = new /pmove/Icicle_Spear
			if(334). = new /pmove/Iron_Defense
			if(335). = new /pmove/Block
			if(336). = new /pmove/Howl
			if(337). = new /pmove/Dragon_Claw
			if(338). = new /pmove/Frenzy_Plant
			if(339). = new /pmove/Bulk_Up
			if(340). = new /pmove/Bounce
			if(341). = new /pmove/Mud_Shot
			if(342). = new /pmove/Poison_Tail
			if(343). = new /pmove/Covet
			if(344). = new /pmove/Volt_Tackle
			if(345). = new /pmove/Magical_Leaf
			if(346). = new /pmove/Water_Sport
			if(347). = new /pmove/Calm_Mind
			if(348). = new /pmove/Leaf_Blade
			if(349). = new /pmove/Dragon_Dance
			if(350). = new /pmove/Rock_Blast
			if(351). = new /pmove/Shock_Wave
			if(352). = new /pmove/Water_Pulse
			if(353). = new /pmove/Doom_Desire
			if(354). = new /pmove/Psycho_Boost
			else . = null
		var pmove/M = .
		if(M)
			M.updateBonus(PPBonus)