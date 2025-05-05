Bakery_API = Bakery_API or {}
local my_version = "Bakery_Lite"
if not Bakery_API.Provider then
    Bakery_API.Provider = my_version
end
Bakery_API.load_stack = {}
function Bakery_API.guard(f)
    if Bakery_API.Provider == my_version then
        f()
    end
end

function Bakery_API.load(file)
    table.insert(Bakery_API.load_stack, file)
    local path = ''
    for _, part in ipairs(Bakery_API.load_stack) do
        path = path .. '/' .. part
    end
    local ret = assert(SMODS.load_file('src/' .. path .. '.lua'))()
    table.remove(Bakery_API.load_stack)
    return ret
end

Bakery_API.load('util')
Bakery_API.load('contributor')
Bakery_API.load('joker')
Bakery_API.load('back')
Bakery_API.load('tag')
Bakery_API.load('blind')
Bakery_API.load('challenge')
Bakery_API.load('consumable')
Bakery_API.load('enhancement')
Bakery_API.load('edition')
Bakery_API.load('charm')

if Balatest then
    assert(SMODS.load_file('test/joker_tests.lua'))()
    assert(SMODS.load_file('test/blind_tests.lua'))()
    assert(SMODS.load_file('test/back_tests.lua'))()
    assert(SMODS.load_file('test/edition_tests.lua'))()
    assert(SMODS.load_file('test/consumable_tests.lua'))()
    assert(SMODS.load_file('test/enhancement_tests.lua'))()
end

Bakery_API.guard(function()
    SMODS.Atlas {
        key = "modicon",
        path = "Icon.png",
        px = 34,
        py = 34
    }
end)
