# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'json'
require 'open-uri'

puts 'Cleaning database...'
Pokemon.destroy_all
User.destroy_all

puts "Creating user..."
user1 = User.create!(name: "Professeur Chen", email: "professeur.chen@pokemon.com", password: "password")
user2 = User.create!(name: "Team Pokemon", email: "team_pokemon@lewagon.fr", password: "pokemons")

puts " Pokémons from PokeAPI..."
url = "https://pokeapi.co/api/v2/pokemon?limit=20"
pokemon_list = JSON.parse(URI.open(url).read)

pokemon_list["results"].each do |pokemon|
  pokemon_data = JSON.parse(URI.open(pokemon["url"]).read)

  name = pokemon_data["name"].capitalize
  element_type = pokemon_data["types"].first["type"]["name"].capitalize
  address =  [
    "Pallet Town",
    "Cinnabar Island",
    "Cerulean City",
    "Vermilion City",
    "Lavender Town",
    "Goldenrod City",
    "Slateport City",
    "Littleroot Town",
    "Saffron City",
    "Castelia City",
    "Lumiose City",
    "Mistralton City",
    "Viridian City",
    "Fuchsia City",
    "Mauville City",
    "Hearthome City",
    "Icirrus City",
    "Hau'oli City",
    "Celadon City",
    "Snowbelle City"
  ]

  price_per_day = rand(5..20)

  created_pokemon = Pokemon.create!(
    name: name,
    element_type: element_type,
    address: address.sample,
    price_per_day: price_per_day,
    user: [user1, user2].sample
  )

   image_url = pokemon_data['sprites']['front_default']
   created_pokemon.photo.attach(
     io: URI.open(image_url),
     filename: "#{name.downcase}.png", 
     content_type: 'image/png'
   )

  puts "Created: #{name} (Element ype: #{element_type}, Price: #{price_per_day}€/day)"
end

puts "Finished!  Created #{Pokemon.count} Pokemons"
