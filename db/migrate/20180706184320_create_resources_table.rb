class CreateResourcesTable < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :title
      t.string :description
      t.string :url
      t.timestamps :created_at
      t.timestamps :updated_at
    end
  end
end
