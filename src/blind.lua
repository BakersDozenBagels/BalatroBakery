SMODS.Atlas {
    key = "BakeryBlinds",
    path = "BakeryBlinds.png",
    px = 34,
    py = 34,
    atlas_table = 'ANIMATION_ATLAS',
    frames = 21
}

SMODS.Blind {
    key = "Aleph", -- The Leader
    atlas = "BakeryBlinds",
    boss = {
        min = 3,
        max = 0
    },
    boss_colour = HEX('a9e74b'),
    -- -1 Hand, -1 Discard
    set_blind = function(self)
        ease_discard(-1)
        ease_hands_played(-1)
    end,
    disable = function(self)
        ease_discard(1)
        ease_hands_played(1)
    end
}

SMODS.Blind {
    key = "Tsadi", -- The Attrition
    atlas = "BakeryBlinds",
    pos = {
        y = 1
    },
    boss = {
        min = 3,
        max = 0
    },
    boss_colour = HEX('ff004b'),
    -- -(Ante*5) Mult before scoring
    config = {
        extra = {
            scale = 5
        }
    },
    collection_loc_vars = function(self)
        return {
            vars = { localize {
                type = 'variable',
                key = 'b_Bakery_ante_times',
                vars = { self.config.extra.scale }
            } }
        }
    end,
    loc_vars = function(self)
        return {
            vars = { G.GAME.round_resets.ante * self.config.extra.scale }
        }
    end,
    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        return mult - (G.GAME.round_resets.ante * self.config.extra.scale), hand_chips, true
    end
}

local raw_SMODS_never_scores = SMODS.never_scores
function SMODS.never_scores(card)
    if G.GAME.blind.config.blind.key == "bl_Bakery_He" and not G.GAME.blind.disabled and G.play.cards[1] then
        local max = 1
        local max_rank = G.play.cards[1].base.nominal
        for i = 2, #G.play.cards do
            if G.play.cards[i].base.nominal > max_rank then
                max = i
                max_rank = G.play.cards[i].base.nominal
            end
        end
        if card ~= G.play.cards[max] then
            return true
        end
    end
    return raw_SMODS_never_scores(card)
end

sendInfoMessage("SMODS.never_scores() patched. Reason: The Solo Boss Blind", "Bakery")

SMODS.Blind {
    key = "He", -- The Solo
    atlas = "BakeryBlinds",
    pos = {
        y = 2
    },
    boss = {
        min = 3,
        max = 0
    },
    boss_colour = HEX('ffd78e')
    -- Only one card scores
}

SMODS.Blind {
    key = "Qof", -- The Witch
    atlas = "BakeryBlinds",
    pos = {
        y = 3
    },
    boss = {
        min = 2,
        max = 0
    },
    boss_colour = HEX('e9b4ff'),
    -- Adds (Ante) curses to your deck
    collection_loc_vars = function(self)
        return { vars = { localize 'b_Bakery_ante' } }
    end,
    loc_vars = function(self)
        return { vars = { G.GAME.round_resets.ante } }
    end,
    set_blind = function(self)
        local cards = {}
        for _ = 1, G.GAME.round_resets.ante do
            local front = pseudorandom_element(G.P_CARDS, pseudoseed('bl_Bakery_Qof'))
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            local card = Card(G.discard.T.x + G.discard.T.w / 2, G.discard.T.y, G.CARD_W, G.CARD_H, front,
                G.P_CENTERS.m_Bakery_Curse, { playing_card = G.playing_card })
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:start_materialize({ G.C.SECONDARY_SET.Enhanced })
                    G.play:emplace(card)
                    table.insert(G.playing_cards, card)
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    return true
                end
            }))
            cards[#cards + 1] = card
        end

        for i = 1, G.GAME.round_resets.ante do
            draw_card(G.play, G.deck, 90 + i, 'up', nil)
        end
        playing_card_joker_effects(cards)
    end,
    disable = function(self)
        local done = 0
        for i = 1, #G.deck.cards do
            if G.deck.cards[i].config.center.key == 'm_Bakery_Curse' then
                local card = G.deck.cards[i]
                G.E_MANAGER:add_event(Event {
                    func = function()
                        card:start_dissolve()
                        return true
                    end
                })
                done = done + 1
                if done >= G.GAME.round_resets.ante then
                    return
                end
            end
        end
    end
}

SMODS.Blind {
    key = "Kaf", -- The Build
    atlas = "BakeryBlinds",
    pos = {
        y = 4
    },
    boss = {
        min = 2,
        max = 0
    },
    boss_colour = HEX('93a9ff'),
    -- No base chips
    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        return mult, 0, hand_chips ~= 0
    end
}

Bakery_API.credit(SMODS.Blind {
    key = "Samekh", -- The Ruler
    atlas = "BakeryBlinds",
    pos = {
        y = 5
    },
    boss = {
        min = 3,
        max = 0
    },
    boss_colour = HEX('eaba23'),
    artist = 'Jack5',
    coder = 'Jack5',
    idea = 'Jack5',
    -- Cards with no rank or suit are debuffed
    recalc_debuff = function(self, card, from_blind)
        return
            not G.GAME.blind.disabled and
            card.area ~= G.jokers and
            card.area ~= G.Bakery_charm_area and
            (SMODS.has_no_rank(card) or SMODS.has_no_suit(card))
    end,
    -- Only appears if 1 in 6 cards have no rank or suit
    in_pool = function()
        if not G.playing_cards then return false end
        local count = 0
        for i = 1, #G.playing_cards do
            if SMODS.has_no_rank(G.playing_cards[i]) or SMODS.has_no_suit(G.playing_cards[i]) then
                count = count + 1
                if count >= #G.playing_cards / 6 then
                    return true
                end
            end
        end
        return false
    end
})

sendInfoMessage("Blind:set_blind() patched. Reason: Allow Charms to be debuffed", "Bakery")

Bakery_API.credit(SMODS.Blind {
    key = "Lammed", -- The Stoic
    atlas = "BakeryBlinds",
    pos = {
        y = 6
    },
    boss = {
        min = 3,
        max = 0
    },
    boss_colour = HEX('5a6159'),
    artist = 'Jack5',
    coder = 'Jack5',
    idea = 'Jack5',
    -- Charm is debuffed
    set_blind = function(self)
        if G.GAME.Bakery_charm then
            G.P_CENTERS[G.GAME.Bakery_charm]:unequip(G.Bakery_charm_area.cards[1])
            G.GAME.Bakery_charm = nil
        end
    end,
    disable = function(self)
        if G.Bakery_charm_area and #G.Bakery_charm_area.cards == 1 and not G.GAME.Bakery_charm then
            G.GAME.Bakery_charm = G.Bakery_charm_area.cards[1].config.center.key
            G.P_CENTERS[G.GAME.Bakery_charm]:equip(G.Bakery_charm_area.cards[1])
            SMODS.recalc_debuff(G.Bakery_charm_area.cards[1])
        end
    end,
    defeat = function(self)
        self:disable()
    end,
    recalc_debuff = function(self, card, from_blind)
        return not G.GAME.blind.disabled and card.area == G.Bakery_charm_area
    end
})
