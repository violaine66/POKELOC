class Pokemon < ApplicationRecord
  belongs_to :user
  # has_many :reviews, dependent: :destroy
  has_many :bookings, dependent: :destroy

  has_many_attached :photos

  validates :name, presence: true
  validates :element_type, presence: true
  validates :address, presence: true
  validates :price_per_day, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true
end
