# CreateUsers Migration
#
# Created on April 29, 2009 11:35 by Mark Connell as part
# of the "authentication" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      # core user details
      t.string    :first_name
      t.string    :last_name
      t.string    :email

      # authentication details
      t.string    :username,                     :limit => 255
      t.string    :crypted_password,             :limit => 40
      t.string    :salt,                         :limit => 40
      t.string    :remember_token,               :limit => 40
      t.datetime  :remember_token_expires_at
      t.string    :activation_code,              :limit => 40
      t.datetime  :activated_at
      t.string    :state,                        :limit => 255
      t.datetime  :deleted_at
      t.datetime  :last_logged_in_at

      # authority details
      t.boolean :administrator

      # additionals
      t.timestamps
    end

    # table is created so we can now create the index
    add_index(:users, :email)
  end

  def self.down
    drop_table :users
  end
end
