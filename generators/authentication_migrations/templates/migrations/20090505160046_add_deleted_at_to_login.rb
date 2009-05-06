class AddDeletedAtToLogin < ActiveRecord::Migration
  def self.up
    change_table :logins do |t|
      t.datetime :deleted_at
    end
  end

  def self.down
    change_table :logins do |t|
      t.remove :deleted_at
    end
  end
end
