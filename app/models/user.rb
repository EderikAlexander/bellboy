class User < ApplicationRecord

  # GEM PARANOIA
  acts_as_paranoid
  # END GEM PARANOIA

  # VALIDATIONS AND ASSOCIATIONS FROM DEVISE GEM

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # END VALIDATIONS AND ASSOCIATIONS FROM DEVISE GEM

  # VALIDATIONS AND ASSOCIATIONS
  validates :first_name, :last_name, presence: true
  has_many :stays
  has_many :messages, through: :stays
  has_many :hotels, through: :stays
  has_many :rooms, through: :stays

  # END VALIDATIONS AND ASSOCIATIONS FROM

end
