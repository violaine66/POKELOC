
class Booking < ApplicationRecord
  belongs_to :pokemon
  belongs_to :user
  has_many :reviews, dependent: :destroy

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates_comparison_of :end_date, greater_than_or_equal_to: :start_date, message: "Cannot be earlier than the start date!"
  validates :total_price, presence: true

  validate :no_overlap_with_existing_bookings

  private

  def no_overlap_with_existing_bookings
    conflicting_booking = pokemon.bookings.where('start_date < ? AND end_date > ?', end_date, start_date).exists?
    errors.add(:base, 'Booking conflicts with an existing reservation') if conflicting_booking
  end
end
