class AddLastLoggedInAtToLogins < ActiveRecord::Migration
  def self.up
    change_table :logins do |t|
      t.datetime :last_logged_in_at
    end
  end

  def self.down
    change_table :logins do |t|
      t.remove :last_logged_in_at
    end
  end
end
