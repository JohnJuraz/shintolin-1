time = require '../../time'

module.exports =
  id: 'floodplain'
  style: ->
    switch time().season
      when 'Spring'
        'rapids'
      else
        'flood'

  actions: ['dig']

  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are wading through ankle-deep water; the Spring floods have come to the plains.'
      when 'Summer'
        'You are walking across a flood plain. The ground bakes beneath the sun.'
      when 'Autumn'
        'You are walking across a flood plain.'
      when 'Winter'
        'You are walking across a flood plain.'

  search_odds: (tile, character) ->
    wheat: .15

  dig_odds: (tile, character) ->
    clay: .40
    stone: .10
    gold_coin: .01

  cost_to_enter: (character, tile_from, tile_to) ->
    switch time().season
      when 'Spring'
        4
      else
        1