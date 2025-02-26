class Pokemon < ApplicationRecord
  belongs_to :user

  validates :name, presence:true
  validates :element_type, presence:true
  validates :address, presence:true
  validates :price_per_day, presence:true
end
