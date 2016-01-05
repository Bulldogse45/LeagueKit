# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


  user = User.create!(username:"#{Faker::Company.profession}#{Faker::Number.number(5)}", first_name:"Matt", last_name:"Fair", email:"matt@aol.com", password:"password", password_confirmation:"password",email_optout:true, address_1:Faker::Address.street_address, city:Faker::Address.city, state:Faker::Address.state_abbr, zip:Faker::Address.zip, phone1:Faker::PhoneNumber.cell_phone)
  player = Player.create!(first_name:Faker::Name.first_name, last_name:Faker::Name.last_name,user_id:user.id, date_of_birth:Faker::Date.between(10.years.ago, 8.years.ago), jersey_number:Faker::Number.between(0, 99))
  league = League.create!(name:Faker::Book.title, user_id:user.id)
  tournament = Tournament.create!(name:Faker::Book.title,league_id:league.id, start_time:Faker::Time.forward(23, :morning), end_time:Faker::Time.forward(23, :morning), user_id:user.id)
  team1 = Team.create!(name:"The #{Faker::Team.name}", user_id:user.id)
  team1.update!(original_id:team1.id)
  team1.players << player
  user.follow(team1)
  5.times do
    new_user3 = User.create!(username:"#{Faker::Company.profession}#{Faker::Number.number(5)}",first_name:Faker::Name.first_name, last_name:Faker::Name.last_name, email:Faker::Internet.email, password:"password",email_optout:true, password_confirmation:"password", address_1:Faker::Address.street_address, city:Faker::Address.city, state:Faker::Address.state_abbr, zip:Faker::Address.zip, phone1:Faker::PhoneNumber.cell_phone)
    team1.players <<  Player.create!(first_name:Faker::Name.first_name, last_name:Faker::Name.last_name,user_id:new_user3.id, date_of_birth:Faker::Date.between(10.years.ago, 8.years.ago), jersey_number:Faker::Number.between(0, 99))
    new_user3.follow(team1)
  end
  10.times do
    new_user = User.create!(username:"#{Faker::Company.profession}#{Faker::Number.number(5)}",first_name:Faker::Name.first_name, last_name:Faker::Name.last_name, email:Faker::Internet.email, password:"password",email_optout:true, password_confirmation:"password", address_1:Faker::Address.street_address, city:Faker::Address.city, state:Faker::Address.state_abbr, zip:Faker::Address.zip, phone1:Faker::PhoneNumber.cell_phone)
    team = Team.create!(name:"The #{Faker::Team.name}", user_id:new_user.id)
    team.update!(original_id:team.id)
    new_user.follow(team)
    5.times do
      new_user2 = User.create!(username:"#{Faker::Company.profession}#{Faker::Number.number(5)}",first_name:Faker::Name.first_name, last_name:Faker::Name.last_name, email:Faker::Internet.email, password:"password",email_optout:true, password_confirmation:"password", address_1:Faker::Address.street_address, city:Faker::Address.city, state:Faker::Address.state_abbr, zip:Faker::Address.zip, phone1:Faker::PhoneNumber.cell_phone)
      team.players << Player.create!(first_name:Faker::Name.first_name, last_name:Faker::Name.last_name,user_id:new_user2.id, date_of_birth:Faker::Date.between(10.years.ago, 8.years.ago), jersey_number:Faker::Number.between(0, 99))
      new_user2.follow(team)
    end
  end
