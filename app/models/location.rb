class Location < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: :address_changed?


  # GEM PARANOIA
  acts_as_paranoid
  # END GEM PARANOIA

  #cloudiary photo
  has_attachment :photo

  # VALIDATIONS AND ASSOCIATIONS
  belongs_to :hotel

  validates :name, :address, presence: true
  validates :category, inclusion: { in: [ "Restaurants", "Rentals", "Sights", "beaches"] }
  # END VALIDATIONS AND ASSOCIATIONS

end
