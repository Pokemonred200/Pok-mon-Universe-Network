costume
	var/tmp{icon/card_image;icon/running_image;icon/bike_image;icon/bike_idle;icon/back_sprite;icon/seeker_image;costume_state=""}

	parent_type = /obj
	name = ""

	proc/Switch(player/P)

		P.sprite.icon = src.icon
		P.sprite.icon_state = src.icon_state
		P.costumeImage.Image(src.card_image)
		P.current_costume = "[src.type]"
		P.active_costume = src
		winset(P, "costume", "is-visible=false")

	Click() {src.Switch(usr)}

	special_costume
		icon = 'Heroes Icon.dmi'
		New()
			. = ..()
			if(!src.bike_image)
				if(src.icon_state in icon_states('Heroes Biking.dmi'))
					src.bike_image = icon('Heroes Biking.dmi',src.icon_state)
					src.bike_idle = icon('Heroes Idle Bike.dmi',src.icon_state)
			if(!src.running_image)
				if(src.icon_state in icon_states('Heroes Running.dmi'))
					src.running_image = icon('Heroes Running.dmi',src.icon_state)
			if(!src.seeker_image)
				if(src.icon_state in icon_states('Heroes Vs. Seeker.dmi'))
					src.seeker_image = icon('Heroes Vs. Seeker.dmi',src.icon_state)
	trainer_costume {icon = 'Trainer Icon.dmi'}
	team_costume {icon = 'Team Icon.dmi'}

	special_costume/HGSS_character
		icon_male_01 {icon_state = "Icon 01" ; card_image = 'Heroes 01 Image.dmi'}
		icon_male_02 {icon_state = "Icon 08" ; card_image = 'Heroes 08 Image.dmi'}
		icon_male_03 {icon_state = "Icon 21" ; card_image = 'Heroes 21 Image.dmi'}
		icon_female_01 {icon_state = "Icon 03" ; card_image = 'Heroes 03 Image.dmi'}
		icon_female_02 {icon_state = "Icon 22" ; card_image = 'Heroes 22 Image.dmi'}
		icon_female_03 {icon_state = "Icon 25" ; card_image = 'Heroes 25 Image.dmi' ; back_sprite = 'Heroes 25 Back.dmi'}
		icon_female_04 {icon_state = "Icon 26" ; card_image = 'Heroes 25 Image.dmi'}

	special_costume/RSE_character
		icon_male_01 {icon_state = "Icon 14" ; card_image = 'Heroes 14 Image.dmi'}
		icon_male_02 {icon_state = "Icon 16" ; card_image = 'Heroes 16 Image.dmi'}
		icon_female_01 {icon_state = "Icon 15" ; card_image = 'Heroes 15 Image.dmi'}
		icon_female_02 {icon_state = "Icon 17" ; card_image = 'Heroes 17 Image.dmi'}

	special_costume/FRLG_character
		icon_male_01 {icon_state = "Icon 06" ; card_image = 'Heroes 06 Image.dmi' ; back_sprite = 'Heroes 06 Back.dmi'}
		icon_female_01 {icon_state = "Icon 18" ; card_image = 'Heroes 18 Image.dmi' ; back_sprite = 'Heroes 18 Back.dmi'}

	special_costume/DPPt_character
		icon_male_01 {icon_state = "Icon 02" ; card_image = 'Heroes 02 Image.dmi'}
		icon_male_02 {icon_state = "Icon 19" ; card_image = 'Heroes 19 Image.dmi'}
		icon_female_01 {icon_state = "Icon 04" ; card_image = 'Heroes 04 Image.dmi'}
		icon_female_02 {icon_state = "Icon 20" ; card_image = 'Heroes 20 Image.dmi'}

	special_costume/other_character
		icon_rai {icon = 'Rai Icon.dmi' ; icon_state = "Icon 01" ; card_image = 'Rai Image.dmi'}
		icon_skya {icon = 'Skya Icon.dmi' ; icon_state = "Icon 01" ; card_image = 'Kayleen Image.dmi'}
		icon_vexxen {icon = 'Vexxen Icon.dmi' ; icon_state = "Icon 01" ; card_image = 'Vexxen Image.dmi'}
		icon_harzar {icon = 'Harzar Icon.dmi' ; icon_state = "Icon 01" ; card_image = 'Harzar Image.dmi'}
		icon_amber {icon = 'Amber Icon.dmi';icon_state = "Icon 01"}
		icon_teal {icon = 'Teal Icon.dmi' ; icon_state = "Icon 01" ; card_image = 'Teal Image.dmi'}
		icon_sarah {icon = 'Region 02.dmi';icon_state = "Teddiursa"}
		icon_draconi{icon = 'Region 01.dmi';icon_state = "Raichu"}
		icon_lonefire{icon = 'Gymleader Icon.dmi';icon_state = "Icon 03"; card_image = 'Lonefire Image.dmi'}
		icon_kenny{icon = 'Elite Four Icon.dmi';icon_state = "Icon 01";card_image='Kenny Image.dmi'}
		icon_rob{icon = 'Gymleader Icon.dmi';icon_state = "Icon 05";card_image='Rob Image.dmi'}
		icon_scotty{icon = 'Elite Four Icon.dmi';icon_state = "Icon 08";card_image='Scotty Image.dmi'}
		icon_red_01
			icon = 'Red Icon.dmi'
			icon_state = "Red Icon"
			New()
				running_image = icon('Red Icon.dmi',"Red Running")
				bike_image = icon('Red Icon.dmi',"Red Biking")
				bike_idle = bike_image
				. = ..()
		icon_red_02{icon = 'Heroes Icon.dmi';icon_state = "Icon 27";card_image = 'Heroes 27 Image.dmi'}