FactoryBot.define do
  factory :github_event, class: 'Github::Event' do
    sequence(:event_id)
    sequence(:user_id)
  end
end
