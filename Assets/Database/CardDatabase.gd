enum Cards { PoorInfantryman, Crossbowman, Jester, Spy, Spearman, Shieldbearer, Acolyte, Ranger }

#hp,attack,koszt

const DATA = {
	Cards.PoorInfantryman :
		["Common", 5, 3, "Poor Infantryman", "normal", 1, ""],
	Cards.Crossbowman : 
		["Common", 3, 5, "Crossbow-man", "normal", 1, ""],
	Cards.Jester : 
		["Common", 4, 2, "Jester", "bait", 2, ""],
	Cards.Spy : 
		["Common", 2, 5, "Spy", "fast", 2, ""],
	Cards.Spearman : 
		["Common", 5, 5, "Spearman", "normal", 2, ""],
	Cards.Shieldbearer : 
		["Common", 7, 2, "Shieldbearer", "bait", 3, ""],
	Cards.Acolyte : 
		["Common", 1, 6, "Acolyte", "fast", 2, ""],
	Cards.Ranger : 
		["Common", 4, 6, "Ranger", "fast", 3, ""],
}
