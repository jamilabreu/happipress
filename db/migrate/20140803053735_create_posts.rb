class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :title
      t.text :url
      t.text :summary
      t.integer :entry_id
      t.string :ancestry
      t.references :user

      t.timestamps
    end
  end
end
