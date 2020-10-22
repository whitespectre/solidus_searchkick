module SolidusSearchkick
  module Spree
    module ProductDecorator
      def self.prepended(base)
        base.singleton_class.prepend ClassMethods
      end

      def search_data
        {
          name: name,
          description: description,
          active: available?,
          price: price,
          currency: ::Spree::Config.currency,
          sku: sku,
          conversions: orders.complete.count,
          taxon_ids: taxon_and_ancestors.map(&:id),
          taxon_names: taxon_and_ancestors.map(&:name)
        }
      end

      def taxon_and_ancestors
        taxons.map(&:self_and_ancestors).flatten.uniq
      end

      module ClassMethods
        def autocomplete(keywords)
          if keywords
            ::Spree::Product.search(
              keywords,
              fields: ['name^5'],
              match: :word_start,
              limit: 10,
              load: false,
              misspellings: { below: 3 },
              where: search_where,
            ).map(&:name).map(&:strip).uniq
          else
            ::Spree::Product.search(
              '*',
              where: search_where
            ).map(&:name).map(&:strip).uniq
          end
        end

        def search_where
          {
            active: true,
            price: { not: nil }
          }
        end
      end

      ::Spree::Product.prepend self
    end
  end
end
