-- The end

function event_map_started(destination_point_name)

  if destination_point_name == "from_ending" then
    sol.map.hero_freeze()
    sol.map.hero_set_visible(false)
    sol.map.hud_set_enabled(false)
    sol.main.timer_start(sol.game.reset, 10000)
  end
end

