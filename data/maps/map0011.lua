-- Grandma house

-- The player talks to grandma
function event_npc_interaction(npc_name)

  local has_smith_sword = sol.game.savegame_get_boolean(30)
  local has_clay_key = sol.game.savegame_get_boolean(28)
  local has_finished_lyriann_cave = sol.game.savegame_get_boolean(37)
  local has_bow = sol.game.savegame_get_boolean(26)
  local has_rock_key = sol.game.savegame_get_boolean(68)

  if not has_smith_sword then
    -- beginning: go get a sword
    sol.map.dialog_start("grandma_house.sword")
  elseif not has_clay_key then
    -- with the sword: find Sahasrahla
    sol.map.dialog_start("grandma_house.find_sahasrahla")
  elseif not has_finished_lyriann_cave then
    -- with the clay key: go to the cave
    sol.map.dialog_start("grandma_house.go_lyriann_cave")
  elseif not sol.game.is_dungeon_finished(1) then
    -- lyriann cave finished: go to the first dungeon
    sol.map.dialog_start("grandma_house.go_dungeon_1")
  elseif not has_bow then
    -- dungeon 1 finished: go to Sahasrahla's house
    sol.map.dialog_start("grandma_house.go_back_sahasrahla")
  elseif not has_rock_key then
    -- with the bow: go to the twin caves
    sol.map.dialog_start("grandma_house.go_twin_caves")
  elseif not sol.game.is_dungeon_finished(2) then
    -- with the rock key: go to the second dungeon
    sol.map.dialog_start("grandma_house.go_dungeon_2")
  elseif not sol.game.is_dungeon_finished(4) then
    -- use the telepathic booth
    sol.map.dialog_start("grandma_house.go_telepathic_booth")
  elseif not sol.game.is_dungeon_finished(5) then
    -- rupee house broken
    sol.map.dialog_start("grandma_house.dark_world_enabled")
  else
    -- use the telepathic booth again
    sol.map.dialog_start("grandma_house.go_telepathic_booth")
  end

end

