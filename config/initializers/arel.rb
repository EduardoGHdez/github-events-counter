require './lib/extensions/arel'

ActiveSupport.on_load :active_record do
  Arel::Attributes::Attribute.include Extensions::Arel::Predications
  Arel::Nodes::Unary.include Extensions::Arel::Predications
  Arel::Nodes::Function.include Extensions::Arel::Predications
  Arel::Nodes::Grouping.include Extensions::Arel::Predications
  Arel::Nodes::Binary.include Extensions::Arel::Predications
  Arel::Nodes::SqlLiteral.include Extensions::Arel::Predications
end
