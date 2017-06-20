class Message < ApplicationRecord

  # VALIDATIONS AND ASSOCIATIONS
  belongs_to :stay

  validates :content, :from, presence: true
  # END VALIDATIONS AND ASSOCIATIONS

end
