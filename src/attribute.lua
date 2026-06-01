--KEEP_LITE
Bakery_API.guard(function()
    -- Any Joker with a use button from Bakery. Automatically populated
    SMODS.Attribute {
        key = "bakery_usable"
    }

    -- Any card with this attribute will be rendered double sided.
    -- The front sprite of the card should be specified in `config.extra.front_pos`, and the back in `config.extra.back_pos`.
    -- `config.extra.flipped` will be indicate whether the card has been flipped with `Bakery_API.flip_double_sided(card)`.
    -- `config.extra.flipped` does NOT include effects like Amber Acorn.
    SMODS.Attribute {
        key = "bakery_double_sided"
    }

    -- Any Joker that Full Moon considers to be a werewolf
    SMODS.Attribute {
        key = "bakery_werewolf"
    }

    local function process(center)
        if (center.attributes or {}).bakery_usable then
            sendErrorMessage(
                center.key ..
                " manually specified the 'bakery_usable' attribute. This attribute is applied automatically.",
                "Bakery")
        end
        if type(center.Bakery_use_joker) == "function" then
            center.attributes = center.attributes or {}
            center.attributes[#center.attributes + 1] = 'bakery_usable'
            center.attributes.bakery_usable = true
            SMODS.Attributes.bakery_usable.keys = SMODS.merge_lists({ SMODS.Attributes.bakery_usable.keys or {}, { center.key } })
        end
    end

    for _, v in pairs(G.P_CENTERS) do
        process(v)
    end

    local raw_SMODS_Center_inject = SMODS.Center.inject
    function SMODS.Center:inject(...)
        local ret = { raw_SMODS_Center_inject(self, ...) }
        process(self)
        return unpack(ret)
    end
end)
--END_KEEP_LITE
