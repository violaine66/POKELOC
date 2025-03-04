class ReviewsController < ApplicationController
  before_action :set_booking

  def new
    @review = @booking.reviews.build
  end

  def create
    @review = @booking.reviews.build(review_params)

    if @review.save
      redirect_to bookings_path, notice: 'Review added successfully!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def set_booking
    @booking = Booking.find(params[:booking_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment, :booking_id)
  end
end
