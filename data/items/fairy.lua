function event_appear(variant)
  m = sol.main.random_movement_create(32)
  sol.main.movement_set_property(m, "max_distance", 40)
  sol.item.set_movement(m)
end

