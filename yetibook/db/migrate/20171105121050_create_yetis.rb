class CreateYetis < ActiveRecord::Migration[5.1]
  def change
    create_table :yetis do |t|
      t.string :name
      t.string :email
      t.string :password_digest

      t.timestamps
    end
    add_index :yetis, :email, unique: true
  end
end
