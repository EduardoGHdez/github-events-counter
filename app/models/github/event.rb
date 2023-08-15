class Github::Event < ActiveRecord::Base
  def self.users_by_day
    events = arel_table
    day = events[:created_at].date_trunc('day').as('date')
    users_hll = events[:user_id].hll_hash_bigint.hll_add_agg.as('users')

    select(day, users_hll).group(:date).as_json
  end
end
