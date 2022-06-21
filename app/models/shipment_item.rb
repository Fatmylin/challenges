class ShipmentItem < ApplicationRecord
  belongs_to :shipment

  after_commit :update_es_index

  private

  def update_es_index
    shipment_id = shipment.id
    query = ->{ where(id: shipment_id) }
    Shipment.import(query: query)
  end
end
