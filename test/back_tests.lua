-- See https://github.com/BakersDozenBagels/Balatest/ for more information.

Balatest.TestPlay {
    name = 'violet',
    category = { 'backs', 'violet_deck' },

    back = 'Violet',
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}

Balatest.TestPlay {
    name = 'house_yes',
    category = { 'backs', 'house_deck' },

    back = 'House',
    seed = 'House',
    execute = function()
        G.GAME.probabilities.normal = 1024
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(#G.discard.cards, 1)
        Balatest.assert(G.discard.cards[1].base.suit == 'Diamonds')
        Balatest.assert(G.discard.cards[1].base.value == '7')
    end
}
Balatest.TestPlay {
    name = 'house_no',
    category = { 'backs', 'house_deck' },

    back = 'House',
    seed = 'House',
    execute = function()
        G.GAME.probabilities.normal = 0
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(#G.discard.cards, 1)
        Balatest.assert(G.discard.cards[1].base.suit == 'Spades')
        Balatest.assert(G.discard.cards[1].base.value == '2')
    end
}

Balatest.TestPlay {
    name = 'credit_cash_out',
    category = { 'backs', 'credit_deck' },

    back = 'Credit',
    custom_rules = {
        { id = 'no_reward',           value = false },
        { id = 'no_interest',         value = false },
        { id = 'no_extra_hand_money', value = false },
        { id = 'money_per_discard',   value = 1 },
    },
    hands = 1,
    discards = 1,
    money = 0,
    jokers = { 'j_golden' },
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 0)
    end
}
Balatest.TestPlay {
    name = 'credit_rental_gold',
    category = { 'backs', 'credit_deck' },

    back = 'Credit',
    dollars = 0,
    jokers = { 'j_joker' },
    deck = { cards = { { s = 'S', r = '2', e = 'm_gold' } } },
    execute = function()
        G.jokers.cards[1]:set_rental(true)
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, -3)
    end
}
Balatest.TestPlay {
    name = 'credit_purchase',
    category = { 'backs', 'credit_deck' },

    back = 'Credit',
    dollars = 2,
    execute = function()
        G.GAME.tarot_rate = 0
        G.GAME.planet_rate = 0
        Balatest.hook(_G, 'poll_edition', function() end)
        Balatest.hook(_G, 'create_card', function(orig, set, a, l, r, k, s, f, ...)
            return set == 'Joker' and orig(set, a, l, r, k, s, f or 'j_joker', ...) or orig(set, a, l, r, k, s, f, ...)
        end)
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.buy(function() return G.shop_jokers.cards[1] end)
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 1)
    end
}

Balatest.TestPlay {
    name = 'dn_lucky_1',
    category = { 'backs', 'dn_deck' },

    back = 'DN',
    deck = { cards = { { r = '2', s = 'S', e = 'm_lucky' }, { r = '3', s = 'S' } } },
    dollars = 0,
    execute = function()
        local val = 0
        Balatest.hook(_G, 'pseudorandom', function(orig, ...)
            val = 1 - val
            return val
        end)

        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(147)
        Balatest.assert_eq(G.GAME.dollars, 20)
    end
}
Balatest.TestPlay {
    name = 'dn_lucky_2',
    category = { 'backs', 'dn_deck' },

    back = 'DN',
    deck = { cards = { { r = '2', s = 'S', e = 'm_lucky' }, { r = '3', s = 'S' } } },
    dollars = 0,
    execute = function()
        local val = 1
        Balatest.hook(_G, 'pseudorandom', function(orig, ...)
            val = 1 - val
            return val
        end)

        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(147)
        Balatest.assert_eq(G.GAME.dollars, 20)
    end
}

Balatest.TestPlay {
    name = 'dominion',
    category = { 'backs', 'dominion_deck' },

    back = 'Dominion',
    hand_size = 8,
    execute = function()
        Balatest.wait_for_input()
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 3)
        for _, card in ipairs(G.jokers.cards) do
            Balatest.assert_eq(card.config.center.key, 'j_Bakery_Estate')
        end
        Balatest.assert_eq(#G.hand.cards, 5)
    end
}
Balatest.TestPlay {
    name = 'dominion_increase',
    category = { 'backs', 'dominion_deck' },

    back = 'Dominion',
    deck = { cards = {
        { r = 'A', s = 'D' },
        { r = 'A', s = 'D' },
        { r = 'A', s = 'C' },
        { r = 'A', s = 'C' },
        { r = 'A', s = 'H' },
        { r = 'A', s = 'H' },
        { r = 'A', s = 'S' },
        { r = 'A', s = 'S' },
    } },
    hand_size = 8,
    no_auto_start = true,
    blind = 'bl_serpent',
    execute = function()
        for _ = 1, 2 do
            Balatest.skip_blind 'tag_Bakery_BlankTag'
            Balatest.skip_blind 'tag_Bakery_BlankTag'
            Balatest.start_round()
            Balatest.end_round()
            Balatest.cash_out()
            Balatest.exit_shop()
        end
        Balatest.start_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 6)
    end
}
