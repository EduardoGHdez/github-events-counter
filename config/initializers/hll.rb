require './lib/hll'

ActiveSupport.on_load :active_record do
  # Add :hll column method, so it can be used for adding/changing a new column
  # within a migration.
  # See: https://api.rubyonrails.org/v7.0.4/classes/ActiveRecord/ConnectionAdapters/TableDefinition.html#method-i-column
  ActiveRecord::ConnectionAdapters::PostgreSQL::TableDefinition.prepend Hll::ColumnMethods

  # Register :hll type, so ActiveRecord is able to map hll values when it
  # interacts with the db (reading/writing).
  #
  # See: https://api.rubyonrails.org/v7.0.4/classes/ActiveRecord/ConnectionAdapters/TableDefinition.html#method-i-column
  ActiveRecord::Type.register(:hll, Hll::Type, override: false)

  # Register oid type do be detected on schema-dumper.
  # See example: https://github.com/rails/rails/pull/17443
  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend Hll::AdapterExtension

  Arel::Attributes::Attribute.prepend Hll::Arel::Predications
  Arel::Nodes::Function.prepend Hll::Arel::Predications
  Arel::Nodes::Grouping.prepend Hll::Arel::Predications
  Arel::Nodes::Unary.prepend Hll::Arel::Predications
  Arel::Nodes::Binary.prepend Hll::Arel::Predications
  Arel::Nodes::SqlLiteral.prepend Hll::Arel::Predications

  ActiveRecord::Calculations.prepend Hll::ActiveRecord::Calculations
  ActiveRecord::Querying.prepend Hll::ActiveRecord::Querying
end
