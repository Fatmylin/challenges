require 'spec_helper'

describe GetTrackingInformationService do
  let(:shipment) { create(:shipment) }
  let(:success_response) { File.read('spec/fixtures/aftership/get_success_response.json') }
  let(:failed_response) { File.read('spec/fixtures/aftership/get_failure_response.json') }

  describe '#initialize' do
    it 'raise error when shipment does not have slug' do
      shipment.update(slug: nil)
      expect { described_class.new(shipment: shipment) }.to raise_error('Slug of shipment is required')
    end

    it 'raise error when shipment does not have tracking number' do
      shipment.update(tracking_number: nil)
      expect { described_class.new(shipment: shipment) }.to raise_error('Tracking number of shipment is required')
    end
  end

  describe '#call' do
    it 'return data when response is 200' do
      expect(Net::HTTP).to receive(:start).and_return(
        OpenStruct.new(
          code: '200',
          body: success_response
        )
      )
      expect(described_class.call(shipment: shipment)).to eq(
        'status' => 'InTransit',
        'current_location' => 'Singapore Main Office, Singapore',
        'last_checkpoint_message' => 'Received at Operations Facility',
        'last_checkpoint_time' => '2016-02-01T13:00:00'
      )
    end

    it 'raise error when response is not 200' do
      expect(Net::HTTP).to receive(:start).and_return(
        OpenStruct.new(
          code: '4004',
          body: failed_response
        )
      )
      expect{ described_class.call(shipment: shipment) }.to raise_error('Tracking does not exist.')
    end
  end
end