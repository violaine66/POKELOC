class BookingsController < ApplicationController
  before_action :set_pokemon, only: %i[new create]

  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.pokemon = @pokemon
    @booking.user = current_user
    @booking.status = "réservé"
    @booking.total_price = @booking.start_date == @booking.end_date ? @pokemon.price_per_day : (@booking.end_date - @booking.start_date + 1) * @pokemon.price_per_day
    if @booking.save
      redirect_to pokemon_path(@pokemon)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_pokemon
    @pokemon = Pokemon.find(params[:pokemon_id])
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end
end
