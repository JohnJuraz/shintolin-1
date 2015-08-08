_ = require 'underscore'
BPromise = require 'bluebird'
teleport = BPromise.promisify(require '../../commands/teleport')
send_message = BPromise.promisify(require '../../commands/send_message')
send_message_nearby = BPromise.promisify(require '../../commands/send_message_nearby')

module.exports = (character, tile) ->
  return false unless tile? and tile.z is 1

  dazed = (tile?.people ? []).filter (p) ->
    p.hp <= 0
  return false unless dazed.length

  category: 'target'
  ap: 5
  people: dazed

  execute: (body, req) ->
    BPromise.resolve()

      .then ->
        teleport req.target, req.tile,
          x: req.tile.x
          y: req.tile.y
          z: 0

      .then ->
        msg =
          target_id: req.target._id
          target_name: req.target.name
          target_slug: req.target.slug
          building: tile.building
        BPromise.all [
          send_message 'kick_out', req.character, req.character, msg
          send_message 'kicked_out', req.character, req.target, msg
          send_message_nearby 'kick_out_nearby', req.character, [req.character, req.target], msg
        ]
