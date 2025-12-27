-- See https://github.com/BakersDozenBagels/Balatest/ for more information.

--#region Tarmogoyf
Balatest.TestPlay {
    name = 'tarmogoyf_null',
    category = { 'jokers', 'tarmogoyf' },

    jokers = { 'j_Bakery_Tarmogoyf' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end
}
Balatest.TestPlay {
    name = 'tarmogoyf_discarded',
    category = { 'jokers', 'tarmogoyf' },

    jokers = { 'j_Bakery_Tarmogoyf' },
    execute = function()
        Balatest.discard { '2H', '3H', '4H', '5H', '6H' }
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 * 6)
    end
}
Balatest.TestPlay {
    name = 'tarmogoyf_discarded_duplicates',
    category = { 'jokers', 'tarmogoyf' },

    jokers = { 'j_Bakery_Tarmogoyf' },
    execute = function()
        Balatest.discard { 'AS', 'AH', 'AC', 'AD', '2H' }
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 * 3)
    end
}
Balatest.TestPlay {
    name = 'tarmogoyf_discarded_multiple',
    category = { 'jokers', 'tarmogoyf' },

    jokers = { 'j_Bakery_Tarmogoyf' },
    execute = function()
        Balatest.discard { 'AS', 'AH', 'AC', 'AD', '2H' }
        Balatest.discard { '3S', '4H', '5C', '6D', '7H' }
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 * 8)
    end
}
Balatest.TestPlay {
    name = 'tarmogoyf_reset',
    category = { 'jokers', 'tarmogoyf' },

    jokers = { 'j_Bakery_Tarmogoyf' },
    execute = function()
        Balatest.discard { '3S', '4H', '5C', '6D', '7H' }
        Balatest.next_round()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end
}
--#endregion

--#region Auctioneer
Balatest.TestPlay {
    name = 'auctioneer_none',
    category = { 'jokers', 'auctioneer' },

    jokers = { 'j_Bakery_Auctioneer' },
    dollars = 0,
    execute = function() end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 0)
        Balatest.assert_eq(#G.jokers.cards, 1)
    end
}
Balatest.TestPlay {
    name = 'auctioneer_j_joker',
    category = { 'jokers', 'auctioneer' },

    jokers = { 'j_Bakery_Auctioneer', 'j_joker' },
    dollars = 0,
    execute = function() end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 3)
        Balatest.assert_eq(#G.jokers.cards, 1)
    end
}
Balatest.TestPlay {
    name = 'auctioneer_j_caino',
    category = { 'jokers', 'auctioneer' },

    jokers = { 'j_Bakery_Auctioneer', 'j_caino' },
    dollars = 0,
    execute = function() end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 30)
        Balatest.assert_eq(#G.jokers.cards, 1)
    end
}
Balatest.TestPlay {
    name = 'auctioneer_twice_half',
    category = { 'jokers', 'auctioneer' },

    jokers = { 'j_Bakery_Auctioneer', 'j_joker', 'j_joker' },
    dollars = 0,
    execute = function()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 3)
        Balatest.assert_eq(#G.jokers.cards, 2)
    end
}
Balatest.TestPlay {
    name = 'auctioneer_twice',
    category = { 'jokers', 'auctioneer' },

    jokers = { 'j_Bakery_Auctioneer', 'j_joker', 'j_joker' },
    dollars = 0,
    execute = function()
        Balatest.next_round()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 6)
        Balatest.assert_eq(#G.jokers.cards, 1)
    end
}
--#endregion

--#region Don
Balatest.TestPlay {
    name = 'don',
    category = { 'jokers', 'don' },

    jokers = { 'j_Bakery_Don' },
    dollars = 4,
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(21)
        Balatest.assert_eq(G.GAME.dollars, 1)
    end
}
Balatest.TestPlay {
    name = 'don_debt',
    category = { 'jokers', 'don' },

    jokers = { 'j_Bakery_Don' },
    dollars = 1,
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(21)
        Balatest.assert_eq(G.GAME.dollars, -2)
    end
}
Balatest.TestPlay {
    name = 'don_deep_debt',
    category = { 'jokers', 'don' },

    jokers = { 'j_Bakery_Don' },
    dollars = -10,
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(21)
        Balatest.assert_eq(G.GAME.dollars, -13)
    end
}
--#endregion

--#region Werewolf
Balatest.TestPlay {
    name = 'werewolf_front',
    category = { 'jokers', 'werewolf' },

    jokers = { 'j_Bakery_Werewolf' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'werewolf_front_flips',
    category = { 'jokers', 'werewolf' },

    jokers = { 'j_Bakery_Werewolf' },
    execute = function()
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].ability.extra.flipped)
    end
}
Balatest.TestPlay {
    name = 'werewolf_front_does_not_flip',
    category = { 'jokers', 'werewolf' },

    jokers = { 'j_Bakery_Werewolf' },
    execute = function()
        Balatest.discard { '2S' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(not G.jokers.cards[1].ability.extra.flipped)
    end
}
Balatest.TestPlay {
    name = 'werewolf_back',
    category = { 'jokers', 'werewolf' },

    jokers = { 'j_Bakery_Werewolf' },
    execute = function()
        Balatest.next_round()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(21)
    end
}
Balatest.TestPlay {
    name = 'werewolf_back_does_not_flip_0',
    category = { 'jokers', 'werewolf' },

    jokers = { 'j_Bakery_Werewolf' },
    execute = function()
        Balatest.next_round()
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].ability.extra.flipped)
    end
}
Balatest.TestPlay {
    name = 'werewolf_back_does_not_flip_1',
    category = { 'jokers', 'werewolf' },

    jokers = { 'j_Bakery_Werewolf' },
    execute = function()
        Balatest.next_round()
        Balatest.discard { '2S' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].ability.extra.flipped)
    end
}
Balatest.TestPlay {
    name = 'werewolf_back_flips',
    category = { 'jokers', 'werewolf' },

    jokers = { 'j_Bakery_Werewolf' },
    execute = function()
        Balatest.next_round()
        Balatest.discard { '2S' }
        Balatest.discard { '3S' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(not G.jokers.cards[1].ability.extra.flipped)
    end
}
--#endregion

--#region Spinner
Balatest.TestPlay {
    name = 'spinner_0',
    category = { 'jokers', 'spinner' },

    jokers = { 'j_Bakery_Spinner' },
    execute = function()
        G.jokers.cards[1].ability.extra.rotation = 0
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 * 21)
    end
}
Balatest.TestPlay {
    name = 'spinner_1',
    category = { 'jokers', 'spinner' },

    jokers = { 'j_Bakery_Spinner' },
    execute = function()
        G.jokers.cards[1].ability.extra.rotation = 1
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(57)
    end
}
Balatest.TestPlay {
    name = 'spinner_2',
    category = { 'jokers', 'spinner' },

    jokers = { 'j_Bakery_Spinner' },
    execute = function()
        G.jokers.cards[1].ability.extra.rotation = 2
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'spinner_3',
    category = { 'jokers', 'spinner' },

    jokers = { 'j_Bakery_Spinner' },
    dollars = 0,
    execute = function()
        G.jokers.cards[1].ability.extra.rotation = 3
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 5)
    end
}
Balatest.TestPlay {
    name = 'spinner_spins_0',
    category = { 'jokers', 'spinner' },

    jokers = { 'j_Bakery_Spinner' },
    execute = function()
        G.jokers.cards[1].ability.extra.rotation = 0
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].ability.extra.rotation == 1)
    end
}
Balatest.TestPlay {
    name = 'spinner_spins_1',
    category = { 'jokers', 'spinner' },

    jokers = { 'j_Bakery_Spinner' },
    execute = function()
        G.jokers.cards[1].ability.extra.rotation = 1
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].ability.extra.rotation == 2)
    end
}
Balatest.TestPlay {
    name = 'spinner_spins_2',
    category = { 'jokers', 'spinner' },

    jokers = { 'j_Bakery_Spinner' },
    execute = function()
        G.jokers.cards[1].ability.extra.rotation = 2
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].ability.extra.rotation == 3)
    end
}
Balatest.TestPlay {
    name = 'spinner_spins_3',
    category = { 'jokers', 'spinner' },

    jokers = { 'j_Bakery_Spinner' },
    execute = function()
        G.jokers.cards[1].ability.extra.rotation = 3
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].ability.extra.rotation == 4)
    end
}
--#endregion

--#region Proxy
Balatest.TestPlay {
    name = 'proxy_null',
    category = { 'jokers', 'proxy' },

    jokers = { 'j_Bakery_Proxy' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end
}
Balatest.TestPlay {
    name = 'proxy_joker_from_judgement',
    category = { 'jokers', 'proxy' },

    jokers = { 'j_Bakery_Proxy' },
    consumeables = { 'c_judgement' },
    execute = function()
        Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
            return orig(t, a, l, r, k, s, 'j_joker', ...)
        end)
        Balatest.hook(_G, 'poll_edition', function() end)
        Balatest.use(G.consumeables.cards[1])
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(35)
    end
}
Balatest.TestPlay {
    name = 'proxy_joker_with_timestamp',
    category = { 'jokers', 'proxy' },

    jokers = { 'j_Bakery_Proxy', 'j_joker' },
    execute = function()
        Balatest.q(function()
            G.jokers.cards[2].ability.Bakery_purchase_index = 1
        end)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(63)
    end
}
Balatest.TestPlay {
    name = 'proxy_joker_from_pack',
    category = { 'jokers', 'proxy' },

    jokers = { 'j_Bakery_Proxy' },
    execute = function()
        Balatest.hook(_G, 'get_pack', function() return { key = 'p_buffoon_normal_1' } end)
        Balatest.hook(_G, 'create_card', function(orig, set, a, l, r, k, s, f, ...)
            return set == 'Joker' and orig(set, a, l, r, k, s, 'j_joker', ...) or orig(set, a, l, r, k, s, f, ...)
        end)
        Balatest.hook(_G, 'poll_edition', function() end)
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.use(function() return G.shop_booster.cards[2] end)
        Balatest.use(function() return G.pack_cards.cards[1] end)
        Balatest.exit_shop()
        Balatest.start_round()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(35)
    end
}
Balatest.TestPlay {
    name = 'proxy_joker_from_shop',
    category = { 'jokers', 'proxy' },

    jokers = { 'j_Bakery_Proxy' },
    dollars = 2,
    execute = function()
        G.GAME.tarot_rate = 0
        G.GAME.planet_rate = 0
        Balatest.hook(_G, 'create_card', function(orig, set, a, l, r, k, s, f, ...)
            return set == 'Joker' and orig(set, a, l, r, k, s, 'j_joker', ...) or orig(set, a, l, r, k, s, f, ...)
        end)
        Balatest.hook(_G, 'poll_edition', function() end)
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.buy(function() return G.shop_jokers.cards[1] end)
        Balatest.exit_shop()
        Balatest.start_round()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(63)
    end
}
Balatest.TestPlay {
    name = 'proxy_skipped',
    category = { 'jokers', 'proxy' },

    jokers = { 'j_Bakery_Proxy' },
    dollars = 6,
    execute = function()
        G.GAME.tarot_rate = 0
        G.GAME.planet_rate = 0
        Balatest.hook(_G, 'create_card', function(orig, set, a, l, r, k, s, f, ...)
            return set == 'Joker' and orig(set, a, l, r, k, s, 'j_golden', ...) or orig(set, a, l, r, k, s, f, ...)
        end)
        Balatest.hook(_G, 'poll_edition', function() end)
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.buy(function() return G.shop_jokers.cards[1] end)
        Balatest.exit_shop()
        Balatest.start_round()
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 4)
    end
}
Balatest.TestPlay {
    name = 'proxy_unskipped',
    category = { 'jokers', 'proxy' },

    jokers = { 'j_Bakery_Proxy' },
    dollars = 6,
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
        Balatest.exit_shop()
        Balatest.start_round()
        Balatest.end_round()
        Balatest.hook(_G, 'create_card', function(orig, set, a, l, r, k, s, f, ...)
            return set == 'Joker' and orig(set, a, l, r, k, s, f or 'j_golden', ...) or orig(set, a, l, r, k, s, f, ...)
        end)
        Balatest.cash_out()
        Balatest.buy(function() return G.shop_jokers.cards[1] end)
        Balatest.exit_shop()
        Balatest.start_round()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(63)
    end
}
Balatest.TestPlay {
    name = 'proxy_loop',
    category = { 'jokers', 'proxy' },

    jokers = {},
    dollars = 6,
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
        Balatest.exit_shop()
        Balatest.start_round()
        Balatest.end_round()
        Balatest.hook(_G, 'create_card', function(orig, set, a, l, r, k, s, f, ...)
            return set == 'Joker' and orig(set, a, l, r, k, s, f or 'j_Bakery_Proxy', ...) or
                orig(set, a, l, r, k, s, f, ...)
        end)
        Balatest.cash_out()
        Balatest.buy(function() return G.shop_jokers.cards[2] end)
        Balatest.buy(function() return G.shop_jokers.cards[1] end)
        Balatest.exit_shop()
        Balatest.start_round()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(91)
    end
}
--#endregion

--#region Sticker Sheet
Balatest.TestPlay {
    name = 'sticker_sheet_null',
    category = { 'jokers', 'sticker_sheet' },

    jokers = { 'j_Bakery_StickerSheet' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_self_eternal',
    category = { 'jokers', 'sticker_sheet' },

    jokers = { { id = 'j_Bakery_StickerSheet', eternal = true } },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_other_eternal',
    category = { 'jokers', 'sticker_sheet' },

    jokers = { 'j_Bakery_StickerSheet', { id = 'j_golden', eternal = true } },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_two_eternal',
    category = { 'jokers', 'sticker_sheet' },

    jokers = { { id = 'j_Bakery_StickerSheet', eternal = true }, { id = 'j_golden', eternal = true } },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(28)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_self_rental',
    category = { 'jokers', 'sticker_sheet' },

    jokers = { 'j_Bakery_StickerSheet' },
    execute = function()
        G.jokers.cards[1]:set_rental(true)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_other_rental',
    category = { 'jokers', 'sticker_sheet' },

    jokers = { 'j_Bakery_StickerSheet', 'j_golden' },
    execute = function()
        G.jokers.cards[2]:set_rental(true)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_two_rental',
    category = { 'jokers', 'sticker_sheet' },

    jokers = { 'j_Bakery_StickerSheet', 'j_golden' },
    execute = function()
        G.jokers.cards[1]:set_rental(true)
        G.jokers.cards[2]:set_rental(true)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(28)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_self_perishable',
    category = { 'jokers', 'sticker_sheet' },

    jokers = { 'j_Bakery_StickerSheet' },
    execute = function()
        G.jokers.cards[1]:set_perishable(true)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_other_perishable',
    category = { 'jokers', 'sticker_sheet' },

    jokers = { 'j_Bakery_StickerSheet', 'j_golden' },
    execute = function()
        G.jokers.cards[2]:set_perishable(true)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_two_perishable',
    category = { 'jokers', 'sticker_sheet' },

    jokers = { 'j_Bakery_StickerSheet', 'j_golden' },
    execute = function()
        G.jokers.cards[1]:set_perishable(true)
        G.jokers.cards[2]:set_perishable(true)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(28)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_self_eternal_rental',
    category = { 'jokers', 'sticker_sheet' },

    jokers = { { id = 'j_Bakery_StickerSheet', eternal = true } },
    execute = function()
        G.jokers.cards[1]:set_rental(true)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_other_eternal_rental',
    category = { 'jokers', 'sticker_sheet' },

    jokers = { 'j_Bakery_StickerSheet', { id = 'j_golden', eternal = true } },
    execute = function()
        G.jokers.cards[2]:set_rental(true)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_two_eternal_rental',
    category = { 'jokers', 'sticker_sheet' },

    jokers = { { id = 'j_Bakery_StickerSheet', eternal = true }, { id = 'j_golden', eternal = true } },
    execute = function()
        G.jokers.cards[1]:set_rental(true)
        G.jokers.cards[2]:set_rental(true)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(28)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_order_1',
    category = { 'jokers', 'sticker_sheet' },

    jokers = { { id = 'j_Bakery_StickerSheet', eternal = true }, { id = 'j_joker', eternal = true } },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(84)
    end
}
Balatest.TestPlay {
    name = 'sticker_sheet_order_2',
    category = { 'jokers', 'sticker_sheet' },

    jokers = { { id = 'j_joker', eternal = true }, { id = 'j_Bakery_StickerSheet', eternal = true } },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(140)
    end
}
--#endregion

--#region 1 of Spades
Balatest.TestPlay {
    name = '1_of_spades_level_1',
    category = { 'jokers', '1_of_spades' },

    jokers = { 'j_Bakery_PlayingCard' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(24)
    end
}
Balatest.TestPlay {
    name = '1_of_spades_level_2',
    category = { 'jokers', '1_of_spades' },

    jokers = { 'j_Bakery_PlayingCard' },
    execute = function()
        level_up_hand(nil, 'High Card', true, 1)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(128)
    end
}
--#endregion

--#region 11 of Spades
Balatest.TestPlay {
    name = '11_of_spades_level_1',
    category = { 'jokers', '11_of_spades' },

    jokers = { 'j_Bakery_PlayingCard11' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(51)
    end
}
Balatest.TestPlay {
    name = '11_of_spades_level_2',
    category = { 'jokers', '11_of_spades' },

    jokers = { 'j_Bakery_PlayingCard11' },
    execute = function()
        level_up_hand(nil, 'Pair', true, 1)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(128)
    end
}
--#endregion

--#region Evil Steven
Balatest.TestPlay {
    name = 'evil_steven_2_4',
    category = { 'jokers', 'evil_steven' },

    jokers = { 'j_Bakery_EvilSteven' },
    execute = function()
        Balatest.play_hand { '2S', '2H', '2C', '4D', '4H' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 47)
    end
}
Balatest.TestPlay {
    name = 'evil_steven_6_8',
    category = { 'jokers', 'evil_steven' },

    jokers = { 'j_Bakery_EvilSteven' },
    execute = function()
        Balatest.play_hand { '6S', '6H', '8C', '8D', '8H' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 47)
    end
}
Balatest.TestPlay {
    name = 'evil_steven_10_Q',
    category = { 'jokers', 'evil_steven' },

    jokers = { 'j_Bakery_EvilSteven' },
    execute = function()
        Balatest.play_hand { 'TS', 'TH', 'TC', 'QD', 'QH' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 49)
    end
}
Balatest.TestPlay {
    name = 'evil_steven_A_J_K',
    category = { 'jokers', 'evil_steven' },

    jokers = { 'j_Bakery_EvilSteven' },
    execute = function()
        Balatest.play_hand { 'AS' }
        Balatest.play_hand { 'JS' }
        Balatest.play_hand { 'KS' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 52)
    end
}
Balatest.TestPlay {
    name = 'evil_steven_unscoring',
    category = { 'jokers', 'evil_steven' },

    jokers = { 'j_Bakery_EvilSteven' },
    execute = function()
        Balatest.play_hand { 'AS', 'AH', 'AD', '2S', '4S' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 52)
    end
}
Balatest.TestPlay {
    name = 'evil_steven_strength',
    category = { 'jokers', 'evil_steven' },

    jokers = { 'j_Bakery_EvilSteven' },
    consumeables = { 'c_strength', 'c_strength' },
    deck = { cards = { { r = 'A', s = 'S' }, { r = '3', s = 'S' }, { r = '5', s = 'S' }, { r = '6', s = 'S' }, { r = 'J', s = 'S' }, { r = 'Q', s = 'S' } } },
    execute = function()
        Balatest.highlight { 'AS', '3S' }
        Balatest.use(G.consumeables.cards[1])
        Balatest.highlight { '5S', '6S' }
        Balatest.use(G.consumeables.cards[2])
        Balatest.play_hand { '2S', '4S', '6S', '7S', 'JS' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 3)
    end
}
--#endregion

--#region Awful Todd
Balatest.TestPlay {
    name = 'awful_todd_A_3',
    category = { 'jokers', 'awful_todd' },

    jokers = { 'j_Bakery_AwfulTodd' },
    execute = function()
        Balatest.play_hand { 'AS', 'AH', 'AC', '3D', '3H' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 47)
    end
}
Balatest.TestPlay {
    name = 'awful_todd_5_7',
    category = { 'jokers', 'awful_todd' },

    jokers = { 'j_Bakery_AwfulTodd' },
    execute = function()
        Balatest.play_hand { '5S', '5H', '7C', '7D', '7H' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 47)
    end
}
Balatest.TestPlay {
    name = 'awful_todd_9_J',
    category = { 'jokers', 'awful_todd' },

    jokers = { 'j_Bakery_AwfulTodd' },
    execute = function()
        Balatest.play_hand { '9S', '9H', '9C', 'JD', 'JH' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 49)
    end
}
Balatest.TestPlay {
    name = 'awful_todd_10_Q_K',
    category = { 'jokers', 'awful_todd' },

    jokers = { 'j_Bakery_AwfulTodd' },
    execute = function()
        Balatest.play_hand { 'TS' }
        Balatest.play_hand { 'QS' }
        Balatest.play_hand { 'KS' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 52)
    end
}
Balatest.TestPlay {
    name = 'awful_todd_unscoring',
    category = { 'jokers', 'awful_todd' },

    jokers = { 'j_Bakery_AwfulTodd' },
    execute = function()
        Balatest.play_hand { '2S', '2H', '2D', 'AS', '3S' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 52)
    end
}
Balatest.TestPlay {
    name = 'awful_todd_strength',
    category = { 'jokers', 'awful_todd' },

    jokers = { 'j_Bakery_AwfulTodd' },
    consumeables = { 'c_strength', 'c_strength' },
    deck = { cards = { { r = 'A', s = 'S' }, { r = '3', s = 'S' }, { r = '5', s = 'S' }, { r = '6', s = 'S' }, { r = 'J', s = 'S' }, { r = 'Q', s = 'S' } } },
    execute = function()
        Balatest.highlight { 'AS', '3S' }
        Balatest.use(G.consumeables.cards[1])
        Balatest.highlight { '5S', '6S' }
        Balatest.use(G.consumeables.cards[2])
        Balatest.play_hand { '2S', '4S', '6S', '7S', 'JS' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 5)
    end
}
--#endregion

--#region Joker Against Humanity
Balatest.TestPlay {
    name = 'joker_against_humanity_null',
    category = { 'jokers', 'joker_against_humanity' },

    jokers = { 'j_Bakery_JokerAgainstHumanity' },
    execute = function()
        level_up_hand(nil, 'High Card', true, 1)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(34)
    end
}
Balatest.TestPlay {
    name = 'joker_against_humanity_upgrades',
    category = { 'jokers', 'joker_against_humanity' },

    jokers = { 'j_Bakery_JokerAgainstHumanity' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(21)
    end
}
Balatest.TestPlay {
    name = 'joker_against_humanity_upgrades_twice',
    category = { 'jokers', 'joker_against_humanity' },

    jokers = { 'j_Bakery_JokerAgainstHumanity' },
    execute = function()
        Balatest.play_hand { '2S' }
        Balatest.play_hand { '2H' }
    end,
    assert = function()
        Balatest.assert_chips(56)
    end
}
Balatest.TestPlay {
    name = 'joker_against_humanity_upgrades_kept',
    category = { 'jokers', 'joker_against_humanity' },

    jokers = { 'j_Bakery_JokerAgainstHumanity' },
    execute = function()
        Balatest.play_hand { '2S' }
        Balatest.play_hand { '2H' }
        Balatest.next_round()
        Balatest.q(function() level_up_hand(nil, 'High Card', true, 1) end)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(102)
    end
}
--#endregion

--#region Card Sleeve
local function wait_for_sleeve() -- I am going to commit a crime
    local done = false
    Balatest.q(function()
        done = false
        G.E_MANAGER:add_event(Event {
            func = function()
                G.E_MANAGER:add_event(Event {
                    func = function()
                        G.E_MANAGER:add_event(Event {
                            func = function()
                                done = true
                                return true
                            end
                        })
                        return true
                    end
                })
                return true
            end
        })
    end)
    Balatest.q(function()
        return done
    end)
end

Balatest.TestPlay {
    name = 'card_sleeve_can_use_null',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve' },
    execute = function() end,
    assert = function()
        Balatest.assert(not G.jokers.cards[1].config.center:Bakery_can_use(G.jokers.cards[1]))
    end
}
Balatest.TestPlay {
    name = 'card_sleeve_can_use_one',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve' },
    execute = function()
        Balatest.highlight { '2S' }
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].config.center:Bakery_can_use(G.jokers.cards[1]))
    end
}
Balatest.TestPlay {
    name = 'card_sleeve_can_use_two',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve' },
    execute = function()
        Balatest.highlight { '2S', '3S' }
    end,
    assert = function()
        Balatest.assert(not G.jokers.cards[1].config.center:Bakery_can_use(G.jokers.cards[1]))
    end
}
Balatest.TestPlay {
    name = 'card_sleeve_hold',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve' },
    execute = function()
        Balatest.highlight { '2S' }
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].config.center:Bakery_can_use(G.jokers.cards[1]))
        Balatest.assert(G["Bakery_sleeve_" .. G.jokers.cards[1].ability.extra.key] ~= nil)
        Balatest.assert_eq(#G["Bakery_sleeve_" .. G.jokers.cards[1].ability.extra.key].cards, 1)
    end
}
Balatest.TestPlay {
    name = 'card_sleeve_hold_highlight',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve' },
    execute = function()
        Balatest.highlight { '2S' }
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
        Balatest.highlight { '3S', '4S', '5S' }
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].config.center:Bakery_can_use(G.jokers.cards[1]))
    end
}
Balatest.TestPlay {
    name = 'card_sleeve_unhold',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve' },
    execute = function()
        Balatest.highlight { '2S' }
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].ability.extra.key == nil)
        Balatest.assert_eq(#G.hand.cards, 52)
        Balatest.assert(not G.jokers.cards[1].config.center:Bakery_can_use(G.jokers.cards[1]))
    end
}
Balatest.TestPlay {
    name = 'card_sleeve_sell',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve' },
    execute = function()
        Balatest.highlight { '2S' }
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
        Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
    end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 52)
        Balatest.assert_eq(#G.jokers.cards, 0)
    end
}
Balatest.TestPlay {
    name = 'card_sleeve_can_use_in_shop',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve' },
    execute = function()
        Balatest.highlight { '2S' }
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert(G["Bakery_sleeve_" .. G.jokers.cards[1].ability.extra.key] ~= nil)
        Balatest.assert_eq(#G["Bakery_sleeve_" .. G.jokers.cards[1].ability.extra.key].cards, 1)
        Balatest.assert(not G.jokers.cards[1].config.center:Bakery_can_use(G.jokers.cards[1]))
    end
}
Balatest.TestPlay {
    name = 'card_sleeve_sell_in_shop',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve' },
    execute = function()
        Balatest.highlight { '2S' }
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
    end,
    assert = function()
        Balatest.assert_eq(#G.deck.cards, 52)
        Balatest.assert_eq(#G.jokers.cards, 0)
    end
}
Balatest.TestPlay {
    name = 'card_sleeve_gold',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve' },
    deck = { cards = { { r = '2', s = 'S', e = 'm_gold' }, { r = '3', s = 'S', e = 'm_gold' } } },
    dollars = 0,
    execute = function()
        Balatest.highlight { '3S' }
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 3)
    end
}
Balatest.TestPlay {
    name = 'card_sleeve_two',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve', 'j_Bakery_CardSleeve' },
    deck = { cards = { { r = '2', s = 'S', e = 'm_gold' }, { r = '3', s = 'S', e = 'm_gold' }, { r = '4', s = 'S' }, { r = '5', s = 'S' } } },
    dollars = 0,
    execute = function()
        Balatest.highlight { '2S' }
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
        Balatest.highlight { '3S' }
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[2] } } end)
        wait_for_sleeve()
    end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 2)
    end
}
Balatest.TestPlay {
    name = 'card_sleeve_two_retrieve',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve', 'j_Bakery_CardSleeve' },
    deck = { cards = { { r = '2', s = 'S', e = 'm_gold' }, { r = '3', s = 'S', e = 'm_gold' }, { r = '4', s = 'S' }, { r = '5', s = 'S' } } },
    dollars = 0,
    execute = function()
        Balatest.highlight { '2S' }
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
        Balatest.highlight { '3S' }
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[2] } } end)
        wait_for_sleeve()
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
    end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 3)
    end
}
Balatest.TestPlay {
    name = 'card_sleeve_chariot',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve' },
    consumeables = { 'c_chariot' },
    deck = { cards = { { r = '2', s = 'S' }, { r = '3', s = 'S' } } },
    dollars = 0,
    execute = function()
        Balatest.highlight { '2S' }
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
        Balatest.q(function()
            G["Bakery_sleeve_" .. G.jokers.cards[1].ability.extra.key]:add_to_highlighted(
                G["Bakery_sleeve_" .. G.jokers.cards[1].ability.extra.key].cards[1], true)
        end)
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert(G["Bakery_sleeve_" .. G.jokers.cards[1].ability.extra.key].cards[1].config.center.key ==
            'm_steel')
    end
}
Balatest.TestPlay {
    name = 'card_sleeve_chariot_release',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve' },
    consumeables = { 'c_chariot' },
    deck = { cards = { { r = '2', s = 'S' }, { r = '3', s = 'S' } } },
    dollars = 0,
    execute = function()
        Balatest.highlight { '2S' }
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
        Balatest.q(function()
            G["Bakery_sleeve_" .. G.jokers.cards[1].ability.extra.key]:add_to_highlighted(
                G["Bakery_sleeve_" .. G.jokers.cards[1].ability.extra.key].cards[1], true)
        end)
        Balatest.use(G.consumeables.cards[1])
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
    end,
    assert = function()
        Balatest.assert(G.hand.cards[2].config.center.key == 'm_steel')
    end
}
Balatest.TestPlay {
    name = 'card_sleeve_hanged_man',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve' },
    consumeables = { 'c_hanged_man' },
    deck = { cards = { { r = '2', s = 'S' }, { r = '3', s = 'S' } } },
    dollars = 0,
    execute = function()
        Balatest.highlight { '2S' }
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
        Balatest.q(function()
            G["Bakery_sleeve_" .. G.jokers.cards[1].ability.extra.key]:add_to_highlighted(
                G["Bakery_sleeve_" .. G.jokers.cards[1].ability.extra.key].cards[1], true)
        end)
        Balatest.use(G.consumeables.cards[1])
        Balatest.highlight { '3S' }
    end,
    assert = function()
        Balatest.assert(not G.jokers.cards[1].ability.extra.occupied)
        Balatest.assert(G.jokers.cards[1].config.center:Bakery_can_use(G.jokers.cards[1]))
    end
}
Balatest.TestPlay {
    name = 'card_sleeve_hanged_man_add',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve' },
    consumeables = { 'c_hanged_man' },
    deck = { cards = { { r = '2', s = 'S' }, { r = '3', s = 'S' }, { r = '4', s = 'S' } } },
    dollars = 0,
    execute = function()
        Balatest.highlight { '2S' }
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
        Balatest.q(function()
            G["Bakery_sleeve_" .. G.jokers.cards[1].ability.extra.key]:add_to_highlighted(
                G["Bakery_sleeve_" .. G.jokers.cards[1].ability.extra.key].cards[1], true)
        end)
        Balatest.use(G.consumeables.cards[1])
        Balatest.highlight { '3S' }
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].ability.extra.occupied)
        Balatest.assert_eq(#G.hand.cards, 1)
    end
}
Balatest.TestPlay {
    name = 'card_sleeve_chariot_in_shop',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve' },
    consumeables = { 'c_chariot' },
    deck = { cards = { { r = '2', s = 'S' }, { r = '3', s = 'S' } } },
    dollars = 0,
    execute = function()
        Balatest.highlight { '2S' }
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
        Balatest.q(function()
            G["Bakery_sleeve_" .. G.jokers.cards[1].ability.extra.key]:add_to_highlighted(
                G["Bakery_sleeve_" .. G.jokers.cards[1].ability.extra.key].cards[1], true)
        end)
        Balatest.end_round()
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert(G["Bakery_sleeve_" .. G.jokers.cards[1].ability.extra.key].cards[1].config.center.key ==
            'm_steel')
    end
}
Balatest.TestPlay {
    name = 'card_sleeve_in_pack',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve' },
    dollars = 10,
    execute = function()
        Balatest.hook(_G, 'get_pack', function() return { key = 'p_arcana_normal_1' } end)
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.use(function() return G.shop_booster.cards[2] end)
        Balatest.highlight { '2S' }
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].ability.extra.occupied)
        Balatest.assert_eq(#G.hand.cards, 51)
    end
}
Balatest.TestPlay {
    name = 'card_sleeve_in_pack_retrieved',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve' },
    dollars = 10,
    execute = function()
        Balatest.hook(_G, 'get_pack', function() return { key = 'p_arcana_normal_1' } end)
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.use(function() return G.shop_booster.cards[2] end)
        Balatest.highlight { '2S' }
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
    end,
    assert = function()
        Balatest.assert(not G.jokers.cards[1].ability.extra.occupied)
        Balatest.assert_eq(#G.hand.cards, 52)
    end
}
Balatest.TestPlay {
    name = 'card_sleeve_in_pack_sold',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve' },
    dollars = 10,
    execute = function()
        Balatest.hook(_G, 'get_pack', function() return { key = 'p_arcana_normal_1' } end)
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.use(function() return G.shop_booster.cards[2] end)
        Balatest.highlight { '2S' }
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
        Balatest.q(function() G.FUNCS.sell_card { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
    end,
    assert = function()
        Balatest.assert_eq(#G.jokers.cards, 0)
        Balatest.assert_eq(#G.hand.cards, 52)
    end
}
Balatest.TestPlay {
    name = 'card_sleeve_in_pack_death',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve' },
    dollars = 10,
    execute = function()
        Balatest.hook(_G, 'get_pack', function() return { key = 'p_arcana_normal_1' } end)
        Balatest.hook(_G, 'create_card', function(orig, set, a, l, r, k, s, f, ...)
            return set == 'Tarot' and orig(set, a, l, r, k, s, 'c_death', ...) or orig(set, a, l, r, k, s, f, ...)
        end)
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.use(function() return G.shop_booster.cards[2] end)
        Balatest.highlight { '2S' }
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        wait_for_sleeve()
        Balatest.q(function()
            G["Bakery_sleeve_" .. G.jokers.cards[1].ability.extra.key]:add_to_highlighted(
                G["Bakery_sleeve_" .. G.jokers.cards[1].ability.extra.key].cards[1], true)
        end)
        Balatest.highlight { '3S' }
        Balatest.use(function() return G.pack_cards.cards[1] end)
    end,
    assert = function()
        Balatest.assert(G["Bakery_sleeve_" .. G.jokers.cards[1].ability.extra.key].cards[1].base.id == 3)
    end
}
Balatest.TestPlay {
    name = 'card_sleeve_reload_full',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve' },
    execute = function()
        Balatest.highlight { '2S' }
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        Balatest.end_round()
        Balatest.reload()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].ability.extra.area:is(CardArea))
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.area.cards[1].base.id, 2)
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.area.cards[1].base.suit, 'Spades')
        Balatest.assert_eq(#G.jokers.cards[1].ability.extra.area.cards, 1)
    end,
}
Balatest.TestPlay {
    name = 'card_sleeve_reload_full_empty',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve', 'j_Bakery_CardSleeve' },
    execute = function()
        Balatest.highlight { '2S' }
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        Balatest.end_round()
        Balatest.reload()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].ability.extra.area:is(CardArea))
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.area.cards[1].base.id, 2)
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.area.cards[1].base.suit, 'Spades')
        Balatest.assert_eq(#G.jokers.cards[1].ability.extra.area.cards, 1)
        Balatest.assert(G.jokers.cards[2].ability.extra.area == nil)
        Balatest.assert(not G.jokers.cards[2].ability.extra.occupied)
    end,
}
Balatest.TestPlay {
    name = 'card_sleeve_reload_empty',
    category = { 'jokers', 'card_sleeve' },

    jokers = { 'j_Bakery_CardSleeve' },
    execute = function()
        Balatest.highlight { '2S' }
        Balatest.end_round()
        Balatest.reload()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].ability.extra.area == nil)
        Balatest.assert(not G.jokers.cards[1].ability.extra.occupied)
    end,
}
--#endregion

--#region Bongard Problem
Balatest.TestPlay {
    name = 'bongard_problem_standard',
    category = { 'jokers', 'bongard_problem' },

    jokers = { 'j_Bakery_BongardProblem' },
    execute = function()
        Balatest.play_hand { '2S', '2H' }
    end,
    assert = function()
        Balatest.assert_chips(56)
    end
}
Balatest.TestPlay {
    name = 'bongard_problem_same_suit',
    category = { 'jokers', 'bongard_problem' },

    jokers = { 'j_Bakery_BongardProblem' },
    execute = function()
        Balatest.play_hand { '2S', '3C', '4H', '5D', '6S' }
    end,
    assert = function()
        Balatest.assert_chips(200)
    end
}
Balatest.TestPlay {
    name = 'bongard_problem_single',
    category = { 'jokers', 'bongard_problem' },

    jokers = { 'j_Bakery_BongardProblem' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end
}
Balatest.TestPlay {
    name = 'bongard_problem_single_wild',
    category = { 'jokers', 'bongard_problem' },

    jokers = { 'j_Bakery_BongardProblem' },
    deck = { cards = { { s = 'S', r = '2', e = 'm_wild' }, { s = 'S', r = '3' } } },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
--#endregion

--#region Coin Slot
Balatest.TestPlay {
    name = 'coin_slot_null',
    category = { 'jokers', 'coin_slot' },

    jokers = { 'j_Bakery_CoinSlot' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end
}
Balatest.TestPlay {
    name = 'coin_slot_inserted',
    category = { 'jokers', 'coin_slot' },

    jokers = { 'j_Bakery_CoinSlot' },
    dollars = 10,
    execute = function()
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 5)
        Balatest.assert_chips(28)
    end
}
Balatest.TestPlay {
    name = 'coin_slot_inserted_twice',
    category = { 'jokers', 'coin_slot' },

    jokers = { 'j_Bakery_CoinSlot' },
    dollars = 10,
    execute = function()
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        Balatest.q(function() return Bakery_API.default_can_use(G.jokers.cards[1]) end)
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 0)
        Balatest.assert_chips(49)
    end
}
Balatest.TestPlay {
    name = 'coin_slot_no_debt',
    category = { 'jokers', 'coin_slot' },

    jokers = { 'j_Bakery_CoinSlot' },
    dollars = 0,
    execute = function() end,
    assert = function()
        Balatest.assert(not G.jokers.cards[1].config.center:Bakery_can_use(G.jokers.cards[1]))
    end
}
Balatest.TestPlay {
    name = 'coin_slot_no_debt_click',
    category = { 'jokers', 'coin_slot' },

    jokers = { 'j_Bakery_CoinSlot' },
    dollars = 0,
    execute = function()
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 0)
        Balatest.assert_chips(7)
    end
}
Balatest.TestPlay {
    name = 'coin_slot_yes_debt',
    category = { 'jokers', 'coin_slot' },

    jokers = { 'j_Bakery_CoinSlot', 'j_credit_card' },
    dollars = 0,
    execute = function()
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, -5)
        Balatest.assert_chips(28)
    end
}
--#endregion

--#region Pyrite
Balatest.TestPlay {
    name = 'pyrite_normal',
    category = { 'jokers', 'pyrite' },

    jokers = { 'j_Bakery_Pyrite' },
    hand_size = 5,
    execute = function() end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 8)
    end
}
Balatest.TestPlay {
    name = 'pyrite_full',
    category = { 'jokers', 'pyrite' },

    jokers = { 'j_Bakery_Pyrite' },
    deck = { cards = { { s = 'S', r = 'A' } } },
    hand_size = 1,
    execute = function() end,
    assert = function()
        Balatest.assert_eq(#G.hand.cards, 1)
    end
}
--#endregion

--#region Snowball
Balatest.TestPlay {
    name = 'snowball_1',
    category = { 'jokers', 'snowball' },

    jokers = { 'j_joker', 'j_joker', 'j_Bakery_Snowball' },
    execute = function()
        Balatest.play_hand { '2S', '2H' }
    end,
    assert = function()
        Balatest.assert_chips(154)
    end
}
Balatest.TestPlay {
    name = 'snowball_5',
    category = { 'jokers', 'snowball' },

    jokers = { 'j_joker', 'j_joker', 'j_Bakery_Snowball' },
    execute = function()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.play_hand { '2S', '2H' }
    end,
    assert = function()
        Balatest.assert_chips(210)
    end
}
--#endregion

--#region Get Out of Jail Free Card
Balatest.TestPlay {
    name = 'get_out_of_jail_free_card_null',
    category = { 'jokers', 'get_out_of_jail_free_card' },

    jokers = { 'j_Bakery_GetOutOfJailFreeCard' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end
}
Balatest.TestPlay {
    name = 'get_out_of_jail_free_card_used',
    category = { 'jokers', 'get_out_of_jail_free_card' },

    jokers = { 'j_Bakery_GetOutOfJailFreeCard' },
    execute = function()
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(35)
    end
}
Balatest.TestPlay {
    name = 'get_out_of_jail_free_card_used_across_rounds',
    category = { 'jokers', 'get_out_of_jail_free_card' },

    jokers = { 'j_Bakery_GetOutOfJailFreeCard' },
    execute = function()
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
        Balatest.next_round()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(35)
    end
}
Balatest.TestPlay {
    name = 'get_out_of_jail_free_card_use_twice',
    category = { 'jokers', 'get_out_of_jail_free_card' },

    jokers = { 'j_Bakery_GetOutOfJailFreeCard' },
    execute = function()
        Balatest.q(function() G.FUNCS.Bakery_use_joker { config = { ref_table = G.jokers.cards[1] } } end)
    end,
    assert = function()
        Balatest.assert(not G.jokers.cards[1].config.center:Bakery_can_use(G.jokers.cards[1]))
    end
}
--#endregion

--#region Transparent Back Buffer
Balatest.TestPlay {
    name = 'transparent_back_buffer_1',
    category = { 'jokers', 'transparent_back_buffer' },

    jokers = { 'j_Bakery_TransparentBackBuffer' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(49)
    end
}
Balatest.TestPlay {
    name = 'transparent_back_buffer_5_k_r',
    category = { 'jokers', 'transparent_back_buffer' },

    jokers = { 'j_Bakery_TransparentBackBuffer' },
    execute = function()
        Balatest.play_hand { '2S', '2H', '2C', '3D', '3S' }
    end,
    assert = function()
        Balatest.assert_chips(1768)
    end
}
Balatest.TestPlay {
    name = 'transparent_back_buffer_5_r_k',
    category = { 'jokers', 'transparent_back_buffer' },

    jokers = { 'j_Bakery_TransparentBackBuffer' },
    execute = function()
        Balatest.play_hand { '2H', '2S', '2D', '3C', '3D' }
    end,
    assert = function()
        Balatest.assert_chips(1768)
    end
}
Balatest.TestPlay {
    name = 'transparent_back_buffer_5_wild',
    category = { 'jokers', 'transparent_back_buffer' },

    jokers = { 'j_Bakery_TransparentBackBuffer' },
    deck = { cards = { { s = 'S', r = 'A', e = 'm_wild' }, { s = 'S', r = 'A', e = 'm_wild' }, { s = 'S', r = 'A', e = 'm_wild' }, { s = 'S', r = 'A', e = 'm_wild' }, { s = 'S', r = 'A', e = 'm_wild' }, { s = 'S', r = '2' } } },
    execute = function()
        Balatest.play_hand { 'AS', 'AS', 'AS', 'AS', 'AS' }
    end,
    assert = function()
        Balatest.assert_chips(9890)
    end
}
Balatest.TestPlay {
    name = 'transparent_back_buffer_stone',
    category = { 'jokers', 'transparent_back_buffer' },

    jokers = { 'j_Bakery_TransparentBackBuffer' },
    deck = { cards = { { s = 'S', r = 'A', e = 'm_stone' }, { s = 'S', r = '2' } } },
    execute = function()
        Balatest.play_hand { 'AS' }
    end,
    assert = function()
        Balatest.assert_chips(55)
    end
}
--#endregion

--#region Tier List
Balatest.TestPlay {
    name = 'tier_list_solo',
    category = { 'jokers', 'tier_list' },

    jokers = { 'j_Bakery_TierList' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end
}
Balatest.TestPlay {
    name = 'tier_list_golden',
    category = { 'jokers', 'tier_list' },

    jokers = { 'j_Bakery_TierList', 'j_golden' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'tier_list_golden_golden',
    category = { 'jokers', 'tier_list' },

    jokers = { 'j_Bakery_TierList', 'j_golden', 'j_golden' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'tier_list_golden_stone',
    category = { 'jokers', 'tier_list' },

    jokers = { 'j_Bakery_TierList', 'j_golden', 'j_stone' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(21)
    end
}
Balatest.TestPlay {
    name = 'tier_list_golden_stone_chicot',
    category = { 'jokers', 'tier_list' },

    jokers = { 'j_Bakery_TierList', 'j_golden', 'j_stone', 'j_chicot' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(28)
    end
}
--#endregion

--#region Tag
Balatest.TestPlay {
    name = 'tag_null',
    category = { 'jokers', 'tag' },

    jokers = { 'j_Bakery_Tag' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7)
    end
}
Balatest.TestPlay {
    name = 'tag_one',
    category = { 'jokers', 'tag' },

    jokers = { 'j_Bakery_Tag' },
    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_BlankTag'
        Balatest.start_round()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'tag_two',
    category = { 'jokers', 'tag' },

    jokers = { 'j_Bakery_Tag' },
    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_BlankTag'
        Balatest.skip_blind 'tag_Bakery_BlankTag'
        Balatest.start_round()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(28)
    end
}
Balatest.TestPlay {
    name = 'tag_gone',
    category = { 'jokers', 'tag' },

    jokers = { 'j_Bakery_Tag' },
    no_auto_start = true,
    execute = function()
        Balatest.skip_blind 'tag_Bakery_BlankTag'
        Balatest.skip_blind 'tag_Bakery_BlankTag'
        Balatest.start_round()
        Balatest.play_hand { '2S' }
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.exit_shop()
        Balatest.skip_blind 'tag_Bakery_AntiTag'
        Balatest.start_round()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
--#endregion

--#region Glass Cannon
Balatest.TestPlay {
    name = 'glass_cannon_no_shatter',
    category = { 'jokers', 'glass_cannon' },

    jokers = { 'j_Bakery_GlassCannon' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(21)
        Balatest.assert_eq(#G.jokers.cards, 1)
    end
}
Balatest.TestPlay {
    name = 'glass_cannon_yes_shatter',
    category = { 'jokers', 'glass_cannon' },

    jokers = { 'j_order', 'j_order', 'j_Bakery_GlassCannon' },
    execute = function()
        Balatest.play_hand { '2S', '3S', '4S', '5S', '6S' }
    end,
    assert = function()
        Balatest.assert_chips(25920)
        Balatest.assert_eq(#G.jokers.cards, 2)
    end
}
Balatest.TestPlay {
    name = 'glass_cannon_yes_shatter_avoided',
    category = { 'jokers', 'glass_cannon' },

    jokers = { 'j_Bakery_GlassCannon', 'j_order', 'j_order' },
    execute = function()
        Balatest.play_hand { '2S', '3S', '4S', '5S', '6S' }
    end,
    assert = function()
        Balatest.assert_chips(25920)
        Balatest.assert_eq(#G.jokers.cards, 3)
    end
}
--#endregion

--#region 3 of So
Balatest.TestPlay {
    name = '3_of_so_no_straight',
    category = { 'jokers', '3_of_so' },

    jokers = { 'j_Bakery_3So' },
    execute = function()
        Balatest.play_hand { '2S', '3S', '5S', '6S', '8S' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 0)
        Balatest.assert_chips(236)
    end
}
Balatest.TestPlay {
    name = '3_of_so_straight_unscoring',
    category = { 'jokers', '3_of_so' },

    jokers = { 'j_Bakery_3So' },
    execute = function()
        Balatest.play_hand { '2S', '3S', '4S', '6S', '8H' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 0)
        Balatest.assert_chips(13)
    end
}
Balatest.TestPlay {
    name = '3_of_so_straight',
    category = { 'jokers', '3_of_so' },

    jokers = { 'j_Bakery_3So' },
    execute = function()
        Balatest.play_hand { '2S', '3S', '4S', '6S', '8S' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 2)
        Balatest.assert_chips(348)
    end
}
Balatest.TestPlay {
    name = '3_of_so_scaled',
    category = { 'jokers', '3_of_so' },

    jokers = { 'j_Bakery_3So' },
    execute = function()
        Balatest.play_hand { '2S', '3S', '4S', '6S', '8S' }
        Balatest.next_round()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.jokers.cards[1].ability.extra.mult, 2)
        Balatest.assert_chips(21)
    end
}
--#endregion

--#region Weerewolf
Balatest.TestPlay {
    name = 'weerewolf_front',
    category = { 'jokers', 'weerewolf' },

    jokers = { 'j_Bakery_Weerewolf' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(21)
    end
}
Balatest.TestPlay {
    name = 'weerewolf_front_flips',
    category = { 'jokers', 'weerewolf' },

    jokers = { 'j_Bakery_Weerewolf' },
    execute = function()
        Balatest.play_hand { '2S' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].ability.extra.flipped)
    end
}
Balatest.TestPlay {
    name = 'weerewolf_front_does_not_flip',
    category = { 'jokers', 'weerewolf' },

    jokers = { 'j_Bakery_Weerewolf' },
    execute = function()
        Balatest.discard { '3S' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(not G.jokers.cards[1].ability.extra.flipped)
    end
}
Balatest.TestPlay {
    name = 'weerewolf_back',
    category = { 'jokers', 'weerewolf' },

    jokers = { 'j_Bakery_Weerewolf' },
    execute = function()
        Balatest.play_hand { '2S' }
        Balatest.next_round()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'weerewolf_back_does_not_flip',
    category = { 'jokers', 'weerewolf' },

    jokers = { 'j_Bakery_Weerewolf' },
    execute = function()
        Balatest.play_hand { '2S' }
        Balatest.next_round()
        Balatest.play_hand { '2S' }
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(G.jokers.cards[1].ability.extra.flipped)
    end
}
Balatest.TestPlay {
    name = 'weerewolf_back_flips',
    category = { 'jokers', 'weerewolf' },

    jokers = { 'j_Bakery_Weerewolf' },
    execute = function()
        Balatest.play_hand { '2S' }
        Balatest.next_round()
        Balatest.end_round()
    end,
    assert = function()
        Balatest.assert(not G.jokers.cards[1].ability.extra.flipped)
    end
}
--#endregion

--#region Lua Joker
Balatest.TestPlay {
    name = 'lua_joker_small',
    category = { 'jokers', 'lua_joker', 'talisman' },

    jokers = { 'j_joker', 'j_Bakery_Lua' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(84)
    end
}
Balatest.TestPlay {
    name = 'lua_joker_fractional',
    category = { 'jokers', 'lua_joker', 'talisman' },

    jokers = { 'j_Bakery_Lua' },
    execute = function()
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(1) -- 1.54 but the game rounds
    end
}
Balatest.TestPlay {
    name = 'lua_joker_thousands',
    category = { 'jokers', 'lua_joker', 'talisman' },

    jokers = { 'j_joker', 'j_Bakery_Lua' },
    execute = function()
        G.jokers.cards[1].ability.mult = 4999
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(70014)
    end
}
Balatest.TestPlay {
    name = 'lua_joker_e',
    category = { 'jokers', 'lua_joker', 'talisman' },

    jokers = { 'j_joker', 'j_Bakery_Lua' },
    execute = function()
        G.jokers.cards[1].ability.mult = 5e15 - 1
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(7 * 1e152) -- Explicitly spell this multiplication to avoid precision issues
    end
}
if Talisman then
    Balatest.TestPlay {
        name = 'lua_joker_talisman_ee',
        category = { 'jokers', 'lua_joker', 'talisman' },

        jokers = { 'j_joker', 'j_Bakery_Lua' },
        execute = function()
            G.jokers.cards[1].ability.mult = Big:parse 'e1e62'
            Balatest.play_hand { '2S' }
        end,
        assert = function()
            Balatest.assert_chips(Big:parse 'e1e622')
        end
    }
    Balatest.TestPlay {
        name = 'lua_joker_talisman_#',
        category = { 'jokers', 'lua_joker', 'talisman' },

        jokers = { 'j_joker', 'j_Bakery_Lua' },
        execute = function()
            G.jokers.cards[1].ability.mult = Bakery_API.parse_hyper_e 'e10#62'
            Balatest.play_hand { '2S' }
        end,
        assert = function()
            Balatest.assert_chips(Bakery_API.parse_hyper_e 'e10#622')
        end
    }
    Balatest.TestPlay {
        name = 'lua_joker_talisman_##',
        category = { 'jokers', 'lua_joker', 'talisman' },

        jokers = { 'j_joker', 'j_Bakery_Lua' },
        execute = function()
            G.jokers.cards[1].ability.mult = Bakery_API.parse_hyper_e 'e10#10##62'
            Balatest.play_hand { '2S' }
        end,
        assert = function()
            Balatest.assert_chips(Bakery_API.parse_hyper_e 'e10#10##622')
        end
    }
end
--#endregion
