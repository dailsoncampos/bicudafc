class CreateRounds < ActiveRecord::Migration[5.2]
  def change
    create_table :rounds do |t|
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
