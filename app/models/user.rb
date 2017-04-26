require 'bcrypt'

class User < ActiveRecord::Base
  extend UsersHelper
  validates :firstName, length: { minimum: 2 }, presence: true
  validates :lastName, length: { minimum: 2 }, presence: true
  validate :firstName_capitalized, :lastName_capitalized, :valid_phone, :position_taken
  validates :email, presence: true, :email => true
  validates :password, presence: true, length: { minimum: 8 }
  @pres_taken = false
  @vp_taken = false
  @soc_chair_taken = false
  # has_many :announcements
  # has_many :groups, through: :groups_users
  # has_many :groups_users, dependent: :destroy

  def firstName_capitalized
    unless firstName.nil?
      errors.add(:firstName, 'First name is not capitalized.') unless firstName.capitalize == firstName
    end
  end

  def lastName_capitalized
    unless lastName.nil?
      errors.add(:lastName, 'Last name is not capitalized.') unless lastName.capitalize == lastName
    end
  end

  def valid_phone
    unless phone.nil?
        errors.add(:phone, 'must be 10 digits.')  unless phone =~ /^\d{10}$/
    end
  end

  def position_taken
    if position == 'President'
      errors.add(:position, 'President is already taken') if self.class.pres_taken
      self.class.pres_taken = true unless self.class.pres_taken
    end

    if position == 'Vice President'
      errors.add(:position, 'Vice President position is already taken') if self.class.vp_taken
      self.class.vp_taken = true unless self.class.vp_taken
    end

    if position == 'Social Chair'
      errors.add(:position, 'Social Chair position is already taken') if self.class.soc_chair_taken
      self.class.soc_chair_taken = true unless self.class.soc_chair_taken
    end
  end

  include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end
