# frozen_string_literal: true

module ALNS
  module Select
    class Base
      def initialize(num_destroy, num_repair, op_coupling = nil)
        if num_destroy <= 0 || num_repair <= 0
          raise ArgumentError, 'Missing destroy or repair operators.'
        end

        unless op_coupling.nil?
          rows = op_coupling.length
          cols = op_coupling[0].length

          if rows != num_destroy || cols != num_repair
            raise ArgumentError,
                  "coupling matrix of shape (#{rows}, #{cols}), expected (#{num_destroy}, #{num_repair})"
          end

          op_coupling.each_with_index do |row, i|
            if row.length != cols
              raise ArgumentError,
                    "the number of columns in a row #{i} does not match the expected #{cols}"
            end

            coupled = row.any? { |b| b }
            unless coupled
              raise ArgumentError,
                    "destroy operator #{i} has no coupled repair operators"
            end
          end
        end

        @num_destroy = num_destroy
        @num_repair = num_repair
        @op_coupling = op_coupling
      end

      def select(rnd, best, current)
        raise NotImplementedError
      end

      def update(candidate, d_idx, r_idx, outcome)
        raise NotImplementedError
      end
    end
  end
end
