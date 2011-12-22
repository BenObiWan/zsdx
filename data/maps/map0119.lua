-- Outside world C3

fighting_boss = false

function event_map_started(destination_point_name)

  local new_music = nil
  if destination_point_name == "from_ending" then
    -- game ending sequence
    sol.map.hero_freeze()
    sol.map.hero_set_visible(false)
    sol.map.hud_set_enabled(false)
    sol.map.enemy_set_group_enabled("", false)
    new_music = "fanfare.spc"
    sol.map.tile_set_group_enabled("roof_entrance", false)
  else
    -- enable dark world
    if sol.game.savegame_get_boolean(905) then
      new_music = "dark_mountain.spc"
      sol.map.tileset_set(13)
    end

    -- boss fight
    if destination_point_name == "from_dungeon_10_5f" then

      if not sol.game.savegame_get_boolean(299) then
	-- boss not killed yet
        new_music = "none"
        sol.map.enemy_set_group_enabled("", false) -- disable all simple enemies
      elseif not sol.game.savegame_get_boolean(298) then
	-- boss killed but sword not got yet
	local variant = 2
	if sol.game.get_ability("sword") >= 2 then
	  -- the player already has the second one: give the third one instead
	  variant = 3
	end
	sol.map.pickable_item_create("sword", variant, 298, 440, 157, 1)
      end
    else
      sol.map.tile_set_group_enabled("roof_entrance", false)
    end
  end

  if new_music ~= nil then
    sol.main.play_music(new_music)
  end
end

function event_map_opening_transition_finished(destination_point_name)

  if destination_point_name == "from_ending" then
    sol.map.dialog_start("credits_6")
    sol.map.camera_move(440, 96, 25, function() end, 1e6)
  end
end

function event_hero_on_sensor(sensor_name)

  if sensor_name == "start_boss_sensor"
      and not sol.game.savegame_get_boolean(299)
      and not fighting_boss then

    -- boss fight
    sol.map.hero_freeze()
    sol.map.tile_set_group_enabled("roof_entrance", false)
    sol.map.stairs_set_enabled("roof_stairs", false)
    sol.map.teletransporter_set_enabled("roof_teletransporter", false)
    sol.main.play_sound("door_closed")
    sol.main.timer_start(start_boss, 1000)
  end
end

function start_boss()

  sol.main.play_music("boss.spc")
  sol.map.enemy_set_enabled("boss", true)
  sol.map.hero_unfreeze()
  fighting_boss = true
  sol.main.timer_start(repeat_give_arrows, 20000)
end

function repeat_give_arrows()

  -- give arrows if necessary during the boss fight
  if sol.game.get_item_amount("bow") == 0 then
    local positions = {
      { x = 408, y = 189 },
      { x = 472, y = 189 },
    }
    arrow_xy = positions[math.random(#positions)]
    sol.map.pickable_item_create("arrow", 3, -1, arrow_xy.x, arrow_xy.y, 1)
  end
  sol.main.timer_start(repeat_give_arrows, 20000)
end

function event_enemy_dead(enemy_name)

  if enemy_name == "boss" then
    -- give the second sword
    local variant = 2
    if sol.game.get_ability("sword") == 2 then
      -- the player already has the second one: give the third one instead
      variant = 3
    end
    sol.map.pickable_item_create("sword", variant, 298, 440, 189, 1)
    sol.main.timer_stop_all()
  end
end

function event_treasure_obtaining(item_name, variant, savegame_variable)

  if item_name == "sword" then
    sol.main.play_music("excalibur.spc")
  end
end

function event_treasure_obtained(item_name, variant, savegame_variable)

  if item_name == "sword" then
    sol.map.hero_start_victory_sequence()
  end
end

function event_hero_victory_sequence_finished()

  sol.game.set_dungeon_finished(10)
  sol.map.hero_set_map(119, "from_dungeon_10", 1)
  sol.map.enemy_set_group_enabled("", true) -- enable simple enemies back

  sol.main.timer_start(function()
    if sol.game.savegame_get_boolean(905) then
      sol.main.play_music("dark_mountain.spc")
    else
      sol.main.play_music("overworld.spc")
    end
  end, 1000)
end

function event_dialog_finished(first_message_id)

  if first_message_id == "credits_6" then
   sol.main.timer_start(ending_next, 2000)
  end
end

function ending_next()
  sol.map.hero_set_map(131, "from_ending", 1)
end

