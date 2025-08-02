Bakery_API.guard(function()
    -- Items that, with the Credit Deck, can never be better than the same item doing absolutely nothing.
    -- For example, Egg is not on this list, since sell value can still matter for Swashbuckler or Ceremonial Dagger.
    -- Neither is Midas Mask, since it can feed Vampire or Driver's License.
    Bakery_API.econ_only_items = { 'j_delayed_grat', 'j_business', 'j_faceless', 'j_cloud_9', 'j_rocket',
        'j_reserved_parking', 'j_mail', 'j_to_the_moon', 'j_golden', 'j_ticket',
        'j_rough_gem', 'j_satellite', 'j_todo_list', 'j_Bakery_Auctioneer', 'v_seed_money',
        'v_money_tree', 'c_hermit', 'c_temperance', 'tag_investment', 'tag_skip',
        'tag_economy' }
end)
