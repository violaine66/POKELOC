class PokemonsController < ApplicationController

  def index
    @pokemons = Pokemon.all
  end

  def new
    @pokemon = pokemon.new
  end

  def create
    @pokemon = pokemon.new(pokemon_params)
    @pokemon.user = current_user

    if @pokemon.save
      redirect_to pokemon_path(@pokemon), notice: "Pokemon créé avec succès !"
    else
      render :new, status: :unprocessable_entity
    end

    private

    def pokemon_params
      params.required(:pokemon).permit(:name, :element_type, :address, :price_per_day)
    end
  end
end
