class User < ApplicationRecord

  # GEM PARANOIA
  acts_as_paranoid
  # END GEM PARANOIA

  #cloudiary photo
  has_attachment :photo

  # VALIDATIONS AND ASSOCIATIONS FROM DEVISE GEM

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # :facebook is an array, you can add twitter etc.
  devise :omniauthable, omniauth_providers: [:facebook]
  # END VALIDATIONS AND ASSOCIATIONS FROM DEVISE GEM

  # VALIDATIONS AND ASSOCIATIONS
  validates :first_name, :last_name, presence: true
  has_many :hotels_as_owner, foreign_key: :user_id, class_name: 'Hotel', dependent: :destroy
  has_many :stays
  has_many :messages, through: :stays
  has_many :hotels, through: :stays
  has_many :rooms, through: :stays

  has_many :bookings
  has_many :services, through: :bookings

  # END VALIDATIONS AND ASSOCIATIONS FROM

  # facebook sign in sign up
  def self.find_for_facebook_oauth(auth)

      user_params = auth.slice(:provider, :uid)
      user_params.merge! auth.info.slice(:email, :first_name, :last_name)
      user_params[:facebook_picture_url] = auth.info.image
      user_params[:token] = auth.credentials.token
      user_params[:token_expiry] = Time.at(auth.credentials.expires_at)
      user_params = user_params.to_h

      user = User.find_by(provider: auth.provider, uid: auth.uid)
      user ||= User.find_by(email: auth.info.email) # User did a regular sign up in the past.
      if user
        user.update(user_params)
      else
        user = User.new(user_params)
        user.password = Devise.friendly_token[0,20]  # Fake password for validation
        user.save
      end

      return user
    end

    def koala
    @graph = Koala::Facebook::API.new(token)

  end

end
