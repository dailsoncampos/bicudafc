class CreateClubs < ActiveRecord::Migration[5.2]
  def change
    create_table :clubs do |t|
      t.integer :id_club
      t.string :name
      t.string :abbreviation
      t.integer :position
      t.string :fantasy_name
      t.string :shield_30x30
      t.string :shield_45x45
      t.string :shield_60x60

      t.timestamps
    end
  end
end
