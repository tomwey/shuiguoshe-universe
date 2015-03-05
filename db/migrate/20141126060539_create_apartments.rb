class CreateApartments < ActiveRecord::Migration
  def change
    create_table :apartments do |t|
      t.string :name
      t.string :address

      t.timestamps
    end
  end
end
