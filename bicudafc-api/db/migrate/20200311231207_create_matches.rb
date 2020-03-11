class CreateMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :matches do |t|
      t.integer :id_match
      t.integer :home_club_id
      t.integer :position_home_club
      t.integer :away_club_id
      t.integer :position_away_club
      t.datetime :date
      t.string :location
      t.boolean :match_validate
      t.integer :score_home_club
      t.integer :score_away_club
      t.text :performance_home_club
      t.text :performance_away_club
      t.references :round, foreign_key: true

      t.timestamps
    end
  end
end
