class AddDescriptionToPokemons < ActiveRecord::Migration[7.1]
  def change
    add_column :pokemons, :description, :text
  end
end
