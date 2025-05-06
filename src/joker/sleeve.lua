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
        local highlighted = card.highlighted
        if card.children.use_button then
            card.children.use_button:remove()
            card.children.use_button = nil
        end
        card:highlight(highlighted)
    end
end)
