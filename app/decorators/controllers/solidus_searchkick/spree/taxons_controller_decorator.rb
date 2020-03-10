module SolidusSearchkick
  module Spree
    module TaxonsControllerDecorator
      def autocomplete
        keywords = params[:keywords] ||= nil
        json = ::Spree::Taxon.autocomplete(keywords)
        render json: json
      end

      ::Spree::TaxonsController.prepend self
    end
  end
end
