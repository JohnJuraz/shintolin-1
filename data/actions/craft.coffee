Bluebird = require 'bluebird'
{items} = require '../'
craft = Bluebird.promisify(require('../../commands').craft)
send_message = Bluebird.promisify(require('../../commands').send_message)
can_take = require('../../queries').can_take
ACTION = 'craft'

visit_recipe = (recipe, action, character, tile) ->
  io = recipe[action] character, tile
  takes_items = []
  takes_items.push {item: key, count: value} for key, value of io.takes.items

  can_take_response = can_take character, tile, io.takes

  retval =
    id: recipe.id
    name: recipe.name
    gives: io.gives
    takes: io.takes
    ap: io.takes.ap
    items: takes_items
    tools: io.takes.tools
    hp: gives?.tile_hp
    craftable: can_take_response.craftable
  retval[action] = recipe[action]
  retval

module.exports = (character, tile) ->
  Bluebird.resolve()
    .then ->
      recipes = {}
      for key, recipe of items
        if recipe.craft?
          recipes[key] = visit_recipe(recipe, ACTION, character, tile)
      recipes

    .then (recipes) ->
      category: 'self'
      charge_ap: false #done via recipe instead
      recipes: recipes

      execute: (body) ->
        recipe = recipes[body.recipe]
        Bluebird.resolve()

          .then ->
            throw 'Invalid Recipe' unless recipe?[ACTION]?
            craft character, tile, recipe, ACTION

          .then ([io, broken_items]) ->
            send_message 'craft', character, character,
              recipe: recipe.name
              gives: io.gives
              takes: io.takes
              broken: broken_items
