class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.boolean :active
      t.integer :position

      t.timestamps
    end

    add_index :items, :active
    add_index :items, :position
  end
end
