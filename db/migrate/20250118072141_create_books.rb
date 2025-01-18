class CreateBooks < ActiveRecord::Migration[7.2]
  def change
    create_table :books do |t|
      t.integer :author_id, null: false
      t.string :title, null: false
      t.text :description, null: false

      t.timestamps
    end
  end
end
