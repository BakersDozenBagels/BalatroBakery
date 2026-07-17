-- See https://github.com/BakersDozenBagels/Balatest/ for more information.

Balatest.TestPlay {
	name = 'carbon_joker',
	category = { 'editions', 'carbon' },

	jokers = { { id = 'j_joker', edition = 'Bakery_Carbon' } },
	execute = function()
		Balatest.play_hand { '2S' }
	end,
	assert = function()
		Balatest.assert_eq(#G.jokers.cards, 0)
	end,
}
Balatest.TestPlay {
	name = 'carbon_joker_no_play',
	category = { 'editions', 'carbon' },

	jokers = { { id = 'j_joker', edition = 'Bakery_Carbon' } },
	execute = function()
		Balatest.next_round()
	end,
	assert = function()
		Balatest.assert_eq(#G.jokers.cards, 1)
	end,
}
Balatest.TestPlay {
	name = 'carbon_card',
	category = { 'editions', 'carbon' },

	deck = { cards = { { s = 'S', r = '2', d = 'Bakery_Carbon' }, { s = 'S', r = '3' } } },
	execute = function()
		Balatest.play_hand { '2S' }
		Balatest.end_round()
	end,
	assert = function()
		Balatest.assert_eq(#G.deck.cards, 1)
	end,
}
Balatest.TestPlay {
	name = 'carbon_card_in_hand',
	category = { 'editions', 'carbon' },

	deck = { cards = { { s = 'S', r = '2', d = 'Bakery_Carbon' }, { s = 'S', r = '3' } } },
	execute = function()
		Balatest.play_hand { '3S' }
		Balatest.end_round()
	end,
	assert = function()
		Balatest.assert_eq(#G.deck.cards, 2)
	end,
}
Balatest.TestPlay {
	name = 'carbon_gold_card_in_hand',
	category = { 'editions', 'carbon' },

	deck = { cards = { { s = 'S', r = '2', e = 'm_gold', d = 'Bakery_Carbon' }, { s = 'S', r = '3' } } },
	dollars = 0,
	execute = function()
		Balatest.play_hand { '3S' }
		Balatest.end_round()
	end,
	assert = function()
		Balatest.assert_eq(#G.deck.cards, 2)
		Balatest.assert_eq(G.GAME.dollars, 3)
	end,
}
Balatest.TestPlay {
	name = 'carbon_joker_eternal',
	category = { 'editions', 'carbon' },

	jokers = { { id = 'j_joker', edition = 'Bakery_Carbon', eternal = true } },
	execute = function()
		Balatest.play_hand { '2S' }
	end,
	assert = function()
		Balatest.assert_eq(#G.jokers.cards, 1)
	end,
}
