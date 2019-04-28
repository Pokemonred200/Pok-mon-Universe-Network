game_corner
	var
		player/owner
		score = 0 // The 'score' value is used differently in each game, but in the end is always used to determine the number of coins gained from the game.
	proc
		coinPayout() // The proc where each game determines the number if coins gained
	voltorb_flip
		var
			voltorbArray[5][5]
			foundCards[5][5]
			level = 1
	slot_machines
	pokemon_poker
	whack_a_diglett
		coinPayout()
			owner.modCoins(score * 10) // proc 'modCoins' is used as the owner cannot use the game corner without a coin case in the inventory.
	roulette
