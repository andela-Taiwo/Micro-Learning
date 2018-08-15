class CreateTopicsTable < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :title
      t.string :description
      t.timestamps :created_at
      t.timestamps :updated_at
    end
  end
end
