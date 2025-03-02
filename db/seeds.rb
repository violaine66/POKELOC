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

puts "Creating user..."
user1 = User.create!(name: "Professeur Chen", email: "professeur.chen@pokemon.com", password: "password")
user2 = User.create!(name: "Team Pokemon", email: "team_pokemon@lewagon.fr", password: "pokemons")

puts "Fetching Pokémons from PokeAPI..."
url = "https://pokeapi.co/api/v2/pokemon?limit=50"
pokemon_list = JSON.parse(URI.open(url).read)

pokemon_list["results"].each do |pokemon|
  pokemon_data = JSON.parse(URI.open(pokemon["url"]).read)
  species_url = pokemon_data["species"]["url"]
  species_data = JSON.parse(URI.open(species_url).read)

  name = pokemon_data["name"].capitalize
  element_type = pokemon_data["types"].first["type"]["name"].capitalize
  address = [
    "Rue du Chenipan, Bourg Palette", "Avenue Dracaufeu, Cramois’Île", "Quai Léviator, Azuria", "Boulevard Pikachu, Carmin-sur-Mer", "Impasse Fantominus, Lavanville",
    "Place Togepi, Doublonville", "Rue du Wailord, Poivressel", "Allée Arcko, Bourg-en-Vol", "Avenue Kadabra, Safrania", "Promenade Noarfang, Volucité",
    "Rue Méga-Gardevoir, Illumis", "Sentier Altaria, Mistral", "Impasse Tortank, Jadielle", "Chemin Smogogo, Parmanie", "Allée Dynamo, Lavandia",
    "Esplanade Togekiss, Unionpolis", "Parc Cryptero, Flocombe", "Rue Brindibou, Ekaeka", "Place Évoli, Céladopole", "Boulevard Givrali, Fort Vanitas",
    "Avenue Sulfura, Îles Écume", "Boulevard Mewtwo, Caverne Azurée", "Place Celebi, Forêt Johto", "Allée Rayquaza, Pilier Céleste", "Rue Dialga, Mont Couronné",
    "Esplanade Giratina, Distorsion", "Sentier Reshiram, Tour Dragospire", "Rue Zygarde, Grotte Coda", "Place Lunala, Autel de la Lune", "Boulevard Zacian, Forêt de Sleepwood",
    "Promenade Arceus, Hall de l'Origine", "Quai Kyogre, Abysse Maritime", "Chemin Darkrai, Île Pleine Lune", "Place Ho-oh, Tour Ferraille", "Rue Latios, Îles du Sud",
    "Allée Deoxys, Triangle des Bermudes", "Avenue Lugia, Tour des Mers", "Esplanade Regigigas, Temple de Neige", "Boulevard Palkia, Galaxie Distorsion", "Promenade Jirachi, Vallée des Étoiles"
  ]

# Récupérer directement la description sans vérifier la langue
description = species_data["flavor_text_entries"].first["flavor_text"].gsub("\n", " ")

price_per_day = rand(5..20)

  created_pokemon = Pokemon.create!(
    name: name,
    element_type: element_type,
    address: address.sample,
    price_per_day: price_per_day,
    user: [user1, user2].sample,
    description: description
  )

  image_urls = [
    pokemon_data['sprites']['front_default'],
    pokemon_data['sprites']['back_default'],
    pokemon_data['sprites']['front_shiny'],
    pokemon_data['sprites']['back_shiny'],
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
