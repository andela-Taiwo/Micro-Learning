class CreateUsersTable1 < ActiveRecord::Migration
  def change
    rename_column :users, :password, :password_digest
    change_table :users do |t|
      t.column :admin, :boolean, default: false
    end
  end
end
