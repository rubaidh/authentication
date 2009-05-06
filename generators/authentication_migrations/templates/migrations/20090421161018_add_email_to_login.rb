class AddEmailToLogin < ActiveRecord::Migration
  def self.up
    change_table :logins do |t|
      t.string :email
    end
  end

  def self.down
    change_table :logins do |t|
      t.remove :email
    end
  end
end
