-- KEEP_LITE
return {
    descriptions = {
        -- END_KEEP_LITE
        Joker = {
            j_Bakery_Tarmogoyf = {
                name = 'Tarmogoyf',
                text = { '{C:red}+#1#{} Mult for each {C:attention}unique{}', 'rank discarded this {C:attention}round',
                    '{C:inactive}(Currently {C:red}+#2#{C:inactive} Mult)' }
            },
            j_Bakery_Auctioneer = {
                name = 'Auctioneer',
                text = { "When {C:attention}Blind{} is selected", "{C:money}sells{} Joker to the right",
                    "for {C:attention}#1#x{} its sell value" }
            },
            j_Bakery_Don = {
                name = 'Don',
                text = { "{X:mult,C:white}X#1#{} Mult", "Lose {C:money}$#2#{} per played hand" }
            },
            j_Bakery_Werewolf = {
                name = 'Werewolf (Day)',
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "{C:attention}Transform{} this Joker",
                    "at end of round if",
                    "{C:attention}no discards{} were used"
                }
            },
            j_Bakery_Werewolf_Back = {
                name = 'Werewolf (Night)',
                text = { "{X:mult,C:white}X#1#{} Mult", "{C:attention}Transform{} this Joker", "at end of round",
                    "if {C:attention}2 or more", "{C:attention}discards{} were used" }
            },
            j_Bakery_Spinner = {
                name = "Spinner",
                text = { "Gives the {C:attention}bottom{} bonus", "Rotates {C:attention}clockwise",
                    "at end of {C:attention}round" }
            },
            j_Bakery_Proxy = {
                name = "Proxy",
                text = {
                    "Copies ability of most",
                    "recently purchased {C:attention}Joker{}",
                    "{C:inactive}(Currently {C:attention}#1#{C:inactive})"
                },
                unlock = { "Have {C:attention}#1#", "and {C:attention}#2#", "simultaneously" }
            },
            j_Bakery_StickerSheet = {
                name = "Sticker Sheet",
                text = { "Each {C:attention}stickered{} Joker", "gives {X:mult,C:white}X#1#{} Mult" },
                unlock = { "Have an {C:attention}eternal", "{C:attention}rental{} Joker" }
            },
            j_Bakery_PlayingCard = {
                name = "1 of Spades",
                text = { "Gives {C:mult}Mult{} and {C:chips}Chips", "of {C:attention}High Card" },
                unlock = { "Get {C:attention}High Card", "to level {C:attention}#1#" }
            },
            j_Bakery_PlayingCard11 = {
                name = "11 of Spades",
                text = { "Gives {C:mult}Mult{} and {C:chips}Chips", "of {C:attention}Pair" },
                unlock = { "Get {C:attention}Pair", "to level {C:attention}#1#" }
            },
            j_Bakery_EvilSteven = {
                name = "Evil Steven",
                text = {
                    "{C:red}Destroys{} all scored cards",
                    "with {C:attention}even{} rank",
                    "{C:inactive}(2, 4, 6, 8, 10)"
                }
            },
            j_Bakery_AwfulTodd = {
                name = "Awful Todd",
                text = { "{C:red}Destroys{} all scored cards", "with {C:attention}odd{} rank",
                    "{C:inactive}(A, 3, 5, 7, 9)" }
            },
            j_Bakery_JokerAgainstHumanity = {
                name = "Joker Against Humanity",
                text = {
                    "Gains {C:mult}+#1#{} Mult when played",
                    "{C:attention}poker hand{} is {C:attention}level 1{}",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult){}"
                }
            },
            j_Bakery_CardSleeve = {
                name = "Card Sleeve",
                text = { "{C:attention}Holds{} one", "playing card" }
            },
            j_Bakery_BongardProblem = {
                name = "Bongard Problem",
                text = { "{X:mult,C:white}X#1#{} Mult if", "leftmost and rightmost", "scoring cards are",
                    "different {C:attention}suits" }
            },
            j_Bakery_CoinSlot = {
                name = "Coin Slot",
                text = { "Gains {C:mult}+#1#{} Mult", "per {C:money}$#2#{} put", "into the slot",
                    "{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)" }
            },
            j_Bakery_Pyrite = {
                name = "Pyrite",
                text = { "Draw {C:attention}#1#{} extra cards", "in {C:attention}first hand{} of round" }
            },
            j_Bakery_Snowball = {
                name = "Snowball",
                text = { "Gains {X:mult,C:white}X#1#{} Mult", "when {C:attention}Blind{} is selected",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)" }
            },
            j_Bakery_GetOutOfJailFreeCard = {
                name = "Get Out of Jail Free Card",
                text = {
                    "{C:attention}Use{} to get {X:mult,C:white}X#1#{} Mult for {C:attention}one hand",
                    "{C:inactive}This card may be kept",
                    "{C:inactive}until needed or sold"
                }
            },
            j_Bakery_TransparentBackBuffer = {
                name = "Transparent Back Buffer",
                text = { "{C:mult}+#1#{} Mult per scored card", "if played hand alternates",
                    "{C:attention}red{} and {C:attention}black{} suits" }
            },
            j_Bakery_TierList = {
                name = "Tier List",
                text = { "{X:mult,C:white}X#1#{} Mult for each {C:attention}unique",
                    "{C:attention}rarity{} among your {C:attention}Jokers{}",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)" }
            },
            j_Bakery_Tag = {
                name = "Tag",
                text = { "{C:attention}Tags{} give {X:mult,C:white}X#1#{} Mult" }
            },
            j_Bakery_GlassCannon = {
                name = "Glass Cannon",
                text = { "{X:mult,C:white}X#1#{} Mult", "{C:red}Self-destructs{} if Mult is",
                    "{C:attention}at least #2#{} afterwards" }
            },
            j_Bakery_3So = {
                name = "3 of Sō",
                text = { "Gains {C:mult}+#1#{} Mult if played hand", "contains a {C:attention}#2#-card Straight", "{C:inactive}(Currently {C:mult}+#3# {C:inactive}Mult)" }
            },
            j_Bakery_Weerewolf = {
                name = 'Weerewolf (Day)',
                text = {
                    "{C:mult}+#1#{} Mult",
                    "{C:attention}Transform{} this Joker",
                    "at end of round if",
                    "a {C:attention}2{} was scored"
                }
            },
            j_Bakery_Weerewolf_Back = {
                name = 'Weerewolf (Night)',
                text = { "{X:mult,C:white}X#1#{} Mult", "{C:attention}Transform{} this Joker", "at end of round",
                    "if no {C:attention}2s{} were scored" }
            },
            j_Bakery_Lua = {
                name = "Lua Joker",
                text = { "{X:mult,C:white}X#1#{} Mult,", '{X:mult,C:white}.."#2#"{} Mult' }
            }
        },
        Tag = {
            tag_Bakery_RetriggerTag = {
                name = 'Retrigger Tag',
                text = { "Shop has a free", "{C:dark_edition}Retrigger Joker" }
            },
            tag_Bakery_ChocolateTag = {
                name = "Chocolate Tag",
                text = {
                    "Gives {C:chips}+#1# Chips{} and",
                    "{C:mult}+#2# Mult{} when scored",
                    "{C:chips}-#3# Chips{} and {C:mult}-#4# Mult{0}",
                    "for every hand played"
                }
            },
            tag_Bakery_PolyTag = {
                name = "Poly Tag",
                text = { "Gives {X:mult,C:white}X#1#{} Mult when scored", "Lasts {C:attention}1{} round" }
            },
            tag_Bakery_PennyTag = {
                name = "Penny Tag",
                text = { "Scored cards give {C:money}$#1#", "for the next {C:attention}#2#{} hands" }
            },
            tag_Bakery_BlankTag = {
                name = "Blank Tag",
                text = { "{C:inactive}Does nothing?" }
            },
            tag_Bakery_AntiTag = {
                name = "Anti Tag",
                text = { "{C:dark_edition}+1{} Joker slot" }
            },
            tag_Bakery_CharmTag = {
                name = "Equip Tag",
                text = { "Adds two {C:attention}Charms", "to the next shop" }
            },
            tag_Bakery_DownTag = {
                name = "Down Tag",
                text = { "Disables effect of", "next {C:attention}Boss Blind" }
            },
            tag_Bakery_UpTag = {
                name = "Up Tag",
                text = { "{C:attention}Retrigger{} all scored", "cards for the next", "{C:attention}#1#{} hands" }
            },
            tag_Bakery_AlertTag = {
                name = "Alert Tag",
                text = { "Enhances next {C:attention}#1#", "scored cards to", "{C:attention}#2#" }
            },
            tag_Bakery_GoldTag = {
                name = "Gold Tag",
                text = { "Enhances next {C:attention}#1#", "scored cards to", "{C:attention}#2#" }
            },
            tag_Bakery_BatteryTag = {
                name = "Battery Tag",
                text = { "Enhances next {C:attention}#1#", "scored cards to", "{C:attention}#2#" }
            },
            tag_Bakery_RockTag = {
                name = "Rock Tag",
                text = { "Enhances next {C:attention}#1#", "scored cards to", "{C:attention}#2#" }
            },
            tag_Bakery_EqualTag = {
                name = "Equal Tag",
                text = { "Enhances next {C:attention}#1#", "scored cards to", "{C:attention}#2#" }
            },
            tag_Bakery_RouletteTag = {
                name = "Roulette Tag",
                text = { "Enhances next {C:attention}#1#", "scored cards to", "{C:attention}#2#" }
            },
            tag_Bakery_BlueTag = {
                name = "Blue Tag",
                text = { "Enhances next {C:attention}#1#", "scored cards to", "{C:attention}#2#" }
            },
            tag_Bakery_RedTag = {
                name = "Red Tag",
                text = { "Enhances next {C:attention}#1#", "scored cards to", "{C:attention}#2#" }
            },
            tag_Bakery_StrangeTag = {
                name = "Strange Tag",
                text = {}
            },
            tag_Bakery_TopTag = {
                name = "Top Tag",
                text = { "Gives {C:money}50¢{} per", "card in your deck", "{C:inactive}(Will give {C:money}$#1#{C:inactive})" }
            },
            tag_Bakery_BottomTag = {
                name = "Bottom Tag",
                text = { "Gives {C:money}$10{} per", "empty Joker slot", "{C:inactive}(Will give {C:money}$#1#{C:inactive})" }
            }
        },
        Back = {
            b_Bakery_Violet = {
                name = "Violet Deck",
                text = { "Gives {X:mult,C:white}X#1#{} Mult" },
                unlock = { "Defeat {C:purple}#1#" }
            },
            b_Bakery_House = {
                name = "House Deck",
                text = { "Each played card has a", "{C:green}#1# in #2#{} chance", "to change rank and suit",
                    "after a hand is scored" },
                unlock = { "Win a run with", "{C:attention}#1#{}", "on any difficulty" }
            },
            b_Bakery_Credit = {
                name = "Credit Deck",
                text = { "Start with extra {C:money}$#1#{}", "Earn {C:red}no money{}", "from any source" },
                unlock = { "Win a run with", "{C:attention}#1#{}", "on at least", "{V:1}#2#{} difficulty" }
            },
            b_Bakery_DN = {
                name = "D & Deck",
                text = { "All {C:green}probabilities{} are", "rolled with {C:attention}advantage", "{C:inactive}(Roll twice, keep the better result)" }
            }
        },
        Sleeve = {
            sleeve_Bakery_Violet = {
                name = "Violet Sleeve",
                text = { "Gives {X:mult,C:white}X#1#{} Mult" }
            },
            sleeve_Bakery_House = {
                name = "House Sleeve",
                text = { "Each played card has a", "{C:green}#1# in #2#{} chance", "to change rank and suit",
                    "after a hand is scored" }
            },
            sleeve_Bakery_House_alt = {
                name = "House Sleeve",
                text = { "Cards are {C:green}twice{} as", "likely to change and", "can gain modifications" }
            },
            sleeve_Bakery_Credit = {
                name = "Credit Sleeve",
                text = { "Start with extra {C:money}$#1#{}", "Earn {C:red}no money{}", "from any source" }
            },
            sleeve_Bakery_Credit_alt = {
                name = "Credit Sleeve",
                text = { "Start with extra {C:money}$#1#{}", "Lose {C:red}$1{} per card played" }
            },
            sleeve_Bakery_DN = {
                name = "D & Sleeve",
                text = { "All {C:green}probabilities{} are", "rolled with {C:attention}advantage", "{C:inactive}(Roll twice, keep the better result)" }
            },
            sleeve_Bakery_DN_alt = {
                name = "5eeve",
                text = { "All {C:green}probabilities{} are", "rolled with {C:attention}double advantage", "{C:inactive}(Roll three times, keep the best result)" }
            }
        },
        Blind = {
            bl_Bakery_Aleph = {
                name = "The Leader",
                text = { "-1 Hand", "-1 Discard" }
            },
            bl_Bakery_Tsadi = {
                name = "The Attrition",
                text = { "{C:red}-#1#{} Mult", "before scoring" }
            },
            bl_Bakery_He = {
                name = "The Solo",
                text = { "Only {C:attention}one", "card scores" }
            },
            bl_Bakery_Qof = {
                name = "The Witch",
                text = {
                    "Adds {C:attention}#1#{} {C:purple}Curses",
                    "to your deck"
                }
            },
            bl_Bakery_Kaf = {
                name = "The Build",
                text = { "No base Chips" }
            },
            bl_Bakery_Samekh = {
                name = "The Ruler",
                text = {
                    "Cards with no rank",
                    "or suit are debuffed"
                }
            },
            bl_Bakery_Lammed = {
                name = "The Stoic",
                text = { "Charm is debuffed" }
            }
        },
        Spectral = {
            c_Bakery_Astrology = {
                name = "Astrology",
                text = { "{C:money}Sell{} all {C:attention}hand levels", "for {C:money}$#1#{} each" }
            },
            c_Bakery_TimeMachine = {
                name = "Time Machine",
                text = {
                    "Enhances {C:attention}#1#{} selected",
                    "card into a {C:attention}#2#"
                }
            },
            c_Bakery_Boids = {
                name = "Boids",
                text = {
                    "Converts up to {C:attention}#1#{} selected",
                    "cards into the {C:attention}same",
                    "random {C:attention}suit {}and {C:attention}rank"
                }
            }
        },
        Tarot = {
            c_Bakery_Scribe = {
                name = "The Scribe",
                text = { "Create {C:attention}#1#{} {C:dark_edition}Carbon{}", "copy of {C:attention}#2#{} selected",
                    "{C:attention}playing card{} or {C:attention}Joker", "{C:inactive}(Must have room)",
                    "{C:inactive}(Removes {C:eternal}Eternal{C:inactive} from copy)" }
            }
        },
        Enhanced = {
            m_Bakery_TimeWalk = {
                name = "Time Walk",
                text = { "{C:blue}+#1#{} Hand", "No rank or suit" }
            },
            m_Bakery_Curse = {
                name = "Curse",
                text = { "No rank or suit" }
            }
        },
        Edition = {
            e_Bakery_Carbon = {
                name = "Carbon",
                text = { "{C:red}Self-destructs", "after scoring" }
            }
        },
        -- KEEP_LITE
        BakeryCharm = {
            -- END_KEEP_LITE
            BakeryCharm_Bakery_Palette = {
                name = "Palette",
                text = { "{C:attention}Flushes{} may be made", "with at least", "{C:attention}4 suits" },
                unlock = { "Have at least {C:attention}#1#", "cards of the same", "{C:attention}suit{} in your deck" }
            },
            BakeryCharm_Bakery_AnaglyphLens = {
                name = "Anaglyph Lens",
                text = { "Poker hands are determined", "as though the {C:attention}first{} card",
                    "had been {C:attention}duplicated" },
                unlock = { "Have {C:attention}#1# #2#", "simultaneously" }
            },
            BakeryCharm_Bakery_Pedigree = {
                name = "Pedigree",
                text = { "{C:attention}Full Houses{} may be", "made with {C:attention}suits{}",
                    "{C:inactive}(in addition to {C:attention}ranks{C:inactive})" }
            },
            BakeryCharm_Bakery_Epitaph = {
                name = "Epitaph",
                text = { "{C:attention}Unscored{} played cards", "give {X:mult,C:white}X#1#{} Mult" },
                unlock = { "Have only {C:attention}always-scoring", "cards in your deck" }
            },
            BakeryCharm_Bakery_Rune = {
                name = "Rune",
                text = { "You can {C:attention}discard", "{C:attention}0 cards{} to draw",
                    "{C:attention}#1#{} extra cards" },
                unlock = { "Have at least {C:attention}#1#", "cards in your hand" }
            },
            BakeryCharm_Bakery_Obsession = {
                name = "Obsession",
                text = { "You can {C:attention}discard", "{C:attention}0 cards{} to", "earn {C:money}$#1#{}" },
                unlock = { "Win a run without", "discarding a single card" }
            },
            BakeryCharm_Bakery_Introversion = {
                name = "Introversion",
                text = { "{C:attention}Jokers{} do not", "appear in the shop" }
            },
            BakeryCharm_Bakery_Extroversion = {
                name = "Extroversion",
                text = { "{C:attention}Tarot{} and {C:attention}Planet{} cards", "do not appear in the shop" }
            },
            BakeryCharm_Bakery_Coin = {
                name = "Coin",
                text = { "{C:attention}Interest{} is earned", "for every {C:money}$#1#",
                    "{C:inactive}(instead of every {C:money}$5{C:inactive})" }
            },
            BakeryCharm_Bakery_Void = {
                name = "Void",
                text = { "{C:dark_edition}Negative{} cards appear", "{X:dark_edition,C:white}#1#X{} as often" },
                unlock = { "Have at least", "{C:attention}#1# Jokers" }
            },
            BakeryCharm_Bakery_PrintError = {
                name = "Print Error",
                text = { "Printers print twice" },
                unlock = { "Have at least", "{C:attention}#1# Contracts" }
            },
            BakeryCharm_Bakery_Posterization = {
                name = "Posterization",
                text = { "{C:colourcard}Colour{} cards only", "take {C:attention}half{} a slot" },
                unlock = { "Have a {C:colourcard}Colour{} card", "with {C:attention}#1#{} triggers" }
            },
            BakeryCharm_Bakery_Marm = {
                name = "Marm",
                text = { "Every hand is a {C:attention}Pair{}", "Every {C:attention}played card", "counts in scoring" },
                unlock = { "Win a run with", "only {C:attention}Pair{} hands" }
            },
            BakeryCharm_Bakery_DuctTape = {
                name = "Duct Tape",
                text = {
                    "{C:common}Common{} and {C:uncommon}Uncommon",
                    "{C:attention}Jokers{} don't appear",
                    "{C:red}Cannot be removed"
                }
            },
            BakeryCharm_Bakery_Virus = {
                name = "Virus",
                text = {
                    "{C:green}Infects{} a random uninfected",
                    "card held in hand after scoring"
                },
                unlock = {
                    "Have {C:attention}only {C:green}Infected Cards",
                }
            },
            BakeryCharm_Bakery_PetriDish = {
                name = "Petri Dish",
                text = { "{C:attention}+#1#{} consumable slots" },
                unlock = {
                    "Copy {C:legendary}#1#",
                    "with {C:tarot}#2#"
                }
            },
            BakeryCharm_Bakery_Cogwheel = {
                name = 'Cogwheel',
                text = { "{C:attention}-#1#{} Antes,", "{C:attention}-#2#{} card in shop" },
                unlock = { 'Clear Ante {C:attention}#1#' }
            },
            BakeryCharm_Bakery_OopsAll20s = {
                name = 'Oops! All 20s',
                text = { 'Triples all {C:attention}listed', '{C:green,E:1,S:1.1}probabilities', '{C:inactive}(ex: {C:green}1 in 3{C:inactive} -> {C:green}3 in 3{C:inactive})' }
            },
            BakeryCharm_Bakery_Fortuna = {
                name = 'Fortuna',
                text = { '{C:tarot}#1#{} never', 'adds {C:dark_edition}#2#{} or {C:dark_edition}#3#' }
            },
            BakeryCharm_Bakery_MementoMori = {
                name = 'Memento Mori',
                text = { 'All {C:tarot}Tarot{} cards', 'are {C:attention}#1#' },
                unlock = { 'Have {C:attention}every{} card in', 'your {C:attention}full deck', 'be identical' }
            }
            -- KEEP_LITE
        },
        Other = {
            Bakery_charm = {
                name = "Charm",
                text = { "Only one Charm may", "be equipped at a time,", "purchasing a new Charm", "replaces an old one" }
            },
            undiscovered_bakerycharm = {
                name = "Undiscovered",
                text = { "Equip this Charm", "in an unseeded run", "to learn what it does" }
            }
        }
    },
    misc = {
        v_text = {
            ch_c_Bakery_Balanced = { "{C:mult}Mult{} cannot exceed {C:chips}Chips{}" },
            ch_c_Bakery_Vagabond = { "{C:money}Money{} cannot exceed {C:money}$#1#" },
            ch_c_Bakery_Sprint_Small = { "{C:attention}Small Blinds{} must be skipped" },
            ch_c_Bakery_Sprint_Big = { "{C:attention}Big Blinds{} must be skipped" },
        },
        -- END_KEEP_LITE
        challenge_names = {
            c_Bakery_Balanced = "Balanced",
            c_Bakery_Vagabond = "Vagabond",
            c_Bakery_Sprint = "Sprint",
        },
        -- KEEP_LITE
        dictionary = {
            -- END_KEEP_LITE
            b_Bakery_store = "STORE",
            b_Bakery_return = "GET",
            b_Bakery_shattered = "Shattered!",
            k_Bakery_charm = "Charm",
            k_Bakery_charms = "Charms",
            b_Bakery_double_tags = "Double Tags",
            -- KEEP_LITE
            k_bakerycharm = "Charm",
            k_BakeryCharmInfo = { "Only one Charm may be equipped at a time.",
                "Purchasing a new Charm replaces an old one." },
            b_Bakery_equip = "EQUIP",
            b_Bakery_ante = "(Ante)"
        },
        -- END_KEEP_LITE
        v_dictionary = {
            b_Bakery_deposit = "DEPOSIT $#1#",
            b_Bakery_ante_times = "(Ante*#1#)",
            v_Bakery_artist = "Art: #1#",
            v_Bakery_coder = "Code: #1#",
            v_Bakery_idea = "Idea: #1#",
            v_Bakery_by = "Made by: #1#"
        },
        labels = {
            Bakery_Carbon = "Carbon"
        },
        poker_hands = {
            Bakery_StuffedHouse = "Stuffed House",      -- Full House of suits & Full House of ranks
            Bakery_StuffedFlush = "Stuffed Flush",      -- Full House of suits & Full House of ranks & Flush (Possible with wild cards)
            Bakery_StraightHouse = "Harem",             -- Straight & Full House
            Bakery_StraightFlushHouse = "Flush Harem",  -- Straight Flush & Flush House
            Bakery_RoyalFlushHouse = "Royal Harem",     -- Royal Flush & Flush House
            Bakery_FullFive = "Full Five",              -- Full House & Five of a Kind
            Bakery_FullFlushFive = "Full Flush Five",   -- Full House & Flush Five
            Bakery_SixOfAKind = "Six Of A Kind",        -- Five of a Kind & 6 cards
            Bakery_FlushSix = "Flush Six",              -- Flush & Five of a Kind & 6 cards
            Bakery_ThreePair = "Three Pair",            -- 3X Pair
            Bakery_FlushThreePair = "Flush Three Pair", -- Flush & 3X Pair
            Bakery_TwoTriplets = "Two Triplets",        -- 2X Thee of a Kind
            Bakery_FlushTriplets = "Flush Triplets",    -- Flush & 2X Thee of a Kind
            Bakery_FlushMansion = "Flush Mansion"       -- Flush & Four of a Kind & Pair
        }
        -- KEEP_LITE
    }
}
