class Hotel < ApplicationRecord

  # VALIDATIONS AND ASSOCIATIONS
  has_many :services, dependent: :destroy
  has_many :rooms, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :stays, dependent: :destroy
  has_many :users, through: :stays
  has_many :messages, through: :stays

  validates :name, :address, :city, presence: true
  validates :name, uniqueness: { scope: [:address, :city] }
  # END VALIDATIONS AND ASSOCIATIONS

end
