class CreateClients < ActiveRecord::Migration[8.1]
  def change
    create_table :clients do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email
      t.string :phone
      t.text :notes

      t.timestamps
    end

    add_index :clients, :email, unique: true, where: 'email IS NOT NULL'
  end
end
