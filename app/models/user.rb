# User Model
#
# Created on April 29, 2009 11:35 by Mark Connell as part
# of the "authentication" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++
require 'digest/sha1'

class User < ActiveRecord::Base
  unloadable

  ## Named scopes
  named_scope :active, :conditions => { :state => "active" }
  named_scope :inactive, :conditions => ["state != 'active'"]


  ## Validations
  before_validation :encrypt_plaintext_password_if_supplied

  validates_presence_of     :first_name, :last_name, :email
  validates_uniqueness_of   :username, :email
  validates_length_of       :email, :within => 6..100

  validates_length_of       :username, :within => 3..40       , :if => :plaintext_password_required?
  validates_presence_of     :password, :password_confirmation , :if => :plaintext_password_required?
  validates_confirmation_of :password                         , :if => :plaintext_password_required?
  validates_presence_of :crypted_password

  # Additional attributes
  attr_accessor :password, :password_confirmation

  before_create :make_admin_if_no_other_users
  def make_admin_if_no_other_users
    self.administrator = true if User.count == 0
  end

  # activation is delegated to the login object
  after_create :request_activation
  def request_activation
    login.request_activation
  end

  ## State Machine

  state_machine :initial => :new do

    before_transition :new => :pending do |object, transition|
      object.activated_at = nil
      object.activation_code = User.generate_hash
    end

    before_transition any => :active do |object, transition|
      object.activated_at = Time.now.utc
      object.activation_code = nil
      object.deleted_at = nil
    end

    before_transition any => :suspended do |object, transition|
      # nil anything related to activated users
      object.activated_at = nil
      object.activation_code = nil
    end

    before_transition any => :deleted do |object, transition|
      object.deleted_at = Time.now
      object.activated_at = nil
      object.activation_code = nil
    end

    event :request_activation do
      transition :new => :pending
    end

    event :activate do
      transition [:new, :pending, :suspended, :deleted] => :active
    end

    event :suspend do
      transition all => :suspended
    end

    event :mark_deleted do
      transition all => :deleted
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  ## Class Methods

  # Ask the user model to provide a token by which the user can be
  # authenticated (which may be stored as a cookie, for example) instead of
  # supplying a login and password.  The generated token will automatically
  # expire 2 weeks after its last use.
  def remember_me
    self.remember_token = self.class.generate_hash
    self.remember_token_expires_at = 2.weeks.from_now.utc
  end

  # Forget any associated remember token.  This will generally be called when
  # a user explicitly logs out.
  def forget_me
    self.remember_token = nil
    self.remember_token_expires_at = nil
  end

  # Determines whether a particular login and password matches any of the
  # active users in the database.  If it does, then this method returns that
  # user instance.  If not, it returns +nil+.  It only checks active users (ie
  # those that have created an account and correctly verified their email
  # address).
  def self.authenticate(email, password)
    user = User.active.find_by_email(email)
    user if user.present? && user.correct_password?(password)
  end

  # Takes a password as an argument and indicates, by returning true or false,
  # whether the password supplied is the correct password for this user.
  # Authentication is really a two-step operation -- finding the user so that
  # we can supply the correct salt, then checking the password.  This is the
  # second part of that process, and is not intended to be called directly.
  def correct_password?(password)
    crypted_password == encrypt_plaintext_password(password)
  end

  # Generate a secure digest based upon the arguments passed to it.  Arguments
  # can be any strings.  This method is not intended to be used directly;
  # instead one should use +generate_hash+ or +password_digest+.
  def self.secure_digest(*args)
    Digest::SHA1.hexdigest args.join('--')
  end

  # Generate a hash based upon the current time and the name of the
  # application.  This should be random enough for most purposes.
  def self.generate_hash
    secure_digest Time.now.to_s(:long), File.basename(RAILS_ROOT)
  end

  # Generate an encrypted password based upon the supplied plain text password
  # and a salt.
  def self.password_digest(password, salt)
    secure_digest password, salt
  end

  def resend_activation!
    UserMailer.deliver_activation_request(self)
  end

  def reset_password!
    self.password = self.password_confirmation = User.generate_random_password
    UserMailer.deliver_password_reset(self)
    save!
  end

  PASSWORD_CHARACTERS = ((('a'..'z').to_a + ('A'..'Z').to_a + ('1'..'9').to_a) - ['o', 'O', 'i', 'I', 'l', 'L', '1']).freeze unless defined?(PASSWORD_CHARACTERS)

  # Generate a random +length+ (default: 8) character password.
  def self.generate_random_password(length = 8)
    Array.new(length) { PASSWORD_CHARACTERS[rand(PASSWORD_CHARACTERS.size)] }.join
  end

  def update_password(password, password_confirmation)
    valid?
    errors.add(:password, "must not be blank") if password.blank?
    errors.add(:password_confirmation, "must not be blank") if password_confirmation.blank?
    update_attributes(:password => password, :password_confirmation => password_confirmation) if errors.blank?
  end

  # Protected and private methods
  protected

  # If a plain text password is set in the model, then update the encrypted
  # password to match.
  def encrypt_plaintext_password_if_supplied
    if password.present?
      self.salt = self.class.generate_hash
      self.crypted_password = encrypt_plaintext_password
    end
  end

  # Encrypt a plain text password based upon the password string supplied
  # (default to the instance's current plain text password) along with the
  # salt already set on the current instance.
  def encrypt_plaintext_password(password = password)
    self.class.password_digest(password, salt)
  end

  # Determine whether the validations for the password should run.  The
  # password validations should run if:
  #
  # * There is no existing encrypted password; or
  # * A new plaintext password has been supplied.
  def plaintext_password_required?
    password.present? || crypted_password.blank?
  end


end
