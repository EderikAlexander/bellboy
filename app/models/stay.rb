class Stay < ApplicationRecord

  # GEM PARANOIA
  acts_as_paranoid
  # END GEM PARANOIA

  # VALIDATIONS AND ASSOCIATIONS
  belongs_to :user
  belongs_to :hotel
  has_many :messages

  validates :start_booking_date, :end_booking_date, :checked_in, :checked_out, presence: true
  # END VALIDATIONS AND ASSOCIATIONS

end
