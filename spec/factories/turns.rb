require 'faker'


FactoryGirl.define do
  factory :turn do
    face 6
    quantity 5
    round 1
    guess_type 'normal'

	  factory :turn_doubt do
	  	guess_type 'doubt'
	  end

	  factory :turn_tropical do
	  	guess_type 'tropical'
	  end

	  factory :turn_stake do
	  	guess_type 'stake'
	  end

	end
end
