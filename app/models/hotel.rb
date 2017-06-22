class Hotel < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  # GEM PARANOIA
  acts_as_paranoid
  # END GEM PARANOIA

  #cloudiary photo
  has_attachment :photo

  # VALIDATIONS AND ASSOCIATIONS
  has_many :services, dependent: :destroy
  has_many :rooms, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :stays, dependent: :destroy
  has_many :users, through: :stays
  has_many :messages, through: :stays

  belongs_to :user

  validates :name, :address, :city, presence: true
  validates :name, uniqueness: { scope: [:address, :city] }
  # END VALIDATIONS AND ASSOCIATIONS

  def can_manage?(current_user)
    self.user_id and self.user == current_user
  end

end
