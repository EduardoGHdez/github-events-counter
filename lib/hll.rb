class Hll
  class << self
    def bigint_agg(*numbers)
      table = ::Arel::Table.new('numbers')
      values = ::Arel::Nodes::Grouping.new(
        ::Arel::Nodes::ValuesList.new(
          numbers.map { |number| [number] }
        )
      ).as('numbers(number)')
      hll_aggregate = table[:number].hll_hash_bigint.hll_add_agg

      query = table.project(hll_aggregate).from(values)
      ::ActiveRecord::Base.connection.select_value(query)
    end
  end

  class Type < ActiveModel::Type::Value
    def type
      :hll
    end
  end

  module AdapterExtension
    def initialize_type_map(m = type_map)
      m.register_type 'hll', ::Hll::Type.new
      super(m)
    end

    def native_database_types
      super.merge! hll: { name: 'hll' }
    end
  end

  module ColumnMethods
    extend ActiveSupport::Concern

    prepended do
      define_column_methods :hll
    end
  end

  module Arel
    module Nodes
      class HashBigInt < ::Arel::Nodes::NamedFunction
        def initialize(expr)
          super('hll_hash_bigint', expr)
        end
      end

      class Cardinality < ::Arel::Nodes::NamedFunction
        def initialize(expr)
          super('hll_cardinality', expr)
        end
      end

      class UnionAgg < ::Arel::Nodes::NamedFunction
        def initialize(expr)
          super('hll_union_agg', expr)
        end
      end

      class AddAgg < ::Arel::Nodes::NamedFunction
        def initialize(expr)
          super('hll_add_agg', expr)
        end
      end
    end

    module Predications
      def hll_hash_bigint(*others)
        Nodes::HashBigInt.new(others.unshift(self))
      end

      def hll_cardinality(*others)
        Nodes::Cardinality.new(others.unshift(self))
      end

      def hll_union_agg(*others)
        Nodes::UnionAgg.new(others.unshift(self))
      end

      def hll_add_agg(*others)
        Nodes::AddAgg.new(others.unshift(self))
      end
    end
  end

  module ActiveRecord
    module Calculations
      def hll_cardinality(column)
        query = arel_table[column].hll_union_agg.hll_cardinality.as(column.to_s)

        group_values.any?  ?
          select(query, *group_values).as_json(only: [column, *group_values]) :
          pluck(query).first
      end
    end

    module Querying
      extend ActiveSupport::Concern

      prepended do
        delegate(:hll_cardinality, to: :all)
      end
    end
  end
end
