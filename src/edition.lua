SMODS.Shader({
	key = "Bakery_Carbon",
	path = "Bakery_Carbon.fs",
})

SMODS.Edition({
	key = "Carbon",
	shader = "Bakery_Carbon",
	weight = 0,
	calculate = function(self, card, context)
		if
			card.area ~= G.hand
			and card.area ~= G.play
			and not card.debuff
			and context.after
			and (not card.area or card.area ~= G.hand)
			and not card.ability.eternal
		then
			G.E_MANAGER:add_event(Event({
				func = function()
					if SMODS.shatters(card) then
						card:shatter()
					else
						card:start_dissolve(nil, true)
					end
					return true
				end,
			}))
		end
		if
			not card.debuff
			and context.destroy_card == card
			and (not card.area or card.area ~= G.hand)
			and not card.ability.eternal
		then
			return {
				remove = true,
			}
		end
	end,
	in_pool = function()
		return false
	end,
})
