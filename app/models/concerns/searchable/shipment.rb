module Searchable
  module Shipment
    extend ActiveSupport::Concern

    included do
      mapping dynamic: false do
        indexes :shipment_items_size, type: :integer
        indexes :company_id, type: :integer
        indexes :shipment_items do
          indexes :description, type: :text
        end
      end

      def as_indexed_json(options = {})
        as_json(
          only: [:company_id],
          include: {
            shipment_items: {
              only: [:description]
            }
          },
          methods: [:shipment_items_size]
        )
      end
    end
  end
end