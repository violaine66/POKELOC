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

require 'json'
require 'open-uri'

puts 'Cleaning database...'
Booking.destroy_all
Pokemon.destroy_all
User.destroy_all
Review.destroy_all

puts "Creating user..."
user1 = User.create!(name: "Professeur Chen", email: "professeur.chen@pokemon.com", password: "password")
user2 = User.create!(name: "Team Pokemon", email: "team_pokemon@lewagon.fr", password: "pokemons")

puts "Fetching Pokémons from PokeAPI..."
url = "https://pokeapi.co/api/v2/pokemon?limit=30"
pokemon_list = JSON.parse(URI.open(url).read)

pokemon_list["results"].each do |pokemon|
  pokemon_data = JSON.parse(URI.open(pokemon["url"]).read)
  species_url = pokemon_data["species"]["url"]
  species_data = JSON.parse(URI.open(species_url).read)

  name = pokemon_data["name"].capitalize
  element_type = pokemon_data["types"].first["type"]["name"].capitalize
  address = addresses = [
    "Rua do Bonfim, Lisbonne, Portugal",
    "Calle del Espejo, Madrid, Espagne",
    "Baker Street, Londres, Royaume-Uni",
    "Chicken Dinner Road, Idaho, États-Unis",
    "Rua das Flores, Porto, Portugal",
    "Sesame Street, New York, États-Unis",
    "Avenue de la Toison d'Or, Bruxelles, Belgique",
    "Paradisgatan, Göteborg, Suède",
    "Funny Street, Canberra, Australie",
    "Ha Ha Road, Londres, Royaume-Uni",
    "Calle de la Amargura, San José, Costa Rica",
    "Pillow Street, Manchester, Royaume-Uni",
    "Rue du Chat-qui-Pêche, Paris, France",
    "Bubblegum Alley, San Luis Obispo, États-Unis",
    "Calle de la Primavera, Séville, Espagne",
    "Rua do Céu, Rio de Janeiro, Brésil",
    "Pancake Street, Rotterdam, Pays-Bas",
    "Bumpy Road, Alaska, États-Unis",
    "Avenue de la Joie, Québec, Canada",
    "Chemin du Bout du Monde, Genève, Suisse",
    "Diagon Alley, Édimbourg, Royaume-Uni",
    "Lost Street, Oklahoma City, États-Unis",
    "Memory Lane, Toronto, Canada",
    "Nowhere Road, Nevada, États-Unis",
    "Rue de la Bière, Bruxelles, Belgique",
    "Chicken Alley, Charleston, États-Unis",
    "Lollipop Lane, California, États-Unis",
    "Happy Street, Singapour",
    "Rainbow Road, Christchurch, Nouvelle-Zélande",
    "Zzyzx Road, Californie, États-Unis"
  ]



# Récupérer directement la description sans vérifier la langue
description = species_data["flavor_text_entries"].first["flavor_text"].gsub("\n", " ")

price_per_day = rand(50..100)

  created_pokemon = Pokemon.create!(
    name: name,
    element_type: element_type,
    address: address.sample,
    price_per_day: price_per_day,
    user: [user1, user2].sample,
    description: description
  )

  image_urls = [
    pokemon_data['sprites']['other']['official-artwork']['front_default'],
    pokemon_data['sprites']['other']['official-artwork']['front_shiny']
  ].compact

  image_urls.last(2).each_with_index do |image_url, index|
    created_pokemon.photos.attach(
      io: URI.open(image_url),
      filename: "#{name.downcase}_#{index}.png",
      content_type: 'image/png'
    )
  end

  puts "Created: #{name} (Element Type: #{element_type}, Price: #{price_per_day}€/day) with #{image_urls.size} images"
end

puts "Finished! Created #{Pokemon.count} Pokemons"
