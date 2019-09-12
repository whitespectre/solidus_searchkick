module SolidusSearchkick
  module Spree
    module ProductsControllerDecorator
      def autocomplete
        keywords = params[:keywords] ||= nil
        json = ::Spree::Product.autocomplete(keywords)
        render json: json
      end

      ::Spree::ProductsController.prepend self
    end
  end
end
