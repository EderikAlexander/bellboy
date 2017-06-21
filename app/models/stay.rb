class Stay < ApplicationRecord

  # GEM PARANOIA
  acts_as_paranoid
  # END GEM PARANOIA

  # VALIDATIONS AND ASSOCIATIONS
  belongs_to :user
  belongs_to :hotel
  has_many :messages
  belongs_to :room, class_name: "Room", foreign_key: "room_id"
  validates :start_booking_date, presence: true
  validates :end_booking_date, presence: true
  # END VALIDATIONS AND ASSOCIATIONS

private

def check_in
  self.checked_in = Date.today
end

def check_out
  self.checked_out = self.end_booking_date
end

end
