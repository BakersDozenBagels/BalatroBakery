-- See https://github.com/BakersDozenBagels/Balatest/ for more information.

Balatest.TestPlay {
    name = 'leader',
    category = { 'blinds', 'leader' },

    hands = 5,
    discards = 5,
    blind = 'bl_Bakery_Aleph',
    assert = function()
        Balatest.assert_eq(G.GAME.current_round.hands_left, 4)
        Balatest.assert_eq(G.GAME.current_round.discards_left, 4)
    end
}
Balatest.TestPlay {
    name = 'leader_chicot',
    category = { 'blinds', 'leader' },

    jokers = { 'j_chicot' },
    hands = 5,
    discards = 5,
    blind = 'bl_Bakery_Aleph',
    assert = function()
        Balatest.assert_eq(G.GAME.current_round.hands_left, 5)
        Balatest.assert_eq(G.GAME.current_round.discards_left, 5)
    end
}

Balatest.TestPlay {
    name = 'attrition',
    category = { 'blinds', 'attrition' },

    blind = 'bl_Bakery_Tsadi',
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(-28)
    end
}
Balatest.TestPlay {
    name = 'attrition_matador',
    category = { 'blinds', 'attrition', 'matador' },

    blind = 'bl_Bakery_Tsadi',
    jokers = { 'j_matador' },
    money = 0,
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 8)
    end
}
Balatest.TestPlay {
    name = 'attrition_chicot',
    category = { 'blinds', 'attrition' },

    jokers = { 'j_chicot' },
    blind = 'bl_Bakery_Tsadi',
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end
}

Balatest.TestPlay {
    name = 'solo_single',
    category = { 'blinds', 'solo' },

    blind = 'bl_Bakery_He',
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end
}
Balatest.TestPlay {
    name = 'solo_single_matador',
    category = { 'blinds', 'solo', 'matador' },

    blind = 'bl_Bakery_He',
    jokers = { 'j_matador' },
    money = 0,
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 0)
    end
}
Balatest.TestPlay {
    name = 'solo_double',
    category = { 'blinds', 'solo' },

    blind = 'bl_Bakery_He',
    execute = function()
        Balatest.play_hand { '2S', '2H', '2C' }
    end,
    assert = function()
        Balatest.assert_chips(32 * 3)
    end
}
Balatest.TestPlay {
    name = 'solo_double_matador',
    category = { 'blinds', 'solo', 'matador' },

    blind = 'bl_Bakery_He',
    jokers = { 'j_matador' },
    money = 0,
    execute = function()
        Balatest.play_hand { '2S', '2H', '2C' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 8)
    end
}
Balatest.TestPlay {
    name = 'solo_straight',
    category = { 'blinds', 'solo' },

    blind = 'bl_Bakery_He',
    execute = function()
        Balatest.play_hand { '2S', '3H', '6S', '4C', '5D' }
    end,
    assert = function()
        Balatest.assert_chips(36 * 4)
    end
}
Balatest.TestPlay {
    name = 'solo_pair_low',
    category = { 'blinds', 'solo' },

    blind = 'bl_Bakery_He',
    execute = function()
        Balatest.play_hand { '2S', '2H', '3S' }
    end,
    assert = function()
        Balatest.assert_chips(24)
    end
}
Balatest.TestPlay {
    name = 'solo_chicot',
    category = { 'blinds', 'solo' },

    jokers = { 'j_chicot' },
    blind = 'bl_Bakery_He',
    execute = function()
        Balatest.play_hand { '2S', '2H', '2C' }
    end,
    assert = function()
        Balatest.assert_chips(36 * 3)
    end
}

Balatest.TestPlay {
    name = 'witch',
    category = { 'blinds', 'witch' },

    hand_size = 100,
    blind = 'bl_Bakery_Qof',
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 53)
    end
}
Balatest.TestPlay {
    name = 'witch_chicot',
    category = { 'blinds', 'witch' },

    hand_size = 100,
    jokers = { 'j_chicot' },
    blind = 'bl_Bakery_Qof',
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 52)

        for k, v in pairs(G.hand.cards) do
            assert(v.config.center.key == 'c_base',
                "Card " .. k .. " should have no enhancement, found " .. v.config.center.key)
        end
    end
}
Balatest.TestPlay {
    name = 'witch_chicot_chicot',
    category = { 'blinds', 'witch' },

    hand_size = 100,
    jokers = { 'j_chicot', 'j_chicot' },
    blind = 'bl_Bakery_Qof',
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 52)

        for k, v in pairs(G.hand.cards) do
            assert(v.config.center.key == 'c_base',
                "Card " .. k .. " should have no enhancement, found " .. v.config.center.key)
        end
    end
}
Balatest.TestPlay { -- This test passes at 8x speed but fails at 16x or higher??? Manually, this works fine even at higher speeds.
    name = 'down_tag_witch',
    category = { 'tags', 'blinds', 'down_tag', 'witch' },

    hand_size = 100,
    no_auto_start = true,
    blind = 'bl_Bakery_Qof',
    execute = function()
        Balatest.skip_blind 'tag_Bakery_DownTag'
        Balatest.start_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.GAME.tags, 0)
        Balatest.assert_eq(#G.hand.cards, 52)

        for k, v in pairs(G.hand.cards) do
            assert(v.config.center.key == 'c_base',
                "Card " .. k .. " should have no enhancement, found " .. v.config.center.key)
        end
    end,
    skip = function()
        return "The test is flaky at high speeds"
    end
}
Balatest.TestPlay {
    name = 'luchador_witch',
    category = { 'blinds', 'witch' },

    hand_size = 100,
    jokers = { 'j_luchador' },
    blind = 'bl_Bakery_Qof',
    execute = function()
        Balatest.sell(function() return G.jokers.cards[1] end)
    end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 52)

        for k, v in pairs(G.hand.cards) do
            assert(v.config.center.key == 'c_base',
                "Card " .. k .. " should have no enhancement, found " .. v.config.center.key)
        end
    end
}
Balatest.TestPlay {
    name = 'luchador_witch_alt',
    category = { 'blinds', 'witch' },

    hand_size = 1,
    jokers = { 'j_luchador' },
    blind = 'bl_Bakery_Qof',
    execute = function()
        Balatest.sell(function() return G.jokers.cards[1] end)
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 51)

        for k, v in pairs(G.deck.cards) do
            assert(v.config.center.key == 'c_base',
                "Card " .. k .. " should have no enhancement, found " .. v.config.center.key)
        end
    end
}

Balatest.TestPlay {
    name = 'build',
    category = { 'blinds', 'build' },

    blind = 'bl_Bakery_Kaf',
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(2)
    end
}
Balatest.TestPlay {
    name = 'build_matador',
    category = { 'blinds', 'build', 'matador' },

    blind = 'bl_Bakery_Kaf',
    jokers = { 'j_matador' },
    money = 0,
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 8)
    end
}
Balatest.TestPlay {
    name = 'build_chicot',
    category = { 'blinds', 'build' },

    blind = 'bl_Bakery_Kaf',
    jokers = { 'j_chicot' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end
}

Balatest.TestPlay {
    name = 'ruler',
    category = { 'blinds', 'ruler' },

    blind = 'bl_Bakery_Samekh',
    deck = { cards = {
        { r = '2', s = 'C', e = 'm_stone' },
        { r = '2', s = 'D', e = 'm_stone' }, -- Prevent game over from no cards
    } },
    execute = function()
        Balatest.play_hand { '2C' }
    end,
    assert = function()
        Balatest.assert_chips(5)
    end
}
Balatest.TestPlay {
    name = 'ruler_matador',
    category = { 'blinds', 'ruler', 'matador' },

    blind = 'bl_Bakery_Samekh',
    jokers = { 'j_matador' },
    money = 0,
    deck = { cards = {
        { r = '2', s = 'C', e = 'm_stone' },
        { r = '2', s = 'D', e = 'm_stone' }, -- Prevent game over from no cards
    } },
    execute = function()
        Balatest.play_hand { '2C' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 8)
    end
}
Balatest.TestPlay {
    name = 'ruler_matadornt',
    category = { 'blinds', 'ruler', 'matador' },

    blind = 'bl_Bakery_Samekh',
    jokers = { 'j_matador' },
    money = 0,
    deck = { cards = {
        { r = '2', s = 'C' },
        { r = '2', s = 'D', e = 'm_stone' }, -- Prevent game over from no cards
    } },
    execute = function()
        Balatest.play_hand { '2C' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 0)
    end
}
Balatest.TestPlay {
    name = 'ruler_chicot',
    category = { 'blinds', 'ruler' },

    blind = 'bl_Bakery_Samekh',
    jokers = { 'j_chicot' },
    deck = { cards = {
        { r = '2', s = 'C', e = 'm_stone' },
        { r = '2', s = 'D', e = 'm_stone' }, -- Prevent game over from no cards
    } },
    execute = function()
        Balatest.play_hand { '2C' }
    end,
    assert = function()
        Balatest.assert_chips(55)
    end
}
Balatest.TestPlay {
    name = 'ruler_charm',
    category = { 'blinds', 'ruler' },

    blind = 'bl_Bakery_Samekh',
    no_auto_start = true,
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Coin'
        Balatest.start_round()
    end,
    assert = function()
        Balatest.assert(not G.Bakery_charm_area.cards[1].debuff)
    end
}
