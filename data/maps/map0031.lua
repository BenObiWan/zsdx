-------------------------
-- Dungeon 2 B1 script --
-------------------------

-- the order the switches have to be activated
switches_puzzle_order = {
  switch_a = 1,
  switch_b = 2,
  switch_c = 3,
  switch_d = 4,
  switch_e = 5,
  switch_f = 6
}

switches_puzzle_nb_enabled = 0
switches_puzzle_correct = true

function event_map_started(destination_point)

  chest_set_hidden("boss_key_chest", true)

  if savegame_get_boolean(81) then
    -- boss key chest already found
    for k,v in pairs(switches_puzzle_order) do
      switch_set_enabled(k, true)
    end
  end
end

function event_switch_enabled(switch_name)

  order = switches_puzzle_order[switch_name]
  if order ~= nil then 

    switches_puzzle_nb_enabled = switches_puzzle_nb_enabled + 1
    if switches_puzzle_nb_enabled ~= order then
      switches_puzzle_correct = false
    end

    if switches_puzzle_nb_enabled == 6 then

      if switches_puzzle_correct then
	move_camera(240, 328, 15)
      else
	play_sound("wrong")
	switches_puzzle_nb_enabled = 0
	switches_puzzle_correct = true
	switch_set_locked(switch_name, true)
	for k,v in pairs(switches_puzzle_order) do
	  switch_set_enabled(k, false)
	end
      end
    end
  end
end

function event_switch_left(switch_name)

  if switches_puzzle_nb_enabled == 0 then
    for k,v in pairs(switches_puzzle_order) do
      switch_set_locked(k, false)
    end
  end
end

function event_camera_reached_target()
  start_timer(1000, "boss_key_chest_timer", false)
end

function boss_key_chest_timer()
  chest_set_hidden("boss_key_chest", false)
  play_sound("secret")
  start_timer(1000, "restore_camera", false)
end

