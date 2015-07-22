time = require '../../time'

module.exports =
  style: 'lightforest'

  tags: ['trees']
  buildable: ['tiny', 'small']
  actions: ['chop']

  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are walking though an open woodland.'
      when 'Summer'
        'You are walking though an open woodland.'
      when 'Autumn'
        'You are walking though an open woodland, the leaves turning golden and brown with autumn.'
      when 'Winter'
        'You are walking though an open woodland. The tree branches are bare.'

  search_odds: (character, tile) ->
    stick: .25
    chestnut: .15
    bark: .10
    staff: .08

  grow: (tile) ->
    odds = switch time().season
      when 'Spring'
        .15
      when 'Summer'
        .30
    return null unless odds > 0
    return 'forest_3' if Math.random() < odds
  shrink: (tile) ->
    'forest_1'
