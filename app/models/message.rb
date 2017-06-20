class Message < ApplicationRecord

  # GEM PARANOIA
  acts_as_paranoid
  # END GEM PARANOIA

  # VALIDATIONS AND ASSOCIATIONS
  belongs_to :stay

  validates :content, :from, presence: true
  # END VALIDATIONS AND ASSOCIATIONS

end
