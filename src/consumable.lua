SMODS.Atlas {
    key = "BakeryConsumables",
    path = "BakeryConsumables.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = 'Astrology',
    set = 'Spectral',
    atlas = "BakeryConsumables",
    pos = {
        x = 0,
        y = 0
    },
    cost = 5,
    hidden = true,
    soul_set = 'Planet',
    soul_rate = 0.003,
    config = {
        extra = {
            multiplier = 10
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.multiplier }
        }
    end,
    use = function(self, card, area, copier)
        update_hand_text({
            sound = 'button',
            volume = 0.7,
            pitch = 0.8,
            delay = 0.3
        }, {
            handname = localize('k_all_hands'),
            chips = '...',
            mult = '...',
            level = ''
        })
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                G.TAROT_INTERRUPT_PULSE = true
                return true
            end
        }))
        update_hand_text({
            delay = 0
        }, {
            mult = '=',
            StatusText = true
        })
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.9,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                return true
            end
        }))
        update_hand_text({
            delay = 0
        }, {
            chips = '=',
            StatusText = true
        })
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.9,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                G.TAROT_INTERRUPT_PULSE = nil
                return true
            end
        }))
        update_hand_text({
            sound = 'button',
            volume = 0.7,
            pitch = 0.9,
            delay = 0
        }, {
            level = '1'
        })
        delay(1.3)

        local levels = 0
        for k, v in pairs(G.GAME.hands) do
            levels = levels + math.max(v.level - 1, 0)
            v.level = 1
            v.mult = math.max(v.s_mult + v.l_mult * (v.level - 1), 1)
            v.chips = math.max(v.s_chips + v.l_chips * (v.level - 1), 0)
        end

        ease_dollars(levels * card.ability.extra.multiplier)

        update_hand_text({
            sound = 'button',
            volume = 0.7,
            pitch = 1.1,
            delay = 0
        }, {
            mult = 0,
            chips = 0,
            handname = '',
            level = ''
        })
    end,
    can_use = function(self, card)
        for k, v in pairs(G.GAME.hands) do
            if Bakery_API.big(v.level) > Bakery_API.big(1) then
                return true
            end
        end
        return false
    end
}

SMODS.Consumable {
    key = 'TimeMachine',
    set = 'Spectral',
    atlas = "BakeryConsumables",
    pos = {
        x = 1,
        y = 0
    },
    cost = 7,
    config = {
        mod_conv = 'm_Bakery_TimeWalk',
        max_highlighted = 1
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_Bakery_TimeWalk
        return {
            vars = { self.config.max_highlighted, localize {
                type = 'name_text',
                set = 'Enhanced',
                key = self.config.mod_conv
            } }
        }
    end
}

Bakery_API.credit(SMODS.Consumable {
    key = 'Scribe',
    set = 'Tarot',
    atlas = "BakeryConsumables",
    pos = {
        x = 2,
        y = 0
    },
    artist = "GhostSalt",
    cost = 4,
    config = {
        extra = {
            hl = 1,
            copies = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_Bakery_Carbon
        return {
            vars = { card.ability.extra.copies, card.ability.extra.hl }
        }
    end,
    can_use = function(self, card)
        local count = #Bakery_API.get_highlighted() + #G.jokers.highlighted
        return count >= 1 and count <= card.ability.extra.hl and
            (#Bakery_API.get_highlighted() > 0 or #G.jokers.highlighted + #G.jokers.cards <= G.jokers.config.card_limit)
    end,
    use = function(self, card, area, copier)
        if not self:can_use(card) then
            return
        end

        G.E_MANAGER:add_event(Event({
            func = function()
                local new_cards = {}
                for i = 1, #Bakery_API.get_highlighted() do
                    local copied = Bakery_API.get_highlighted()[i]
                    local _first_dissolve = nil
                    for i = 1, card.ability.extra.copies do
                        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                        local _card = copy_card(copied, nil, nil, G.playing_card)
                        _card:set_edition("e_Bakery_Carbon", true, true)
                        _card:set_eternal(nil)
                        _card:add_to_deck()
                        G.deck.config.card_limit = G.deck.config.card_limit + 1
                        table.insert(G.playing_cards, _card)
                        G.hand:emplace(_card)
                        _card:start_materialize(nil, _first_dissolve)
                        _first_dissolve = true
                        new_cards[#new_cards + 1] = _card
                    end
                end

                for i = 1, card.ability.extra.copies do
                    for i = 1, #G.jokers.highlighted do
                        if #G.jokers.highlighted + #G.jokers.cards <= G.jokers.config.card_limit then
                            local copied = G.jokers.highlighted[i]
                            local _card = copy_card(copied, nil, nil, nil, copied.edition)
                            _card:set_edition("e_Bakery_Carbon", true, true)
                            _card:set_eternal(nil)
                            _card:add_to_deck()
                            G.jokers:emplace(_card)

                            check_for_unlock { type = 'Bakery_Scribe_Joker', key = copied.config.center.key }
                        end
                    end
                end

                playing_card_joker_effects(new_cards)
                return true
            end
        }))
    end
})

SMODS.Consumable {
    key = 'Boids',
    set = 'Spectral',
    atlas = "BakeryConsumables",
    pos = {
        x = 3,
        y = 0
    },
    cost = 6,
    config = {
        extra = {
            cards = 5
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.cards }
        }
    end,
    use = function(self, card, area, copier)
        local front = pseudorandom_element(G.P_CARDS, pseudoseed 'c_Bakery_Boids')
        G.E_MANAGER:add_event(Event {
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound 'tarot1'
                card:juice_up(0.3, 0.5)
                return true
            end
        })
        for i = 1, #Bakery_API.get_highlighted() do
            local percent = 1.15 - (i - 0.999) / (#Bakery_API.get_highlighted() - 0.998) * 0.3
            G.E_MANAGER:add_event(Event { trigger = 'after', delay = 0.15, func = function()
                Bakery_API.get_highlighted()[i]:flip(); play_sound('card1', percent); Bakery_API.get_highlighted()[i]
                    :juice_up(0.3, 0.3); return true
            end })
        end
        delay(0.2)
        for i = 1, #Bakery_API.get_highlighted() do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    local card = Bakery_API.get_highlighted()[i]
                    card:set_base(front)
                    return true
                end
            }))
        end
        for i = 1, #Bakery_API.get_highlighted() do
            local percent = 0.85 + (i - 0.999) / (#Bakery_API.get_highlighted() - 0.998) * 0.3
            G.E_MANAGER:add_event(Event { trigger = 'after', delay = 0.15, func = function()
                Bakery_API.get_highlighted()[i]:flip(); play_sound('tarot2', percent, 0.6); Bakery_API.get_highlighted()
                    [i]:juice_up(0.3, 0.3); return true
            end })
        end
        G.E_MANAGER:add_event(Event {
            trigger = 'after',
            delay = 0.2,
            func = function()
                Bakery_API.unhighlight_all(); return true
            end
        })
        delay(0.5)
    end,
    can_use = function(self, card)
        return #Bakery_API.get_highlighted() > 0 and #Bakery_API.get_highlighted() <= card.ability.extra.cards
    end
}
