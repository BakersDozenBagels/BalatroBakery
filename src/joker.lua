Bakery_API.guard(function()
    function Bakery_API.Joker(o)
        o.name = o.name or o.key
        o.atlas = o.atlas or 'Bakery'
        o.pos = o.pos or {
            x = 0.5,
            y = 0.5
        }
        return Bakery_API.credit(SMODS.Joker(o))
    end
end)
Bakery_API.guard(function()
    function Bakery_API.get_proxied_joker()
        if G.jokers and G.jokers.cards then
            local other_joker = nil
            local latest = -1
            for _, other in pairs(G.jokers.cards) do
                if other.config.center ~= G.P_CENTERS.j_Bakery_Proxy and other.ability.Bakery_purchase_index and
                    other.ability.Bakery_purchase_index > latest and other.config.center.blueprint_compat then
                    latest = other.ability.Bakery_purchase_index
                    other_joker = other
                end
            end
            return other_joker
        end
    end
end)
Bakery_API.load('sleeve')
Bakery_API.guard(function()
    Bakery_API.black_suits = { "Spades", "Clubs" }
    Bakery_API.red_suits = { "Hearts", "Diamonds" }
    function Bakery_API.is_any_suit(card, suits)
        for _, s in pairs(suits) do
            if card:is_suit(s) then
                return true
            end
        end
        return false
    end

    function Bakery_API.alternates_suits(hand, first, second)
        if not first then
            return Bakery_API.alternates_suits(hand, Bakery_API.red_suits, Bakery_API.black_suits) or
                Bakery_API.alternates_suits(hand, Bakery_API.black_suits, Bakery_API.red_suits)
        end

        for i = 1, #hand, 2 do
            if not Bakery_API.is_any_suit(hand[i], first) then
                return false
            end
        end

        for i = 2, #hand, 2 do
            if not Bakery_API.is_any_suit(hand[i], second) then
                return false
            end
        end

        return true
    end
end)
Bakery_API.guard(function()
    Bakery_API.rarities = {
        Common = 1,
        Uncommon = 2,
        Rare = 3,
        Legendary = 4
    }
    function Bakery_API.count_rarities()
        if not G.jokers then
            return 0
        end
        local count = 0
        local rarities = {}
        for _, v in ipairs(G.jokers.cards) do
            local rarity = Bakery_API.rarities[v.config.center.rarity] or v.config.center.rarity
            if not rarities[rarity] then
                rarities[rarity] = true
                count = count + 1
            end
        end
        return count
    end
end)
-- from http://lua-users.org/wiki/SplitJoin
local function Split(str, delim)
    if string.find(str, delim) == nil then return { str } end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gfind(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
    end
    result[nb + 1] = string.sub(str, lastPos)
    return result
end

local MAX_NUM

function Bakery_API.parse_hyper_e(num)
    local split_array = num:sub(2)
    local arr = {}
    local current_run = 0
    local i = 1
    for _, str in ipairs(Split(split_array, "#")) do
        current_run = current_run + 1
        if #str ~= 0 then
            local val = tonumber(str)
            if current_run == 1 then
                if i > 2 then val = val - 1 end
                arr[i] = val
            elseif current_run == 2 then
                local last = arr[i - 1]
                for _ = 1, val do
                    arr[i] = last
                    i = i + 1
                end
            else
                -- Triple hash is unsupported. Bail.
                return MAX_NUM, true
            end
            current_run = 0
            i = i + 1
            if i > 10010 then
                -- Number is too big to fit in memory. Bail.
                return MAX_NUM, true
            end
        end
    end
    return setmetatable({ array = arr, sign = 1 }, OmegaMeta)
end

MAX_NUM = Bakery_API.parse_hyper_e("e10#10##10000")
