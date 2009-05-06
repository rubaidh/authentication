# User Model
#
# Created on April 29, 2009 11:35 by Mark Connell as part
# of the "authentication" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

class User < ActiveRecord::Base
  has_one :login
  accepts_nested_attributes_for :login, :allow_destroy => true

  ## named scope
  named_scope :active, lambda { { :joins => :login, :conditions => ["logins.state = ?", "active"] } }
  named_scope :inactive, lambda { { :joins => :login, :conditions => ["logins.state != ?", "active"] } }

  validates_presence_of :first_name, :last_name

  # activation is delegated to the login object
  after_create :request_activation
  def request_activation
    login.request_activation
  end

  def initialize(*params)
    super
    build_login if login.blank?
    self.administrator = true if User.count == 0
  end

  def email
    login.email
  end

  def email=(email)
    login.update_attribute(:email, email)
  end

end
