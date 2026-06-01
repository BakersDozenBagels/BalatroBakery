Bakery_API.guard(function()
    Bakery_API.retrigger_jokers = setmetatable({}, {
        __index = function(_, k)
            sendWarnMessage(
                "Bakery_API.retrigger_jokers is deprecated and will be removed in a future release. Use Card:has_attribute('retrigger') instead.",
                'Bakery')
            return (G.P_CENTERS[k].attributes or {}).retrigger
        end,
        __newindex = function(_, k, v)
            sendWarnMessage(
                "Bakery_API.retrigger_jokers is deprecated and will be removed in a future release. Set the 'retrigger' attribute instead.",
                'Bakery')
            if k == true then
                G.P_CENTERS[k].attributes = G.P_CENTERS[k].attributes or {}
                G.P_CENTERS[k].attributes[#G.P_CENTERS[k].attributes + 1] = 'retrigger'
                G.P_CENTERS[k].attributes.retrigger = true
                SMODS.Attributes.retrigger.keys = SMODS.merge_lists({ SMODS.Attributes.retrigger.keys or {}, { k } })
            end
        end
    })
end)
