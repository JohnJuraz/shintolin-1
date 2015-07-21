_ = require 'underscore'

module.exports =
  hp: 10

  attacked: (attacker, target, tile, weapon) ->
    roll = Math.random()
    if roll < .60
      'flee'
    else
      null

  loot: (attacker, target, tile, weapon) ->
    if _.contains(attacker.skills, 'butchering')
      meat_raw: 4
    else
      meat_raw: 3

  is_habitable: (terrain, tile) ->
    _.contains(terrain.tags, 'trees')
