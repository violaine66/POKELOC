class BookingsController < ApplicationController
  before_action :set_pokemon, only: %i[new create]

  def index
    @bookings = current_user.bookings
    @reviews = Review.all 
  end

  def new
    @booking = Booking.new
  end


  def create
    @booking = Booking.new(booking_params)
    @booking.pokemon = @pokemon
    @booking.user = current_user
    @booking.status = "active"

    if @booking.end_date && @booking.start_date
      @booking.total_price = (@booking.end_date - @booking.start_date + 1) * @pokemon.price_per_day
    else
      flash[:error] = "Please provide both start and end dates."
      render "pokemons/show" and return
    end

    if @booking.save
      flash[:success] = "Booking created successfully."
      redirect_to pokemon_path(@pokemon)
    else
      flash[:error] = "There was an error creating the booking."
      render "pokemons/show", status: :unprocessable_entity
    end
  end

  def cancel
    @booking = Booking.find(params[:id])
    @booking.update(status: "inactive")
    redirect_to bookings_path
  end


  private

  def set_pokemon
    @pokemon = Pokemon.find(params[:pokemon_id])
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end
end
