---------------------------------
-- Dungeon 1 final room script --
---------------------------------

function event_map_started()
  sol.map.hero_freeze()
end

function event_map_opening_transition_finished(destination_point_name)
  sol.main.play_music("dungeon_finished.spc")
  sol.map.npc_set_position("solarus_child", 160, 165)
  sol.map.npc_set_animation("solarus_child", "stopped")
  sol.map.npc_set_animation_ignore_suspend("solarus_child", true)
  sol.main.timer_start(5000, "dialog", false)
end

function dialog()
  sol.map.dialog_start("dungeon_1.solarus_child")
  sol.map.dialog_set_variable("dungeon_1.solarus_child", sol.game.savegame_get_name());
end

function event_dialog_finished(first_message_id, answer)

  if first_message_id == "dungeon_1.solarus_child" then
    sol.map.hero_start_victory_sequence()
  end

end

function event_hero_victory_sequence_finished()
  sol.game.equipment_set_dungeon_finished(1)
  sol.map.hero_set_map(6, "from_dungeon_1_1F", 1)
  sol.map.hud_set_pause_enabled(true);
end

