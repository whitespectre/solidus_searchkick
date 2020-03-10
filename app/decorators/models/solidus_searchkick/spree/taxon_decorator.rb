module SolidusSearchkick
  module Spree
    module TaxonDecorator
      def self.prepended(base)
        base.singleton_class.prepend ClassMethods
      end

      def search_data
        json = {
          name: name,
          description: description,
          active: available?
        }

        json
      end

      def available?
        available_count.to_i > 0
      end

      module ClassMethods
        def autocomplete(keywords)
          if keywords
            Searchkick.search(
              keywords,
              fields: ['name^5'],
              match: :word_start,
              limit: 10,
              # misspellings: { below: 3 },
              load: false,
              index_name: [ ::Spree::Taxon, ::Spree::Product ],
              indices_boost: {::Spree::Taxon => 2, ::Spree::Product => 1},
              where: {_or: [{_type: "spree/product", active: true}, {_type: "spree/taxon", active: true}]},
            ).map(&:name).map(&:strip).uniq
          else
            Searchkick.search(
              '*',
              index_name: [ ::Spree::Product, ::Spree::Taxon ],
              indices_boost: {::Spree::Taxon => 2, ::Spree::Product => 1},
              where: {_or: [{_type: "spree/product", active: true}, {_type: "spree/taxon", active: true}]}
            ).map(&:name).map(&:strip).uniq
          end
        end
      end

      ::Spree::Taxon.prepend self
    end
  end
end
