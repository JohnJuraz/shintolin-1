module.exports =
  id: 'stone_spear'
  name: 'stone spear'
  plural: 'stone spears'
  tags: ['weapon']
  weight: 5

  weapon_class: 'stab'
  break_odds: .02
  accuracy: (attacker, target, tile) ->
    chance = .30
    chance += .10 if attacker.skills.indexOf('spear_2') isnt -1
    chance += .10 if attacker.skills.indexOf('spear_4') isnt -1
    chance
  damage: (attacker, target, tile) ->
    dmg = 2
    dmg += 1 if attacker.skills.indexOf('spear_1') isnt -1
    dmg += 1 if attacker.skills.indexOf('spear_3') isnt -1
    dmg
