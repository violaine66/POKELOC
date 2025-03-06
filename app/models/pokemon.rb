class Pokemon < ApplicationRecord
  belongs_to :user
  has_many :bookings
  has_many :reviews, through: :bookings
  has_many_attached :photos
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?


  validates :name, presence: true
  validates :element_type, presence: true
  validates :address, presence: true
  validates :price_per_day, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true

  include PgSearch::Model
  pg_search_scope :search_by_name_type_and_address,
    against: [:name, :element_type, :address],
    using: {
      tsearch: { prefix: true }
    }
end
