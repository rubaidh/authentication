# User Exemplar
#
# Created on April 29, 2009 11:35 by Mark Connell as part
# of the "authentication" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

User.class_eval do
  generator_for :first_name, 'John'
  generator_for :last_name, 'Doe'
  generator_for :administrator, false

  # authentication related
  generator_for :email, :start => "testuser@example.com" do |prev|
    user, domain = prev.split('@')
    "#{user.succ}@#{domain}"
  end

  generator_for :activation_code, :start => "kaGhou1Ohxai6Iepho8vaxee8eideez3ku3ozohy" do |prev|
    prev.succ
  end

  generator_for :password, "foobar"
  generator_for :password_confirmation, "foobar"
  generator_for :last_logged_in_at, (Time.now - 10.days)
end
