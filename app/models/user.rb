class User < ApplicationRecord

  # VALIDATIONS AND ASSOCIATIONS FROM DEVISE GEM

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # END VALIDATIONS AND ASSOCIATIONS FROM DEVISE GEM

  # VALIDATIONS AND ASSOCIATIONS
  validates :first_name, :last_name, :passport, presence: true

  emailvalidation = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, format: { with: emailvalidation, message: "Please enter a valid email address" }
  # END VALIDATIONS AND ASSOCIATIONS FROM

end
