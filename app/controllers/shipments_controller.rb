class ShipmentsController < ApplicationController
  def index
    @shipments = Shipment.all
  end

  def show
    shipment = Shipment.find_by(id: params[:id], company_id: params[:company_id])
    raise ActiveRecord::RecordNotFound if shipment.nil?

    render json: { 
      shipment:  ShipmentBlueprint.render_as_json(
        shipment,
        items_order: shipment_params[:items_order]
      ) 
    }
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: 'Shipment not found' }, status: :not_found
  rescue StandardError => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  private

  def shipment_params
    params.permit(:items_order)
  end
end
