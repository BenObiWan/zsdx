-------------------------
-- Dungeon 2 1F script --
-------------------------

current_switch = ""

function event_map_started(destination_point_name)

  if savegame_get_boolean(78) then
    tile_set_enabled("barrier", false)
    switch_set_enabled("barrier_switch", true)
  end

  if savegame_get_boolean(90) then
    open_hidden_stairs()
  end

  if savegame_get_boolean(91) then
    open_hidden_door()
  end
end

function event_switch_enabled(switch_name)

  current_switch = switch_name
  if switch_name == "barrier_switch" then
    move_camera(120, 536, 15)
  elseif switch_name == "left_eye_switch" then
    check_eye_statues()
  elseif switch_name == "right_eye_switch" then
    check_eye_statues()
  end
end

function event_camera_reached_target()

  if current_switch == "barrier_switch" then
    start_timer(1000, "barrier_camera_timer", false)
  elseif not savegame_get_boolean(90) then
    start_timer(1000, "hidden_stairs_timer", false)
  else
    start_timer(1000, "hidden_door_timer", false)
  end
end

function check_eye_statues()

  if switch_is_enabled("left_eye_switch") and switch_is_enabled("right_eye_switch") then

    switch_set_enabled("left_eye_switch", false)
    switch_set_enabled("right_eye_switch", false)

    if not savegame_get_boolean(90) then
      play_sound("switch")
      move_camera(456, 232, 15)
    elseif not savegame_get_boolean(91) then
      play_sound("switch")
      move_camera(520, 320, 15)
    end
  end
end

function barrier_camera_timer()
  play_sound("secret")
  tile_set_enabled("barrier", false)
  savegame_set_boolean(78, true)
  start_timer(1000, "restore_camera", false)
end

function hidden_stairs_timer()
  play_sound("secret")
  open_hidden_stairs()
  savegame_set_boolean(90, true)
  start_timer(1000, "restore_camera", false)
end

function hidden_door_timer()
  play_sound("secret")
  open_hidden_door()
  savegame_set_boolean(91, true)
  start_timer(1000, "restore_camera", false)
end

function open_hidden_stairs()
  tiles_set_enabled("hidden_stairs_closed", false)
  tiles_set_enabled("hidden_stairs_open", true)
end

function open_hidden_door()
  tiles_set_enabled("hidden_door_closed", false)
  tiles_set_enabled("hidden_door_open", true)
end

