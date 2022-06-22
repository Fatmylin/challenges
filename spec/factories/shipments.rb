FactoryBot.define do
  factory :shipment do
    destination_country { 'GB' }
    origin_country { 'CR' }
    slug { 'usps' }
    tracking_number { '000000000000' }
    company { create(:company) }

    trait :with_apple_items do
      after(:create) do |shipment|
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
    end
  end
end
