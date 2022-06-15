require "rails_helper"

RSpec.describe Shipment, type: :model do
  describe '#shipment_items_with_description_and_count' do
    let(:shipment) { create(:shipment) }

    it 'return empty array when no shipment items' do
      expect(shipment.shipment_items_with_description_and_count).to eq([])
    end

    context 'when having shipment items' do
      before do
        ['Apple Watch', 'iPad', 'iPhone'].each.with_index(1) do |description, idx|
          create_list(
            :shipment_item, 
            idx,
            description: description,
            weight: idx,
            shipment: shipment
          )
        end
      end

      it 'return description and count of shipment items in ASC order of count' do
        expect(shipment.shipment_items_with_description_and_count).to eq([
          { description: 'Apple Watch', count: 1 },
          { description: 'iPad', count: 2 },
          { description: 'iPhone', count: 3}
        ])
      end

      context 'when given oder other than ASC' do
        it 'return description and count of shipment items in DESC order of count' do
          expect(shipment.shipment_items_with_description_and_count(order: 'DESC')).to eq([
            { description: 'iPhone', count: 3},
            { description: 'iPad', count: 2 },
            { description: 'Apple Watch', count: 1 }
          ])
        end

        it 'return description and count of shipment items in DESC order of count' do
          expect(shipment.shipment_items_with_description_and_count(order: 'OTHER')).to eq([
            { description: 'iPhone', count: 3},
            { description: 'iPad', count: 2 },
            { description: 'Apple Watch', count: 1 }
          ])
        end
      end
    end
  end
end
