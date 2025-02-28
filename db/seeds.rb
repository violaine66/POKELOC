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
Booking.destroy_all
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

   descriptions = {
    "Bulbasaur" => "Bulbasaur, ce petit Pokémon avec une plante sur son dos, adore les promenades sous la pluie. Attention, il peut arroser tout ce qui passe à proximité !",
    "Ivysaur" => "Ivysaur est toujours prêt à vous donner des conseils pour jardiner. Il a un certain talent pour faire pousser des plantes... et des ennuis.",
    "Venusaur" => "Venusaur aime les longues siestes au soleil. Attention, si vous êtes sous son ombre, vous pourriez devenir sa prochaine victime... de pollen !",
    "Charmander" => "Charmander est un petit feu ambulant. Il peut allumer un barbecue rien qu'en éternuant !",
    "Charmeleon" => "Charmeleon a un tempérament de feu... littéralement. Mais attention, il pourrait aussi s'enflammer pour rien. Une vraie boule de nerfs.",
    "Charizard" => "Charizard, le dragon ultime, peut fondre un métal avec son souffle ardent. Mais n'ayez crainte, il préfère les marshmallows grillés.",
    "Squirtle" => "Squirtle aime se mouiller, mais attention, il peut être aussi un peu trop généreux avec ses jets d'eau ! Ne soyez pas surpris s'il vous asperge lors de sa joyeuse baignade.",
    "Wartortle" => "Wartortle est un maître du yoga aquatique. En revanche, il n'a pas vraiment l'air de s'intéresser à l'idée de vous apprendre la technique. Il est plus intéressé par ses propres bras !",
    "Blastoise" => "Blastoise est un grand fan de l'hydrothérapie. Il a les meilleures canons à eau, mais vous ne voudriez pas être dans sa ligne de mire.",
    "Pidgey" => "Pidgey passe son temps à voler en cercles. Mais attention, ne vous approchez pas trop près, il pourrait se perdre dans vos cheveux.",
    "Pidgeotto" => "Pidgeotto est un oiseau assez royal. Il aime surveiller son territoire et les gens qui ne respectent pas ses frontières sont souvent renvoyés avec un bon coup de bec.",
    "Pidgeot" => "Pidgeot est le roi des oiseaux. Si vous avez besoin d'un vol rapide, il est là, même s'il préfère une petite sieste avant de vous emmener quelque part.",
    "Rattata" => "Rattata est un rat des champs qui adore courir partout. C'est le Pokémon le plus rapide de la région… mais surtout pour fuir les ennuis !",
    "Raticate" => "Raticate est un gourmande invétérée. Tout ce qui brille ou a l'air comestible disparaîtra en un éclair.",
    "Jigglypuff" => "Jigglypuff a un super pouvoir : endormir les gens avec sa chanson. Mais attention, même lui tombe parfois de sommeil en plein concert !",
    "Wigglytuff" => "Wigglytuff aime chanter, mais ses performances sont un peu trop... soporifiques pour certains. Restez loin si vous avez un gros examen à passer !",
    "Meowth" => "Meowth aime l'argent et les câlins. Mais n'attendez pas qu'il partage ses pièces, il les garde toutes pour lui-même.",
    "Persian" => "Persian est un chat majestueux. On dirait qu'il a été élevé dans un palace. Soyez prêt à le traiter comme un véritable roi ou reine de la maison.",
    "Psyduck" => "Psyduck, ce Pokémon un peu perturbé, n'a toujours pas compris pourquoi il a mal à la tête. Heureusement, ses amis sont là pour l'aider… même s'ils ne savent pas comment.",
    "Golduck" => "Golduck a enfin compris d'où venait sa migraine : trop de pensées. Il préfère se relaxer au bord de l'eau maintenant, loin du stress."
  }

  puts "Created: #{name} (Element ype: #{element_type}, Price: #{price_per_day}€/day)"
end

puts "Finished!  Created #{Pokemon.count} Pokemons"
