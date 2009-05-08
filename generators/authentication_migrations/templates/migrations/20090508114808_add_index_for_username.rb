class AddIndexForUsername < ActiveRecord::Migration
  def self.up
    change_table :logins do |t|
      t.index :username
    end
  end

  def self.down
    remove_index :logins, :username
  end
end
