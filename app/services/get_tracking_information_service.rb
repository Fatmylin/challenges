require 'uri'
require 'net/http'

class GetTrackingInformationService < BaseService
  attr_reader :slug, :tracking_number

  def initialize(shipment:)
    @slug = shipment.slug
    raise('Slug of shipment is required') if @slug.nil?
    @tracking_number = shipment.tracking_number
    raise('Tracking number of shipment is required') if @tracking_number.nil?
  end

  def call
    uri = URI("https://api.aftership.com/v4/trackings/#{slug}/#{tracking_number}")
    req = Net::HTTP::Get.new(uri)
    req['aftership-api-key'] = ENV['AFTERSHIP_API_KEY']
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(req)
    end
    
    raise(JSON.parse(res.body)['meta']['message']) if res.code != '200'

    checkpoints = JSON.parse(res.body)['data']['tracking'].try(:[], 'checkpoints')
    last_checkpoint = checkpoints.sort_by { |checkpoint| checkpoint['checkpoint_time'] }.last
    if last_checkpoint
      {
        'status' => last_checkpoint['tag'],
        'current_location' => last_checkpoint['location'],
        'last_checkpoint_message' => last_checkpoint['message'],
        'last_checkpoint_time' => Time.zone.parse(last_checkpoint['checkpoint_time']).strftime("%A, %d %b %Y at %I:%M %p ")
      }
    else
      {}
    end
  end
end