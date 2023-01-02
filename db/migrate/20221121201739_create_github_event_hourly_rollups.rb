class CreateGithubEventHourlyRollups < ActiveRecord::Migration[7.0]
  def change
    create_table :github_event_hourly_rollups do |t|
      t.timestamp :date
      t.string :event_type
      t.hll :distinct_user_id_count
    end
  end
end
