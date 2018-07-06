class CreateUsersTable < ActiveRecord::Migration
  def change
      create_table :users do |t|
        t.string   "username"
        t.string   "email"
        t.string   "password_digest"
        t.boolean  "admin", default: false
        t.boolean  "email_confirmed", default: false
        t.string   "confirm_token"
        t.timestamp "created_at"
        t.timestamp "updated_at"
      end
  end
end
