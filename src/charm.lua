local function all_suits(n, hand)
    local suits = SMODS.Suit.obj_buffer
    local counts = {}
    local vals = {}
    for j = 1, #suits do
        vals[j] = {}
        counts[j] = 0
        for i = 1, #hand do
            if hand[i]:is_suit(suits[j], nil, true) then
                counts[j] = counts[j] + 1
                vals[j][#vals[j] + 1] = hand[i]
            end
        end
    end
    local ret = {}
    for k, v in pairs(counts) do
        if v >= n then
            ret[#ret + 1] = vals[k]
        end
    end
    return ret
end

Bakery_API.guard(function()
    SMODS.ObjectType {
        key = "BakeryCharm"
    }

    Bakery_API.Charm = SMODS.Center:extend {
        required_params = { "key" },
        unlocked = true,
        discovered = false,
        pos = {
            x = 0,
            y = 0
        },
        cost = 8,
        config = {},
        consumeable = true,
        set = 'BakeryCharm',
        class_prefix = 'BakeryCharm',
        pools = { "BakeryCharm" },
        set_card_type_badge = function(self, card, badges)
            badges[#badges + 1] = create_badge(localize('k_Bakery_charm'), G.C.DARK_EDITION, G.C.WHITE, 1.2)
        end,
        load = function(self, card, cardTable, other_card)
            card.T.h = G.CARD_W
            card.T.w = G.CARD_W
        end,
        register = function(self)
            local raw_obj_loc_vars = self.loc_vars
            self.loc_vars = function(self, info_queue, card)
                info_queue[#info_queue + 1] = {
                    set = "Other",
                    key = "Bakery_charm"
                }
                if raw_obj_loc_vars then
                    return raw_obj_loc_vars(self, info_queue, card)
                end
            end
            Bakery_API.Charm.super.register(self)
        end,
        equip = function(self, card)
        end,
        unequip = function(self, card)
        end
    }

    SMODS.Atlas {
        key = "CharmsUtil",
        px = 68,
        py = 68,
        path = "BakeryCharmsUtil.png"
    }

    SMODS.UndiscoveredSprite {
        key = "BakeryCharm",
        atlas = "CharmsUtil",
        pos = {
            x = 0,
            y = 1
        },
        overlay_pos = {
            x = 0,
            y = 2
        }
    }

    G.FUNCS.your_collection_Bakery_Charms_page = function(args)
        if not args or not args.cycle_config then
            return
        end
        for j = 1, #G.your_collection do
            for i = #G.your_collection[j].cards, 1, -1 do
                local c = G.your_collection[j]:remove_card(G.your_collection[j].cards[i])
                c:remove()
                c = nil
            end
        end
        for i = 1, 5 do
            for j = 1, #G.your_collection do
                local center = G.P_CENTER_POOLS.BakeryCharm[i + (j - 1) * 5 +
                (5 * #G.your_collection * (args.cycle_config.current_option - 1))]
                if not center then
                    break
                end
                local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w / 2, G.your_collection[j].T.y,
                    G.CARD_W, G.CARD_W, G.P_CARDS.empty, center)
                card.sticker = get_joker_win_sticker(center)
                G.your_collection[j]:emplace(card)
            end
        end
        INIT_COLLECTION_CARD_ALERTS()
    end

    SMODS.current_mod.custom_collection_tabs = function()
        local tally = 0
        for _, v in pairs(G.P_CENTER_POOLS.BakeryCharm) do
            if v.discovered or G.PROFILES[G.SETTINGS.profile].all_unlocked then
                tally = tally + 1
            end
        end
        return { UIBox_button {
            button = 'your_collection_Bakery_Charms',
            id = 'your_collection_Bakery_Charms',
            label = { localize('k_Bakery_charms') },
            count = {
                tally = tally,
                of = #G.P_CENTER_POOLS.BakeryCharm
            },
            minw = 5
        } }
    end
    function G.FUNCS.your_collection_Bakery_Charms()
        G.SETTINGS.paused = true
        G.FUNCS.overlay_menu {
            definition = SMODS.card_collection_UIBox(G.P_CENTER_POOLS.BakeryCharm, { 5, 5 }, {
                snap_back = true,
                infotip = localize('k_BakeryCharmInfo'),
                hide_single_page = true,
                collapse_single_page = true,
                h_mod = 0.65,
                modify_card = function(card, center, i, j)
                    card.T.h = card.T.w
                end
            })
        }
    end

    G.BakeryCharm_locked = {
        unlocked = false,
        max = 1,
        name = "Locked",
        pos = {
            x = 0,
            y = 0
        },
        set = "BakeryCharm",
        atlas = "Bakery_CharmsUtil",
        cost_mult = 1.0,
        config = {}
    }

    local raw_Card_set_sprites = Card.set_sprites
    function Card:set_sprites(center, front)
        raw_Card_set_sprites(self, center, front)
        if center and center.set == 'BakeryCharm' and not center.unlocked then
            self.children.center.atlas = G.ASSET_ATLAS.Bakery_CharmsUtil
            self.children.center.scale = {
                x = G.ASSET_ATLAS.Bakery_CharmsUtil.px,
                y = G.ASSET_ATLAS.Bakery_CharmsUtil.py
            }
            self.children.center.scale_mag = math.min(
                G.ASSET_ATLAS.Bakery_CharmsUtil.px / (self.children.center.VT.W or 1),
                G.ASSET_ATLAS.Bakery_CharmsUtil.py / (self.children.center.VT.H or 1))
            self.children.center:set_sprite_pos({
                x = 0,
                y = 0
            })
        end
    end

    sendInfoMessage("Card:set_sprites() patched. Reason: Charm Unlocking", "Bakery")

    function Bakery_API.get_charm_count()
        return (G.GAME.starting_params.Bakery_charms_in_shop or 1) + (G.GAME.modifiers.Bakery_extra_charms or 0)
    end

    function Bakery_API.get_next_charms(ret, count)
        local ret = ret or {
            spawn = {}
        }
        local _pool, _pool_key = get_current_pool('BakeryCharm')
        local already = 0
        G.GAME.current_round.Bakery_charm = G.GAME.current_round.Bakery_charm or {
            spawn = {}
        }
        for _, v in ipairs(_pool) do
            if G.GAME.current_round.Bakery_charm.spawn[v] then
                already = already + 1
            end
        end
        for i = 1, math.min(SMODS.size_of_pool(_pool) - already, count or Bakery_API.get_charm_count()) do
            local center = pseudorandom_element(_pool, pseudoseed(_pool_key))
            local it = 1
            while center == 'UNAVAILABLE' or G.GAME.current_round.Bakery_charm.spawn[center] do
                it = it + 1
                center = pseudorandom_element(_pool, pseudoseed(_pool_key .. '_resample' .. it))
            end

            ret[#ret + 1] = center
            ret.spawn[center] = true
        end
        return ret
    end

    function Bakery_API.add_charms_to_shop()
        local charms_to_spawn = 0
        G.GAME.current_round.Bakery_charm = G.GAME.current_round.Bakery_charm or {
            spawn = {}
        }
        for _ in pairs(G.GAME.current_round.Bakery_charm.spawn) do
            charms_to_spawn = charms_to_spawn + 1
        end
        if charms_to_spawn < Bakery_API.get_charm_count() then
            Bakery_API.get_next_charms(G.GAME.current_round.Bakery_charm)
        end
        for _, key in ipairs(G.GAME.current_round.Bakery_charm or {}) do
            if G.P_CENTERS[key] and G.GAME.current_round.Bakery_charm.spawn[key] and key ~= 'j_joker' then
                Bakery_API.add_charm_to_shop(key, 'shop_voucher')
            end
        end
    end

    function Bakery_API.add_charm_to_shop(key, source)
        assert(key, "Expected a key")
        assert(G.P_CENTERS[key], "Invalid charm key: " .. key)
        local card = Card(G.shop_vouchers.T.x + G.shop_vouchers.T.w / 2, G.shop_vouchers.T.y, G.CARD_W, G.CARD_W,
            G.P_CARDS.empty, G.P_CENTERS[key], {
                bypass_discovery_center = true,
                bypass_discovery_ui = true
            })
        card[source] = true
        create_shop_card_ui(card, 'Charm', G.shop_vouchers)
        card:start_materialize()
        G.shop_vouchers:emplace(card)
        G.shop_vouchers.config.card_limit = #G.shop_vouchers.cards
        return card
    end

    function Bakery_API.equip_button(card)
        return {
            n = G.UIT.ROOT,
            config = {
                ref_table = card,
                minw = 1.1,
                maxw = 1.3,
                padding = 0.1,
                align = 'bm',
                colour = G.C.GREEN,
                shadow = true,
                r = 0.08,
                minh = 0.94,
                func = 'Bakery_can_equip',
                one_press = true,
                button = 'Bakery_equip_from_shop',
                hover = true
            },
            nodes = { {
                n = G.UIT.T,
                config = {
                    text = localize('b_Bakery_equip'),
                    colour = G.C.WHITE,
                    scale = 0.4
                }
            } }
        }
    end

    local to_big = to_big or function(...) return ... end
    G.FUNCS.Bakery_can_equip = function(e)
        if G.GAME.Bakery_charm == 'BakeryCharm_Bakery_DuctTape' or
            to_big(e.config.ref_table.cost) > to_big(G.GAME.dollars) - to_big(G.GAME.bankrupt_at) then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        else
            e.config.colour = G.C.GREEN
            e.config.button = 'Bakery_equip_from_shop'
        end
    end
    G.FUNCS.Bakery_equip_from_shop = function(e, mute, nosave)
        e.config.button = nil
        local card = e.config.ref_table
        local area = card.area
        local prev_state = G.STATE
        local delay_fac = 1

        G.TAROT_INTERRUPT = G.STATE
        G.STATE = (G.STATE == G.STATES.TAROT_PACK and G.STATES.TAROT_PACK) or
            (G.STATE == G.STATES.PLANET_PACK and G.STATES.PLANET_PACK) or
            (G.STATE == G.STATES.SPECTRAL_PACK and G.STATES.SPECTRAL_PACK) or
            (G.STATE == G.STATES.STANDARD_PACK and G.STATES.STANDARD_PACK) or
            (G.STATE == G.STATES.BUFFOON_PACK and G.STATES.BUFFOON_PACK) or G.STATES.PLAY_TAROT

        G.CONTROLLER.locks.use = true

        if card.children.use_button then
            card.children.use_button:remove();
            card.children.use_button = nil
        end
        if card.children.price then
            card.children.price:remove();
            card.children.price = nil
        end

        if card.area then
            card.area:remove_card(card)
        end

        delay(0.1)
        G.GAME.round_scores.cards_purchased.amt = G.GAME.round_scores.cards_purchased.amt + 1
        e.config.ref_table:Bakery_equip()

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                G.STATE = prev_state
                G.TAROT_INTERRUPT = nil
                G.CONTROLLER.locks.use = false

                if area and area.cards[1] then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.CONTROLLER.interrupt.focus = nil
                            G.CONTROLLER:snap_to({
                                node = G.shop:get_UIE_by_ID('next_round_button')
                            })
                            return true
                        end
                    }))
                end
                return true
            end
        }))
    end

    function Card:Bakery_equip()
        if self.config.center.set ~= 'BakeryCharm' then
            return
        end
        stop_use()
        if not self.config.center.discovered then
            discover_card(self.config.center)
        end
        if self.shop_voucher then
            G.GAME.current_round.Bakery_charm.spawn[self.config.center_key] = false
        end

        if G.GAME.Bakery_charm then
            G.P_CENTERS[G.GAME.Bakery_charm]:unequip(G.Bakery_charm_area.cards[1])
            G.GAME.used_jokers[G.GAME.Bakery_charm] = nil
            if not G.Bakery_charm_area.cards[1] then
                sendWarnMessage("No charm was found in G.Bakery_charm_area to destroy.", "Bakery")
            else
                G.Bakery_charm_area.cards[1]:start_dissolve()
            end
        end
        G.GAME.Bakery_charm = self.config.center_key
        G.GAME.used_jokers[self.config.center_key] = true
        G.Bakery_charm_area:emplace(self)
        if self.cost ~= 0 then
            ease_dollars(-self.cost)
            inc_career_stat('c_shop_dollars_spent', self.cost)
        end
        -- TODO: stat tracking
        -- inc_career_stat('c_vouchers_bought', 1)
        -- set_voucher_usage(self)

        self.config.center:equip(self)
        delay(0.6)
        SMODS.calculate_context({
            buying_card = true,
            card = self
        })

        if G.GAME.modifiers.inflation then
            G.GAME.inflation = G.GAME.inflation + 1
            G.E_MANAGER:add_event(Event({
                func = function()
                    for k, v in pairs(G.I.CARD) do
                        if v.set_cost then
                            v:set_cost()
                        end
                    end
                    return true
                end
            }))
        end
    end

    function Bakery_API.create_charm_area()
        G.Bakery_charm_area = CardArea(0, 0, 0.95 * G.CARD_W, 0.95 * G.CARD_W, {
            card_limit = 1,
            type = 'joker',
            highlight_limit = 1
        })
        G.Bakery_charm_area.ARGS.invisible_area_types = {
            joker = 1
        }
    end

    local raw_set_screen_positions = set_screen_positions
    function set_screen_positions()
        raw_set_screen_positions()
        if G.STAGE == G.STAGES.RUN and G.Bakery_charm_area then
            G.Bakery_charm_area.T.x = G.TILE_W - G.Bakery_charm_area.T.w - 0.5
            G.Bakery_charm_area.T.y = G.TILE_H - G.deck.T.h - 1.2 * G.Bakery_charm_area.T.h
        end
    end

    local raw_CardArea_can_highlight = CardArea.can_highlight
    function CardArea:can_highlight(card)
        return self ~= G.Bakery_charm_area and raw_CardArea_can_highlight(self, card)
    end

    sendInfoMessage("set_screen_positions() and CardArea:can_highlight() patched. Reason: Charm rendering", "Bakery")

    SMODS.PokerHandPart {
        key = 's_2',
        func = function(hand)
            return all_suits(2, hand)
        end
    }
    SMODS.PokerHandPart {
        key = 's_3',
        func = function(hand)
            return all_suits(3, hand)
        end
    }
    SMODS.PokerHandPart {
        key = 's_all_pairs',
        func = function(hand)
            local _2 = all_suits(2, hand)
            if not next(_2) then
                return {}
            end
            return { SMODS.merge_lists(_2) }
        end
    }
end)
Bakery_API.guard(function()
    function Bakery_API.maximus_full_house_compat(parts, val)
        return val
    end
end)
