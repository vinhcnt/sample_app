class User < ApplicationRecord
  before_save :downcase_email

  USER_PARAMS = %i(name email password password_confirmation).freeze

  validates :name, presence: true,
    length: {maximum: Settings.validation.user.name.max_length}

  validates :email, presence: true,
    length: {maximum: Settings.validation.user.email.max_length},
    format: {with: Settings.validation.user.email.valid_email_regex},
    uniqueness: true

  validates :password, presence: true,
    length: {minimum: Settings.validation.user.password.min_length}

  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end
  end

  private

  def downcase_email
    email.downcase!
  end
end
