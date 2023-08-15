require 'rails_helper'

describe Github::Event do
  subject(:event) { Github::Event.new }

  it { is_expected.to respond_to(:event_id) }
  it { is_expected.to respond_to(:event_type) }
  it { is_expected.to respond_to(:event_public) }
  it { is_expected.to respond_to(:repo_id) }
  it { is_expected.to respond_to(:payload) }
  it { is_expected.to respond_to(:repo) }
  it { is_expected.to respond_to(:user_id) }
  it { is_expected.to respond_to(:created_at) }

  describe '.users_by_day' do

    before do
      create :github_event, user_id: 100, created_at: '2023-01-01'.to_date
      create :github_event, user_id: 200, created_at: '2023-01-02'.to_date
    end

    subject(:users_by_day) { Github::Event.users_by_day }

    it 'returns users hyperloglog by day' do
      expect(users_by_day).to eq([
        {
          "date" => '2023-01-01T00:00:00.000Z',
          "users" => Hll.bigint_agg(100)
        },
        {
          "date" => '2023-01-02T00:00:00.000Z',
          "users" => Hll.bigint_agg(200)
        },
      ])
    end
  end
end
