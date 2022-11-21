class Hll
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

    included do
      define_column_methods :hll
    end
  end
end
