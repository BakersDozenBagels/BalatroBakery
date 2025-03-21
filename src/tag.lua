SMODS.Atlas {
    key = "BakeryTags",
    path = "BakeryTags.png",
    px = 34,
    py = 34
}

-- KEEP_LITE
Bakery_API.guard(function()
    -- Jokers that can be spawned by a Retrigger Tag
    Bakery_API.retrigger_jokers = Bakery_API.sized_table {
        j_mime = true,
        j_dusk = true,
        j_hack = true,
        j_selzer = true,
        j_sock_and_buskin = true,
        j_hanging_chad = true
    }
end)
-- END_KEEP_LITE

SMODS.Tag {
    key = "RetriggerTag",
    atlas = 'BakeryTags',
    pos = {
        x = 0,
        y = 0
    },
    min_ante = 4,
    config = {
        type = 'store_joker_create'
    },
    loc_vars = function(self, info_queue, card)
        for k in pairs(Bakery_API.retrigger_jokers) do
            if G.P_CENTERS[k] ~= nil then
                info_queue[#info_queue + 1] = G.P_CENTERS[k]
            end
        end
    end,
    apply = function(self, tag, context)
        if not tag.triggered and tag.config.type == context.type then
            tag.triggered = true

            local in_posession = {0}
            for k, v in ipairs(G.jokers.cards) do
                if Bakery_API.retrigger_jokers[v.config.center.rarity] and not in_posession[v.config.center.key] then
                    in_posession[1] = in_posession[1] + 1
                    in_posession[v.config.center.key] = true
                end
            end

            if Bakery_API.retrigger_jokers.Length > in_posession[1] then
                local j, k = pseudorandom_element(Bakery_API.retrigger_jokers, pseudoseed('Retrigger Tag'))
                local card = create_card('Joker', context.area, nil, 2, nil, nil, k, 'Retrigger Tag')
                create_shop_card_ui(card, 'Joker', context.area)
                card.states.visible = false
                tag:yep('+', G.C.RED, function()
                    card:start_materialize()
                    card.ability.couponed = true
                    card:set_cost()
                    return true
                end)
                return card
            else
                tag:nope()
            end
        end
    end
}

SMODS.Tag {
    key = "ChocolateTag",
    atlas = 'BakeryTags',
    pos = {
        x = 1,
        y = 0
    },
    min_ante = 0,
    config = {
        type = 'Bakery_play_hand_early',
        chips = 25,
        mult = 5,
        d_chips = 5,
        d_mult = 1
    },
    loc_vars = function(self, info_queue, tag)
        tag.ability = tag.ability or {}
        tag.ability.chips = tag.ability.chips or self.config.chips
        tag.ability.mult = tag.ability.mult or self.config.mult
        return {
            vars = {tag.ability.chips, tag.ability.mult, self.config.d_chips, self.config.d_mult}
        }
    end,
    apply = function(self, tag, context)
        if not tag.triggered and self.config.type == context.type then
            tag.ability = tag.ability or {}
            tag.ability.chips = tag.ability.chips or self.config.chips
            tag.ability.mult = tag.ability.mult or self.config.mult
            local ret = {
                chips = tag.ability.chips,
                mult = tag.ability.mult
            }
            tag.ability.chips = math.max(tag.ability.chips - self.config.d_chips, 0)
            tag.ability.mult = math.max(tag.ability.mult - self.config.d_mult, 0)
            if tag.ability.chips == 0 and tag.ability.mult == 0 then
                ret.after = function()
                    tag:yep('X', G.C.RED, function()
                        return true
                    end)
                end
            end
            return ret
        end
    end
}

SMODS.Tag {
    key = "PolyTag",
    atlas = 'BakeryTags',
    pos = {
        x = 2,
        y = 0
    },
    min_ante = 0,
    config = {
        type = 'Bakery_play_hand_late',
        x_mult = 1.5
    },
    loc_vars = function(self, info_queue, tag)
        return {
            vars = {self.config.x_mult}
        }
    end,
    apply = function(self, tag, context)
        if not tag.triggered and self.config.type == context.type then
            return {
                x_mult = self.config.x_mult
            }
        end
        if not tag.triggered and context.type == 'eval' then
            tag.triggered = true
            tag:yep('X', G.C.RED, function()
                return true
            end)
        end
    end
}

SMODS.Tag {
    key = "PennyTag",
    atlas = 'BakeryTags',
    pos = {
        x = 3,
        y = 0
    },
    min_ante = 0,
    config = {
        dollars = 1,
        hands = 5
    },
    loc_vars = function(self, info_queue, tag)
        tag.ability = tag.ability or {}
        return {
            vars = {tag.ability.dollars or self.config.dollars, tag.ability.hands or self.config.hands}
        }
    end,
    apply = function(self, tag, context)
        tag.ability = tag.ability or {}
        if not tag.triggered and context.type == 'Bakery_score_card' then
            return {
                func = function()
                    juice_card(tag)
                end,
                extra = {
                    dollars = tag.ability.dollars or self.config.dollars
                }
            }
        end
        if not tag.triggered and context.type == 'Bakery_play_hand_late' then
            tag.ability.hands = (tag.ability.hands or self.config.hands) - 1
            if tag.ability.hands == 0 then
                tag.triggered = true
                tag:yep('X', G.C.RED, function()
                    return true
                end)
            end
        end
    end
}

SMODS.Tag {
    key = "BlankTag",
    atlas = 'BakeryTags',
    pos = {
        x = 4,
        y = 0
    },
    min_ante = 0,
    in_pool = function(self, args)
        for i = 1, #G.GAME.tags do
            if G.GAME.tags[i].key == "tag_Bakery_BlankTag" then
                return false
            end
        end
        return true
    end
}

SMODS.Tag {
    key = "AntiTag",
    atlas = 'BakeryTags',
    pos = {
        x = 5,
        y = 0
    },
    min_ante = 1,
    in_pool = function(self, args)
        local found = false
        for i = 1, #G.GAME.tags do
            if G.GAME.tags[i].key == "tag_Bakery_BlankTag" then
                if found then
                    return true, {
                        allow_duplicates = true
                    }
                end
                found = true
            end
        end
        return found, {
            allow_duplicates = false
        }
    end,
    apply = function(self, tag, context)
        if not tag.triggered then
            for i = 1, #G.GAME.tags do
                if G.GAME.tags[i].key == "tag_Bakery_BlankTag" and not G.GAME.tags[i].triggered then
                    G.GAME.tags[i].triggered = true
                    G.GAME.tags[i]:yep('-', G.C.PURPLE, function()
                        return true
                    end)
                end
            end

            tag.triggered = true
            tag:yep('-', G.C.PURPLE, function()
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
                return true
            end)
            return true
        end
    end
}

SMODS.Tag {
    key = "CharmTag",
    atlas = 'BakeryTags',
    pos = {
        x = 6,
        y = 0
    },
    min_ante = 2,
    loc_vars = function(self, info_queue, tag)
        info_queue[#info_queue + 1] = {
            set = "Other",
            key = "Bakery_charm"
        }
    end,
    apply = function(self, tag, context)
        if not tag.triggered and context.type == 'voucher_add' then
            tag.triggered = true

            local keys = Bakery_API.get_next_charms(nil, 2)
            local tbl = G.GAME.current_round.Bakery_charm
            if keys[1] and keys[1] ~= 'j_joker' then
                tag:yep('+', G.C.SECONDARY_SET.Voucher, function()
                    tbl[#tbl + 1] = keys[1]
                    tbl.spawn[keys[1]] = true
                    Bakery_API.add_charm_to_shop(keys[1], 'from_tag')
                    if keys[2] and keys[2] ~= 'j_joker' then
                        tbl[#tbl + 1] = keys[2]
                        tbl.spawn[keys[2]] = true
                        Bakery_API.add_charm_to_shop(keys[2], 'from_tag')
                    end
                    return true
                end)
            else
                tag:nope()
            end
        end
    end
}
