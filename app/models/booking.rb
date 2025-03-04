class Booking < ApplicationRecord
  belongs_to :pokemon
  belongs_to :user
  has_one :review

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates_comparison_of :end_date, greater_than_or_equal_to: :start_date,
                          message: "Cannot be earlier than the start date!"

  validates :total_price, presence: true
end
