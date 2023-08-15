require 'rails_helper'

describe DailyRollup do
  describe 'hll_cardinality' do
    before do
      create_list :github_event, 10, user_id: 1, created_at: '2023-01-01'.to_date
      create_list :github_event, 10, user_id: 2, created_at: '2023-01-01'.to_date
      create_list :github_event, 10, user_id: 1, created_at: '2023-01-02'.to_date
      create_list :github_event, 10, user_id: 3, created_at: '2023-01-03'.to_date

      users_by_day = Github::Event.users_by_day.as_json

      DailyRollup.upsert_all(users_by_day)
    end

    it 'returns unique users count' do
      result = DailyRollup.hll_cardinality(:users)
      expect(result).to eq(3)
    end

    it 'returns unique users by day' do
      result = DailyRollup.group(:date)
                          .order(date: :asc)
                          .hll_cardinality(:users)

      expect(result).to eq([
        { "date" => '2023-01-01T00:00:00.000Z', 'users' => 2 },
        { "date" => '2023-01-02T00:00:00.000Z', 'users' => 1 },
        { "date" => '2023-01-03T00:00:00.000Z', 'users' => 1 },
      ])
    end
  end
end
