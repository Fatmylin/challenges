class ShipmentsController < ApplicationController
  def index
    company = Company.find(params[:company_id])
    shipments = Shipment.where(company: company).includes(:shipment_items)
    render json: { shipments: ShipmentBlueprint.render_as_json(shipments, items_order: 'ASC') }
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: 'Company not found' }, status: :not_found
  rescue StandardError => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  def show
    shipment = Shipment.find_by(id: params[:id], company_id: params[:company_id])
    raise ActiveRecord::RecordNotFound if shipment.nil?

    josn_shipment = ShipmentBlueprint.render_as_json(
      shipment,
      items_order: shipment_params[:items_order]
    )
    tracking_information = GetTrackingInformationService.call(shipment: shipment)
    josn_shipment['tracking'] = tracking_information

    render json: { shipment: josn_shipment }
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: 'Shipment not found' }, status: :not_found
  rescue StandardError => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  def search
    company = Company.find(params[:company_id])
    term = shipment_params.try(:[], :shipment_items).try(:[], :description) || shipment_params[:shipment_items_size]
    shipment_ids = Shipment.search(term).results.map(&:id)
    shipments = Shipment.where(id: shipment_ids, company_id: params[:company_id]).includes(:shipment_items)
    render json: { shipments: ShipmentBlueprint.render_as_json(shipments, items_order: 'ASC') }
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: 'Company not found' }, status: :not_found
  rescue StandardError => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  private

  def shipment_params
    params.permit(
      :id,
      :company_id,
      :items_order, 
      :shipment_items_size,
      shipment_items: [:description]
    )
  end
end
