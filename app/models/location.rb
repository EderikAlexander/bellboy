class Location < ApplicationRecord
  # GEM PARANOIA
  acts_as_paranoid
  # END GEM PARANOIA

  # VALIDATIONS AND ASSOCIATIONS
  belongs_to :hotel

  validates :name, :address, presence: true
  validates :category, inclusion: { in: [ "Restaurants", "Rentals", "Sight seeing"] }
  # END VALIDATIONS AND ASSOCIATIONS

end
