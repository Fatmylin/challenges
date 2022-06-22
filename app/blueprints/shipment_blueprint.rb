class ShipmentBlueprint < Blueprinter::Base
  identifier :id

  fields(
    :company_id,
    :destination_country,
    :origin_country,
    :tracking_number,
    :slug
  )

  field :created_at do |shipment|
    shipment.created_at.strftime("%Y %b %d at %I:%M%p (%A)")
  end

  field :items do |shipment, options|
    shipment.shipment_items_with_description_and_count(items_order: options[:items_order] || 'ASC')
  end
end