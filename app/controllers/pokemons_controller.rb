class PokemonsController < ApplicationController

  def index
    @pokemons = Pokemon.all
  end

  def show
    @pokemon = Pokemon.find(params[:id])
    @booking = Booking.new
    
    @reviews = Review.new

    if @pokemon.latitude && @pokemon.longitude
      @markers = [
        {
          lat: @pokemon.latitude,
          lng: @pokemon.longitude,
          info_window_html: render_to_string(partial: "info_window", locals: { pokemon: @pokemon })
        }
      ]
    else
      @markers = []
    end

  end

  def new
    @pokemon = Pokemon.new
  end

  def create
    @pokemon = Pokemon.new(pokemon_params)
    @pokemon.user = current_user

    if @pokemon.save
      redirect_to pokemon_path(@pokemon), notice: "Pokemon créé avec succès ! "
    else
      render :new, status: :unprocessable_entity
    end
  end
    private

    def pokemon_params
      params.require(:pokemon).permit(:name, :element_type, :address, :price_per_day, :description, photos: [])
    end
end
