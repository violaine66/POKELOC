class PokemonsController < ApplicationController

  def index
    if params[:query].present?
      @pokemons = Pokemon.where("name ILIKE ? OR element_type ILIKE ? OR address ILIKE ?",
                              "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%")

    else
       @pokemons = Pokemon.all
    end

    @markers = @pokemons.geocoded.map do |pokemon|

      {
        lat: pokemon.latitude,
        lng: pokemon.longitude,
        info_window_html:  render_to_string(partial: "info_window", locals: {pokemon: pokemon}),
        marker_html: render_to_string(partial: "marker", locals: { pokemon: pokemon })
      }
    end
  end

  def show
    @pokemon = Pokemon.find(params[:id])
    @booking = Booking.new
    @reviews = @pokemon.reviews

    @reviews = Review.new

    if @pokemon.latitude && @pokemon.longitude
      @markers = [
        {
          lat: @pokemon.latitude,
          lng: @pokemon.longitude,
          info_window_html: render_to_string(partial: "info_window", locals: { pokemon: @pokemon }),
          marker_html: render_to_string(partial: "marker",  locals: { pokemon: @pokemon })
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
      redirect_to pokemon_path(@pokemon), notice: "pokemon created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def search
    if params[:query].present?
      @pokemons = Pokemon.search_by_name_type_and_address(params[:query])
    else
      @pokemons = Pokemon.all
    end
    render :index
  end

    private

    def pokemon_params
      params.require(:pokemon).permit(:name, :element_type, :address, :price_per_day, :description, photos: [])
    end


end
