class Service < ApplicationRecord

  # VALIDATIONS AND ASSOCIATIONS
  belongs_to :hotel
  validates :title, :description, :start_time, :end_time, presence: true
  validates :price, numericality: true
  validates :title, uniqueness: true
  # END VALIDATIONS AND ASSOCIATIONS
end
