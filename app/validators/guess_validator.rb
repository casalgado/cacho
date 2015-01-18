class GuessValidator < ActiveModel::Validator

  def validate(record)
  	if record.past_turn_id
	  	last_turn = Turn.find(record.past_turn_id) 
	  	if last_turn.quantity
	  	 	unless record.guess_type == "doubt" || record.guess_type == "tropical"
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
			end
		end
  end
  
end