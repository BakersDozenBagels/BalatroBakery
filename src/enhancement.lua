SMODS.Atlas {
    key = "BakeryEnhancements",
    path = "BakeryEnhancements.png",
    px = 71,
    py = 95
}

SMODS.Sound {
    key = "TimeWalk",
    path = "TimeWalk.ogg"
}

local time_walk_buffer = 0
Bakery_API.credit(SMODS.Enhancement {
    key = "TimeWalk",
    atlas = 'BakeryEnhancements',
    pos = {
        x = 0,
        y = 0
    },
    replace_base_card = true,
    no_rank = true,
    no_suit = true,
    always_scores = true,
    weight = 0.025,
    artist = "AmyWeber",
    config = {
        extra = {
            hands = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.hands }
        }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.main_scoring then
            if not (Talisman and Talisman.config_file and Talisman.config_file.disable_anims) then
                time_walk_buffer = time_walk_buffer + 1
                local scale = math.max(math.min(time_walk_buffer - 2, 4), 1)
                G.E_MANAGER:add_event(Event {
                    trigger = 'before',
                    delay = 1 / time_walk_buffer,
                    timer = 'REAL',
                    func = function()
                        play_sound("Bakery_TimeWalk", 0.8 + math.random() * 0.2 + scale / 2, 1 / scale)
                        time_walk_buffer = 0
                        return true
                    end
                })
                G.E_MANAGER:add_event(Event {
                    trigger = 'immediate',
                    func = function()
                        card:juice_up(0.6, 0.1)
                        return true
                    end
                })
            end -- Entirely visual
            ease_hands_played(card.ability.extra.hands)
            if time_walk_buffer < 16 and not (Talisman and Talisman.config_file and Talisman.config_file.disable_anims) then
                delay(0.85)
            end
            return {
                effect = true
            }
        end
    end
})

Bakery_API.credit(SMODS.Enhancement {
    key = "Curse",
    atlas = 'BakeryEnhancements',
    pos = {
        x = 1,
        y = 0
    },
    replace_base_card = true,
    no_rank = true,
    no_suit = true,
    never_scores = true,
    weight = 0,
    artist = "ClausStephan",
    in_pool = function() return false end
})
