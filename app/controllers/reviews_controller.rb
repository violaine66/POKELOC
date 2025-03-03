class ReviewsController < ApplicationController
  def new
    @booking = Booking.find(params[:booking_id])
    @review = @booking.build_review
  end

  def create
    @booking = Booking.find(params[:booking_id])
    @review = @booking.build_review(review_params)



    if @review.save
      redirect_to booking_path(@booking), notice: 'Review added successfully!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def review_params
    params.require(:review).permit(:rating, :comment, :booking_id)
  end
end
