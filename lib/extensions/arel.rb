module Extensions
  module Arel
    module Nodes
      class DateTrunc < ::Arel::Nodes::NamedFunction
        def initialize(expr, time_bucket)
          super('date_trunc', [::Arel::Nodes.build_quoted(time_bucket), expr])
        end
      end
    end

    module Predications
      def date_trunc(time_bucket)
        Nodes::DateTrunc.new(self, time_bucket.to_sym)
      end
    end
  end
end

