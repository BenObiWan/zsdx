message_id = {
  "_treasure.piece_of_heart.1.first",
  "_treasure.piece_of_heart.1.second",
  "_treasure.piece_of_heart.1.third",
  "_treasure.piece_of_heart.1.fourth"
}

function event_obtained(variant)

  nb_pieces_of_heart = sol.game.savegame_get_integer(1030)
  sol.game.savegame.set_integer((nb_pieces_of_heart + 1) % 4)
  if (nb_pieces_of_heart == 3) then
    sol.game.equipment.add_max_life(4)
  end
  sol.map.dialog_start(message_id[nb_pieces_of_heart])

end

