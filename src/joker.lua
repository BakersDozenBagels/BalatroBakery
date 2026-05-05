SMODS.Atlas {
    key = "Bakery",
    path = "Bakery.png",
    px = 71,
    py = 95
}

-- KEEP_LITE
Bakery_API.guard(function()
    local resets = {}

    function Bakery_API.Joker(o)
        o.name = o.name or o.key
        o.atlas = o.atlas or 'Bakery'
        o.pos = o.pos or {
            x = 0.5,
            y = 0.5
        }
        if o.reset_game_globals then
            resets[#resets + 1] = o.reset_game_globals
        end
        return Bakery_API.credit(SMODS.Joker(o))
    end

    function SMODS.current_mod.reset_game_globals(...)
        for _, f in ipairs(resets) do
            f(...)
        end
    end
end)
-- END_KEEP_LITE

Bakery_API.Joker {
    key = "Tarmogoyf",
    pos = {
        x = 0,
        y = 0
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {
        extra = {
            mult = 0,
            mult_gain = 2,
            used_ranks = {}
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult_gain, card.ability.extra.mult }
        }
    end,
    calculate = function(self, card, context)
        if context.discard and not context.blueprint and not context.retrigger_joker and not context.other_card.debuff then
            local rank = context.other_card:get_id()
            if rank > 0 -- Stone cards are random negative ranks
                and card.ability.extra.used_ranks[rank] == nil then
                card.ability.extra.used_ranks[rank] = true
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                return {
                    message = '+' .. (card.ability.extra.mult_gain),
                    colour = G.C.RED,
                    card = card
                }
            end
        end

        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                mult_mod = card.ability.extra.mult,
                message = localize {
                    type = 'variable',
                    key = 'a_mult',
                    vars = { card.ability.extra.mult },
                    card = card
                }
            }
        end

        if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
            local flag = card.ability.extra.mult ~= 0
            card.ability.extra.mult = 0
            card.ability.extra.used_ranks = {}
            if flag then
                return {
                    message = 'Reset',
                    colour = G.C.RED,
                    card = card
                }
            end
        end
    end
}

Bakery_API.Joker {
    key = "Auctioneer",
    pos = {
        x = 1,
        y = 0
    },
    rarity = 2,
    cost = 3,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    config = {
        extra = {
            scale = 3
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.scale }
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    my_pos = i;
                    break
                end
            end
            if my_pos and G.jokers.cards[my_pos + 1] and not G.jokers.cards[my_pos + 1].ability.eternal and
                not G.jokers.cards[my_pos + 1].getting_sliced then
                local sliced_card = G.jokers.cards[my_pos + 1]
                sliced_card.getting_sliced = true

                sliced_card.sell_cost = sliced_card.sell_cost * card.ability.extra.scale
                sliced_card:sell_card()
            end
        end
    end
}

Bakery_API.Joker {
    key = "Don",
    pos = {
        x = 2,
        y = 0
    },
    rarity = 3,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {
        extra = {
            x_mult = 3,
            cost = 3
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.x_mult, card.ability.extra.cost }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.x_mult,
                dollars = -card.ability.extra.cost
            }
        end
    end
}

Bakery_API.Joker {
    key = "Werewolf",
    rarity = 3,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    artist = "SadCube",
    config = {
        extra = {
            front = 2,
            back = 3,
            flipped = false,
            discards = 0,
            front_pos = {
                x = 3,
                y = 0
            },
            back_pos = {
                x = 4,
                y = 0
            }
        }
    },
    loc_vars = function(self, info_queue, card)
        if not self or not card or not card.ability or not card.ability.extra then
            return {
                vars = {}
            }
        end
        return {
            vars = { self.key == "j_Bakery_Werewolf_Back" and card.ability.extra.back or card.ability.extra.front }
        }
    end,
    generate_ui = Bakery_API.werewolf_ui 'j_Bakery_Werewolf_Back',
    calculate = function(self, card, context)
        if context.pre_discard and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.discards = card.ability.extra.discards + 1
        end

        if context.joker_main then
            return {
                x_mult = card.ability.extra.flipped and card.ability.extra.back or card.ability.extra.front
            }
        end

        if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
            if (card.ability.extra.flipped and card.ability.extra.discards >= 2) or
                (not card.ability.extra.flipped and card.ability.extra.discards == 0) then
                Bakery_API.flip_double_sided(card)
            end
            card.ability.extra.discards = 0
        end
    end
}

local j_spinner = Bakery_API.Joker {
    key = "Spinner",
    pos = {
        x = 5,
        y = 0
    },
    pixel_size = {
        w = 71,
        h = 71
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {
        extra = {
            effect = {
                [0] = {
                    mult = 20
                },
                [1] = {
                    chips = 50
                },
                [2] = {
                    x_mult = 2
                },
                [3] = {}
            },
            dollars = { 0, 0, 0, 5 }
        }
    },
    calculate = function(self, card, context)
        if context.joker_main then
            return card.ability.extra.effect[math.floor(card.ability.extra.rotation or 0) % 4]
        end

        if context.Bakery_after_eval then
            G.E_MANAGER:add_event(Event {
                trigger = 'before',
                delay = 0.2,
                func = function()
                    play_sound('tarot1')
                    card:juice_up(0.3, 0.3)
                    card.ability.extra.rotation = math.floor(card.ability.extra.rotation or 0) + 1
                    return true
                end
            })
        end
    end,
    calc_dollar_bonus = function(self, card)
        local dollars = card.ability.extra.dollars[math.floor(card.ability.extra.rotation or 0) % 4 + 1]
        if dollars > 0 then
            return dollars
        end
    end,
    set_ability = function(self, joker)
        joker.ability.extra.rotation = math.floor(joker.ability.extra.rotation or
            pseudorandom(pseudoseed("Spinner"), 0, 3))
    end
}

local raw_Card_set_sprites = Card.set_sprites
function Card:set_sprites(center, front)
    raw_Card_set_sprites(self, center, front)
    if center == j_spinner and (center.discovered or self.params.bypass_discovery_center) then
        self.children.center.role.r_bond = 'Weak'
        self.children.center.role.role_type = 'Major'
        local t = self.T
        self.children.center.T = setmetatable({}, {
            __index = function(_, k)
                if k == "r" then
                    return math.rad((self.ability and self.ability.extra.rotation or 0) * 90)
                end
                return t[k]
            end,
            __newindex = function(_, k, v)
                t[k] = v
            end
        })
    end
end

sendInfoMessage("Card:set_sprites() patched. Reason: Spinner Loading", "Bakery")

function Bakery_API.get_proxied_joker()
    if G.jokers and G.jokers.cards then
        local other_joker = nil
        local latest = -1
        for _, other in pairs(G.jokers.cards) do
            if other.config.center ~= G.P_CENTERS.j_Bakery_Proxy and other.ability.Bakery_purchase_index and
                other.ability.Bakery_purchase_index > latest and other.config.center.blueprint_compat then
                latest = other.ability.Bakery_purchase_index
                other_joker = other
            end
        end
        return other_joker
    end
end

Bakery_API.Joker {
    key = "Proxy",
    pos = {
        x = 0,
        y = 1
    },
    rarity = 3,
    cost = 9,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    config = {
        extra = {}
    },
    loc_vars = function(self, info_queue, card)
        local other_joker = Bakery_API.get_proxied_joker()

        return {
            vars = { other_joker and (localize {
                type = 'name_text',
                set = other_joker.config.center.set,
                key = other_joker.config.center.key
            }) or localize('k_none') }
        }
    end,
    locked_loc_vars = function(self, card)
        return {
            vars = { G.P_CENTERS['j_blueprint'].discovered and localize {
                type = 'name_text',
                key = 'j_blueprint',
                set = "Joker"
            } or localize('k_unknown'), G.P_CENTERS['j_brainstorm'].discovered and localize {
                type = 'name_text',
                key = 'j_brainstorm',
                set = "Joker"
            } or localize('k_unknown') }
        }
    end,
    check_for_unlock = function(self, args)
        if not G.jokers or not G.jokers.cards then
            return false
        end
        local print = false
        local storm = false
        for _, other in pairs(G.jokers.cards) do
            if other.config.center.key == 'j_blueprint' then
                print = true
            end
            if other.config.center.key == 'j_brainstorm' then
                storm = true
            end
        end
        return print and storm
    end,
    calculate = function(self, card, context)
        local other_joker = Bakery_API.get_proxied_joker()
        return SMODS.blueprint_effect(card, other_joker, context)
    end
}

Bakery_API.Joker {
    key = "StickerSheet",
    pos = {
        x = 1,
        y = 1
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    config = {
        extra = {
            x_mult = 1.5
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.x_mult }
        }
    end,
    check_for_unlock = function(self, args)
        if not G.jokers or not G.jokers.cards then
            return false
        end
        for _, other in pairs(G.jokers.cards) do
            if other.ability.eternal and other.ability.rental then
                return true
            end
        end
        return false
    end,
    calculate = function(self, card, context)
        if context.other_joker then
            local sticker_count = 0
            for k, v in ipairs(SMODS.Sticker.obj_buffer) do
                if context.other_joker.ability[v] then
                    sticker_count = sticker_count + 1
                end
            end
            if sticker_count > 0 then
                local m = math.pow(card.ability.extra.x_mult, sticker_count)
                G.E_MANAGER:add_event(Event {
                    func = function()
                        context.other_joker:juice_up(0.5, 0.5)
                        return true
                    end
                })
                return {
                    message = localize {
                        type = 'variable',
                        key = 'a_xmult',
                        vars = { m }
                    },
                    Xmult_mod = m
                }
            end
        end
    end,
    in_pool = function(self, args)
        return G.GAME.stake >= 4
    end
}

local function num(x)
    return type(x) == "table" and x:to_number() or x
end
Bakery_API.Joker {
    key = "PlayingCard",
    pos = {
        x = 2,
        y = 1
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    config = {
        extra = {
            unlock_level = 20
        }
    },
    locked_loc_vars = function(self, card)
        return {
            vars = { self.config.extra.unlock_level }
        }
    end,
    check_for_unlock = function(self, args)
        return Bakery_API.big(G.GAME.hands["High Card"].level) >= Bakery_API.big(self.config.extra.unlock_level)
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = num(G.GAME.hands["High Card"].mult),
                chips = num(G.GAME.hands["High Card"].chips)
            }
        end
    end
}
Bakery_API.Joker {
    key = "PlayingCard11",
    pos = {
        x = 3,
        y = 1
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    config = {
        extra = {
            unlock_level = 20
        }
    },
    locked_loc_vars = function(self, card)
        return {
            vars = { self.config.extra.unlock_level }
        }
    end,
    check_for_unlock = function(self, args)
        return Bakery_API.big(G.GAME.hands["Pair"].level) >= Bakery_API.big(self.config.extra.unlock_level)
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = num(G.GAME.hands["Pair"].mult),
                chips = num(G.GAME.hands["Pair"].chips)
            }
        end
    end
}

local parity = {
    ["A"] = "odd",
    ["Ace"] = "odd",
    ["1"] = "odd",
    ["2"] = "even",
    ["3"] = "odd",
    ["4"] = "even",
    ["5"] = "odd",
    ["6"] = "even",
    ["7"] = "odd",
    ["8"] = "even",
    ["9"] = "odd",
    ["10"] = "even",
    ["Jack"] = nil,
    ["Queen"] = nil,
    ["King"] = nil
}
Bakery_API.Joker {
    key = "EvilSteven",
    pos = {
        x = 4,
        y = 1
    },
    rarity = 3,
    cost = 6,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.destroy_card and context.cardarea == G.play then
            if not SMODS.has_no_rank(context.destroying_card) and parity[context.destroying_card.base.value] ==
                "even" then
                return {
                    remove = true
                }
            end
        end
    end
}
Bakery_API.Joker {
    key = "AwfulTodd",
    pos = {
        x = 5,
        y = 1
    },
    rarity = 3,
    cost = 6,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.destroy_card and context.cardarea == G.play then
            if not SMODS.has_no_rank(context.destroying_card) and parity[context.destroying_card.base.value] ==
                "odd" then
                return {
                    remove = true
                }
            end
        end
    end
}

SMODS.Atlas {
    key = "BakeryJokerAgainstHumanity",
    path = "BakeryJokerAgainstHumanity.png",
    px = 71,
    py = 95
}
Bakery_API.Joker {
    key = "JokerAgainstHumanity",
    atlas = 'BakeryJokerAgainstHumanity',
    pos = {
        x = 0,
        y = 0
    },
    rarity = 2,
    cost = 6,
    config = {
        extra = {
            mult = 0,
            mult_gain = 5
        }
    },
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult_gain, card.ability.extra.mult }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.mult
            }
        end

        if context.before and Bakery_API.big(G.GAME.hands[context.scoring_name].level) == Bakery_API.big(1) and
            not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            return {
                message = 'Upgraded!',
                colour = G.C.CHIPS,
                card = card
            }
        end
    end,
    set_sprites = function(self, card, front)
        if not self.discovered and not card.params.bypass_discovery_center then
            return
        end
        local c = card or {}
        c.ability = c.ability or {}
        -- The seeding is broken by visiting the collection, but whatever, it's only cosmetic
        c.ability.Bakery_x = c.ability.Bakery_x or pseudorandom(pseudoseed("JokerAgainstHumanity"), 0, 3)
        c.ability.Bakery_y = c.ability.Bakery_y or pseudorandom(pseudoseed("JokerAgainstHumanity"), 0, 3)
        if card and card.children and card.children.center and card.children.center.set_sprite_pos then
            card.children.center:set_sprite_pos({
                x = c.ability.Bakery_x,
                y = c.ability.Bakery_y
            })
        end
    end
}

-- KEEP_LITE
Bakery_API.load('sleeve')
-- END_KEEP_LITE

Bakery_API.Joker {
    key = "BongardProblem",
    pos = {
        x = 1,
        y = 2
    },
    rarity = 2,
    cost = 7,
    config = {
        extra = {
            xmult = 2
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.xmult }
        }
    end,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            if not SMODS.has_no_suit(context.scoring_hand[1]) and
                not SMODS.has_no_suit(context.scoring_hand[#context.scoring_hand]) and
                (SMODS.has_any_suit(context.scoring_hand[1]) or
                    SMODS.has_any_suit(context.scoring_hand[#context.scoring_hand]) or
                    not context.scoring_hand[1]:is_suit(context.scoring_hand[#context.scoring_hand].base.suit)) then
                return {
                    x_mult = card.ability.extra.xmult
                }
            end
        end
    end
}

Bakery_API.Joker {
    key = "CoinSlot",
    pos = {
        x = 2,
        y = 2
    },
    rarity = 2,
    cost = 1,
    config = {
        extra = {
            mult = 0,
            cost = 5,
            mult_gain = 3
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult_gain, card.ability.extra.cost, card.ability.extra.mult }
        }
    end,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    Bakery_can_use = function(self, card)
        return Bakery_API.default_can_use(card) and
            Bakery_API.big(card.ability.extra.cost) <= Bakery_API.big(G.GAME.dollars) +
            Bakery_API.big(G.GAME.dollar_buffer or 0) - Bakery_API.big(G.GAME.bankrupt_at)
    end,
    Bakery_use_joker = function(self, card)
        -- G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) - card.ability.extra.cost
        ease_dollars(-card.ability.extra.cost)
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
        card_eval_status_text(card, 'extra', nil, math.random(0, 100), nil, {
            mult_mod = true,
            message = localize {
                type = 'variable',
                key = 'a_mult',
                vars = { card.ability.extra.mult }
            }
        })
        -- G.E_MANAGER:add_event(Event({
        --     func = (function()
        --         G.GAME.dollar_buffer = G.GAME.dollar_buffer + card.ability.extra.cost
        --         return true
        --     end)
        -- }))
        Bakery_API.rehighlight(card)
    end,
    Bakery_use_button_text = function(self, card)
        return localize {
            type = 'variable',
            key = 'b_Bakery_deposit',
            vars = { card.ability.extra.cost }
        }
    end
}

Bakery_API.Joker {
    key = "Pyrite",
    pos = {
        x = 3,
        y = 2
    },
    rarity = 1,
    cost = 5,
    config = {
        extra = {
            cards = 3
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.cards }
        }
    end,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            juice_card(context.blueprint_card or card)
            for i = 1, card.ability.extra.cards do
                draw_card(G.deck, G.hand, i * 100 / card.ability.extra.cards, 'up', true)
            end
        end
    end
}

Bakery_API.Joker {
    key = "Snowball",
    pos = {
        x = 4,
        y = 2
    },
    artist = "SadCube",
    rarity = 3,
    cost = 8,
    config = {
        extra = {
            chips = 0,
            chips_gain = 30
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.chips_gain, card.ability.extra.chips }
        }
    end,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return { chips = card.ability.extra.chips }
        end
        if context.setting_blind and not context.blueprint and not card.getting_sliced then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
            G.E_MANAGER:add_event(Event({
                func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize {
                            type = 'variable',
                            key = 'a_chips',
                            vars = { card.ability.extra.chips }
                        }
                    });
                    return true
                end
            }))
            return nil, true
        end
    end
}

Bakery_API.Joker {
    key = "GetOutOfJailFreeCard",
    pos = {
        x = 5,
        y = 2
    },
    artist = "GhostSalt",
    rarity = 2,
    cost = 7,
    config = {
        extra = {
            used = false,
            xmult = 5
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.xmult }
        }
    end,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.used then
            return {
                x_mult = card.ability.extra.xmult,
                func = function()
                    G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                    G.E_MANAGER:add_event(Event {
                        trigger = 'before',
                        delay = 1.12,
                        func = function()
                            G.GAME.joker_buffer = 0
                            card:juice_up(0.8, 0.8)
                            card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                            return true
                        end
                    })
                end
            }
        end
    end,
    Bakery_can_use = function(self, card)
        return Bakery_API.default_can_use(card) and not card.ability.extra.used
    end,
    Bakery_use_joker = function(self, card)
        card.ability.extra.used = true
        juice_card_until(card, function()
            return true
        end)
        Bakery_API.rehighlight(card)
    end
}

-- KEEP_LITE
Bakery_API.guard(function()
    Bakery_API.black_suits = { "Spades", "Clubs" }
    Bakery_API.red_suits = { "Hearts", "Diamonds" }
    function Bakery_API.is_any_suit(card, suits)
        for _, s in pairs(suits) do
            if card:is_suit(s) then
                return true
            end
        end
        return false
    end

    function Bakery_API.alternates_suits(hand, first, second)
        if not first then
            return Bakery_API.alternates_suits(hand, Bakery_API.red_suits, Bakery_API.black_suits) or
                Bakery_API.alternates_suits(hand, Bakery_API.black_suits, Bakery_API.red_suits)
        end

        for i = 1, #hand, 2 do
            if not Bakery_API.is_any_suit(hand[i], first) then
                return false
            end
        end

        for i = 2, #hand, 2 do
            if not Bakery_API.is_any_suit(hand[i], second) then
                return false
            end
        end

        return true
    end
end)
-- END_KEEP_LITE
Bakery_API.Joker {
    key = "TransparentBackBuffer",
    pos = {
        x = 0,
        y = 3
    },
    rarity = 1,
    cost = 4,
    config = {
        extra = {
            mult = 6
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult }
        }
    end,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            local hand = context.scoring_hand
            if Bakery_API.alternates_suits(context.scoring_hand) then
                return {
                    mult = card.ability.extra.mult * #context.scoring_hand
                }
            end
        end
    end
}

-- KEEP_LITE
Bakery_API.guard(function()
    Bakery_API.rarities = {
        Common = 1,
        Uncommon = 2,
        Rare = 3,
        Legendary = 4
    }
    function Bakery_API.count_rarities()
        if not G.jokers then
            return 0
        end
        local count = 0
        local rarities = {}
        for _, v in ipairs(G.jokers.cards) do
            local rarity = Bakery_API.rarities[v.config.center.rarity] or v.config.center.rarity
            if not rarities[rarity] then
                rarities[rarity] = true
                count = count + 1
            end
        end
        return count
    end
end)
-- END_KEEP_LITE
Bakery_API.Joker {
    key = "TierList",
    pos = {
        x = 1,
        y = 3
    },
    rarity = 3,
    cost = 8,
    config = {
        extra = {
            xmult = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.xmult, Bakery_API.count_rarities() * card.ability.extra.xmult }
        }
    end,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = Bakery_API.count_rarities() * card.ability.extra.xmult
            }
        end
    end
}

Bakery_API.Joker {
    key = "Tag",
    -- atlas = "tags",
    -- prefix_config = {
    --     atlas = false
    -- },
    pos = {
        x = 2,
        y = 3
    },
    pixel_size = {
        w = 34,
        h = 34
    },
    rarity = 2,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {
        extra = {
            x_mult = 2
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.x_mult }
        }
    end,
    calculate = function(self, card, context)
        if context.Bakery_calculate_tags_late and not self.debuffed then
            return {
                x_mult = card.ability.extra.x_mult
            }
        end
    end
}

Bakery_API.Joker {
    key = "GlassCannon",
    pos = {
        x = 3,
        y = 3
    },
    rarity = 2,
    cost = 9,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    config = {
        extra = {
            x_mult = 3,
            limit = 100
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.x_mult, card.ability.extra.limit }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main and not card.shattered then
            SMODS.calculate_effect({
                x_mult = card.ability.extra.x_mult
            }, card)
            if Bakery_API.big(mult) >= Bakery_API.big(card.ability.extra.limit) and not context.blueprint then
                G.E_MANAGER:add_event(Event {
                    trigger = 'before',
                    delay = 0.4,
                    func = function()
                        card:shatter()
                        return true
                    end
                })
                return {
                    message = localize('b_Bakery_shattered'),
                    colour = G.C.RED
                }
            end
            return {}, true
        end
    end
}

local raw_Card_start_dissolve = Card.start_dissolve
function Card:start_dissolve()
    if self.config.center.key == "j_Bakery_GlassCannon" then
        self:shatter()
    else
        raw_Card_start_dissolve(self)
    end
end

sendInfoMessage("Card:start_dissolve() patched. Reason: Glass Cannon shatters", "Bakery")

local function has_straight(cards, len)
    return next(get_straight(cards, len, SMODS.shortcut(), SMODS.wrap_around_straight()))
end

Bakery_API.Joker {
    key = '3So',
    pos = {
        x = 4,
        y = 3
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    config = {
        extra = {
            mult = 0,
            d_mult = 2,
            len = 3
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.d_mult, card.ability.extra.len, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and has_straight(context.scoring_hand, card.ability.extra.len) then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.d_mult
            return {
                message = '+' .. (card.ability.extra.d_mult),
                colour = G.C.RED,
                card = card
            }
        end

        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

Bakery_API.Joker {
    key = "Weerewolf",
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    artist = "SadCube",
    config = {
        extra = {
            flipped = false,
            twos = false,
            mult = 2,
            x_mult = 2,
            front_pos = {
                x = 3,
                y = 0
            },
            back_pos = {
                x = 4,
                y = 0
            }
        }
    },
    display_size = { h = 95 * 0.7, w = 71 * 0.7 },
    loc_vars = function(self, info_queue, card)
        if not self or not card or not card.ability or not card.ability.extra then
            return {
                vars = {}
            }
        end
        return {
            vars = { self.key == "j_Bakery_Weerewolf_Back" and card.ability.extra.x_mult or card.ability.extra.mult }
        }
    end,
    generate_ui = Bakery_API.werewolf_ui 'j_Bakery_Weerewolf_Back',
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 2 and not context.blueprint then
            card.ability.extra.twos = true
        end

        if context.joker_main then
            return card.ability.extra.flipped and
                { x_mult = card.ability.extra.x_mult } or
                { mult = card.ability.extra.mult }
        end

        if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
            if card.ability.extra.flipped ~= card.ability.extra.twos then
                Bakery_API.flip_double_sided(card)
            end
            card.ability.extra.twos = false
        end
    end
}

-- KEEP_LITE
-- from http://lua-users.org/wiki/SplitJoin
local function Split(str, delim)
    if string.find(str, delim) == nil then return { str } end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gfind(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
    end
    result[nb + 1] = string.sub(str, lastPos)
    return result
end

local MAX_NUM

function Bakery_API.parse_hyper_e(num)
    local split_array = num:sub(2)
    local arr = {}
    local current_run = 0
    local i = 1
    for _, str in ipairs(Split(split_array, "#")) do
        current_run = current_run + 1
        if #str ~= 0 then
            local val = tonumber(str)
            if current_run == 1 then
                if i > 2 then val = val - 1 end
                arr[i] = val
            elseif current_run == 2 then
                local last = arr[i - 1]
                for _ = 1, val do
                    arr[i] = last
                    i = i + 1
                end
            else
                -- Triple hash is unsupported. Bail.
                return MAX_NUM, true
            end
            current_run = 0
            i = i + 1
            if i > 10010 then
                -- Number is too big to fit in memory. Bail.
                return MAX_NUM, true
            end
        end
    end
    return Big:new(arr)
end

if Big then
    MAX_NUM = Bakery_API.parse_hyper_e("e10#10##10000")
end
-- END_KEEP_LITE

Bakery_API.Joker {
    key = "Lua",
    rarity = 2,
    cost = 8,
    pos = {
        x = 5,
        y = 3
    },
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {
        extra = {
            x_mult = 0.2,
            concat_mult = "2",
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.concat_mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                func = function()
                    -- Prevent crash for huge numbers with Amulet
                    if not number_format(mult):find("#") then
                        mult = mult * card.ability.extra.x_mult
                    end
                    update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
                    card_eval_status_text(
                        card, 'x_mult', card.ability.extra.x_mult, percent
                    )
                    local too_big
                    if type(mult) == 'table' and (
                            (mult.isFinite and not mult:isFinite())
                            or (mult.is_naneinf and mult:is_naneinf())
                        ) then
                        too_big = true
                    else
                        mult = number_format(mult):gsub(",", "") .. card.ability.extra.concat_mult
                        if Talisman then
                            if mult:find("#") then
                                mult, too_big = Bakery_API.parse_hyper_e(mult)
                            else
                                mult = Big:parse(mult)
                            end
                        else
                            mult = tonumber(mult)
                        end
                        mult = mod_mult(mult)
                    end

                    update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
                    if too_big then
                        card_eval_status_text(card, 'extra', card.ability.extra.concat_mult, percent, nil,
                            { XMult_mod = true, message = '!?' })
                    else
                        card_eval_status_text(card, 'extra', card.ability.extra.concat_mult, percent, nil,
                            { XMult_mod = true, message = '.."' .. card.ability.extra.concat_mult .. '"' })
                    end
                end
            }
        end
    end
}

Bakery_API.Joker {
    key = "Awarewolf",
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    artist = "SadCube",
    config = {
        h_size = 1,
        extra = {
            flipped = false,
            discards = 0,
            hands = 1,
            back_hands = 2,
            front_pos = {
                x = 0,
                y = 4
            },
            back_pos = {
                x = 1,
                y = 4
            }
        }
    },
    loc_vars = function(self, info_queue, card)
        if not self or not card or not card.ability or not card.ability.extra then
            return { vars = {} }
        end
        return {
            vars = { self.key == "j_Bakery_Awarewolf_Back" and card.ability.extra.back_hands or card.ability.extra.hands }
        }
    end,
    generate_ui = Bakery_API.werewolf_ui 'j_Bakery_Awarewolf_Back',
    calculate = function(self, card, context)
        if context.pre_discard and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.discards = card.ability.extra.discards + 1
        end

        if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
            if (card.ability.extra.flipped and card.ability.extra.discards >= 2) or
                (not card.ability.extra.flipped and card.ability.extra.discards == 0) then
                Bakery_API.flip_double_sided(card)
            end
            card.ability.extra.discards = 0
        end
    end,
    on_flip = function(self, card, to_back)
        local old_h = card.ability.h_size
        card.ability.h_size = to_back and card.ability.extra.back_hands or card.ability.extra.hands
        if card.area == G.jokers and not card.debuffed then
            G.hand:change_size(-old_h + card.ability.h_size)
        end
    end
}

Bakery_API.Joker {
    key = "Warewolf",
    rarity = 2,
    cost = 7,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    artist = "GhostSalt",
    config = {
        extra = {
            flipped = false,
            dollars = 8,
            front_pos = {
                x = 2,
                y = 4
            },
            back_pos = {
                x = 3,
                y = 4
            }
        }
    },
    loc_vars = function(self, info_queue, card)
        if not self or not card or not card.ability or not card.ability.extra then
            return { vars = {} }
        end
        return {
            vars = { self.key == "j_Bakery_Warewolf_Back" and card.ability.extra.dollars or nil }
        }
    end,
    generate_ui = Bakery_API.werewolf_ui 'j_Bakery_Warewolf_Back',
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint then
            if not card.ability.extra.flipped then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil,
                                        'j_Bakery_Warewolf')
                                    card:add_to_deck()
                                    G.consumeables:emplace(card)
                                    G.GAME.consumeable_buffer = 0
                                    return true
                                end
                            }))
                            card_eval_status_text(card, 'extra', nil, nil, nil,
                                { message = localize('k_plus_tarot'), colour = G.C.PURPLE })
                            return true
                        end)
                    }))
                    return nil, true
                else
                    Bakery_API.flip_double_sided(card)
                end
            else
                local destructible_cards = {}
                for i = 1, #G.consumeables.cards do
                    local cons = G.consumeables.cards[i]
                    if not SMODS.is_eternal(cons) and not cons.getting_sliced then
                        destructible_cards[#destructible_cards + 1] = cons
                    end
                end
                if #destructible_cards == 0 then
                    Bakery_API.flip_double_sided(card)
                else
                    local destroyed = pseudorandom_element(destructible_cards, pseudoseed('j_Bakery_Warewolf_Back'))
                    destroyed.getting_sliced = true
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card:juice_up(0.8, 0.8)
                            destroyed:start_dissolve({ G.C.RED }, nil, 1.6)
                            return true
                        end
                    }))
                    ease_dollars(card.ability.extra.dollars)
                end
            end
        end
    end
}

Bakery_API.Joker {
    key = "Wherewolf",
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {
        h_size = 1,
        extra = {
            flipped = false,
            played_cards = false,
            hands = 1,
            x_mult = 2,
            front_pos = {
                x = 4,
                y = 4
            },
            back_pos = {
                x = 5,
                y = 4
            }
        }
    },
    loc_vars = function(self, info_queue, card)
        local c_card = G.GAME.current_round.Bakery_Wherewolf_card or { rank = 'Ace', suit = 'Spades' }
        if not self or not card or not card.ability or not card.ability.extra then
            return { vars = { nil, localize(c_card.rank, 'ranks'), localize(c_card.suit, 'suits_plural'), colours = { G.C.SUITS.Spades } } }
        end
        return {
            vars = {
                card.ability.extra.hands,
                localize(c_card.rank, 'ranks'),
                localize(c_card.suit, 'suits_plural'),
                card.ability.extra.x_mult,
                colours = { G.C.SUITS[c_card.suit] }
            }
        }
    end,
    generate_ui = Bakery_API.werewolf_ui 'j_Bakery_Wherewolf_Back',
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            context.other_card:get_id() == G.GAME.current_round.Bakery_Wherewolf_card.id and
            context.other_card:is_suit(G.GAME.current_round.Bakery_Wherewolf_card.suit) then
            if not context.blueprint then card.ability.extra.played_cards = true end
            if not card.ability.extra.flipped and not card.ability.extra.flipping and not context.blueprint then
                Bakery_API.flip_double_sided(card)
                return nil, true
            elseif card.ability.extra.flipped or card.ability.extra.flipping then
                return { xmult = card.ability.extra.x_mult }
            end
        end

        if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
            if (card.ability.extra.flipped and not card.ability.extra.played_cards) then
                Bakery_API.flip_double_sided(card)
            end
            card.ability.extra.played_cards = false
        end
    end,
    on_flip = function(self, card, to_back)
        local old_h = card.ability.h_size
        card.ability.h_size = to_back and 0 or card.ability.extra.hands
        if card.area == G.jokers and not card.debuffed then
            G.hand:change_size(-old_h + card.ability.h_size)
        end
    end,
    reset_game_globals = function()
        G.GAME.current_round.Bakery_Wherewolf_card = { rank = 'Ace', suit = 'Spades' }
        local valid_idol_cards = {}
        for _, playing_card in ipairs(G.playing_cards) do
            if not SMODS.has_no_suit(playing_card) and not SMODS.has_no_rank(playing_card) then
                valid_idol_cards[#valid_idol_cards + 1] = playing_card
            end
        end
        local idol_card = pseudorandom_element(valid_idol_cards, 'Bakery_Wherewolf' .. G.GAME.round_resets.ante)
        if idol_card then
            G.GAME.current_round.Bakery_Wherewolf_card.rank = idol_card.base.value
            G.GAME.current_round.Bakery_Wherewolf_card.suit = idol_card.base.suit
            G.GAME.current_round.Bakery_Wherewolf_card.id = idol_card.base.id
        end
    end
}

Bakery_API.Joker {
    key = "Wearywolf",
    rarity = 2,
    cost = 5,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    config = {
        extra = {
            rounds = 3,
            rounds_remaining = 3,
            percent = 25,
            flipped = false,
            front_pos = {
                x = 0,
                y = 5
            },
            back_pos = {
                x = 1,
                y = 5
            }
        }
    },
    loc_vars = function(self, info_queue, card)
        if not self or not card or not card.ability or not card.ability.extra then
            return { vars = {} }
        end
        return {
            vars = {
                card.ability.extra.rounds,
                card.ability.extra.rounds_remaining,
                card.ability.extra.percent,
            }
        }
    end,
    generate_ui = Bakery_API.werewolf_ui 'j_Bakery_Wearywolf_Back',
    calculate = function(self, card, context)
        if context.end_of_round and not context.game_over and context.main_eval and not context.blueprint and not card.ability.extra.flipped then
            card.ability.extra.rounds_remaining = card.ability.extra.rounds_remaining - 1
            if card.ability.extra.rounds_remaining == 0 then
                Bakery_API.flip_double_sided(card)
            end
        end

        if context.end_of_round and context.game_over and context.main_eval and card.ability.extra.flipped and G.GAME.chips / G.GAME.blind.chips * 100 >= Bakery_API.big(card.ability.extra.percent) then
            Bakery_API.flip_double_sided(card)
            return {
                message = localize 'k_saved_ex',
                saved = 'ph_Bakery_Wearywolf',
                colour = G.C.RED
            }
        end
    end,
    on_flip = function(self, card, to_back)
        if to_back then
            card.ability.extra.rounds_remaining = card.ability.extra.rounds
        end
    end
}

Bakery_API.Joker {
    key = "Wearwolf",
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    config = {
        extra = {
            mult = 0,
            d_mult = 4,
            flipped = false,
            front_pos = {
                x = 2,
                y = 5,
            },
            back_pos = {
                x = 4,
                y = 5,
            }
        }
    },
    artist = 'Craw',
    pixel_size = {
        w = 95,
        h = 71
    },

    loc_vars = function(self, info_queue, card)
        if not self or not card or not card.ability or not card.ability.extra then
            return { vars = {} }
        end
        return {
            vars = {
                card.ability.extra.d_mult,
                localize('Two Pair', 'poker_hands'),
                card.ability.extra.mult
            }
        }
    end,
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local key = self.key
        if card and card.ability.extra.flipped then
            self.key = 'j_Bakery_Wearwolf_Back'
        end
        SMODS.Joker.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        info_queue[#info_queue + 1] = {
            generate_ui = function(_self, _info_queue, _card, _desc_nodes, _specific_vars, _full_UI_table)
                if not card or not card.ability.extra.flipped then
                    self.key = 'j_Bakery_Wearwolf_Back'
                end
                SMODS.Joker.generate_ui(self, _info_queue, card, _desc_nodes, _specific_vars, _full_UI_table)
                self.key = key
            end
        }
        self.key = key
    end,
    -- generate_ui = Bakery_API.werewolf_ui 'j_Bakery_Wearwolf_Back',

    calculate = function(self, card, context)
        if not card.ability.extra.flipped then
            if context.before and not context.blueprint then
                if next(context.poker_hands['Two Pair']) then
                    -- See note about SMODS Scaling Manipulation on the wiki
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.d_mult
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.RED
                    }
                else
                    Bakery_API.flip_double_sided(card)
                end
            end
        else
            if context.joker_main then
                if not context.blueprint and next(context.poker_hands['Two Pair']) then
                    Bakery_API.flip_double_sided(card)
                end
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end
}

local function estate_pos(card)
    if card.area ~= G.jokers and card.area.config.type ~= "title" then return 1 end
    for i, v in ipairs(card.area.cards) do
        if v == card then
            return i
        end
    end
    return 1
end

Bakery_API.Joker {
    key = "Estate",
    pos = {
        x = 0,
        y = 6
    },
    artist = "Jack5",
    coder = "Jack5",
    idea = "Jack5",
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {
        extra = {
            chips = 10,
            mult = 1,
        }
    },
    loc_vars = function(self, info_queue, card)
        local joker_count = estate_pos(card)
        return {
            vars = { card.ability.extra.chips * joker_count, card.ability.extra.mult * joker_count }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local joker_count = estate_pos(card)
            return {
                chips = card.ability.extra.chips * joker_count,
                mult = card.ability.extra.mult * joker_count
            }
        end
    end
}
