require 'spec_helper'

describe ShipmentsController do
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
        'last_checkpoint_time' => 'Monday, 01 Feb 2016 at 01:00 PM'
      }
      expect(GetTrackingInformationService).to receive(:call).and_return(tracking_information)
      get :show, params: { id: shipment.id, company_id: company.id }
      expect(response).to have_http_status :ok
      json_shipment = ShipmentBlueprint.render_as_json(shipment, items_order: nil)
      expect(json_response).to eq('shipment' => json_shipment.merge('tracking' => tracking_information))
    end
  end
end