class Location < ApplicationRecord

  # VALIDATIONS AND ASSOCIATIONS
  belongs_to :hotel

  validates :name, :address, presence: true
  validates :category, inclusion: { in: [ "Restaurants", "Night life", "Entertainment", "Sight seeing"] }
  # END VALIDATIONS AND ASSOCIATIONS

end
