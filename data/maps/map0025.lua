-- Dungeon 1 2F

fighting_miniboss = false

function event_map_started(destination_point_name)

  sol.map.chest_set_enabled("boss_key_chest", false)
  sol.map.door_set_open("stairs_door", true)
  sol.map.door_set_open("miniboss_door", true)
end

function event_map_opening_transition_finished(destination_point_name)

  -- show the welcome message
  if destination_point_name == "from_outside" then
    sol.map.dialog_start("dungeon_1")
  end
end

function event_hero_on_sensor(sensor_name)

  if sensor_name == "start_miniboss_sensor" and not sol.game.savegame_get_boolean(62) and not fighting_miniboss then
    -- the miniboss is alive
    sol.map.door_close("miniboss_door")
    sol.map.hero_freeze()
    sol.main.timer_start(miniboss_timer, 1000)
    fighting_miniboss = true
  end
end

function miniboss_timer()
  sol.main.play_music("boss.spc")
  sol.map.enemy_set_enabled("khorneth", true)
  sol.map.hero_unfreeze()
end

function event_enemy_dead(enemy_name)

  if enemy_name == "khorneth" then
    sol.main.play_music("light_world_dungeon.spc")
    sol.map.door_open("miniboss_door")
  end

  if sol.map.enemy_is_group_dead("boss_key_battle")
    and not sol.map.chest_is_enabled("boss_key_chest") then
    sol.map.camera_move(104, 72, 150)
  end
end

function event_camera_reached_target()
  sol.main.timer_start(boss_key_timer, 1000)
end

function boss_key_timer()
  sol.main.play_sound("chest_appears")
  sol.map.chest_set_enabled("boss_key_chest", true)
  sol.main.timer_start(sol.map.camera_restore, 1000)
end

