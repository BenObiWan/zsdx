-- Gelidrak's head

vulnerable = false      -- becomes vulnerable when the tail is hurt
vulnerable_delay = 5000 -- delay while the head remains vulnerable

function event_appear()

  sol.enemy.set_life(16)
  sol.enemy.set_damage(4)
  sol.enemy.create_sprite("enemies/gelidrak_head")
  sol.enemy.set_size(32, 40)
  sol.enemy.set_origin(16, 24)
  sol.enemy.set_hurt_style("boss")
  sol.enemy.set_obstacle_behavior("flying")
  sol.enemy.set_no_treasure()
  sol.enemy.set_layer_independent_collisions(true)

  sol.enemy.set_invincible()
  sol.enemy.set_attack_consequence("sword", "protected")
  sol.enemy.set_attack_consequence("hookshot", "protected")
  sol.enemy.set_attack_consequence("boomerang", "protected")
  sol.enemy.set_attack_consequence("arrow", "protected")
  sol.enemy.set_pushed_back_when_hurt(false)
end

function event_restart()

  if not vulnerable then
    go_back()
  else
    sol.enemy.set_can_attack(false)
  end
end

function event_collision_enemy(other_name, other_sprite, my_sprite)

  if not vulnerable then
    go_back()
  end
end

function go_back()

  local x, y = sol.map.enemy_get_position(sol.enemy.get_father())
  local m = sol.main.target_movement_create(16, x, y + 48)
  sol.main.movement_set_property(m, "ignore_obstacles", true)
  sol.enemy.start_movement(m)
end

function event_movement_finished(movement)

  local m = sol.main.random_movement_create(16)
  sol.main.movement_set_property(m, "max_distance", 16)
  sol.main.movement_set_property(m, "ignore_obstacles", true)
  sol.enemy.start_movement(m)
  sol.main.timer_start(go_back, 5000)
end

function event_message_received(src_enemy, message)

  if src_enemy == sol.enemy.get_father() then
    if message == "vulnerable" and not vulnerable then
      -- the head now becomes vulnerable
      vulnerable = true
      sol.enemy.stop_movement()
      sol.enemy.set_can_attack(false)
      sol.enemy.set_attack_consequence("sword", 1)
      sol.main.timer_stop_all()
      sol.main.timer_start(function()
	vulnerable = false
	event_restart()
	sol.enemy.set_can_attack(true)
        sol.enemy.set_attack_consequence("sword", "protected")
	sol.enemy.send_message(sol.enemy.get_father(), "recovered")
      end, vulnerable_delay)
    end
  end
end

function event_hurt(attack, life_lost)

  sol.enemy.stop_movement()

  if sol.enemy.get_life() - life_lost > 0 then
    -- notify the body (so that it is hurt too)
    sol.enemy.send_message(sol.enemy.get_father(), "hurt")
  else
    sol.main.timer_stop_all()
  end
end

function event_dead()

  -- notify the body
  sol.enemy.send_message(sol.enemy.get_father(), "dead")
end

