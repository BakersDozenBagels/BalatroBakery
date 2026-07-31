-- See https://github.com/BakersDozenBagels/Balatest/ for more information.

--#region Time Walk
Balatest.TestPlay {
	name = 'time_walk_high_card',
	category = { 'enhancements', 'time_walk' },

	hands = 1,
	deck = { cards = { { r = '2', s = 'S', e = 'm_Bakery_TimeWalk' }, { r = '3', s = 'S' } } },
	execute = function()
		Balatest.play_hand { '2S' }
	end,
	assert = function()
		Balatest.assert_chips(5)
		Balatest.assert_eq(G.GAME.current_round.hands_left, 1)
	end,
}
Balatest.TestPlay {
	name = 'time_walk_high_card_red_seal',
	category = { 'enhancements', 'time_walk' },

	hands = 1,
	deck = { cards = { { r = '2', s = 'S', e = 'm_Bakery_TimeWalk', g = 'Red' }, { r = '3', s = 'S' } } },
	execute = function()
		Balatest.play_hand { '2S' }
	end,
	assert = function()
		Balatest.assert_chips(5)
		Balatest.assert_eq(G.GAME.current_round.hands_left, 2)
	end,
}
Balatest.TestPlay {
	name = 'time_walk_with_other',
	category = { 'enhancements', 'time_walk' },

	hands = 1,
	deck = { cards = { { r = '2', s = 'S', e = 'm_Bakery_TimeWalk' }, { r = '3', s = 'S' }, { r = '4', s = 'S' } } },
	execute = function()
		Balatest.play_hand { '2S', '3S' }
	end,
	assert = function()
		Balatest.assert_chips(8)
		Balatest.assert_eq(G.GAME.current_round.hands_left, 1)
	end,
}
--#endregion

--#region Curse
Balatest.TestPlay {
	name = 'curse_high_card',
	category = { 'enhancements', 'curse' },

	deck = { cards = { { r = '2', s = 'S', e = 'm_Bakery_Curse' }, { r = '3', s = 'S' } } },
	execute = function()
		Balatest.play_hand { '2S' }
	end,
	assert = function()
		Balatest.assert_chips(5)
	end,
}
Balatest.TestPlay {
	name = 'curse_high_card_gold_seal',
	category = { 'enhancements', 'curse' },

	deck = { cards = { { r = '2', s = 'S', e = 'm_Bakery_Curse', g = 'Gold' }, { r = '3', s = 'S' } } },
	dollars = 0,
	execute = function()
		Balatest.play_hand { '2S' }
	end,
	assert = function()
		Balatest.assert_chips(5)
		Balatest.assert_eq(G.GAME.dollars, 0)
	end,
}
Balatest.TestPlay {
	name = 'curse_high_card_gold_seal_with_other',
	category = { 'enhancements', 'curse' },

	deck = {
		cards = { { r = '2', s = 'S', e = 'm_Bakery_Curse', g = 'Gold' }, { r = '3', s = 'S' }, { r = '4', s = 'S' } },
	},
	dollars = 0,
	execute = function()
		Balatest.play_hand { '2S', '3S' }
	end,
	assert = function()
		Balatest.assert_chips(8)
		Balatest.assert_eq(G.GAME.dollars, 0)
	end,
}
--#endregion
