-- See https://github.com/BakersDozenBagels/Balatest/ for more information.

Balatest.TestPlay {
    name = 'leader',
    category = { 'blinds', 'leader' },

    hands = 5,
    discards = 5,
    blind = 'bl_Bakery_Aleph',
    execute = function() end,
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
    execute = function() end,
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
    execute = function() end,
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
    execute = function() end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 52)

        for k, v in pairs(G.hand.cards) do
            assert(v.config.center.key == 'c_base',
                "Card " .. k .. " should have no enhancement, found " .. v.config.center.key)
        end
    end
}
Balatest.TestPlay {
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

local function equip(key)
    Balatest.q(function()
        G.FUNCS.Bakery_equip_from_shop { config = { ref_table = Card(G.Bakery_charm_area.T.x + G.Bakery_charm_area.T.w / 2, G.Bakery_charm_area.T.y, G.CARD_W, G.CARD_W,
            G.P_CARDS.empty, G.P_CENTERS[key], {
                bypass_discovery_center = true,
                bypass_discovery_ui = true
            }) } }
    end)
end
Balatest.TestPlay {
    name = 'ruler_charm',
    category = { 'blinds', 'ruler' },

    blind = 'bl_Bakery_Samekh',
    no_auto_start = true,
    execute = function()
        equip 'BakeryCharm_Bakery_Coin'
        Balatest.start_round()
    end,
    assert = function()
        Balatest.assert(not G.Bakery_charm_area.cards[1].debuff)
    end
}

Balatest.TestPlay {
    name = 'stoic_coin',
    category = { 'blinds', 'stoic', 'coin' },

    blind = 'bl_Bakery_Lammed',
    no_auto_start = true,
    execute = function()
        equip 'BakeryCharm_Bakery_Coin'
        Balatest.start_round()
    end,
    assert = function()
        Balatest.assert(G.Bakery_charm_area.cards[1].debuff)
        Balatest.assert(G.GAME.Bakery_charm == nil)
    end
}
Balatest.TestPlay {
    name = 'stoic_coin_undebuffed',
    category = { 'blinds', 'stoic', 'coin' },

    blind = 'bl_Bakery_Lammed',
    no_auto_start = true,
    execute = function()
        equip 'BakeryCharm_Bakery_Coin'
        Balatest.start_round()
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(not G.Bakery_charm_area.cards[1].debuff)
        Balatest.assert(G.GAME.Bakery_charm == 'BakeryCharm_Bakery_Coin')
    end
}
Balatest.TestPlay {
    name = 'stoic_coin_disabled',
    category = { 'blinds', 'stoic', 'coin' },

    jokers = { 'j_chicot' },
    blind = 'bl_Bakery_Lammed',
    no_auto_start = true,
    execute = function()
        equip 'BakeryCharm_Bakery_Coin'
        Balatest.start_round()
    end,
    assert = function()
        Balatest.assert(not G.Bakery_charm_area.cards[1].debuff)
        Balatest.assert(G.GAME.Bakery_charm == 'BakeryCharm_Bakery_Coin')
    end
}
local count_equip, count_unequip
Balatest.TestPlay {
    name = 'stoic_coin_disabled_twice',
    category = { 'blinds', 'stoic', 'coin' },

    jokers = { 'j_chicot', 'j_chicot' },
    blind = 'bl_Bakery_Lammed',
    no_auto_start = true,
    execute = function()
        equip 'BakeryCharm_Bakery_Coin'
        count_equip = 0
        Balatest.hook(G.P_CENTERS.BakeryCharm_Bakery_Coin, 'equip', function(orig, ...)
            count_equip = count_equip + 1
            return orig(...)
        end)
        count_unequip = 0
        Balatest.hook(G.P_CENTERS.BakeryCharm_Bakery_Coin, 'unequip', function(orig, ...)
            count_unequip = count_unequip + 1
            return orig(...)
        end)
        Balatest.start_round()
    end,
    assert = function()
        Balatest.assert(not G.Bakery_charm_area.cards[1].debuff)
        Balatest.assert(G.GAME.Bakery_charm == 'BakeryCharm_Bakery_Coin')
        Balatest.assert_eq(count_equip, 1)
        Balatest.assert_eq(count_unequip, 1)
    end
}
Balatest.TestPlay {
    name = 'stoic_coin_disabled_beaten',
    category = { 'blinds', 'stoic', 'coin' },

    jokers = { 'j_chicot' },
    blind = 'bl_Bakery_Lammed',
    no_auto_start = true,
    execute = function()
        equip 'BakeryCharm_Bakery_Coin'
        count_equip = 0
        Balatest.hook(G.P_CENTERS.BakeryCharm_Bakery_Coin, 'equip', function(orig, ...)
            count_equip = count_equip + 1
            return orig(...)
        end)
        count_unequip = 0
        Balatest.hook(G.P_CENTERS.BakeryCharm_Bakery_Coin, 'unequip', function(orig, ...)
            count_unequip = count_unequip + 1
            return orig(...)
        end)
        Balatest.start_round()
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(not G.Bakery_charm_area.cards[1].debuff)
        Balatest.assert(G.GAME.Bakery_charm == 'BakeryCharm_Bakery_Coin')
        Balatest.assert_eq(count_equip, 1)
        Balatest.assert_eq(count_unequip, 1)
    end
}
Balatest.TestPlay {
    name = 'stoic_obsession',
    category = { 'blinds', 'stoic', 'obsession' },

    blind = 'bl_Bakery_Lammed',
    no_auto_start = true,
    execute = function()
        equip 'BakeryCharm_Bakery_Obsession'
        Balatest.start_round()
    end,
    assert = function()
        local node = { config = {} }
        G.FUNCS.can_discard(node)
        Balatest.assert(node.config.button ~= 'Bakery_discard_zero')
    end
}
Balatest.TestPlay {
    name = 'stoic_obsession_attempted',
    category = { 'blinds', 'stoic', 'obsession' },

    blind = 'bl_Bakery_Lammed',
    no_auto_start = true,
    dollars = 8,
    execute = function()
        equip 'BakeryCharm_Bakery_Obsession'
        Balatest.start_round()
        Balatest.q(G.FUNCS.Bakery_discard_zero)
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 0)
    end
}
Balatest.TestPlay {
    name = 'stoic_pedigree',
    category = { 'blinds', 'stoic', 'pedigree' },

    blind = 'bl_Bakery_Lammed',
    no_auto_start = true,
    execute = function()
        equip 'BakeryCharm_Bakery_Pedigree'
        Balatest.start_round()
        Balatest.play_hand { '2S', '3S', '4S', '6C', '7C' }
    end,
    assert = function()
        Balatest.assert_chips(12)
    end
}
Balatest.TestPlay {
    name = 'stoic_epitaph',
    category = { 'blinds', 'stoic', 'epitaph' },

    blind = 'bl_Bakery_Lammed',
    no_auto_start = true,
    execute = function()
        equip 'BakeryCharm_Bakery_Epitaph'
        Balatest.start_round()
        Balatest.play_hand { '2S', '3S', '4S', '6C', '7C' }
    end,
    assert = function()
        Balatest.assert_chips(12)
    end
}
Balatest.TestPlay {
    name = 'stoic_anaglyph_lens',
    category = { 'blinds', 'stoic', 'anaglyph_lens' },

    blind = 'bl_Bakery_Lammed',
    no_auto_start = true,
    execute = function()
        equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.start_round()
        Balatest.play_hand { '2S', '3S', '4S', '6C', '7C' }
    end,
    assert = function()
        Balatest.assert_chips(12)
    end
}
Balatest.TestPlay {
    name = 'stoic_no_charm',
    category = { 'blinds', 'stoic' },

    blind = 'bl_Bakery_Lammed',
    execute = function()
        Balatest.end_round()
    end,
    assert = function() end -- Just check for no crash
}
