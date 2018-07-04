class CreateTopicResourcesTable < ActiveRecord::Migration
  def change
    create_table :topic_resources do |t|
      t.integer :topic_id
      t.integer :resource_id
      t.timestamps :created_at
      t.timestamps :updated_at
    end
  end
end
