module SolidusSearchkick
  module Spree
    module OrderDecorator
      def self.prepended(base)
        base.class_eval do
          state_machine.after_transition to: :complete, do: :reindex_order_products
        end
      end

      def reindex_order_products
        return unless complete?
        products.map(&:reindex)
      end

      ::Spree::Order.prepend self
    end
  end
end
