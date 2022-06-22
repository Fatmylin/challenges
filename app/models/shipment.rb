class Shipment < ApplicationRecord
  belongs_to :company
  has_many :shipment_items

  ORDER = ['ASC', 'DESC'].freeze

  def shipment_items_with_description_and_count(items_order:)
    raise "Please provide correct items order like 'ASC' or 'DESC'" if ORDER.exclude?(items_order)
    
    items = shipment_items.group(:description).count.map do |description, count|
      {
        description: description,
        count: count
      }
    end
    items.sort_by do |item|
      items_order == 'ASC' ? item[:count] : -item[:count]
    end
  end
end
