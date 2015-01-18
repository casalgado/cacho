require 'faker'


FactoryGirl.define do
  factory :turn do
    player_id  
    round 1 
    face  
    quantity  
    guess_type  
    past_turn_id  

  end
end
