require 'spec_helper'

describe ShipmentsController do
  before { Timecop.freeze(Time.new(2022, 6, 16)) }

  let(:company) { create(:company) }
  let!(:shipment) { create(:shipment, :with_apple_items, company: company) }

  describe '#show' do
    it 'return not_found when shipment is not found' do
      get :show, params: { id: 'XX', company_id: 'XX' }
      expect(response).to have_http_status :not_found
      expect(json_response).to eq('errors' => 'Shipment not found')
    end

    it 'return unprocessable_entity when other error happenes' do
      allow(ShipmentBlueprint).to receive(:render_as_json).and_raise('Error')
      get :show, params: { id: shipment.id, company_id: company.id }
      expect(response).to have_http_status :unprocessable_entity
    end

    it 'return shipment data if shipment founded' do
      tracking_information = {
        'status' => 'InTransit',
        'current_location' => 'Singapore Main Office, Singapore',
        'last_checkpoint_message' => 'Received at Operations Facility',
        'last_checkpoint_time' => '2016-02-01T13:00:00'
      }
      expect(GetTrackingInformationService).to receive(:call).and_return(tracking_information)
      get :show, params: { id: shipment.id, company_id: company.id }
      expect(response).to have_http_status :ok
      expect(json_response).to eq('shipment' => { 
        'company_id' => 1, 
        'created_at' => '2022 Jun 15 at 04:00PM (Wednesday)', 
        'destination_country' => 'GB', 
        'id' => 1, 
        'items' => [
          { 'count' => 1, 'description' => 'Apple Watch' }, 
          { 'count' => 2, 'description' => 'iPad' }, 
          { 'count' => 3, 'description' => 'iPhone' }
        ], 
        'origin_country' => 'CR', 
        'slug' => 'usps', 
        'tracking_number' => '000000000000',
        'tracking' => tracking_information
      })
    end
  end
  
  describe '#index' do
    let(:other_company) { create(:company) }
    let!(:shipment_in_other_company) { create(:shipment, company: other_company) }

    it 'return not_found when company is not found' do
      get :index, params: { company_id: 'XX' }
      expect(response).to have_http_status :not_found
      expect(json_response).to eq('errors' => 'Company not found')
    end

    it 'return unprocessable_entity when other error happenes' do
      allow(ShipmentBlueprint).to receive(:render_as_json).and_raise('Error')
      get :index, params: { company_id: company.id }
      expect(response).to have_http_status :unprocessable_entity
    end

    it 'return shipments data belonging to the company if company founded' do
      get :index, params: { company_id: company.id }
      expect(response).to have_http_status :ok
      expect(json_response).to eq('shipments' => [
        { 
          'company_id' => 1, 
          'created_at' => '2022 Jun 15 at 04:00PM (Wednesday)', 
          'destination_country' => 'GB', 
          'id' => 1, 
          'items' => [
            { 'count' => 1, 'description' => 'Apple Watch' }, 
            { 'count' => 2, 'description' => 'iPad' }, 
            { 'count' => 3, 'description' => 'iPhone' }
          ], 
          'origin_country' => 'CR', 
          'slug' => 'usps', 
          'tracking_number' => '000000000000',
        }
      ])
      expect(json_response['shipments'].any? { |shipment| shipment['id'] == shipment_in_other_company.id }).to be_falsey
    end
  end
end