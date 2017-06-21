class Location < ApplicationRecord
  # GEM PARANOIA
  acts_as_paranoid
  # END GEM PARANOIA

  #cloudiary photo
  has_attachment :photo

  # VALIDATIONS AND ASSOCIATIONS
  belongs_to :hotel

  validates :name, :address, presence: true
  validates :category, inclusion: { in: [ "Restaurants", "Night life", "Entertainment", "Sight seeing", "Beaches"] }
  # END VALIDATIONS AND ASSOCIATIONS

end
