class Room < ApplicationRecord

  # GEM PARANOIA
  acts_as_paranoid
  # END GEM PARANOIA

  # VALIDATIONS AND ASSOCIATIONS
  belongs_to :hotel
  belongs_to :user ### MISSING (PENDING VALIDATION)

  validates :number, :room_type, presence: true
  validates :number, numericality: { only_integer: true }
  validates :room_type, inclusion: { in: [ "Single", "Double", "Triple", "Suite", "Studio" ] }
  # END VALIDATIONS AND ASSOCIATIONS

end
