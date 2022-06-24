require 'spec_helper'

RSpec.describe Shipment, type: :model do
  describe '#shipment_items_with_description_and_count' do
    let(:shipment) { create(:shipment) }

    it 'return empty array when no shipment items' do
      expect(shipment.shipment_items_with_description_and_count(items_order: 'ASC')).to eq([])
      expect(shipment.shipment_items_with_description_and_count(items_order: 'DESC')).to eq([])
    end

    it 'raise error when items_order is not allowed' do
      expect{ shipment.shipment_items_with_description_and_count(items_order: 'BAD ORDER') }.to raise_error(
        "Please provide correct items order like 'ASC' or 'DESC'"
      )
    end

    context 'when having shipment items' do
      let(:shipment) { create(:shipment, :with_apple_items) }
      
      it 'return description and count of shipment items in ASC order of count' do
        expect(shipment.shipment_items_with_description_and_count(items_order: 'ASC')).to eq([
          { description: 'Apple Watch', count: 1 },
          { description: 'iPad', count: 2 },
          { description: 'iPhone', count: 3}
        ])
      end

      it 'return description and count of shipment items in asc order of count' do
        expect(shipment.shipment_items_with_description_and_count(items_order: 'asc')).to eq([
          { description: 'Apple Watch', count: 1 },
          { description: 'iPad', count: 2 },
          { description: 'iPhone', count: 3}
        ])
      end

      it 'return description and count of shipment items in DESC order of count' do
        expect(shipment.shipment_items_with_description_and_count(items_order: 'DESC')).to eq([
          { description: 'iPhone', count: 3},
          { description: 'iPad', count: 2 },
          { description: 'Apple Watch', count: 1 }
        ])
      end

      it 'return description and count of shipment items in desc order of count' do
        expect(shipment.shipment_items_with_description_and_count(items_order: 'desc')).to eq([
          { description: 'iPhone', count: 3},
          { description: 'iPad', count: 2 },
          { description: 'Apple Watch', count: 1 }
        ])
      end
    end
  end
end
