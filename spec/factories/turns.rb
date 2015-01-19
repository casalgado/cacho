require 'faker'


FactoryGirl.define do
  factory :turn do
    face 6
    quantity 5
    round 1
    guess_type 'normal'

  end
end
