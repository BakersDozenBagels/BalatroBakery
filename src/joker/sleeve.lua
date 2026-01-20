local next_key, j_sleeve, no_recurse

local card_area_size = {
    W = 0,
    H = 0,
    X = G.CARD_W * 0.5,
    Y = G.CARD_H * 0.3
}

local CardSleeveCardArea = CardArea:extend()
function CardSleeveCardArea:init(key, major)
    CardSleeveCardArea.super.init(self, 0, 0, card_area_size.W, card_area_size.H, {
        card_limit = 1,
        type = 'Bakery_cardsleeve',
        Bakery_sleeve_key = key
    })
    table.insert(G.I.CARDAREA, self)
    G["Bakery_sleeve_" .. key] = self
    self.role.role_type = 'Minor'
    self.role.major = major
    self.role.offset = {
        x = card_area_size.X,
        y = card_area_size.Y
    }
    self.ARGS.invisible_area_types = self.ARGS.invisible_area_types or {}
    self.ARGS.invisible_area_types.Bakery_cardsleeve = 1
end

function CardSleeveCardArea:draw()
    CardSleeveCardArea.super.draw(self)
    for k, v in ipairs(self.ARGS.draw_layers) do
        for i = 1, #self.cards do
            if self.cards[i] ~= G.CONTROLLER.focused.target or self == G.hand then
                if G.CONTROLLER.dragging.target ~= self.cards[i] then
                    self.cards[i]:draw(v)
                end
            end
        end
    end
end

function CardSleeveCardArea:can_highlight()
    return true
end

function CardSleeveCardArea:align_cards()
    self.config.type = 'joker'
    CardSleeveCardArea.super.align_cards(self)
    self.config.type = 'Bakery_cardsleeve'
end

function CardSleeveCardArea:remove_card(card)
    local ret = CardSleeveCardArea.super.remove_card(self, card)
    if not no_recurse then
        for k, v in ipairs(G.jokers.cards) do
            if v.config.center.key == j_sleeve.key and v.ability.extra.key == self.config.Bakery_sleeve_key then
                j_sleeve:Bakery_remove_card(v)
            end
        end
    end
    return ret
end

j_sleeve = SMODS.Joker {
    key = "CardSleeve",
    name = "CardSleeve",
    atlas = 'Bakery',
    pos = {
        x = 0,
        y = 2
    },
    rarity = 2,
    cost = 6,
    config = {
        extra = {
            occupied = false
        }
    },
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    _hand_available = function()
        return
            G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or
            G.STATE == G.STATES.SMODS_BOOSTER_OPENED or G.STATE == G.STATES.PLAY_TAROT
    end,
    Bakery_can_use = function(self, card)
        if card.ability.extra.occupied then
            return G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE ==
                G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
        else
            return not card.ability.extra.override and #G.hand.highlighted == 1
        end
    end,
    Bakery_remove_card = function(self, card, force)
        if card.ability.extra.occupied and not card.ability.extra.override then
            if not G["Bakery_sleeve_" .. card.ability.extra.key].cards then
                sendErrorMessage('Sleeve ' .. card.ability.extra.key .. ' has no cards table', 'Bakery')
                return
            end
            no_recurse = true
            draw_card(G["Bakery_sleeve_" .. card.ability.extra.key], self._hand_available() and G.hand or G.deck, nil,
                nil, nil, G["Bakery_sleeve_" .. card.ability.extra.key].cards[1], nil, nil, true)
            G.E_MANAGER:add_event(Event {
                trigger = 'immediate',
                func = function()
                    G["Bakery_sleeve_" .. card.ability.extra.key]:remove()
                    G["Bakery_sleeve_" .. card.ability.extra.key] = nil
                    card.ability.extra.key = nil
                    card.ability.extra.occupied = false
                    card.ability.extra.override = nil
                    no_recurse = false
                    Bakery_API.rehighlight(card)
                    return true
                end
            })
            card.ability.extra.override = true
        end
    end,
    Bakery_use_joker = function(self, card)
        if card.ability.extra.occupied then
            self:Bakery_remove_card(card)
        else
            card.ability.extra.key = next_key()
            CardSleeveCardArea(card.ability.extra.key, card)
            draw_card(G.hand, G["Bakery_sleeve_" .. card.ability.extra.key], nil, nil, nil, G.hand.highlighted[1], nil,
                nil, true)
            card.ability.extra.occupied = true
            Bakery_API.rehighlight(card)
        end
    end,
    Bakery_use_button_text = function(self, card)
        return card.ability.extra.occupied and localize('b_Bakery_return') or localize('b_Bakery_store')
    end
}

function Bakery_API.sleevearea_for_key(k)
    for _, v in ipairs(G.I.CARDAREA) do
        if v.config.Bakery_sleeve_key == k then
            return v
        end
    end
end

next_key = function()
    local key = 1
    while Bakery_API.sleevearea_for_key(key) do
        key = key + 1
    end
    return key
end

local raw_copy_card = copy_card
function copy_card(other, new_card, card_scale, playing_card, strip_edition, ...)
    local k, o, v, a
    if other.config.center.key == j_sleeve.key then
        k = other.ability.extra.key
        o = other.ability.extra.occupied
        v = other.ability.extra.override
        a = other.ability.extra.area
        other.ability.extra.key = nil
        other.ability.extra.occupied = nil
        other.ability.extra.override = nil
        other.ability.extra.area = nil
    end
    local ret = raw_copy_card(other, new_card, card_scale, playing_card, strip_edition, ...)
    if other.config.center.key == j_sleeve.key then
        other.ability.extra.key = k
        other.ability.extra.occupied = o
        other.ability.extra.override = v
        other.ability.extra.area = a
    end
    return ret
end

local raw_Game_start_run = Game.start_run
function Game:start_run(args)
    local todo = {}
    if args.savetext then
        for k, v in pairs(args.savetext.cardAreas) do
            if string.find(k, "^Bakery_sleeve_%d+$") then
                CardSleeveCardArea(tonumber(string.sub(k, 15)))
                todo[k] = G[k]
            end
        end
    end
    local ret = raw_Game_start_run(self, args)
    for k, v in pairs(G.jokers.cards) do
        if v.config.center.key == j_sleeve.key and v.ability.extra.key then
            G["Bakery_sleeve_" .. v.ability.extra.key].role.major = v
            for k, a in ipairs(G.I.CARDAREA) do
                if a == G["Bakery_sleeve_" .. v.ability.extra.key] then
                    table.remove(G.I.CARDAREA, k) -- Render card area in front of joker
                    G.I.CARDAREA[#G.I.CARDAREA + 1] = G["Bakery_sleeve_" .. v.ability.extra.key]
                    break
                end
            end
            todo["Bakery_sleeve_" .. v.ability.extra.key] = nil
        end
    end
    for k, v in pairs(todo) do
        v:remove()
    end
    return ret
end

local raw_Card_load = Card.load
function Card:load(cardTable, other_card)
    raw_Card_load(self, cardTable, other_card)
    if self.config.center.key == j_sleeve.key and self.ability.extra.key then
        for _, v in ipairs(G.I.CARDAREA) do
            if v.config.Bakery_sleeve_key == self.ability.extra.key then
                self.ability.extra.area = v
                return
            end
        end
    end
end

sendInfoMessage("Game:start_run(), copy_card(), and Card:load() patched. Reason: Card Sleeve", "Bakery")

-- KEEP_LITE
Bakery_API.guard(function()
    local raw_usable_jokers = {
        j_Bakery_CardSleeve = true,
        j_Bakery_GetOutOfJailFreeCard = true,
        j_Bakery_CoinSlot = true
    }
    Bakery_API.usable_jokers = setmetatable({}, {
        __newindex = function(t, k, v)
            sendWarnMessage("A mod is trying to set Bakery_API.usable_jokers." .. k ..
                ". This is no longer required, and the table will be removed in a future version of Bakery.",
                "Bakery")
            raw_usable_jokers[k] = v
        end,
        __index = function(t, k)
            sendWarnMessage("A mod is trying to get Bakery_API.usable_jokers." .. k ..
                ". This table will be removed in a future version of Bakery.", "Bakery")
            return raw_usable_jokers[k]
        end
    })

    local raw_G_UIDEF_use_and_sell_buttons = G.UIDEF.use_and_sell_buttons
    function G.UIDEF.use_and_sell_buttons(card)
        local ret = raw_G_UIDEF_use_and_sell_buttons(card)
        if G.jokers and card.area.config.type == 'joker' and card.config and card.config.center and
            card.config.center.Bakery_use_joker then
            ret.nodes[1].nodes[2].nodes[1] = {
                n = G.UIT.C,
                config = {
                    align = "cr"
                },
                nodes = { {
                    n = G.UIT.C,
                    config = {
                        ref_table = card,
                        align = "cr",
                        maxw = 1.25,
                        padding = 0.1,
                        r = 0.08,
                        minw = 1.25,
                        minh = 0,
                        hover = true,
                        shadow = true,
                        colour = G.C.UI.BACKGROUND_INACTIVE,
                        button = 'Bakery_use_joker',
                        func = 'Bakery_can_use_joker'
                    },
                    nodes = { {
                        n = G.UIT.B,
                        config = {
                            w = 0.1,
                            h = 0.6
                        }
                    }, {
                        n = G.UIT.T,
                        config = {
                            text = card.config.center.Bakery_use_button_text and
                                card.config.center:Bakery_use_button_text(card) or localize('b_use'),
                            colour = G.C.UI.TEXT_LIGHT,
                            scale = 0.55,
                            shadow = true
                        }
                    } }
                } }
            }
        end

        return ret
    end

    local raw_G_UIDEF_card_focus_ui = G.UIDEF.card_focus_ui
    function G.UIDEF.card_focus_ui(card)
        local ret = raw_G_UIDEF_card_focus_ui(card)
        local card_width = card.T.w + (card.ability.consumeable and -0.1 or card.ability.set == 'Voucher' and -0.16 or 0)
        local base_attach = ret:get_UIE_by_ID('ATTACH_TO_ME')
        if (card.area == G.jokers and G.jokers) and card.config.center.Bakery_use_joker then
            base_attach.children.use = G.UIDEF.card_focus_button {
                card = card, parent = base_attach, type = 'Bakery_use',
                Bakery_loc = card.config.center.Bakery_use_button_text and card.config.center:Bakery_use_button_text(card) or localize 'b_use',
                func = 'Bakery_can_use_joker', button = 'use_card', card_width = card_width
            }
        end
        return ret
    end

    local raw_Card_remove = Card.remove
    function Card:remove()
        raw_Card_remove(self)
        if self.config.center.Bakery_remove_card then
            self.config.center:Bakery_remove_card(self, true)
        end
    end

    sendInfoMessage("G.UIDEF.use_and_sell_buttons() and Card:remove() patched. Reason: Usable jokers", "Bakery")

    function Bakery_API.default_can_use(card)
        return card.area and card.area.config.type == 'joker' and
            not ((G.play and #G.play.cards > 0) or (G.CONTROLLER.locked) or
                (G.GAME.STOP_USE and G.GAME.STOP_USE > 0))
    end

    function G.FUNCS.Bakery_can_use_joker(node)
        local card = node.config.ref_table
        if card and card.config.center.Bakery_can_use and card.config.center:Bakery_can_use(card) then
            node.config.colour = G.C.RED
            node.config.button = 'Bakery_use_joker'
        else
            node.config.colour = G.C.UI.BACKGROUND_INACTIVE
            node.config.button = nil
        end
    end

    function G.FUNCS.Bakery_use_joker(node)
        local card = node.config.ref_table
        if card and card.config.center.Bakery_use_joker and
            (not card.config.center.Bakery_can_use or card.config.center:Bakery_can_use(card)) then
            card.config.center:Bakery_use_joker(card)
        end
    end

    function Bakery_API.get_highlighted()
        local comb = { unpack(G.hand.highlighted) }
        for k, v in ipairs(G.jokers.cards) do
            if v.config.center.key == 'j_Bakery_CardSleeve' and v.ability.extra.key then
                for k, c in ipairs((Bakery_API.sleevearea_for_key(v.ability.extra.key) or {
                    highlighted = {}
                }).highlighted) do
                    comb[#comb + 1] = c
                end
            end
        end
        return comb
    end

    function Bakery_API.unhighlight_all()
        G.hand:unhighlight_all()
        for k, v in ipairs(G.jokers.cards) do
            if v.config.center.key == 'j_Bakery_CardSleeve' and v.ability.extra.key then
                local area = Bakery_API.sleevearea_for_key(v.ability.extra.key)
                if area then
                    area:unhighlight_all()
                end
            end
        end
    end

    function Bakery_API.rehighlight(card)
        if G.CONTROLLER.HID.controller then
            if card.children.focused_ui then
                card.children.focused_ui:remove()
                card.children.focused_ui = nil
            end
            card:stop_hover()
            card:hover()
        end

        local highlighted = card.highlighted
        if card.children.use_button then
            card.children.use_button:remove()
            card.children.use_button = nil
        end
        card:highlight(highlighted)
    end

    function Bakery_API.can_highlight_area(area)
        return area == G.hand
            -- END_KEEP_LITE
            or area == G.jokers or area:is(CardSleeveCardArea)
            -- KEEP_LITE
    end
end)
-- END_KEEP_LITE

local raw_card_highlight = Card.highlight
function Card:highlight(is_highlighted)
    self.highlighted = is_highlighted
    if G.CONTROLLER.HID.controller then
        return
    end

    return raw_card_highlight(self, is_highlighted)
end

local raw_CardArea_can_highlight = CardArea.can_highlight
function CardArea:can_highlight(card)
    if self == G.jokers then
        return true
    end
    return raw_CardArea_can_highlight(self, card)
end