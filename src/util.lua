-- KEEP_LITE
Bakery_API.guard(function()
    -- Polyfill __pairs and __ipairs metatables
    local raw_pairs = pairs
    pairs = function(t)
        local metatable = getmetatable(t)
        if metatable and metatable.__pairs then
            return metatable.__pairs(t)
        end
        return raw_pairs(t)
    end

    local raw_ipairs = ipairs
    ipairs = function(t)
        local metatable = getmetatable(t)
        if metatable and metatable.__ipairs then
            return metatable.__ipairs(t)
        end
        return raw_ipairs(t)
    end

    sendInfoMessage("pairs() and ipairs() patched. Reason: Convenience", "Bakery")

    --- Adds a `Length` key to the table which reports the number of other keys contained within.
    ---@param table table @The table to modify.
    ---@param key string @The key to use. Defaults to `Length`
    function Bakery_API.sized_table(table, key, ...)
        key = key or "Length"
        local count = 0
        for k in pairs(table) do
            count = count + 1
        end
        return setmetatable({}, {
            __index = function(_, k)
                if k == key then
                    return count
                end
                return table[k]
            end,
            __newindex = function(_, k, v)
                if table[k] == nil and v ~= nil then
                    count = count + 1
                end
                if table[k] ~= nil and v == nil then
                    count = count - 1
                end
                table[k] = v
            end,
            __pairs = function(_)
                return pairs(table)
            end,
            __ipairs = function(_)
                return ipairs(table)
            end
        }), ...
    end

    --- Set a default value when fetching missing keys.
    ---@param table table @The table to modify.
    ---@param value string @The value to use.
    function Bakery_API.default_table(table, value, ...)
        local count = 0
        local keys = {}
        for k in pairs(table) do
            keys[k] = true
        end
        return setmetatable({}, {
            __index = function(_, k)
                if not keys[k] then
                    return value
                end
                return table[k]
            end,
            __newindex = function(_, k, v)
                keys[k] = true
                table[k] = v
            end,
            __pairs = function(_)
                return pairs(table)
            end,
            __ipairs = function(_)
                return ipairs(table)
            end
        }), ...
    end

    --- Set a default value used to replace any falsy values.
    ---@param table table @The table to modify.
    ---@param value string @The value to use.
    function Bakery_API.aggressive_default_table(table, value, ...)
        local count = 0
        return setmetatable({}, {
            __index = function(_, k)
                local v = table[k]
                return v or value
            end,
            __newindex = function(_, k, v)
                table[k] = v
            end,
            __pairs = function(_)
                return pairs(table)
            end,
            __ipairs = function(_)
                return ipairs(table)
            end
        }), ...
    end

    --- Creates a `Reset` function, which when called resets the table to {}.
    ---@param table table @The table to modify.
    ---@return table, function
    function Bakery_API.reset_table(table, ...)
        key = key or 'Reset'
        local function reset()
            table = {}
        end
        return setmetatable({}, {
            __index = function(_, k)
                return table[k]
            end,
            __newindex = function(_, k, v)
                table[k] = v
            end,
            __pairs = function(_)
                return pairs(table)
            end,
            __ipairs = function(_)
                return ipairs(table)
            end
        }), reset, ...
    end

    -- Polyfill a tag trigger when scoring
    -- This is a bit of a hack (it retriggers 2s, 3s, 4s, and 5s), but it should work.
    local raw_modify_hand = Blind.modify_hand
    local raw_update_hand_text = update_hand_text
    local raw_back_trigger_effect = Back.trigger_effect
    local animations = {}
    local last_mult, last_chips, last_mod
    function Blind:modify_hand(cards, poker_hands, text, mult, hand_chips)
        local mult, chips, mod = raw_modify_hand(self, cards, poker_hands, text, mult, hand_chips)
        last_mult = mod_mult(mult)
        last_chips = mod_chips(chips)
        last_mod = mod

        local function apply(ret, default_card)
            if not ret then
                return
            end
            mult = mod_mult(mult + (ret.mult or 0))
            mult = mod_mult(mult * (ret.x_mult or 1))
            chips = mod_chips(chips + (ret.chips or 0))
            table.insert(animations, {
                d_mult = ret.mult,
                x_mult = ret.x_mult,
                mult = mult,
                d_chips = ret.chips,
                chips = chips,
                dollars = ret.dollars,
                card = ret.tag or default_card,
                after = ret.after
            })
        end

        for i = 1, #G.GAME.tags do
            apply(G.GAME.tags[i]:apply_to_run({
                type = 'Bakery_play_hand_early'
            }), G.GAME.tags[i])
        end
        return mult, chips, mod or (#animations > 0)
    end

    local function run_animation(anim)
        local skip = Talisman and Talisman.config_file and Talisman.config_file.disable_anims
        if anim.d_chips and anim.d_chips ~= 0 then
            if not skip then
                juice_card(anim.card)
            end
            raw_update_hand_text({
                delay = 0
            }, {
                chips = anim.chips
            })
            if not skip then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.75,
                    func = function()
                        attention_text {
                            text = localize {
                                type = 'variable',
                                key = 'a_chips',
                                vars = { anim.d_chips }
                            },
                            hold = 0.55,
                            backdrop_colour = G.C.CHIPS,
                            major = anim.card.HUD_tag
                        }
                        play_sound('chips1', 0.845 + 0.04 * math.random(), 1)
                        anim.card:juice_up(0.6, 0.1)
                        G.ROOM.jiggle = G.ROOM.jiggle + 0.7
                        return true
                    end
                }))
            end
        end
        if anim.d_mult and anim.d_mult ~= 0 then
            if not skip then
                juice_card(anim.card)
            end
            raw_update_hand_text({
                delay = 0
            }, {
                mult = (anim.x_mult and anim.mult / anim.x_mult) or anim.mult
            })
            if not skip then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.8125,
                    func = function()
                        attention_text {
                            text = localize {
                                type = 'variable',
                                key = 'a_mult',
                                vars = { anim.d_mult }
                            },
                            scale = 0.7,
                            hold = 0.6125,
                            backdrop_colour = G.C.MULT,
                            major = anim.card.HUD_tag
                        }
                        play_sound('multhit1', 0.845 + 0.04 * math.random(), 1)
                        anim.card:juice_up(0.6, 0.1)
                        G.ROOM.jiggle = G.ROOM.jiggle + 0.7
                        return true
                    end
                }))
            end
        end
        if anim.x_mult and anim.x_mult ~= 0 then
            if not skip then
                juice_card(anim.card)
            end
            raw_update_hand_text({
                delay = 0
            }, {
                mult = anim.mult
            })
            if not skip then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.8125,
                    func = function()
                        attention_text {
                            text = localize {
                                type = 'variable',
                                key = 'a_xmult',
                                vars = { anim.x_mult }
                            },
                            scale = 0.7,
                            hold = 0.6125,
                            backdrop_colour = G.C.XMULT,
                            major = anim.card.HUD_tag
                        }
                        play_sound('multhit2', 0.845 + 0.04 * math.random(), 0.7)
                        anim.card:juice_up(0.6, 0.1)
                        G.ROOM.jiggle = G.ROOM.jiggle + 0.7
                        return true
                    end
                }))
            end
        end
        if anim.dollars and anim.dollars ~= 0 then
            if not skip then
                juice_card(anim.card)
            end
            ease_dollars(anim.dollars)
            if not skip then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.8125,
                    func = function()
                        attention_text {
                            text = (amt < -0.01 and '-' or '') .. localize("$") .. tostring(math.abs(amt)),
                            scale = 1,
                            hold = 0.6125,
                            backdrop_colour = amt < -0.01 and G.C.RED or G.C.MONEY,
                            major = anim.card.HUD_tag
                        }
                        play_sound('coin3', 0.845 + 0.04 * math.random(), 0.7)
                        anim.card:juice_up(0.6, 0.1)
                        G.ROOM.jiggle = G.ROOM.jiggle + 0.7
                        return true
                    end
                }))
            end
        end
        if anim.after then
            anim.after()
        end
    end

    function update_hand_text(config, vals)
        if #animations > 0 then
            config.modded = last_mod
            vals.chips = last_chips
            vals.mult = last_mult
        end

        raw_update_hand_text(config, vals)

        for i = 1, #animations do
            run_animation(animations[i])
        end

        animations = {}
    end

    function Back:trigger_effect(args)
        if args.context == 'final_scoring_step' then
            local function handle(ret, tag)
                if ret ~= nil then
                    args.chips = mod_chips(args.chips + (ret.chips or 0))
                    args.mult = mod_mult(args.mult + (ret.mult or 0))
                    args.mult = mod_mult(args.mult * (ret.x_mult or 1))
                    run_animation({
                        d_mult = ret.mult,
                        x_mult = ret.x_mult,
                        mult = args.mult,
                        d_chips = ret.chips,
                        chips = args.chips,
                        card = ret.tag or tag,
                        after = ret.after
                    })
                end
            end

            for i = 1, #G.GAME.tags do
                if not G.GAME.tags[i].triggered then
                    for j = 1, #G.jokers.cards do
                        if not G.jokers.cards[j].debufffed then
                            handle(G.jokers.cards[j]:calculate_joker({
                                Bakery_calculate_tags_late = true,
                                tag = G.GAME.tags[i]
                            }), G.GAME.tags[i])
                        end
                    end
                end
                handle(G.GAME.tags[i]:apply_to_run({
                    type = 'Bakery_play_hand_late'
                }), G.GAME.tags[i])
            end
        end

        local nu_chips, nu_mult = raw_back_trigger_effect(self, args)
        return nu_chips or args.chips, nu_mult or args.mult
    end

    sendInfoMessage("Blind:modify_hand(), update_hand_text(), and Back:trigger_effect() patched. Reason: Scoring tags",
        "Bakery")

    -- END_KEEP_LITE
    -- Polyfill to render Poly Tag specially
    local PolySprite = Sprite:extend()
    function PolySprite:draw(overlay)
        Sprite.draw(self, overlay)

        self.ARGS.send_to_shader = self.ARGS.send_to_shader or {}
        self.ARGS.send_to_shader[1] = math.min(self.VT.r * 3, 1) + G.TIMERS.REAL / (28) +
            (self.juice and self.juice.r * 20 or 0) + self.tilt_var.amt
        self.ARGS.send_to_shader[2] = G.TIMERS.REAL

        self.tilt_var = self.tilt_var or {
            mx = 0,
            my = 0,
            dx = self.tilt_var.dx or 0,
            dy = self.tilt_var.dy or 0,
            amt = 0
        }
        local tilt_factor = 0.3
        if self.states.focus.is then
            self.tilt_var.mx, self.tilt_var.my = G.CONTROLLER.cursor_position.x + self.tilt_var.dx * self.T.w *
                G.TILESCALE * G.TILESIZE, G.CONTROLLER.cursor_position.y +
                self.tilt_var.dy * self.T.h * G.TILESCALE * G.TILESIZE
            self.tilt_var.amt = math.abs(self.hover_offset.y + self.hover_offset.x - 1 + self.tilt_var.dx +
                self.tilt_var.dy - 1) * tilt_factor
        elseif self.states.hover.is then
            self.tilt_var.mx, self.tilt_var.my = G.CONTROLLER.cursor_position.x, G.CONTROLLER.cursor_position.y
            self.tilt_var.amt = math.abs(self.hover_offset.y + self.hover_offset.x - 1) * tilt_factor
        elseif self.ambient_tilt then
            local tilt_angle = G.TIMERS.REAL * (1.56 + (self.ID / 1.14212) % 1) + self.ID / 1.35122
            self.tilt_var.mx = ((0.5 + 0.5 * self.ambient_tilt * math.cos(tilt_angle)) * self.VT.w + self.VT.x +
                G.ROOM.T.x) * G.TILESIZE * G.TILESCALE
            self.tilt_var.my = ((0.5 + 0.5 * self.ambient_tilt * math.sin(tilt_angle)) * self.VT.h + self.VT.y +
                G.ROOM.T.y) * G.TILESIZE * G.TILESCALE
            self.tilt_var.amt = self.ambient_tilt * (0.5 + math.cos(tilt_angle)) * tilt_factor
        end

        self:draw_shader(self.shader, nil, self.ARGS.send_to_shader)
    end

    local PolyTag = Tag:extend()
    function PolyTag:generate_UI(_size)
        local tag_sprite_tab, tag_sprite = Tag.generate_UI(self, _size)
        tag_sprite.tilt_var = {
            mx = 0,
            my = 0,
            dx = 0,
            dy = 0,
            amt = 0
        }
        setmetatable(tag_sprite, PolySprite)
        tag_sprite.shader = self.ability.shader
        return tag_sprite_tab, tag_sprite
    end

    local raw_Tag_load = Tag.load
    function Tag:load(tbl)
        raw_Tag_load(self, tbl)
        if tbl.key == "tag_Bakery_PolyTag" or tbl.key == "tag_BakeryAntiTag" then
            setmetatable(self, PolyTag)
        end
    end

    local raw_Object_call = Object.__call
    function Object:__call(...)
        local arg = { ... }
        if self == Tag then
            if arg[1] == "tag_Bakery_PolyTag" and (G.P_TAGS.tag_Bakery_PolyTag.discovered or not arg[2]) then
                local ret = raw_Object_call(PolyTag, ...)
                ret.ability.shader = 'polychrome'
                return ret
            end
            if arg[1] == "tag_Bakery_AntiTag" and (G.P_TAGS.tag_Bakery_AntiTag.discovered or not arg[2]) then
                local ret = raw_Object_call(PolyTag, ...)
                ret.ability.shader = 'negative'
                return ret
            end
        end
        return raw_Object_call(self, ...)
    end

    sendInfoMessage("Object:__call() and Tag:load() patched. Reason: Rendering Poly Tag", "Bakery")
    -- KEEP_LITE

    -- Maps the keys of Blinds to how many times they've been defeated this session.
    local defeated_blinds, defeated_blinds_reset = Bakery_API.reset_table {}
    Bakery_API.defeated_blinds = Bakery_API.aggressive_default_table(defeated_blinds, 0)

    local raw_Blind_defeat = Blind.defeat
    function Blind:defeat(silent)
        raw_Blind_defeat(self, silent)
        if self.config.blind.key then
            Bakery_API.defeated_blinds[self.config.blind.key] = Bakery_API.defeated_blinds[self.config.blind.key] + 1
        end

        for k, v in ipairs(G.jokers.cards) do
            if v.config.center.key == 'j_Bakery_CardSleeve' and v.ability.extra.occupied then
                local area = Bakery_API.sleevearea_for_key(v.ability.extra.key)
                if area then
                    for k, v in ipairs(area.cards) do
                        if v.facing == "back" then
                            v:flip()
                        end
                    end
                end
            end
        end
    end

    local raw_G_FUNCS_load_profile = G.FUNCS.load_profile
    G.FUNCS.load_profile = function(...)
        defeated_blinds_reset()
        raw_G_FUNCS_load_profile(...)
    end

    sendInfoMessage("Blind:defeat() and G.FUNCS.load_profile() patched. Reason: Unlock conditions", "Bakery")

    -- Any deck or card sleeve whose key is true in this table will receive no money from any source.
    Bakery_API.no_money_decks = {
        b_Bakery_Credit = true,
        sleeve_Bakery_Credit = true
    }

    function Bakery_API.to_number(num) -- This shouldn't be necessary, but Talisman's __lt and __gt aren't working against numbers for whatever reason
        sendWarnMessage("Bakery_API.to_number() is deprecated and will be removed in a future release of Bakery.",
            "Bakery")
        if type(num) == "table" then
            return num:to_number()
        end
        return num
    end

    function Bakery_API.big(x)
        return to_big and type(to_big) == "function" and to_big(x) or x
    end

    local raw_ease_dollars = ease_dollars
    function ease_dollars(mod, instant)
        if G.GAME.modifiers.Bakery_Vagabond then
            mod = math.min(G.GAME.modifiers.Bakery_Vagabond - G.GAME.dollars, mod)
        end

        if mod == nil or Bakery_API.big(mod) <= Bakery_API.big(0) or
            (not Bakery_API.no_money_decks[G.GAME.selected_back_key.key or G.GAME.selected_back_key] and
                not Bakery_API.no_money_decks[G.GAME.selected_sleeve]) then
            return raw_ease_dollars(mod, instant)
        end

        local function _mod()
            local dollar_UI = G.HUD:get_UIE_by_ID('dollar_text_UI')
            attention_text({
                text = localize('k_nope_ex'),
                scale = 0.8,
                hold = 0.7,
                cover = dollar_UI.parent,
                cover_colour = G.C.RED,
                align = 'cm',
                silent = true
            })
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.06 * G.SETTINGS.GAMESPEED,
                blockable = false,
                blocking = false,
                func = function()
                    play_sound('tarot2', 0.76, 0.4);
                    return true
                end
            }))
            play_sound('tarot2', 1, 0.4)
        end
        if instant then
            _mod()
        else
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    _mod()
                    return true
                end
            }))
        end
    end

    sendInfoMessage("ease_dollars() patched. Reason: Credit Deck, Vagabond Challenge", "Bakery")

    local raw_Blind_press_play = Blind.press_play
    function Blind:press_play()
        raw_Blind_press_play(self)

        local sleeve = CardSleeves and CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve or "sleeve_casl_none")
        if sleeve and type(sleeve.calculate) == "function" then
            sleeve:calculate(sleeve, {
                context = 'Bakery_after_press_play'
            })
        end
    end

    sendInfoMessage("Blind:press_play() patched. Reason: Credit Deck + Credit Sleeve", "Bakery")

    -- Any card whose center's key is true in this table will be rendered double sided.
    -- The front sprite of the card should be specified in `config.extra.front_pos`, and the back in `config.extra.back_pos`.
    -- `config.extra.flipped` will be indicate whether the card has been flipped with `Bakery_API.flip_double_sided(card)`.
    -- `config.extra.flipped` does NOT include effects like Amber Acorn.
    Bakery_API.double_sided_jokers = {
        j_Bakery_Werewolf = true,
        j_Bakery_Weerewolf = true,
    }

    -- Flips a double-sided card.
    function Bakery_API.flip_double_sided(card)
        G.E_MANAGER:add_event(Event {
            trigger = 'before',
            delay = 0.2,
            func = function()
                play_sound('tarot1')
                play_sound('card1')
                card.pinch.x = true
                card.flipping = nil
                return true
            end
        })
        G.E_MANAGER:add_event(Event {
            trigger = 'immediate',
            func = function()
                if card.VT.w <= 0 then
                    card.pinch.x = false
                    card.ability.extra.flipped = not card.ability.extra.flipped
                    return true
                end
                return false
            end
        })
        G.E_MANAGER:add_event(Event {
            trigger = 'immediate',
            blocking = false,
            func = function()
                if card.VT.w >= card.T.w then
                    play_sound('tarot2')
                    card:juice_up(0.3, 0.3)
                    return true
                end
                return false
            end
        })
    end

    local raw_Card_draw = Card.draw
    function Card:draw(layer)
        if self.config.center and (self.config.center.discovered or self.params.bypass_discovery_center) and
            Bakery_API.double_sided_jokers[self.config.center.key] then
            local sprite_facing = self.sprite_facing
            self.sprite_facing = "front"
            self.children.center:set_sprite_pos(self.ability.extra.flipped == nil and self.ability.extra.front_pos or
                (self.ability.extra.flipped ~= (sprite_facing == "front") and
                    self.ability.extra.front_pos or self.ability.extra.back_pos) or
                {
                    x = 0.5,
                    y = 0
                })
            raw_Card_draw(self, layer)
            self.sprite_facing = sprite_facing
            return
        end
        raw_Card_draw(self, layer)
    end

    sendInfoMessage("Card:draw() patched. Reason: Werewolf rendering", "Bakery")

    local raw_G_FUNCS_evaluate_round = G.FUNCS.evaluate_round
    function G.FUNCS.evaluate_round(...)
        raw_G_FUNCS_evaluate_round(...)

        for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:calculate_joker({
                Bakery_after_eval = true
            })
        end
    end

    sendInfoMessage("G.FUNCS.evaluate_round() patched. Reason: Spinner Animation", "Bakery")

    local last_chips = 0
    local raw_mod_mult = mod_mult
    function mod_mult(m)
        if G.GAME.modifiers.Bakery_Balanced then
            return math.min(raw_mod_mult(m), math.max(last_chips, 0))
        end
        return raw_mod_mult(m)
    end

    local raw_mod_chips = mod_chips
    function mod_chips(m)
        local ret = raw_mod_chips(m)
        last_chips = ret
        return ret
    end

    local raw_G_FUNCS_evaluate_play = G.FUNCS.evaluate_play
    function G.FUNCS.evaluate_play(...)
        raw_G_FUNCS_evaluate_play(...)
        last_chips = 0
    end

    sendInfoMessage("mod_mult(), mod_chips(), and G.FUNCS.evaluate_play() patched. Reason: Balanced Challenge", "Bakery")

    local raw_G_FUNCS_buy_from_shop = G.FUNCS.buy_from_shop

    G.FUNCS.buy_from_shop = function(e)
        local ret = raw_G_FUNCS_buy_from_shop(e)

        local card = e.config.ref_table
        if card.ability.set == 'Joker' then
            local latest = Bakery_API.get_proxied_joker()
            card.ability.Bakery_purchase_index = latest and (latest.ability.Bakery_purchase_index + 1) or 1
        end

        return ret
    end

    sendInfoMessage("G.FUNCS.buy_from_shop() patched. Reason: Proxy", "Bakery")

    function Bakery_API.crash(message)
        G.E_MANAGER:add_event(Event {
            trigger = "immediate",
            func = function()
                error(message or "Forced crash via Bakery_API.crash()")
            end
        })
    end

    Bakery_API.tag_effect_names = {}
    Bakery_API.tag_effect_names_t = {}

    local raw_eval_card = eval_card
    function eval_card(card, context)
        local ret, trig = raw_eval_card(card, context)

        if context.cardarea == G.play and context.main_scoring then
            for i = 1, #G.GAME.tags do
                local suffix = ''
                while ret['tag' .. i .. suffix] do
                    suffix = suffix .. 'x'
                end
                if not Bakery_API.tag_effect_names_t['tag' .. i .. suffix] then
                    Bakery_API.tag_effect_names_t['tag' .. i .. suffix] = true
                    Bakery_API.tag_effect_names[#Bakery_API.tag_effect_names + 1] = 'tag' .. i .. suffix
                end
                ret['tag' .. i .. suffix] = G.GAME.tags[i]:apply_to_run({
                    type = 'Bakery_score_card',
                    card = card
                })
            end
        end
        return ret, trig
    end

    sendInfoMessage("eval_card() patched. Reason: Penny Tag", "Bakery")

    local raw_SMODS_calculate_repetitions = SMODS.calculate_repetitions
    SMODS.calculate_repetitions = function(card, context, reps, ...)
        for i = 1, #G.GAME.tags do
            local eval = G.GAME.tags[i]:apply_to_run({
                type = 'Bakery_add_repetitions_to_card',
                context = context
            })
            if eval then
                reps[#reps + 1] = { key = eval }
            end
        end
        return raw_SMODS_calculate_repetitions(card, context, reps, ...)
    end

    sendInfoMessage("SMODS.calculate_repetitions() patched. Reason: Up Tag", "Bakery")

    local raw_Blind_set_text = Blind.set_text
    function Blind:set_text(...)
        raw_Blind_set_text(self, ...)
        local blind = self.config.blind
        if blind and (blind.artist or blind.coder or blind.idea) then
            self.loc_debuff_lines[#self.loc_debuff_lines + 1] = ""
            if blind.artist == blind.coder and blind.coder == blind.idea then
                if Bakery_API.contributors[blind.artist] then
                    local creator = Bakery_API.contributors[blind.artist]
                    self.loc_debuff_lines[#self.loc_debuff_lines + 1] = localize {
                        type = 'variable',
                        key = 'v_Bakery_by',
                        vars = { creator.name }
                    }
                return
                end
            end
            if blind.artist then
                if Bakery_API.contributors[blind.artist] then
                    local artist = Bakery_API.contributors[blind.artist]
                    self.loc_debuff_lines[#self.loc_debuff_lines + 1] = localize {
                        type = 'variable',
                        key = 'v_Bakery_artist',
                        vars = { artist.name }
                    }
                end
            end
            if blind.coder then
                if Bakery_API.contributors[blind.coder] then
                    local coder = Bakery_API.contributors[blind.coder]
                    self.loc_debuff_lines[#self.loc_debuff_lines + 1] = localize {
                        type = 'variable',
                        key = 'v_Bakery_coder',
                        vars = { coder.name }
                    }
                end
            end
            if blind.idea then
                if Bakery_API.contributors[blind.idea] then
                    local idea = Bakery_API.contributors[blind.idea]
                    self.loc_debuff_lines[#self.loc_debuff_lines + 1] = localize {
                        type = 'variable',
                        key = 'v_Bakery_idea',
                        vars = { idea.name }
                    }
                end
            end
        end
    end

    local raw_create_UIBox_blind_popup = create_UIBox_blind_popup
    function create_UIBox_blind_popup(blind, discovered, vars, ...)
        local ret = raw_create_UIBox_blind_popup(blind, discovered, vars, ...)
        local txt = ret.nodes[2].nodes[1].nodes[4]
        if txt and (blind.artist or blind.coder or blind.idea) then
            local function make(kind, contrib)
                txt.nodes[#txt.nodes + 1] =
                { n = G.UIT.R, config = { align = "cm" }, colour = contrib.bg, nodes = { { n = G.UIT.T, config = { text = localize { type = 'variable', key = kind, vars = { contrib.name } }, scale = 0.2, shadow = true, colour = contrib.fg } } } }
            end
            if blind.artist == blind.coder and blind.coder == blind.idea and Bakery_API.contributors[blind.artist] then
                make("v_Bakery_by", Bakery_API.contributors[blind.artist])
            else
                if blind.artist and Bakery_API.contributors[blind.artist] then
                    make("v_Bakery_artist", Bakery_API.contributors[blind.artist])
                end
                if blind.coder and Bakery_API.contributors[blind.coder]then
                    make("v_Bakery_coder", Bakery_API.contributors[blind.coder])
                end
                if blind.idea and Bakery_API.contributors[blind.idea] then
                    make("v_Bakery_idea", Bakery_API.contributors[blind.idea])
                end
            end
        end
        return ret
    end

    function Bakery_API.credit(obj)
        local raw_obj_set_badges = obj.set_badges
        obj.set_badges = function(self, card, badges)
            if self.set == "Enhanced" or self.discovered or card.bypass_discovery_center then
                if self.artist and self.artist == self.coder and self.coder == self.idea then
                    local creator = Bakery_API.contributors[self.artist]
                    badges[#badges + 1] = create_badge(localize {
                        type = 'variable',
                        key = 'v_Bakery_by',
                        vars = { creator.name }
                    }, creator.bg or G.C.RED, creator.fg or G.C.BLACK, 0.7)
                else
                    if self.artist then
                        local artist = Bakery_API.contributors[self.artist]
                        badges[#badges + 1] = create_badge(localize {
                            type = 'variable',
                            key = 'v_Bakery_artist',
                            vars = { artist.name }
                        }, artist.bg or G.C.RED, artist.fg or G.C.BLACK, 0.7)
                    end
                    if self.coder then
                        local coder = Bakery_API.contributors[self.coder]
                        badges[#badges + 1] = create_badge(localize {
                            type = 'variable',
                            key = 'v_Bakery_coder',
                            vars = { coder.name }
                        }, coder.bg or G.C.RED, coder.fg or G.C.BLACK, 0.7)
                    end
                    if self.idea then
                        local idea = Bakery_API.contributors[self.idea]
                        badges[#badges + 1] = create_badge(localize {
                            type = 'variable',
                            key = 'v_Bakery_idea',
                            vars = { idea.name }
                        }, idea.bg or G.C.RED, idea.fg or G.C.BLACK, 0.7)
                    end
                end
            end
            if raw_obj_set_badges then
                raw_obj_set_badges(self, card, badges)
            end
        end
        return obj
    end

    function Bakery_API.interest_scale(no_big)
        local scale = 5
        if G.GAME.Bakery_charm == 'BakeryCharm_Bakery_Coin' then
            scale = G.Bakery_charm_area.cards[1].ability.extra.mod
        end
        return not no_big and to_big and to_big(scale) or scale
    end

    function Bakery_API.on_set_blind(blind)
        for i = 1, #G.GAME.tags do
            G.GAME.tags[i]:apply_to_run({
                type = 'Bakery_set_blind',
                blind = blind
            })
        end
    end
end)
-- END_KEEP_LITE
