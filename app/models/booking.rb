class Booking < ApplicationRecord
  belongs_to :pokemon
  belongs_to :user

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates_comparison_of :end_date, greater_than_or_equal_to: :start_date, message: 'La date de fin ne peut pas être inférieure à la date de début !'
  validates :total_price, presence: true
end
