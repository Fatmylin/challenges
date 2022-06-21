class Shipment < ApplicationRecord
  belongs_to :company
  has_many :shipment_items

  def shipment_items_with_description_and_count(order: 'ASC')
    items = shipment_items.group(:description).count.map do |description, count|
      {
        description: description,
        count: count
      }
    end
    items.sort_by do |item|
      order == 'ASC' ? item[:count] : -item[:count]
    end
  end
end
