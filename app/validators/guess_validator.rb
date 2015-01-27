class GuessValidator < ActiveModel::Validator

  def validate(record)
  	if record.past_turn_id
	  	last_turn = Turn.find(record.past_turn_id) 
	  	if record.guess_type == "normal"
	  		if record.quantity == nil || record.face == nil
	  			record.errors[:base] << "Debes decir algo"
	  		elsif last_turn.quantity == nil 
	  		else
			 		if (last_turn.face == 1) && (record.face != 1)
						unless record.quantity.to_i >= (last_turn.quantity.to_i * 2) + 1
							record.errors[:base] << "Son minimo #{(last_turn.quantity*2)+1} de algo"
						end
					elsif (last_turn.face != 1) && (record.face == 1)
						unless record.quantity.to_i >= (last_turn.quantity.to_i / 2) + 1
							record.errors[:base] << "Son minimo #{(last_turn.quantity/2)+1} aces"
						end
					else
						unless (record.quantity > last_turn.quantity) || (record.quantity == last_turn.quantity && record.face > last_turn.face)
							record.errors[:base] << "Debes decir algo mas grande"
						end
					end
				end
			else
				if record.guess_type == 'stake' && record.game.dice_on_table.size <= record.game.starting_dice / 2
					record.errors[:base] << "Ya no puedes cazar, minimo con record#{(record.game.starting_dice / 2) + 1} dados"
				elsif record.guess_type == 'tropical' && record.player.turns.where(round: record.round, guess_type: 'tropical').exists?
					record.errors[:base] << "Ya dijiste tropical, deja la viveza"
				end
			end
		end
  end
  
end