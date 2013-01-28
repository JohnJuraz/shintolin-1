async = require 'async'
db = require '../db'
queries = require '../queries'
create_tile = require './create_tile'
data = require '../data'
teleport = require './teleport'

db.register_index db.tiles,
  x: 1
  y: 1
  z: 1

module.exports = (character, direction, cb) ->
  old_coords =
    x: character.x
    y: character.y
    z: character.z

  coords = null
  switch direction
    when 'enter'
      coords =
        x: character.x
        y: character.y
        z: 1
    when 'exit'
      coords =
        x: character.x
        y: character.y
        z: 0
    when 'nw'
      coords =
        x: character.x - 1
        y: character.y - 1
        z: character.z
    when 'n'
      coords =
        x: character.x
        y: character.y - 1
        z: character.z
    when 'ne'
      coords =
        x: character.x + 1
        y: character.y - 1
        z: character.z
    when 'w'
      coords =
        x: character.x - 1
        y: character.y
        z: character.z
    when 'e'
      coords =
        x: character.x + 1
        y: character.y
        z: character.z
    when 'sw'
      coords =
        x: character.x - 1
        y: character.y + 1
        z: character.z
    when 's'
      coords =
        x: character.x
        y: character.y + 1
        z: character.z
    when 'se'
      coords =
        x: character.x + 1
        y: character.y + 1
        z: character.z
    else
      return cb 'Invalid direction.'

  async.parallel [
    (cb) ->
      queries.get_tile_by_coords coords, cb
    , (cb) ->
      queries.get_tile_by_coords old_coords, cb
  ], (err, [new_tile, old_tile]) ->
    return cb(err) if err?
    old_terrain = data.terrains[old_tile.terrain]
    if new_tile?
      new_terrain = data.terrains[new_tile.terrain]
    else
      new_terrain = data.terrains.wilderness
    if new_terrain.cost_to_enter?
      ap_cost = new_terrain.cost_to_enter new_tile, old_tile, character
    else
      ap_cost = 1
    return cb('Insufficient AP') unless character.ap >= ap_cost
    teleport character, old_coords, new_tile ? coords, cb
