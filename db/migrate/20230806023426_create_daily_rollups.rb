class CreateDailyRollups < ActiveRecord::Migration[7.0]
  def change
    create_table :daily_rollups do |t|
      t.datetime :date
      t.hll :users

      t.timestamps
    end
  end
end
