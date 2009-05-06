class AddAdministratorColumnToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.boolean :administrator
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :adminstrator
    end
  end
end
