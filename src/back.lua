SMODS.Atlas {
    key = "BakeryBack",
    path = "BakeryBack.png",
    px = 71,
    py = 95
}

local b_violet = SMODS.Back {
    key = "Violet",
    name = "Violet",
    config = {
        extra = {
            x_mult = 2
        }
    },
    atlas = "BakeryBack",
    pos = {
        x = 0,
        y = 0
    },
    unlocked = false,
    discovered = false,
    check_for_unlock = function(self, args)
        return Bakery_API.defeated_blinds['bl_final_vessel'] > 0
    end,
    locked_loc_vars = function(self, args)
        if G.P_BLINDS['bl_final_vessel'].discovered then
            return {
                vars = { localize {
                    type = 'name_text',
                    key = 'bl_final_vessel',
                    set = "Blind"
                } }
            }
        end
        return {
            vars = { localize('k_unknown') }
        }
    end,
    loc_vars = function(self, info_queue, back)
        return {
            vars = { self.config.extra.x_mult }
        }
    end,
    calculate = function(self, back, args)
        if args.context == 'final_scoring_step' then
            args.mult = args.mult * self.config.extra.x_mult

            local skip = Talisman and Talisman.config_file and Talisman.config_file.disable_anims

            update_hand_text({
                delay = 0
            }, {
                mult = args.mult
            })
            if not skip then
                G.E_MANAGER:add_event(Event {
                    trigger = 'before',
                    delay = 0.8125,
                    func = function()
                        attention_text {
                            text = localize {
                                type = 'variable',
                                key = 'a_xmult',
                                vars = { self.config.extra.x_mult }
                            },
                            scale = 1.4,
                            hold = 2,
                            offset = {
                                x = 0,
                                y = -2.7
                            },
                            major = G.play
                        }
                        play_sound('multhit2', 0.845 + 0.04 * math.random(), 0.7)
                        G.ROOM.jiggle = G.ROOM.jiggle + 0.7
                        return true
                    end
                })
            end

            return args.chips, args.mult
        end
    end
}

local function is_double_house()
    return G.GAME.selected_sleeve == 'sleeve_Bakery_House' and
        ((G.GAME.selected_back_key and G.GAME.selected_back_key.key) or G.GAME.selected_back.key) ==
        'b_Bakery_House'
end
local b_house = SMODS.Back {
    key = "House",
    name = "House",
    config = {
        extra = {
            odds_bottom = 4
        }
    },
    atlas = "BakeryBack",
    pos = {
        x = 1,
        y = 0
    },
    unlocked = false,
    discovered = false,
    check_for_unlock = function(self, args)
        return get_deck_win_stake('b_erratic') > 0
    end,
    locked_loc_vars = function(self, back)
        if G.P_CENTERS['b_erratic'].discovered then
            return {
                vars = { localize {
                    type = 'name_text',
                    key = 'b_erratic',
                    set = "Back"
                } }
            }
        end
        return {
            vars = { localize('k_unknown') }
        }
    end,
    loc_vars = function(self)
        return {
            vars = { (G.GAME and G.GAME.probabilities.normal or 1) * (is_double_house() and 2 or 1),
                self.config.extra.odds_bottom }
        }
    end,
    calculate = function(self, back, args)
        if args.context == 'final_scoring_step' then
            local anim = {}

            local double = is_double_house()

            for i = 1, #G.play.cards do
                local choice = pseudorandom(pseudoseed("HouseDeck"), 0, self.config.extra.odds_bottom)
                if double then
                    choice = choice / 2
                end
                if choice <= (G.GAME and G.GAME.probabilities.normal or 1) then
                    table.insert(anim, G.play.cards[i])
                end
            end

            if #anim == 0 then
                return
            end

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('tarot1')
                    return true
                end
            }))
            for i = 1, #anim do
                local percent = 1.15 - (i - 0.999) / (#anim - 0.998) * 0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        anim[i]:flip();
                        play_sound('card1', percent);
                        anim[i]:juice_up(0.3, 0.3);
                        return true
                    end
                }))
            end

            delay(0.2)

            for i = 1, #anim do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        local card = anim[i]
                        local rank = pseudorandom_element(SMODS.Ranks, pseudoseed("HouseDeck")).card_key
                        local suit = pseudorandom_element(SMODS.Suits, pseudoseed("HouseDeck")).card_key
                        card:set_base(G.P_CARDS[suit .. "_" .. rank])
                        if double then
                            if not card.edition then
                                local ed = poll_edition("HouseDeck", nil, true)
                                if ed then
                                    card:set_edition(ed)
                                end
                            end
                            if card.ability.name == G.P_CENTERS.c_base.name then
                                local en = SMODS.poll_enhancement {
                                    type_key = "HouseDeck"
                                }
                                if en then
                                    card:set_ability(G.P_CENTERS[en])
                                end
                            end
                            if not card:get_seal(true) then
                                local se = SMODS.poll_seal {
                                    type_key = "HouseDeck"
                                }
                                if se then
                                    card:set_seal(se)
                                end
                            end
                        end
                        return true
                    end
                }))
                local percent = 0.85 + (i - 0.999) / (#anim - 0.998) * 0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        anim[i]:flip();
                        play_sound('tarot2', percent, 0.6);
                        anim[i]:juice_up(0.3, 0.3);
                        return true
                    end
                }))
            end

            delay(0.7)
        end
    end
}

-- KEEP_LITE
Bakery_API.guard(function()
    -- Items that, with the Credit Deck, can never be better than the same item doing absolutely nothing.
    -- For example, Egg is not on this list, since sell value can still matter for Swashbuckler or Ceremonial Dagger.
    -- Neither is Midas Mask, since it can feed Vampire or Driver's License.
    Bakery_API.econ_only_items = { 'j_delayed_grat', 'j_business', 'j_faceless', 'j_cloud_9', 'j_rocket',
        'j_reserved_parking', 'j_mail', 'j_to_the_moon', 'j_golden', 'j_ticket',
        'j_rough_gem', 'j_satellite', 'j_todo_list', 'j_Bakery_Auctioneer', 'v_seed_money',
        'v_money_tree', 'c_hermit', 'c_temperance', 'tag_investment', 'tag_skip',
        'tag_economy' }
end)
-- END_KEEP_LITE

local b_credit = SMODS.Back {
    key = "Credit",
    name = "Credit",
    config = {
        dollars = 200,
        no_interest = true
    },
    atlas = "Joker",
    prefix_config = {
        atlas = false
    },
    pos = {
        x = 5,
        y = 1
    },
    unlocked = false,
    discovered = false,
    check_for_unlock = function(self, args)
        return get_deck_win_stake('b_yellow') > 3
    end,
    locked_loc_vars = function(self, back)
        if G.P_CENTERS['b_yellow'].discovered then
            return {
                vars = {
                    localize {
                        type = 'name_text',
                        key = 'b_yellow',
                        set = "Back"
                    },
                    localize {
                        type = 'name_text',
                        set = 'Stake',
                        key = 'stake_black'
                    },
                    colours = { G.C.BLACK }
                }
            }
        end
        return {
            vars = {
                localize('k_unknown'),
                localize {
                    type = 'name_text',
                    set = 'Stake',
                    key = 'stake_black'
                },
                colours = { G.C.BLACK }
            }
        }
    end,
    loc_vars = function(self, info_queue, back)
        return {
            vars = { self.config.dollars }
        }
    end,
    apply = function(self, back)
        G.GAME.modifiers.no_blind_reward = {
            Small = true,
            Big = true,
            Boss = true
        }
        G.GAME.modifiers.no_extra_hand_money = true
        for _, k in ipairs(Bakery_API.econ_only_items) do
            G.GAME.banned_keys[k] = true
        end
    end
}

local b_dn = SMODS.Back {
    key = "DN",
    name = "DN",
    atlas = "BakeryBack",
    pos = {
        x = 3,
        y = 0
    },
    apply = function(self, back)
        G.GAME.modifiers.Bakery_advantage = (G.GAME.modifiers.Bakery_advantage or 0) + 1
    end
}

local raw_SMODS_pseudorandom_probability = SMODS.pseudorandom_probability
function SMODS.pseudorandom_probability(...)
    local advantage = G.GAME and G.GAME.modifiers and G.GAME.modifiers.Bakery_advantage or 0
    local result = false
    for _ = 1, advantage + 1 do
        if raw_SMODS_pseudorandom_probability(...) then
            result = true
        end
    end
    return result
end

if CardSleeves then
    SMODS.Atlas {
        key = "BakerySleeves",
        path = "BakerySleeves.png",
        px = 73,
        py = 95
    }

    CardSleeves.Sleeve {
        key = "Violet",
        atlas = "BakerySleeves",
        pos = {
            x = 0,
            y = 0
        },
        unlocked = false,
        unlock_condition = {
            deck = "b_Bakery_Violet",
            stake = "stake_black"
        },
        calculate = b_violet.calculate,
        config = b_violet.config,
        loc_vars = b_violet.loc_vars
    }

    CardSleeves.Sleeve {
        key = "House",
        atlas = "BakerySleeves",
        pos = {
            x = 1,
            y = 0
        },
        unlocked = false,
        unlock_condition = {
            deck = "b_Bakery_House",
            stake = "stake_red"
        },
        config = b_house.config,
        calculate = function(self, sleeve, context)
            local key, vars
            if self.get_current_deck_key() ~= "b_Bakery_House" then
                return b_house.calculate(self, sleeve, context)
            end
        end,
        loc_vars = function(self)
            if self.get_current_deck_key() ~= "b_Bakery_House" then
                return b_house.loc_vars(self)
            end
            return {
                key = self.key .. "_alt"
            }
        end
    }

    CardSleeves.Sleeve {
        key = "Credit",
        atlas = "BakerySleeves",
        pos = {
            x = 2,
            y = 0
        },
        unlocked = false,
        unlock_condition = {
            deck = "b_Bakery_Credit",
            stake = "stake_black"
        },
        config = {
            dollars = 200,
            alt_dollars = 100,
            no_interest = true
        },
        loc_vars = function(self, info_queue, back)
            local key = self.key
            local dollars = self.config.dollars
            if self.get_current_deck_key() == "b_Bakery_Credit" then
                key = key .. "_alt"
                dollars = dollars + self.config.alt_dollars
            end
            return {
                key = key,
                vars = { dollars }
            }
        end,
        apply = function(self)
            G.GAME.modifiers.no_interest = true
            b_credit.apply()
            G.GAME.starting_params.dollars = G.GAME.starting_params.dollars + self.config.dollars
            if self.get_current_deck_key() == "b_Bakery_Credit" then
                G.GAME.starting_params.dollars = G.GAME.starting_params.dollars + self.config.alt_dollars
            end
        end,
        calculate = function(self, sleeve, context)
            if self.get_current_deck_key() == "b_Bakery_Credit" and context.context == 'Bakery_after_press_play' then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        for i = 1, #G.play.cards do
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.play.cards[i]:juice_up();
                                    return true
                                end
                            }))
                            ease_dollars(-1)
                            delay(0.23)
                        end
                        return true
                    end
                }))
            end
        end
    }

    CardSleeves.Sleeve {
        key = "DN",
        atlas = "BakerySleeves",
        pos = {
            x = 3,
            y = 0
        },
        unlocked = false,
        unlock_condition = {
            deck = "b_Bakery_DN",
            stake = "stake_white"
        },
        apply = b_dn.apply,
        loc_vars = function(self)
            if self.get_current_deck_key() == "b_Bakery_DN" then
                return {
                    key = self.key .. "_alt"
                }
            end
        end
    }
end
