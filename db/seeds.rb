# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# require 'json'
# require 'open-uri'

# puts 'Cleaning database...'
# Booking.destroy_all

# Pokemon.destroy_all
# User.destroy_all


# puts "Creating user..."
# user1 = User.create!(name: "Professeur Chen", email: "professeur.chen@pokemon.com", password: "password")
# user2 = User.create!(name: "Team Pokemon", email: "team_pokemon@lewagon.fr", password: "pokemons")

# puts " Pokémons from PokeAPI..."
# url = "https://pokeapi.co/api/v2/pokemon?limit=20"
# pokemon_list = JSON.parse(URI.open(url).read)

# pokemon_list["results"].each do |pokemon|
#   pokemon_data = JSON.parse(URI.open(pokemon["url"]).read)

#   name = pokemon_data["name"].capitalize
#   element_type = pokemon_data["types"].first["type"]["name"].capitalize
#   address =  [
#     "Pallet Town",
#     "Cinnabar Island",
#     "Cerulean City",
#     "Vermilion City",
#     "Lavender Town",
#     "Goldenrod City",
#     "Slateport City",
#     "Littleroot Town",
#     "Saffron City",
#     "Castelia City",
#     "Lumiose City",
#     "Mistralton City",
#     "Viridian City",
#     "Fuchsia City",
#     "Mauville City",
#     "Hearthome City",
#     "Icirrus City",
#     "Hau'oli City",
#     "Celadon City",
#     "Snowbelle City"
#   ]

#   descriptions = [
#     "Ce Pokémon adore se prélasser au soleil et se laisse facilement distraire par des éclats de lumière.",
#     "Il a un tempérament calme, mais peut parfois se montrer surprenant quand il est contrarié.",
#     "Ce Pokémon est un expert pour se cacher dans les buissons et surprendre ses ennemis.",
#     "Ne sous-estimez jamais sa petite taille, ce Pokémon a un cœur grand comme l'océan !",
#     "Il adore se rouler en boule et se prendre pour une balle de tennis, prêt à sauter dans toutes les directions.",
#     "Ce Pokémon pourrait vous suivre partout... à condition qu'il ne s'endorme pas en cours de route.",
#     "Il aime chanter des chansons mystérieuses la nuit, mais n'ose pas trop de peur de déranger les autres.",
#     "Sa couleur vive en fait un excellent guide dans la forêt, mais il n'est pas toujours facile à suivre.",
#     "Ce Pokémon est une véritable boule d'énergie, capable de courir pendant des heures sans jamais se fatiguer.",
#     "Un peu timide au début, mais une fois qu'il vous connaît, il est un ami fidèle et dévoué.",
#     "Ce Pokémon est très protecteur de son territoire et aime montrer ses pouvoirs à ceux qui osent s'aventurer trop près."
#   ]

#   price_per_day = rand(5..20)
#   description = descriptions.sample

#   created_pokemon = Pokemon.create!(
#     name: name,
#     element_type: element_type,
#     address: address.sample,
#     price_per_day: price_per_day,
#     user: [user1, user2].sample,
#     description: description
#   )

#    image_url = pokemon_data['sprites']['front_default']
#    created_pokemon.photo.attach(
#      io: URI.open(image_url),
#      filename: "#{name.downcase}.png",
#      content_type: 'image/png'
#    )

#   puts "Created: #{name} (Element ype: #{element_type}, Price: #{price_per_day}€/day)"
# end

# puts "Finished!  Created #{Pokemon.count} Pokemons"


require 'json'
require 'open-uri'

puts 'Cleaning database...'
Booking.destroy_all
Pokemon.destroy_all
User.destroy_all

puts "Creating user..."
user1 = User.create!(name: "Professeur Chen", email: "professeur.chen@pokemon.com", password: "password")
user2 = User.create!(name: "Team Pokemon", email: "team_pokemon@lewagon.fr", password: "pokemons")

puts "Fetching Pokémons from PokeAPI..."
url = "https://pokeapi.co/api/v2/pokemon?limit=20"
pokemon_list = JSON.parse(URI.open(url).read)

pokemon_list["results"].each do |pokemon|
  pokemon_data = JSON.parse(URI.open(pokemon["url"]).read)
  species_url = pokemon_data["species"]["url"]
  species_data = JSON.parse(URI.open(species_url).read)

  name = pokemon_data["name"].capitalize
  element_type = pokemon_data["types"].first["type"]["name"].capitalize
  address = [
    "Pallet Town", "Cinnabar Island", "Cerulean City", "Vermilion City", "Lavender Town",
    "Goldenrod City", "Slateport City", "Littleroot Town", "Saffron City", "Castelia City",
    "Lumiose City", "Mistralton City", "Viridian City", "Fuchsia City", "Mauville City",
    "Hearthome City", "Icirrus City", "Hau'oli City", "Celadon City", "Snowbelle City"
  ]

  # Récupération de la description en français
  description_entry = species_data["flavor_text_entries"].find { |entry| entry["language"]["name"] == "fr" }
  description = description_entry ? description_entry["flavor_text"].gsub("\n", " ") : "Description non disponible."

  price_per_day = rand(35..75)

  created_pokemon = Pokemon.create!(
    name: name,
    element_type: element_type,
    address: address.sample,
    price_per_day: price_per_day,
    user: [user1, user2].sample,
    description: description
  )

  image_url = pokemon_data['sprites']['front_default']
  created_pokemon.photo.attach(
    io: URI.open(image_url),
    filename: "#{name.downcase}.png",
    content_type: 'image/png'
  )

  puts "Created: #{name} (Element Type: #{element_type}, Price: #{price_per_day}€/day)"
end

puts "Finished! Created #{Pokemon.count} Pokemons"
