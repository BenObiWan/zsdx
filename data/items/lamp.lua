-- Script of the Lamp

temporary_lit_torches = {} -- list of torches that will be unlit by timers soon (FIFO)

-- Called when the hero uses the Lamp
function event_use()

  magic_needed = 1 -- number of magic points required
  if sol.game.get_magic() >= magic_needed then
    sol.main.play_sound("lamp")
    sol.game.remove_magic(magic_needed)
    create_fire()
  else
    sol.main.play_sound("wrong")
  end
  sol.item.set_finished()
end

-- Creates some fire on the map
function create_fire()

  direction = sol.map.hero_get_direction()
  if direction == 0 then
    dx, dy = 18, -4
  elseif direction == 1 then
    dx, dy = 0, -24
  elseif direction == 2 then
    dx, dy = -20, -4
  else
    dx, dy = 0, 16
  end

  x, y, layer = sol.map.hero_get_position()
  sol.map.fire_create(x + dx, y + dy, layer)
end

-- Unlights the oldest torch still lit
function unlight_oldest_torch()
  entity = table.remove(temporary_lit_torches, 1)                   -- remove the torch from the FIFO
  if sol.map.interactive_entity_exists(entity) then                 -- see if it still exists
    torch_sprite = sol.map.interactive_entity_get_sprite(entity)    -- get its sprite
    sol.main.sprite_set_animation(torch_sprite, "unlit")            -- change the animation
  end
end

-- Called when the player obtains the Lamp
function event_obtained(variant, savegame_variable)
  
  -- give the magic bar if necessary
  if sol.game.get_max_magic() == 0 then
    sol.game.set_max_magic(42)
  end
end

-- Called when the current map changes
function event_map_changed()
  -- cancel all torch timers so that the previous map does not interfer with the new one
  sol.main.timer_stop_all()
  temporary_lit_torches = {}
end

-- Called when the hero presses the action key in front of any interactive entity
-- that wants to notify the lamp
function event_hero_interaction(entity_name)

  if string.match(entity_name, "^torch") then
    sol.map.dialog_start("torch.need_lamp")
  end
end

-- Called when fire touches an interactive entity linked to the Lamp
function event_npc_collision_fire(npc_name)

  if string.match(npc_name, "^torch") then
    
    torch_sprite = sol.map.interactive_entity_get_sprite(npc_name)
    if sol.main.sprite_get_animation(torch_sprite) == "unlit" then
      -- temporarily light the torch up
      sol.main.sprite_set_animation(torch_sprite, "lit")
      sol.main.timer_start(10000, "unlight_oldest_torch", false)
      table.insert(temporary_lit_torches, npc_name)
    end
  end
end

