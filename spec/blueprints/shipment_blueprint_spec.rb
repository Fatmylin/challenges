require 'spec_helper'

describe ShipmentBlueprint do
  let(:shipment) { create(:shipment) }

  before { Timecop.freeze(Time.new(2022, 6, 16)) }

  it 'return serialized shipment' do
    expect(ShipmentBlueprint.render_as_json(shipment)).to eq(
      'company_id' => shipment.company.id,
      'created_at' => '2022 Jun 15 at 04:00PM (Wednesday)',
      'destination_country' => 'GB',
      'id' => shipment.id,
      'items' => [],
      'origin_country' => 'CR',
      'slug' => 'usps',
      'tracking_number' => '000000000000',
    )
  end

  context 'with shipment items' do
    let(:shipment) { create(:shipment, :with_apple_items) }

    it 'return serialized shipment with items' do
      expect(ShipmentBlueprint.render_as_json(shipment)).to eq(
        'company_id' => shipment.company.id,
        'created_at' => '2022 Jun 15 at 04:00PM (Wednesday)',
        'destination_country' => 'GB',
        'id' => shipment.id,
        'items' => [
          { 'count'=> 1, 'description' => 'Apple Watch' }, 
          { 'count'=> 2, 'description' => 'iPad' }, 
          { 'count'=> 3, 'description' => 'iPhone' }
        ],
        'origin_country' => 'CR',
        'slug' => 'usps',
        'tracking_number' => '000000000000',
      )
    end

    it 'order DESC with items_order DESC' do
      expect(ShipmentBlueprint.render_as_json(shipment, items_order: 'DESC')).to eq(
        'company_id' => shipment.company.id,
        'created_at' => '2022 Jun 15 at 04:00PM (Wednesday)',
        'destination_country' => 'GB',
        'id' => shipment.id,
        'items' => [
          { 'count'=> 3, 'description' => 'iPhone' },
          { 'count'=> 2, 'description' => 'iPad' }, 
          { 'count'=> 1, 'description' => 'Apple Watch' }, 
        ],
        'origin_country' => 'CR',
        'slug' => 'usps',
        'tracking_number' => '000000000000',
      )
    end
  end
end