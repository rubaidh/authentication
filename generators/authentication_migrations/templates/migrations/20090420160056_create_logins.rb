# CreateLogins Migration
#
# Created on April 20, 2009 17:00 by Mark Connell as part
# of the "Login app" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

class CreateLogins < ActiveRecord::Migration
  def self.up
    create_table :logins do |t|
      t.string :username,                     :limit => 255
      t.string :crypted_password,             :limit => 40
      t.string :salt,                         :limit => 40
      t.string :remember_token,               :limit => 40
      t.datetime :remember_token_expires_at
      t.string :activation_code,              :limit => 40
      t.datetime :activated_at
      t.string :state,                        :limit => 255

      t.timestamps
    end
  end

  def self.down
    drop_table :logins
  end
end
