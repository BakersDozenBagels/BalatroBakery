-- See https://github.com/BakersDozenBagels/Balatest/ for more information.

--#region Palette
Balatest.TestPlay {
    name = 'palette_normal',
    category = { 'charms', 'palette' },

    jokers = { 'j_droll' },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Palette'
        Balatest.play_hand { '2S', '3S', '4S', '5S', '7S' }
    end,
    assert = function()
        Balatest.assert_chips(56 * 14)
    end
}
Balatest.TestPlay {
    name = 'palette_weird',
    category = { 'charms', 'palette' },

    jokers = { 'j_droll' },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Palette'
        Balatest.play_hand { '2S', '3C', '4H', '5D', '7S' }
    end,
    assert = function()
        Balatest.assert_chips(56 * 14)
    end
}
Balatest.TestPlay {
    name = 'palette_unequipped',
    category = { 'charms', 'palette' },

    jokers = { 'j_droll' },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Palette'
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Coin'
        Balatest.play_hand { '2S', '3C', '4H', '5D', '7S' }
    end,
    assert = function()
        Balatest.assert_chips(12)
    end
}
--#endregion

--#region Anaglyph Lens
Balatest.TestPlay {
    name = 'anaglyph_lens_one',
    category = { 'charms', 'anaglyph_lens' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 1)
        Balatest.assert(hand_name == 'Pair')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_stone',
    category = { 'charms', 'anaglyph_lens' },

    deck = { cards = { { r = '2', s = 'S', e = 'm_stone' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 1)
        Balatest.assert(hand_name == 'High Card')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_four',
    category = { 'charms', 'anaglyph_lens' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2H', '2C', '2D' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 4)
        Balatest.assert(hand_name == 'Five of a Kind')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_four_plus_one',
    category = { 'charms', 'anaglyph_lens' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2H', '2C', '2D', '6S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 4)
        Balatest.assert(hand_name == 'Five of a Kind')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_five',
    category = { 'charms', 'anaglyph_lens' },

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'H' }, { r = '2', s = 'C' }, { r = '2', s = 'D' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2H', '2C', '2D', '2S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Bakery_SixOfAKind')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_flush_four_plus_one',
    category = { 'charms', 'anaglyph_lens' },

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '8', s = 'C' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2S', '2S', '2S', '8C' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 4)
        Balatest.assert(hand_name == 'Flush Five')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_flush_four_plus_one_alt',
    category = { 'charms', 'anaglyph_lens' },

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '8', s = 'S' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2S', '2S', '2S', '8S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Flush Five')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_flush_four_plus_one_alt2',
    category = { 'charms', 'anaglyph_lens' },

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '8', s = 'C', e = 'm_stone' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2S', '2S', '2S', '8C' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 4) -- Stone happens later
        Balatest.assert(hand_name == 'Flush Five')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_flush_five',
    category = { 'charms', 'anaglyph_lens' },

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2S', '2S', '2S', '2S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Bakery_FlushSix')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_three_pair',
    category = { 'charms', 'anaglyph_lens' },

    deck = { cards = { { r = '2', s = 'S' }, { r = '4', s = 'C' }, { r = '4', s = 'D' }, { r = '9', s = 'S' }, { r = '9', s = 'S' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '4C', '4D', '9S', '9S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Bakery_ThreePair')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_flush_three_pair',
    category = { 'charms', 'anaglyph_lens' },

    deck = { cards = { { r = '2', s = 'S' }, { r = '4', s = 'S' }, { r = '4', s = 'S' }, { r = '9', s = 'S' }, { r = '9', s = 'S' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '4S', '4S', '9S', '9S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Bakery_FlushThreePair')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_flush_three_pair_alt',
    category = { 'charms', 'anaglyph_lens' },

    deck = { cards = { { r = '2', s = 'S' }, { r = '4', s = 'S' }, { r = '4', s = 'D' }, { r = '9', s = 'S' }, { r = '9', s = 'S' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '4S', '4D', '9S', '9S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 4)
        Balatest.assert(hand_name == 'Flush')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_two_triplets',
    category = { 'charms', 'anaglyph_lens' },

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'D' }, { r = '9', s = 'D' }, { r = '9', s = 'S' }, { r = '9', s = 'S' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2D', '9D', '9S', '9S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Bakery_TwoTriplets')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_flush_two_triplets',
    category = { 'charms', 'anaglyph_lens' },

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '9', s = 'D' }, { r = '9', s = 'S' }, { r = '9', s = 'S' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2s', '9D', '9S', '9S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Bakery_FlushTriplets')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_flush_mansion',
    category = { 'charms', 'anaglyph_lens' },

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '9', s = 'S' }, { r = '9', s = 'S' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2S', '2S', '9S', '9S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Bakery_FlushMansion')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_flush_house',
    category = { 'charms', 'anaglyph_lens' },

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '9', s = 'S' }, { r = '9', s = 'S' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2S', '9S', '9S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 4)
        Balatest.assert(hand_name == 'Flush House')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_flush_house_plus_one',
    category = { 'charms', 'anaglyph_lens' },

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '3', s = 'D' }, { r = '9', s = 'S' }, { r = '9', s = 'S' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2S', '3D', '9S', '9S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 4)
        Balatest.assert(hand_name == 'Flush House')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_flush_house_plus_one_alt',
    category = { 'charms', 'anaglyph_lens' },

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '3', s = 'D', e = 'm_stone' }, { r = '9', s = 'S' }, { r = '9', s = 'S' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '2S', '2S', '3D', '9S', '9S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 4) -- Stone happens later
        Balatest.assert(hand_name == 'Flush House')
    end
}
Balatest.TestPlay {
    name = 'anaglyph_lens_flush_house_plus_one_alt_failed',
    category = { 'charms', 'anaglyph_lens' },

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '3', s = 'D', e = 'm_stone' }, { r = '9', s = 'S' }, { r = '9', s = 'S' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_AnaglyphLens'
        Balatest.highlight { '3D', '2S', '2S', '9S', '9S' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 4) -- Stone happens later
        Balatest.assert(hand_name == 'Two Pair')
    end
}
--#endregion

--#region Pedigree
Balatest.TestPlay {
    name = 'pedigree_normal',
    category = { 'charms', 'pedigree' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Pedigree'
        Balatest.highlight { '2S', '2C', '2D', '3S', '3D' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Full House')
    end
}
Balatest.TestPlay {
    name = 'pedigree_weird',
    category = { 'charms', 'pedigree' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Pedigree'
        Balatest.highlight { '2S', '3S', '4S', '7C', 'QC' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Full House')
    end
}
Balatest.TestPlay {
    name = 'pedigree_stuffed',
    category = { 'charms', 'pedigree' },

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'C' }, { r = '8', s = 'C' }, { r = '8', s = 'C' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Pedigree'
        Balatest.highlight { '2S', '2S', '2C', '8C', '8C' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Bakery_StuffedHouse')
    end
}
Balatest.TestPlay {
    name = 'pedigree_stuffed_house',
    category = { 'charms', 'pedigree' },

    deck = { cards = { { r = '2', s = 'S', e = 'm_wild' }, { r = '2', s = 'S', e = 'm_wild' }, { r = '2', s = 'C' }, { r = '8', s = 'C' }, { r = '8', s = 'C' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Pedigree'
        Balatest.highlight { '2S', '2S', '2C', '8C', '8C' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Bakery_StuffedFlush')
    end
}
Balatest.TestPlay {
    name = 'pedigree_straight_house',
    category = { 'charms', 'pedigree' },

    deck = { cards = { { r = '2', s = 'S' }, { r = '3', s = 'S' }, { r = '4', s = 'H' }, { r = '5', s = 'H' }, { r = '6', s = 'H' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Pedigree'
        Balatest.highlight { '2S', '3S', '4H', '5H', '6H' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Bakery_StraightHouse')
    end
}
Balatest.TestPlay {
    name = 'pedigree_straight_flush_house',
    category = { 'charms', 'pedigree' },

    deck = { cards = { { r = '2', s = 'S' }, { r = '3', s = 'S' }, { r = '4', s = 'H', e = 'm_wild' }, { r = '5', s = 'H', e = 'm_wild' }, { r = '6', s = 'H', e = 'm_wild' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Pedigree'
        Balatest.highlight { '2S', '3S', '4H', '5H', '6H' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Bakery_StraightFlushHouse')
    end
}
Balatest.TestPlay {
    name = 'pedigree_royal_flush_house',
    category = { 'charms', 'pedigree' },

    deck = { cards = { { r = 'T', s = 'S' }, { r = 'J', s = 'S' }, { r = 'Q', s = 'H', e = 'm_wild' }, { r = 'K', s = 'H', e = 'm_wild' }, { r = 'A', s = 'H', e = 'm_wild' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Pedigree'
        Balatest.highlight { 'TS', 'JS', 'QH', 'KH', 'AH' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Bakery_RoyalFlushHouse')
    end
}
Balatest.TestPlay {
    name = 'pedigree_full_five',
    category = { 'charms', 'pedigree' },

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'H' }, { r = '2', s = 'H' }, { r = '2', s = 'H' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Pedigree'
        Balatest.highlight { '2S', '2S', '2H', '2H', '2H' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Bakery_FullFive')
    end
}
Balatest.TestPlay {
    name = 'pedigree_full_flush_five',
    category = { 'charms', 'pedigree' },

    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'H', e = 'm_wild' }, { r = '2', s = 'H', e = 'm_wild' }, { r = '2', s = 'H', e = 'm_wild' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Pedigree'
        Balatest.highlight { '2S', '2S', '2H', '2H', '2H' }
    end,
    assert = function()
        local _, _, _, scoring_hand, hand_name = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        Balatest.assert_eq(#scoring_hand, 5)
        Balatest.assert(hand_name == 'Bakery_FullFlushFive')
    end
}
--#endregion

--#region Epitaph
Balatest.TestPlay {
    name = 'epitaph_one',
    category = { 'charms', 'epitaph' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Epitaph'
        Balatest.play_hand { '2S', '3C' }
    end,
    assert = function()
        Balatest.assert_chips(16)
    end
}
Balatest.TestPlay {
    name = 'epitaph_four',
    category = { 'charms', 'epitaph' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Epitaph'
        Balatest.play_hand { '2S', '3C', '4D', '5H', '7S' }
    end,
    assert = function()
        Balatest.assert_chips(12 * 16)
    end
}
Balatest.TestPlay {
    name = 'epitaph_unequipped',
    category = { 'charms', 'epitaph' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Epitaph'
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Coin'
        Balatest.play_hand { '2S', '3C', '4D', '5H', '7S' }
    end,
    assert = function()
        Balatest.assert_chips(12)
    end
}
--#endregion

--#region Rune
Balatest.TestPlay {
    name = 'rune_can_discard_zero',
    category = { 'charms', 'rune' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Rune'
    end,
    assert = function()
        local node = { config = {} }
        G.FUNCS.can_discard(node)
        Balatest.assert(node.config.button == 'Bakery_discard_zero')
    end
}
Balatest.TestPlay {
    name = 'rune_cant_discard_zero',
    category = { 'charms', 'rune' },

    discards = 0,
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Rune'
    end,
    assert = function()
        local node = { config = {} }
        G.FUNCS.can_discard(node)
        Balatest.assert(node.config.button ~= 'Bakery_discard_zero')
    end
}
Balatest.TestPlay {
    name = 'rune_discard_zero',
    category = { 'charms', 'rune' },

    hand_size = 8,
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Rune'
        Balatest.q(G.FUNCS.Bakery_discard_zero)
    end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 10)
    end
}
Balatest.TestPlay {
    name = 'rune_discard_zero_grat',
    category = { 'charms', 'rune' },

    jokers = { 'j_delayed_grat' },
    dollars = 8,
    hand_size = 8,
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Rune'
        Balatest.q(G.FUNCS.Bakery_discard_zero)
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 0)
    end
}
--#endregion

--#region Obsession
Balatest.TestPlay {
    name = 'obsession_can_discard_zero',
    category = { 'charms', 'obsession' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Obsession'
    end,
    assert = function()
        local node = { config = {} }
        G.FUNCS.can_discard(node)
        Balatest.assert(node.config.button == 'Bakery_discard_zero')
    end
}
Balatest.TestPlay {
    name = 'obsession_cant_discard_zero',
    category = { 'charms', 'obsession' },

    discards = 0,
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Obsession'
    end,
    assert = function()
        local node = { config = {} }
        G.FUNCS.can_discard(node)
        Balatest.assert(node.config.button ~= 'Bakery_discard_zero')
    end
}
Balatest.TestPlay {
    name = 'obsession_discard_zero',
    category = { 'charms', 'obsession' },

    dollars = 8,
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Obsession'
        Balatest.q(G.FUNCS.Bakery_discard_zero)
        Balatest.wait_for_input()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 3)
    end
}
Balatest.TestPlay {
    name = 'obsession_discard_zero_grat',
    category = { 'charms', 'obsession' },

    jokers = { 'j_delayed_grat' },
    dollars = 8,
    hand_size = 8,
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Obsession'
        Balatest.q(G.FUNCS.Bakery_discard_zero)
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 3)
    end
}
--#endregion

--#region Introversion
Balatest.TestPlay {
    name = 'introversion_equip',
    category = { 'charms', 'introversion' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Introversion'
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.joker_rate, 0)
    end
}
Balatest.TestPlay {
    name = 'introversion_unequip',
    category = { 'charms', 'introversion' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Introversion'
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Coin'
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.joker_rate, 20)
    end
}
--#endregion

--#region Extroversion
Balatest.TestPlay {
    name = 'extroversion_equip',
    category = { 'charms', 'extroversion' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Extroversion'
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.planet_rate, 0)
        Balatest.assert_eq(G.GAME.tarot_rate, 0)
    end
}
Balatest.TestPlay {
    name = 'extroversion_unequip',
    category = { 'charms', 'extroversion' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Extroversion'
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Coin'
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.planet_rate, 4)
        Balatest.assert_eq(G.GAME.tarot_rate, 4)
    end
}
--#endregion

--#region Coin
Balatest.TestPlay {
    name = 'coin_interest',
    category = { 'charms', 'coin' },

    dollars = 10,
    execute = function()
        G.GAME.modifiers.no_interest = nil
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Coin'
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 3)
    end
}
Balatest.TestPlay {
    name = 'coin_interest_maxed',
    category = { 'charms', 'coin' },

    dollars = 38,
    execute = function()
        G.GAME.modifiers.no_interest = nil
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Coin'
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 35)
    end
}
Balatest.TestPlay {
    name = 'coin_interest_moon',
    category = { 'charms', 'coin' },

    jokers = { 'j_to_the_moon' },
    dollars = 18,
    execute = function()
        G.GAME.modifiers.no_interest = nil
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Coin'
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 20)
    end
}
Balatest.TestPlay {
    name = 'coin_interest_seed_money',
    category = { 'charms', 'coin' },

    vouchers = { 'v_seed_money' },
    dollars = 28,
    execute = function()
        G.GAME.modifiers.no_interest = nil
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Coin'
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 30)
    end
}
--#endregion

--#region Void
Balatest.TestPlay {
    name = 'void_equip',
    category = { 'charms', 'void' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Void'
    end,
    assert = function()
        Balatest.assert_eq(G.P_CENTERS.e_negative:get_weight(), 30)
    end
}
Balatest.TestPlay {
    name = 'void_unequip',
    category = { 'charms', 'void' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Void'
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Coin'
    end,
    assert = function()
        Balatest.assert_eq(G.P_CENTERS.e_negative:get_weight(), 3)
    end
}
--#endregion

--#region Print Error
Balatest.TestPlay {
    name = 'print_error_cartomancer',
    category = { 'charms', 'print_error', 'revos_vault' },
    required_mods = { 'RevosVault' },

    no_auto_start = true,
    jokers = { 'j_cartomancer' },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_PrintError'
        Balatest.start_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.consumeables.cards, 1)
    end
}
Balatest.TestPlay {
    name = 'print_error_blueprinter',
    category = { 'charms', 'print_error', 'revos_vault' },
    required_mods = { 'RevosVault' },

    no_auto_start = true,
    jokers = { 'j_crv_printer' },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_PrintError'
        Balatest.start_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 3)
    end
}
--#endregion

--#region Posterization
Balatest.TestPlay {
    name = 'posterization_planet_tarot',
    category = { 'charms', 'posterization', 'morefluff' },
    required_mods = { "MoreFluff" },

    consumeables = { 'c_pluto', 'c_death' },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Posterization'
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.consumeables.config.card_limit, 2)
        Balatest.assert_eq(G.consumeables.config.Bakery_visual_card_limit, 2)
    end
}
Balatest.TestPlay {
    name = 'posterization_retroactive',
    category = { 'charms', 'posterization', 'morefluff' },
    required_mods = { "MoreFluff" },

    consumeables = { 'c_mf_black', 'c_mf_crimson' },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Posterization'
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.consumeables.config.card_limit, 3)
        Balatest.assert_eq(G.consumeables.config.Bakery_visual_card_limit, 2)
    end
}
Balatest.TestPlay {
    name = 'posterization_proactive',
    category = { 'charms', 'posterization', 'morefluff' },
    required_mods = { "MoreFluff" },

    dollars = 100,
    execute = function()
        G.GAME.joker_rate = 0
        G.GAME.planet_rate = 0
        G.GAME.tarot_rate = 0
        G.GAME.rotarot_rate = 0
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Posterization'
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.buy(function() return G.shop_jokers.cards[2] end)
        Balatest.buy(function() return G.shop_jokers.cards[1] end)
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.consumeables.config.card_limit, 3)
        Balatest.assert_eq(G.consumeables.config.Bakery_visual_card_limit, 2)
    end
}
Balatest.TestPlay {
    name = 'posterization_unequip',
    category = { 'charms', 'posterization', 'morefluff' },
    required_mods = { "MoreFluff" },

    dollars = 100,
    execute = function()
        G.GAME.joker_rate = 0
        G.GAME.planet_rate = 0
        G.GAME.tarot_rate = 0
        G.GAME.rotarot_rate = 0
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Posterization'
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.buy(function() return G.shop_jokers.cards[2] end)
        Balatest.buy(function() return G.shop_jokers.cards[1] end)
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Coin'
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.consumeables.config.card_limit, 2)
    end
}
--#endregion

--#region Marm
Balatest.TestPlay {
    name = 'marm_single',
    category = { 'charms', 'marm', 'cryptid' },
    required_mods = { 'Cryptid' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Marm'
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(24)
    end
}
Balatest.TestPlay {
    name = 'marm_straight_flush',
    category = { 'charms', 'marm', 'cryptid' },
    required_mods = { 'Cryptid' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Marm'
        Balatest.play_hand { '2S', '3S', '4S', '5S', '6S' }
    end,
    assert = function()
        Balatest.assert_chips(154)
    end
}
Balatest.TestPlay {
    name = 'marm_junk',
    category = { 'charms', 'marm', 'cryptid' },
    required_mods = { 'Cryptid' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Marm'
        Balatest.play_hand { '2S', '3S', '4S', '5S', '7S' }
    end,
    assert = function()
        Balatest.assert_chips(158)
    end
}
Balatest.TestPlay {
    name = 'marm_jolly',
    category = { 'charms', 'marm', 'cryptid' },
    required_mods = { 'Cryptid' },

    jokers = { 'j_jolly' },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Marm'
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(120)
    end
}
--#endregion

--#region Duct Tape
Balatest.TestPlay {
    name = 'duct_tape',
    category = { 'charms', 'duct_tape', 'cryptid' },
    required_mods = { 'Cryptid' },

    dollars = 100,
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_DuctTape'
    end,
    assert = function()
        Balatest.assert_eq(SMODS.Rarities.Common:get_weight(), 0)
        Balatest.assert_eq(SMODS.Rarities.Uncommon:get_weight(), 0)
        local e = { config = {} }
        G.FUNCS.Bakery_can_equip(e)
        Balatest.assert(e.config.button == nil)
    end
}
--#endregion

--#region Virus
Balatest.TestPlay {
    name = 'virus',
    category = { 'charms', 'virus', 'garbshit' },
    required_mods = { 'GARBPACK' },

    deck = { cards = {
        { r = '5', s = 'D' },
        { r = 'A', s = 'S' }
    } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Virus'
        Balatest.play_hand { '5D' }
        Balatest.wait_for_input()
    end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 1)
        Balatest.assert_eq(G.hand.cards[1].ability.name, 'm_garb_infected')
    end
}
Balatest.TestPlay {
    name = 'virus_enhanced',
    category = { 'charms', 'virus', 'garbshit' },
    required_mods = { 'GARBPACK' },

    deck = { cards = {
        { r = '5', s = 'D', e = 'm_wild' },
        { r = 'A', s = 'S', e = 'm_wild' }
    } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Virus'
        Balatest.play_hand { '5D' }
        Balatest.wait_for_input()
    end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 1)
        Balatest.assert_eq(G.hand.cards[1].ability.name, 'm_garb_infected')
    end
}
Balatest.TestPlay {
    name = 'virus_infected',
    category = { 'charms', 'virus', 'garbshit' },
    required_mods = { 'GARBPACK' },

    deck = { cards = {
        { r = '5', s = 'D', e = 'm_garb_infected' },
        { r = 'A', s = 'S', e = 'm_garb_infected' }
    } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Virus'
        Balatest.play_hand { '5D' }
        Balatest.wait_for_input()
    end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 1)
        Balatest.assert_eq(G.hand.cards[1].ability.name, 'm_garb_infected')
    end
}
Balatest.TestPlay {
    name = 'virus_no_cards',
    category = { 'charms', 'virus', 'garbshit' },
    required_mods = { 'GARBPACK' },

    jokers = { 'j_joker', 'j_joker', 'j_cavendish' },
    deck = { cards = {
        { r = 'A', s = 'D' },
    } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Virus'
        Balatest.play_hand { 'AD' }
        Balatest.wait_for_input()
    end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 0)
    end
}
--#endregion

--#region Petri Dish
Balatest.TestPlay {
    name = 'petri_dish_equip',
    category = { 'charms', 'petri_dish' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_PetriDish'
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.consumeables.config.card_limit, 4)
    end
}
Balatest.TestPlay {
    name = 'petri_dish_unequip',
    category = { 'charms', 'petri_dish' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_PetriDish'
        Balatest.wait()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Coin'
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert_eq(G.consumeables.config.card_limit, 2)
    end
}
Balatest.TestPlay {
    name = 'petri_dish_debuff',
    category = { 'charms', 'petri_dish', 'stoic' },

    blind = 'bl_Bakery_Lammed',
    no_auto_start = true,
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_PetriDish'
        Balatest.start_round()
    end,
    assert = function()
        Balatest.assert_eq(G.consumeables.config.card_limit, 2)
    end
}
Balatest.TestPlay {
    name = 'petri_dish_undebuff',
    category = { 'charms', 'petri_dish', 'stoic' },

    blind = 'bl_Bakery_Lammed',
    no_auto_start = true,
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_PetriDish'
        Balatest.start_round()
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(G.consumeables.config.card_limit, 4)
    end
}
--#endregion

--#region Cogwheel
Balatest.TestPlay {
    name = 'cogwheel',
    category = { 'charms', 'cogwheel' },

    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Cogwheel'
        Balatest.wait_for_input()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.round_resets.ante, -1)
        Balatest.assert_eq(G.shop_jokers.config.card_limit, 1)
    end
}
Balatest.TestPlay {
    name = 'cogwheel_unequip',
    category = { 'charms', 'cogwheel' },

    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Cogwheel'
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Coin'
        Balatest.wait_for_input()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.round_resets.ante, 1)
        Balatest.assert_eq(G.GAME.shop.joker_max, 2)
    end
}
Balatest.TestPlay {
    name = 'cogwheel_debuff',
    category = { 'charms', 'cogwheel', 'blinds', 'stoic' },

    blind = 'bl_Bakery_Lammed',
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Cogwheel'
        Balatest.exit_shop()
        Balatest.start_round()
        Balatest.wait_for_input()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.round_resets.ante, 2)
        Balatest.assert_eq(G.GAME.shop.joker_max, 2)
    end
}
Balatest.TestPlay {
    name = 'cogwheel_undebuff',
    category = { 'charms', 'cogwheel', 'blinds', 'stoic' },

    blind = 'bl_Bakery_Lammed',
    execute = function()
        Balatest.end_round()
        Balatest.cash_out()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Cogwheel'
        Balatest.exit_shop()
        Balatest.start_round()
        Balatest.end_round()
        Balatest.wait_for_input()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.round_resets.ante, 1)
        Balatest.assert_eq(G.GAME.shop.joker_max, 1)
    end
}
--#endregion

--#region Oops! All 20s
Balatest.TestPlay {
    name = 'oops_all_20s_business_card',
    category = { 'charms', 'oops_all_20s' },

    jokers = { 'j_business' },
    dollars = 8,
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_OopsAll20s'
        Balatest.play_hand { 'KS', 'QS', 'JS', 'AS', 'TS' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 6)
    end
}
Balatest.TestPlay {
    name = 'oops_all_20s_4_space',
    category = { 'charms', 'oops_all_20s' },

    jokers = { 'j_oops', 'j_space', 'j_space', 'j_space', 'j_space' },
    dollars = 8,
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_OopsAll20s'
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.hands["High Card"].level, 5)
    end
}
--#endregion

--#region Fortuna
Balatest.TestPlay {
    name = 'fortuna',
    category = { 'charms', 'fortuna' },

    jokers = { 'j_oops', 'j_oops', 'j_joker', 'j_joker', 'j_joker' },
    consumeables = { 'c_wheel_of_fortune', 'c_wheel_of_fortune', 'c_wheel_of_fortune', 'c_wheel_of_fortune', 'c_wheel_of_fortune' },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Fortuna'
        for i = 1, 5 do
            Balatest.use(G.consumeables.cards[i])
        end
    end,
    assert = function()
        for i = 1, 5 do
            Balatest.assert(G.jokers.cards[i].edition.key == 'e_polychrome')
        end
    end
}
--#endregion

--#region Memento Mori
Balatest.TestPlay {
    name = 'memento_mori_shop',
    category = { 'charms', 'memento_mori' },

    execute = function()
        Balatest.hook(_G, 'get_current_pool', function(orig, type, ...)
            local r, k = orig(type, ...)
            if type == 'Tarot' then
                for i = #r, 1, -1 do
                    if r[i] == 'c_death' then
                        table.remove(r, i)
                    end
                end
            end
            return r, k
        end)
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_MementoMori'
        Balatest.q(function()
            G.GAME.joker_rate = 0
            G.GAME.planet_rate = 0
        end)
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert(G.shop_jokers.cards[1].config.center.key ~= 'c_death')
        Balatest.assert(G.shop_jokers.cards[2].config.center.key ~= 'c_death')
    end
}
Balatest.TestPlay {
    name = 'memento_mori_pack',
    category = { 'charms', 'memento_mori' },

    execute = function()
        Balatest.hook(Card, 'init', function(orig, self, a, b, c, d, e, center, f, ...)
            if center.set == 'Booster' then
                return orig(self, a, b, c, d, e, G.P_CENTERS.p_arcana_jumbo_1, f, ...)
            end
            return orig(self, a, b, c, d, e, center, f, ...)
        end)
        Balatest.hook(_G, 'get_current_pool', function(orig, type, ...)
            local r, k = orig(type, ...)
            if type == 'Tarot' then
                for i = #r, 1, -1 do
                    if r[i] == 'c_death' then
                        table.remove(r, i)
                    end
                end
            end
            return r, k
        end)
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_MementoMori'
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.use(function() return G.shop_booster.cards[1] end)
    end,
    assert = function()
        for i = 1, 5 do
            Balatest.assert(G.pack_cards.cards[i].config.center.key == 'c_death')
        end
    end
}
Balatest.TestPlay {
    name = 'memento_mori_cartomancer',
    category = { 'charms', 'memento_mori' },

    no_auto_start = true,
    jokers = { 'j_cartomancer' },
    execute = function()
        Balatest.hook(_G, 'get_current_pool', function(orig, type, ...)
            local r, k = orig(type, ...)
            if type == 'Tarot' then
                for i = #r, 1, -1 do
                    if r[i] == 'c_death' then
                        table.remove(r, i)
                    end
                end
            end
            return r, k
        end)
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_MementoMori'
        Balatest.start_round()
    end,
    assert = function()
        Balatest.assert(G.consumeables.cards[1].config.center.key ~= 'c_death')
    end
}
Balatest.TestPlay {
    name = 'memento_mori_vagabond_stoic',
    category = { 'charms', 'memento_mori', 'blinds', 'stoic' },

    jokers = { 'j_vagabond' },
    dollars = 0,
    blind = 'bl_Bakery_Lammed',
    no_auto_start = true,
    execute = function()
        Balatest.hook(_G, 'get_current_pool', function(orig, type, ...)
            local r, k = orig(type, ...)
            if type == 'Tarot' then
                for i = #r, 1, -1 do
                    if r[i] == 'c_death' then
                        table.remove(r, i)
                    end
                end
            end
            return r, k
        end)
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_MementoMori'
        Balatest.start_round()
        Balatest.play_hand { '2S' }
        Balatest.play_hand { '2H' }
    end,
    assert = function()
        Balatest.assert(G.consumeables.cards[1].config.center.key ~= 'c_death')
        Balatest.assert(G.consumeables.cards[2].config.center.key ~= 'c_death')
    end
}
--#endregion

--#region Full Moon
Balatest.TestPlay {
    name = 'full_moon_flips',
    category = { 'charms', 'full_moon' },

    jokers = { 'j_Bakery_Werewolf' },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_FullMoon'
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 * 3)
    end
}
Balatest.TestPlay {
    name = 'full_moon_stops_flips',
    category = { 'charms', 'full_moon' },

    jokers = { 'j_Bakery_Werewolf' },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_FullMoon'
        Balatest.discard { '2S' }
        Balatest.discard { '3S' }
        Balatest.next_round()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 * 3)
    end
}
Balatest.TestPlay {
    name = 'full_moon_proactively_flips',
    category = { 'charms', 'full_moon' },

    execute = function()
        G.GAME.tarot_rate = 0
        G.GAME.planet_rate = 0
        Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
            return orig(t, a, l, r, k, s, 'j_Bakery_Werewolf', ...)
        end)
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_FullMoon'
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.buy(function() return G.shop_jokers.cards[1] end)
        Balatest.exit_shop()
        Balatest.start_round()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 * 3)
    end
}
Balatest.TestPlay {
    name = 'full_moon_retroactive',
    category = { 'charms', 'full_moon' },

    jokers = { 'j_Bakery_Werewolf' },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_FullMoon'
        Balatest.discard { '2S' }
        Balatest.discard { '3S' }
        Balatest.next_round()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Coin'
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 * 3)
    end
}
--#endregion

--#region Ordinary Stone
Balatest.TestPlay {
    name = 'ordinary_stone_play',
    category = { 'charms', 'ordinary_stone' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_OrdinaryStone'
        Balatest.play_hand { '2S' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(G.deck.cards[1].base.value == '2')
        Balatest.assert(G.deck.cards[1].base.suit == 'Spades')
    end
}
Balatest.TestPlay {
    name = 'ordinary_stone_discard',
    category = { 'charms', 'ordinary_stone' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_OrdinaryStone'
        Balatest.discard { '2S' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(G.deck.cards[1].base.value == '2')
        Balatest.assert(G.deck.cards[1].base.suit == 'Spades')
    end
}
--#endregion

--#region Cracked Marble
Balatest.TestPlay {
    name = 'cracked_marble_equipped',
    category = { 'charms', 'cracked_marble' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_CrackedMarble'
        Balatest.hook(_G, 'pseudorandom', function(orig, ...)
            return 1 - ((1 - 0.997) * 7.6)
        end)
        Balatest.q(function()
            local card = create_card('Tarot', G.consumeables, nil, nil, nil, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
            card:start_materialize()
        end)
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert(G.consumeables.cards[1].config.center.key == 'c_soul')
    end
}
Balatest.TestPlay {
    name = 'cracked_marble_unequipped',
    category = { 'charms', 'cracked_marble' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_CrackedMarble'
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Coin'
        Balatest.hook(_G, 'pseudorandom', function(orig, ...)
            return 1 - ((1 - 0.997) * 7.6)
        end)
        Balatest.q(function()
            local card = create_card('Tarot', G.consumeables, nil, nil, nil, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
            card:start_materialize()
        end)
        Balatest.wait()
    end,
    assert = function()
        Balatest.assert(G.consumeables.cards[1].config.center.key ~= 'c_soul')
    end
}
--#endregion

--#region Milky Way
Balatest.TestPlay {
    name = 'milky_way_arcana_pack',
    category = { 'charms', 'milky_way' },

    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_MilkyWay'
        Balatest.hook(_G, 'get_pack', function() return { key = 'p_arcana_normal_1' } end)
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.use(function() return G.shop_booster.cards[2] end)
    end,
    assert = function()
        Balatest.assert(G.pack_cards.cards[1].config.center.set == 'Planet')
    end
}
Balatest.TestPlay {
    name = 'milky_way_cartomancer',
    category = { 'charms', 'milky_way' },

    no_auto_start = true,
    jokers = { 'j_cartomancer' },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_MilkyWay'
        Balatest.start_round()
    end,
    assert = function()
        Balatest.assert(G.consumeables.cards[1].config.center.set == 'Planet')
    end
}
Balatest.TestPlay {
    name = 'milky_way_purple_seal',
    category = { 'charms', 'milky_way' },

    deck = { cards = { { r = '2', s = 'S', g = 'Purple' }, { r = '3', s = 'S' } } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_MilkyWay'
        Balatest.discard { '2s' }
    end,
    assert = function()
        Balatest.assert(G.consumeables.cards[1].config.center.set == 'Planet')
    end
}
Balatest.TestPlay {
    name = 'milky_way_used',
    category = { 'charms', 'milky_way' },

    consumeables = { 'c_pluto' },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_MilkyWay'
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.hands['High Card'].level, 3)
    end
}
--#endregion

--#region Radiation
Balatest.TestPlay {
    name = 'radiation_52',
    category = { 'charms', 'radiation' },

    no_auto_start = true,
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Radiation'
        Balatest.start_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 26)
    end
}
Balatest.TestPlay {
    name = 'radiation_52_twice',
    category = { 'charms', 'radiation' },

    no_auto_start = true,
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Radiation'
        Balatest.start_round()
        Balatest.next_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 13)
    end
}
Balatest.TestPlay {
    name = 'radiation_3',
    category = { 'charms', 'radiation' },

    no_auto_start = true,
    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, { r = '2', s = 'S' }, } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Radiation'
        Balatest.start_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 1)
    end
}
Balatest.TestPlay {
    name = 'radiation_2',
    category = { 'charms', 'radiation' },

    no_auto_start = true,
    deck = { cards = { { r = '2', s = 'S' }, { r = '2', s = 'S' }, } },
    execute = function()
        Bakery_API.Balatest_equip 'BakeryCharm_Bakery_Radiation'
        Balatest.start_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 1)
    end
}
--#endregion
