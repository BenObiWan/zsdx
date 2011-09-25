-- A root of Master Arbror

immobilized = false

function event_appear()

  sol.enemy.set_life(1)
  sol.enemy.set_damage(2)
  sol.enemy.create_sprite("enemies/arbror_root")
  sol.enemy.set_size(64, 96)
  sol.enemy.set_origin(28, 86)
  sol.enemy.set_invincible()
  sol.enemy.set_attack_consequence("hookshot", "immobilized")
  sol.enemy.set_attack_consequence("sword", "protected")
end

function event_restart()

  if immobilized then
    local sprite = sol.enemy.get_sprite()
    sol.main.sprite_set_animation(sprite, "hurt_long")
    sol.main.timer_stop_all()
    sol.main.timer_start(12000, "disappear")
    sol.enemy.stop_movement()
  else
    sol.main.timer_start(1000, "go")
  end
end

function go()

  if not immobilized then
    local m = sol.main.random_path_movement_create(32)
    sol.enemy.start_movement(m)
  end
end

function event_hurt(attack, life_points)

  if not immobilized then
    -- tell my father that I will be immobilized
    father_name = sol.enemy.get_father()
    if father_name ~= "" then
      sol.enemy.send_message(father_name, "begin immobilized")
    end
    sol.main.timer_stop_all()
  end
end

function event_immobilized()

  -- just immobilized
  immobilized = true
  sol.enemy.restart() -- to stop the buit-in behavior of being immobilized
end

function disappear()

  local sprite = sol.enemy.get_sprite()
  sol.main.sprite_set_animation(sprite, "disappearing")

  father_name = sol.enemy.get_father()
  if father_name ~= "" then
    sol.enemy.send_message(father_name, "end immobilized")
  end
end

function event_sprite_animation_finished(sprite, animation)

  if animation == "disappearing" then
    sol.map.enemy_remove(sol.enemy.get_name())
  end
end

