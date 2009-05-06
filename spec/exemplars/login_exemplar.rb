# Login Exemplar
#
# Created on April 20, 2009 17:00 by Mark Connell as part
# of the "Login app" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

Login.class_eval do
  generator_for :username, :start => "testuser" do |prev|
    prev.succ
  end

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
