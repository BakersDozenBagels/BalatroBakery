SMODS.Challenge({
	key = "Balanced",
	rules = {
		custom = { {
			id = "Bakery_Balanced",
		} },
	},
})

SMODS.Challenge({
	key = "Vagabond",
	rules = {
		custom = { {
			id = "Bakery_Vagabond",
			value = 10,
		} },
	},
	restrictions = {
		banned_cards = {
			{
				id = "v_seed_money",
				ids = { "v_money_tree" },
			},
			{
				id = "j_to_the_moon",
			},
			{
				id = "j_credit_card",
			},
		},
	},
})

SMODS.Challenge({
	key = "Sprint",
	rules = {
		custom = {
			{ id = "Bakery_Sprint_Small" },
			{ id = "Bakery_Sprint_Big" },
		},
	},
})
