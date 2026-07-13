SMODS.Atlas({
	key = "BakeryBack",
	path = "BakeryBack.png",
	px = 71,
	py = 95,
})

local b_violet = SMODS.Back({
	key = "Violet",
	name = "Violet",
	config = {
		extra = {
			x_mult = 2,
		},
	},
	atlas = "BakeryBack",
	pos = {
		x = 0,
		y = 0,
	},
	unlocked = false,
	discovered = false,
	check_for_unlock = function(self, args)
		return Bakery_API.defeated_blinds["bl_final_vessel"] > 0
	end,
	locked_loc_vars = function(self, args)
		if G.P_BLINDS["bl_final_vessel"].discovered then
			return {
				vars = {
					localize({
						type = "name_text",
						key = "bl_final_vessel",
						set = "Blind",
					}),
				},
			}
		end
		return {
			vars = { localize("k_unknown") },
		}
	end,
	loc_vars = function(self, info_queue, back)
		return {
			vars = { self.config.extra.x_mult },
		}
	end,
	calculate = function(self, back, args)
		if args.context == "final_scoring_step" then
			args.mult = args.mult * self.config.extra.x_mult

			local skip = Talisman and Talisman.config_file and Talisman.config_file.disable_anims

			update_hand_text({
				delay = 0,
			}, {
				mult = args.mult,
			})
			if not skip then
				G.E_MANAGER:add_event(Event({
					trigger = "before",
					delay = 0.8125,
					func = function()
						attention_text({
							text = localize({
								type = "variable",
								key = "a_xmult",
								vars = { self.config.extra.x_mult },
							}),
							scale = 1.4,
							hold = 2,
							offset = {
								x = 0,
								y = -2.7,
							},
							major = G.play,
						})
						play_sound("multhit2", 0.845 + 0.04 * math.random(), 0.7)
						G.ROOM.jiggle = G.ROOM.jiggle + 0.7
						return true
					end,
				}))
			end

			return args.chips, args.mult
		end
	end,
})

local function is_double_house()
	return G.GAME.selected_sleeve == "sleeve_Bakery_House"
		and ((G.GAME.selected_back_key and G.GAME.selected_back_key.key) or G.GAME.selected_back.key)
			== "b_Bakery_House"
end
local b_house = SMODS.Back({
	key = "House",
	name = "House",
	config = {
		extra = {
			odds_bottom = 4,
		},
	},
	atlas = "BakeryBack",
	pos = {
		x = 1,
		y = 0,
	},
	unlocked = false,
	discovered = false,
	check_for_unlock = function(self, args)
		local a, b = pcall(function()
			return get_deck_win_stake("b_erratic") > 0
		end)
		return a and b
	end,
	locked_loc_vars = function(self, back)
		if G.P_CENTERS["b_erratic"].discovered then
			return {
				vars = {
					localize({
						type = "name_text",
						key = "b_erratic",
						set = "Back",
					}),
				},
			}
		end
		return {
			vars = { localize("k_unknown") },
		}
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				SMODS.get_probability_vars(
					self,
					is_double_house() and 2 or 1,
					self.config.extra.odds_bottom,
					"b_Bakery_House"
				),
			},
		}
	end,
	calculate = function(self, back, args)
		if args.context == "final_scoring_step" then
			local anim = {}

			local double = is_double_house()

			for i = 1, #G.play.cards do
				if
					SMODS.pseudorandom_probability(
						self,
						"b_Bakery_House",
						double and 2 or 1,
						self.config.extra.odds_bottom
					)
				then
					table.insert(anim, G.play.cards[i])
				end
			end

			if #anim == 0 then
				return
			end

			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.4,
				func = function()
					play_sound("tarot1")
					return true
				end,
			}))
			for i = 1, #anim do
				local percent = 1.15 - (i - 0.999) / (#anim - 0.998) * 0.3
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.15,
					func = function()
						anim[i]:flip()
						play_sound("card1", percent)
						anim[i]:juice_up(0.3, 0.3)
						return true
					end,
				}))
			end

			delay(0.2)

			for i = 1, #anim do
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.1,
					func = function()
						local card = anim[i]
						local rank = pseudorandom_element(SMODS.Ranks, pseudoseed("HouseDeck")).card_key
						local suit = pseudorandom_element(SMODS.Suits, pseudoseed("HouseDeck")).card_key
						card:set_base(G.P_CARDS[suit .. "_" .. rank])
						if double then
							if not card.edition then
								local ed = SMODS.poll_edition({ key = "HouseDeck", no_negative = true })
								if ed then
									card:set_edition(ed)
								end
							end
							if card.ability.name == G.P_CENTERS.c_base.name then
								local en = SMODS.poll_enhancement({
									type_key = "HouseDeck",
								})
								if en then
									card:set_ability(G.P_CENTERS[en])
								end
							end
							if not card:get_seal(true) then
								local se = SMODS.poll_seal({
									type_key = "HouseDeck",
								})
								if se then
									card:set_seal(se)
								end
							end
						end
						return true
					end,
				}))
				local percent = 0.85 + (i - 0.999) / (#anim - 0.998) * 0.3
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.15,
					func = function()
						anim[i]:flip()
						play_sound("tarot2", percent, 0.6)
						anim[i]:juice_up(0.3, 0.3)
						return true
					end,
				}))
			end

			delay(0.7)
		end
	end,
})

-- KEEP_LITE
Bakery_API.guard(function()
	-- Items that, with the Credit Deck, can never be better than the same item doing absolutely nothing.
	-- For example, Egg is not on this list, since sell value can still matter for Swashbuckler or Ceremonial Dagger.
	-- Neither is Midas Mask, since it can feed Vampire or Driver's License.
	Bakery_API.econ_only_items = {
		"j_delayed_grat",
		"j_business",
		"j_faceless",
		"j_cloud_9",
		"j_rocket",
		"j_reserved_parking",
		"j_mail",
		"j_to_the_moon",
		"j_golden",
		"j_ticket",
		"j_rough_gem",
		"j_satellite",
		"j_todo_list",
		"j_Bakery_Auctioneer",
		"v_seed_money",
		"v_money_tree",
		"c_hermit",
		"c_temperance",
		"tag_skip",
		"tag_economy",
		"tag_garbage",
		"tag_handy",
		"tag_Bakery_TopTag",
		"tag_Bakery_BottomTag",
		"BakeryCharm_Bakery_Coin",
		"BakeryCharm_Bakery_Obsession",
		"BakeryCharm_Bakery_Revolve",
		"BakeryCharm_Bakery_Epitaph",
		"BakeryCharm_Bakery_Fractal",
	}
end)
-- END_KEEP_LITE

local b_credit = SMODS.Back({
	key = "Credit",
	name = "Credit",
	config = {
		dollars = 200,
		no_interest = true,
	},
	atlas = "Joker",
	prefix_config = {
		atlas = false,
	},
	pos = {
		x = 5,
		y = 1,
	},
	unlocked = false,
	discovered = false,
	check_for_unlock = function(self, args)
		local s, v = pcall(get_deck_win_stake, "b_yellow")
		return s and v > 3
	end,
	locked_loc_vars = function(self, back)
		if G.P_CENTERS["b_yellow"].discovered then
			return {
				vars = {
					localize({
						type = "name_text",
						key = "b_yellow",
						set = "Back",
					}),
					localize({
						type = "name_text",
						set = "Stake",
						key = "stake_black",
					}),
					colours = { G.C.BLACK },
				},
			}
		end
		return {
			vars = {
				localize("k_unknown"),
				localize({
					type = "name_text",
					set = "Stake",
					key = "stake_black",
				}),
				colours = { G.C.BLACK },
			},
		}
	end,
	loc_vars = function(self, info_queue, back)
		return {
			vars = { self.config.dollars },
		}
	end,
	apply = function(self, back)
		G.GAME.modifiers.no_blind_reward = {
			Small = true,
			Big = true,
			Boss = true,
		}
		G.GAME.modifiers.no_extra_hand_money = true
		for _, k in ipairs(Bakery_API.econ_only_items) do
			G.GAME.banned_keys[k] = true
		end
	end,
})

local b_dn = SMODS.Back({
	key = "DN",
	name = "DN",
	atlas = "BakeryBack",
	pos = {
		x = 3,
		y = 0,
	},
	apply = function(self, back)
		G.GAME.modifiers.Bakery_advantage = (G.GAME.modifiers.Bakery_advantage or 0) + 1
	end,
})

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

local function is_double_dominion()
	return G.GAME.selected_sleeve == "sleeve_Bakery_Dominion"
		and ((G.GAME.selected_back_key and G.GAME.selected_back_key.key) or G.GAME.selected_back.key)
			== "b_Bakery_Dominion"
end
local b_dominion = Bakery_API.credit(SMODS.Back({
	key = "Dominion",
	name = "Dominion",
	config = {
		-- Global config
		hand_size_penalty = 3,
		joker_count = 3,
		joker = "j_Bakery_Estate",
		-- Normal-only config
		hand_size_per_period = 1,
		ante_period = 2,
		extra = {
			highest_ante_yet = 1,
		},
	},
	atlas = "BakeryBack",
	pos = {
		x = 4,
		y = 0,
	},
	artist = "Jack5",
	coder = "Jack5",
	idea = "Jack5",
	unlocked = false,
	---Have at least 3 of any one Joker
	check_for_unlock = function(self, args)
		if not G.jokers or not G.jokers.cards or #G.jokers.cards < 3 then
			return false
		end

		local joker_key_counts = {}
		for _, joker in ipairs(G.jokers.cards) do
			joker_key_counts[joker.config.center.key] = (joker_key_counts[joker.config.center.key] or 0) + 1
			if joker_key_counts[joker.config.center.key] >= 3 then
				return true
			end
		end
	end,
	locked_loc_vars = function(self, args)
		return { vars = { 3 } }
	end,
	loc_vars = function(self, info_queue, back)
		return {
			vars = {
				self.config.hand_size_penalty,
				self.config.joker_count,
				localize({
					type = "name_text",
					key = self.config.joker,
					set = "Joker",
				}),
				self.config.hand_size_per_period,
				self.config.ante_period,
			},
		}
	end,
	---Applies the initial effects of the Dominion Deck and Sleeve, those being:
	---Start with -3 hand size and 3 Estate Jokers
	apply = function(self, back)
		G.E_MANAGER:add_event(Event({
			func = function()
				G.hand:change_size(-self.config.hand_size_penalty)
				for _ = 1, self.config.joker_count do
					local joker = create_card("Joker", nil, nil, nil, nil, nil, self.config.joker)
					G.jokers:emplace(joker)
				end
				return true
			end,
		}))
	end,
	---+1 hand size every 2 Antes
	calculate = function(self, back, context)
		if not is_double_dominion() and G.GAME.round_resets.ante > self.config.extra.highest_ante_yet then
			-- Ensure that this triggers for all Antes that haven't triggered yet
			local period_triggers = 0
			for i = self.config.extra.highest_ante_yet + 1, G.GAME.round_resets.ante do
				if (i + 1) % self.config.ante_period == 0 then -- Starting from Ante 1
					period_triggers = period_triggers + 1
				end
			end
			for _ = 1, period_triggers do
				G.hand:change_size(self.config.hand_size_per_period)
			end
			self.config.extra.highest_ante_yet = G.GAME.round_resets.ante
		end
	end,
}))

local function find_texas(x)
	local res = {}
	for _, card in pairs(G.I.CARD) do
		card.ability = card.ability or {}
		if card.ability.Bakery_texas and card.ability.Bakery_texas == x then
			res[#res + 1] = card
		end
	end
	return res
end

local b_lone_star = Bakery_API.credit(SMODS.Back({
	key = "LoneStar",
	name = "LoneStar",
	atlas = "BakeryBack",
	idea = "RedsToad",
	pos = { x = 5, y = 0 },
	unlocked = false,
	discovered = false,
	check_for_unlock = function(self, args)
		local a, b = pcall(function()
			return get_deck_win_stake("b_Bakery_House") > 0
		end)
		return a and b
	end,
	locked_loc_vars = function(self, back)
		if G.P_CENTERS["b_Bakery_House"].discovered then
			return {
				vars = {
					localize({
						type = "name_text",
						key = "b_Bakery_House",
						set = "Back",
					}),
				},
			}
		end
		return {
			vars = { localize("k_unknown") },
		}
	end,
	apply = function()
		G.E_MANAGER:add_event(Event({
			func = function()
				G.hand:change_size(-1)
				G.hand.config.highlighted_limit = 1 / 0 -- Infinity
				G.GAME.modifiers.Bakery_texas_hold_em = true
				G.GAME.Bakery_texas_hold_em_phase = 0
				return true
			end,
		}))
	end,
	calculate = function(self, card, context)
		if context.pre_discard then
			G.GAME.Bakery_texas_hold_em_phase = G.GAME.Bakery_texas_hold_em_phase + 1
			for _, card in pairs(find_texas(G.GAME.Bakery_texas_hold_em_phase)) do
				if card.facing == "back" then
					card:flip()
				end
			end
			G.hand:parse_highlighted() -- After discarding 0 cards
		end

		if context.after then
			G.GAME.Bakery_texas_hold_em_phase = 0
			if G.GAME.round_resets.discards - G.GAME.current_round.discards_left > 0 then
				ease_discard(G.GAME.round_resets.discards - G.GAME.current_round.discards_left)
			end
		end

		if context.hand_drawn then
			G.hand:parse_highlighted()
		end
	end,
}))

-- Queue this to put it after Anaglyph Lens (and any modded hooks)
G.E_MANAGER:add_event(Event({
	blocking = false,
	blockable = false,
	func = function()
		local raw_evaluate_poker_hand = evaluate_poker_hand
		function evaluate_poker_hand(cards, ...)
			if not G.GAME.modifiers.Bakery_texas_hold_em or #cards <= 5 then
				return raw_evaluate_poker_hand(cards, ...)
			end

			local results = {}
			for i = 1, #cards - 4 do
				for j = i + 1, #cards - 3 do
					for k = j + 1, #cards - 2 do
						for l = k + 1, #cards - 1 do
							for m = l + 1, #cards do
								local res =
									raw_evaluate_poker_hand({ cards[i], cards[j], cards[k], cards[l], cards[m] })
								for k, v in pairs(res) do
									results[k] = results[k] or {}
									for _, v in ipairs(res[k]) do
										results[k][#results[k] + 1] = v
									end
								end
							end
						end
					end
				end
			end

			for _, v in ipairs(G.handlist) do
				if not results.top and results[v] then
					results.top = results[v]
					break
				end
			end

			return results
		end
		return true
	end,
}))

local raw_Blind_stay_flipped = Blind.stay_flipped
function Blind:stay_flipped(to, card, from, ...)
	local ret = raw_Blind_stay_flipped(self, to, card, from, ...)

	if not G.GAME.modifiers.Bakery_texas_hold_em or not G.GAME.facing_blind then
		return ret
	end

	card.ability = card.ability or {}

	if to ~= G.hand then
		card.ability.Bakery_texas = nil
	else
		if #find_texas(1) < 3 then
			card.ability.Bakery_texas = 1
			card.ability.Bakery_texas_extra = #find_texas(1)
			return true
		elseif #find_texas(2) < 1 then
			card.ability.Bakery_texas = 2
			card.ability.Bakery_texas_extra = 4
			return true
		elseif #find_texas(3) < 1 then
			card.ability.Bakery_texas = 3
			card.ability.Bakery_texas_extra = 5
			return true
		end
	end

	return ret
end

local raw_G_FUNCS_can_discard = G.FUNCS.can_discard
function G.FUNCS.can_discard(e, ...)
	if G.GAME.modifiers.Bakery_texas_hold_em then
		for _, card in pairs(G.hand.highlighted) do
			card.ability = card.ability or {}
			if card.ability.Bakery_texas then
				e.config.colour = G.C.UI.BACKGROUND_INACTIVE
				e.config.button = nil
				return
			end
		end
	end

	return raw_G_FUNCS_can_discard(e, ...)
end

local raw_G_FUNCS_can_play = G.FUNCS.can_play
function G.FUNCS.can_play(e, ...)
	if G.GAME.modifiers.Bakery_texas_hold_em then
		e.config.colour = G.C.BLUE
		e.config.button = "Bakery_play_texas_hold_em"
		return
	end

	return raw_G_FUNCS_can_play(e, ...)
end

function G.FUNCS.Bakery_play_texas_hold_em(e, ...)
	for _, card in pairs(G.hand.cards) do
		if not card.highlighted then
			G.hand:add_to_highlighted(card, true)
		end
	end
	return G.FUNCS.play_cards_from_highlighted(e, ...)
end

local raw_CardArea_parse_highlighted = CardArea.parse_highlighted
function CardArea:parse_highlighted(...)
	if not G.GAME.modifiers.Bakery_texas_hold_em then
		return raw_CardArea_parse_highlighted(self, ...)
	end

	local visible = {}
	local any_backwards = false
	local all_backwards = true
	for _, card in ipairs(self.cards) do
		if card.facing ~= "back" then
			visible[#visible + 1] = card
			all_backwards = false
		else
			any_backwards = true
		end
	end

	G.boss_throw_hand = nil
	local text, disp_text, poker_hands = G.FUNCS.get_poker_hand_info(visible)
	if text == "NULL" then
		update_hand_text(
			{ immediate = true, nopulse = true, delay = 0 },
			{ mult = 0, chips = 0, level = "", handname = "" }
		)
		for name, parameter in pairs(SMODS.Scoring_Parameters) do
			update_hand_text({ immediate = true, nopulse = true, delay = 0 }, { [name] = parameter.default_value })
		end
		return
	end

	if G.GAME.blind and G.GAME.blind:debuff_hand(self.highlighted, poker_hands, text, true) then
		G.boss_throw_hand = true
	end

	if all_backwards then
		update_hand_text(
			{ immediate = true, nopulse = nil, delay = 0 },
			{ handname = "????", level = "?", mult = "?", chips = "?" }
		)
		for name in pairs(SMODS.Scoring_Parameters) do
			update_hand_text({ immediate = true, nopulse = nil, delay = 0 }, { [name] = "?" })
		end
		return
	end

	local function fix(x)
		return any_backwards and localize({ type = "variable", key = "v_Bakery_value?", vars = { x } }) or x
	end

	for name, parameter in pairs(SMODS.Scoring_Parameters) do
		parameter.current = G.GAME.hands[text][name] or parameter.default_value
		update_hand_text({ immediate = true, nopulse = nil, delay = 0 }, { [name] = fix(parameter.current) })
	end
	update_hand_text({ immediate = true, nopulse = nil, delay = 0 }, {
		handname = fix(disp_text),
		level = fix(G.GAME.hands[text].level),
		mult = fix(G.GAME.hands[text].mult),
		chips = fix(G.GAME.hands[text].chips),
	})
end

local texas_atlas = SMODS.Atlas({
	key = "BakeryTexas",
	path = "BakeryTexas.png",
	px = 71,
	py = 95,
})
G.E_MANAGER:add_event(Event({
	func = function()
		Bakery_API.texas_hold_em_stickers = {
			Sprite(0, 0, G.CARD_W, G.CARD_H, texas_atlas, { x = 0, y = 0 }),
			Sprite(0, 0, G.CARD_W, G.CARD_H, texas_atlas, { x = 1, y = 0 }),
			Sprite(0, 0, G.CARD_W, G.CARD_H, texas_atlas, { x = 2, y = 0 }),
			Sprite(0, 0, G.CARD_W, G.CARD_H, texas_atlas, { x = 3, y = 0 }),
			Sprite(0, 0, G.CARD_W, G.CARD_H, texas_atlas, { x = 4, y = 0 }),
		}
	end,
}))

SMODS.DrawStep({
	key = "texas_hold_em",
	order = 47,
	func = function(card, layer)
		card.ability = card.ability or {}
		if not card.ability.Bakery_texas then
			return
		end

		---@type Sprite
		local sticker = Bakery_API.texas_hold_em_stickers[card.ability.Bakery_texas_extra]
		sticker.role.draw_major = card
		sticker:draw_shader("dissolve", nil, nil, nil, card.children.center)
	end,
})

if CardSleeves then
	SMODS.Atlas({
		key = "BakerySleeves",
		path = "BakerySleeves.png",
		px = 73,
		py = 95,
	})

	CardSleeves.Sleeve({
		key = "Violet",
		atlas = "BakerySleeves",
		pos = {
			x = 0,
			y = 0,
		},
		unlocked = false,
		unlock_condition = {
			deck = "b_Bakery_Violet",
			stake = "stake_black",
		},
		calculate = b_violet.calculate,
		config = b_violet.config,
		loc_vars = b_violet.loc_vars,
	})

	CardSleeves.Sleeve({
		key = "House",
		atlas = "BakerySleeves",
		pos = {
			x = 1,
			y = 0,
		},
		unlocked = false,
		unlock_condition = {
			deck = "b_Bakery_House",
			stake = "stake_red",
		},
		config = b_house.config,
		calculate = function(self, sleeve, context)
			if self.get_current_deck_key() ~= "b_Bakery_House" then
				return b_house.calculate(self, sleeve, context)
			end
		end,
		loc_vars = function(self)
			if self.get_current_deck_key() ~= "b_Bakery_House" then
				return b_house.loc_vars(self)
			end
			return {
				key = self.key .. "_alt",
			}
		end,
	})

	CardSleeves.Sleeve({
		key = "Credit",
		atlas = "BakerySleeves",
		pos = {
			x = 2,
			y = 0,
		},
		unlocked = false,
		unlock_condition = {
			deck = "b_Bakery_Credit",
			stake = "stake_black",
		},
		config = {
			dollars = 200,
			alt_dollars = 100,
			no_interest = true,
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
				vars = { dollars },
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
			if self.get_current_deck_key() == "b_Bakery_Credit" and context.context == "Bakery_after_press_play" then
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.2,
					func = function()
						for i = 1, #G.play.cards do
							G.E_MANAGER:add_event(Event({
								func = function()
									G.play.cards[i]:juice_up()
									return true
								end,
							}))
							ease_dollars(-1)
							delay(0.23)
						end
						return true
					end,
				}))
			end
		end,
	})

	CardSleeves.Sleeve({
		key = "DN",
		atlas = "BakerySleeves",
		pos = {
			x = 3,
			y = 0,
		},
		unlocked = false,
		unlock_condition = {
			deck = "b_Bakery_DN",
			stake = "stake_white",
		},
		apply = b_dn.apply,
		loc_vars = function(self)
			if self.get_current_deck_key() == "b_Bakery_DN" then
				return {
					key = self.key .. "_alt",
				}
			end
		end,
	})

	Bakery_API.credit(CardSleeves.Sleeve({
		key = "Dominion",
		atlas = "BakerySleeves",
		pos = {
			x = 4,
			y = 0,
		},
		artist = "Jack5",
		coder = "Jack5",
		idea = "Jack5",
		unlocked = false,
		config = {
			-- Global config
			hand_size_penalty = 3,
			joker_count = 3,
			joker = "j_Bakery_Estate",
			-- Normal-only config
			hand_size_per_period = 1,
			ante_period = 2,
			extra = {
				highest_ante_yet = 1,
			},
			-- Combo config
			vouchers = {
				"v_magic_trick",
				"v_illusion",
			},
			combo_cards_count = 7,
		},
		unlock_condition = {
			deck = "b_Bakery_Dominion",
			stake = "stake_white",
		},
		loc_vars = function(self, info_queue, back)
			local key = self.key
			local vars = {
				self.config.hand_size_penalty,
				self.config.joker_count,
				localize({
					type = "name_text",
					key = self.config.joker,
					set = "Joker",
				}),
			}
			-- Normal-only localisation
			if self.get_current_deck_key() ~= "b_Bakery_Dominion" then
				table.insert(vars, self.config.hand_size_per_period)
				table.insert(vars, self.config.ante_period)
			else -- Combo localisation
				key = key .. "_alt"
				table.insert(vars, self.config.combo_cards_count)
				table.insert(
					vars,
					localize({
						type = "name_text",
						key = self.config.vouchers[1],
						set = "Voucher",
					})
				)
				table.insert(
					vars,
					localize({
						type = "name_text",
						key = self.config.vouchers[2],
						set = "Voucher",
					})
				)
			end
			return {
				key = key,
				vars = vars,
			}
		end,
		apply = function(self, back)
			if not is_double_dominion() then
				return b_dominion.apply(self, back)
			end
			-- Combo effects: Start with -3 hand size, 3 Estate Jokers, 7 total cards and Illusion Voucher
			G.E_MANAGER:add_event(Event({
				func = function()
					-- Remove all but 7 cards
					local keep_cards = {}
					local kept = 0
					while kept < self.config.combo_cards_count do
						local keep_card = pseudorandom_element(G.playing_cards, pseudoseed("Nothin'ButCoppers"))
						if not keep_cards[keep_card] then
							keep_cards[keep_card] = true
							kept = kept + 1
						end
					end
					for _, card in pairs(G.playing_cards) do
						if not keep_cards[card] then
							card:start_dissolve(nil)
						end
					end
					return true
				end,
			}))
			for k, v in pairs(self.config.vouchers) do
				G.GAME.used_vouchers[v] = true
				G.GAME.starting_voucher_count = (G.GAME.starting_voucher_count or 0) + 1
				G.E_MANAGER:add_event(Event({
					func = function()
						Card.apply_to_run(nil, G.P_CENTERS[v])
						return true
					end,
				}))
			end
		end,
		calculate = b_dominion.calculate,
	}))

	Bakery_API.credit(CardSleeves.Sleeve({
		key = "United",
		atlas = "BakerySleeves",
		idea = "RedsToad",
		pos = {
			x = 5,
			y = 0,
		},
		unlocked = false,
		unlock_condition = {
			deck = "b_Bakery_LoneStar",
			stake = "stake_white",
		},
		loc_vars = function(self)
			local key = self.key
			if self.get_current_deck_key() == "b_Bakery_LoneStar" then
				key = key .. "_alt"
			end
			return { key = key, vars = { 2 } }
		end,
		apply = function(self)
			if self.get_current_deck_key() == "b_Bakery_LoneStar" then
				G.E_MANAGER:add_event(Event({
					func = function()
						G.hand:change_size(2)
						return true
					end,
				}))
			else
				b_lone_star.apply()
			end
		end,
		calculate = function(self, ...)
			if self.get_current_deck_key() ~= "b_Bakery_LoneStar" then
				b_lone_star.calculate(self, ...)
			end
		end,
	}))
end
