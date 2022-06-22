require 'spec_helper'

describe ShipmentsController do
  let(:company) { create(:company) }
  let!(:shipment) { create(:shipment, :with_apple_items, company: company) }

  describe '#show' do
    it 'return not_found when shipment is not found' do
      get :show, params: { id: 'XX', company_id: 'XX' }
      expect(response).to have_http_status :not_found
    end

    it 'return unprocessable_entity when other error happenes' do
      allow(ShipmentBlueprint).to receive(:render_as_json).and_raise('Error')
      get :show, params: { id: shipment.id, company_id: company.id }
      expect(response).to have_http_status :unprocessable_entity
    end

    it 'return shipment data if shipment founded' do
      get :show, params: { id: shipment.id, company_id: company.id }
      expect(response).to have_http_status :ok
      expect(json_response).to eq('shipment' => ShipmentBlueprint.render_as_json(shipment, items_order: nil))
    end
  end
end