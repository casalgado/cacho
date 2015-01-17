# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

var = 1
10.times do
	User.create!(username:"User#{var}", email:"example#{var}@email.com", password:"asdfasdf", password_confirmation:"asdfasdf")
	var += 1
end

