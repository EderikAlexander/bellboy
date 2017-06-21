class Stay < ApplicationRecord

  # GEM PARANOIA
  acts_as_paranoid
  # END GEM PARANOIA

  # VALIDATIONS AND ASSOCIATIONS
  belongs_to :user
  belongs_to :hotel

  validates :start_booking_date, :end_booking_date, :checked_in, :checked_out, presence: true
  # END VALIDATIONS AND ASSOCIATIONS

private

def check_in
  self.checked_in = Date.today
end

def check_out
  self.checked_out = self.end_booking_date
end

end
