class CreateGithubEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :github_events, id: false do |t|
      t.bigint :event_id, index: true, null: false
      t.string :event_type
      t.boolean :event_public
      t.bigint :repo_id
      t.jsonb :payload
      t.jsonb :repo
      t.bigint :user_id
      t.jsonb :org
      t.timestamp :created_at
    end
  end
end
