require 'faker'


FactoryGirl.define do
  factory :user do
    username { Faker::Name.first_name }
		email    { Faker::Internet.email }
		password "asdfasdf"
		password_confirmation "asdfasdf"

  end
end
