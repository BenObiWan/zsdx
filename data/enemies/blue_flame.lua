-- A blue flame thrown by another enemy

function event_appear()

  sol.enemy.set_life(1)
  sol.enemy.set_damage(8)
  sol.enemy.create_sprite("enemies/blue_flame")
  sol.enemy.set_size(16, 16)
  sol.enemy.set_origin(8, 13)
  sol.enemy.set_invincible()
  sol.enemy.set_obstacle_behavior("flying")
  sol.enemy.set_layer_independent_collisions(true)
end

function event_movement_finished(movement)

  sol.map.enemy_remove(sol.enemy.get_name())
end

function event_message_received(src_enemy, message)

  -- the message is the angle to take
  local angle = tonumber(message)
  local m = sol.main.straight_movement_create(192, angle)
  sol.main.movement_set_property(m, "ignore_obstacles", true)
  sol.main.movement_set_property(m, "max_distance", 320)
  sol.enemy.start_movement(m)
end

