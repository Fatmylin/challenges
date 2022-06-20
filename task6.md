## Concept
- Create a general interface to create log.
- Specify the column `LOG_COLUMNS` you want to log in each model.
- Define log_data_changes to keep the changes from `object.changes` and keep the changes `before_save` of the `object.changes` will turn empty after saved.
- Also keep the user_id to log who is operating the changing.
- Create the log after the data successfully is written into the database.
## create a module HasLog
```ruby
module HasLog
  attr_accessor :log_data_changes, :user_id

  def create_log(log_type:, data_changes: {}, options: {})
    Log.create(
      log_type: log_type
      user_id: user_id,
      data: self.to_json,
      data_changes: data_changes
    )
  rescue StandardError => e
    Rails.logger.warn "Cannot create log, type: #{log_type}, message: #{e.message}"
    false
  end
end
```
## Mount the model
```ruby
# Model
class Shipment < ActiveRecord
  include HasLog

  LOG_COLUMNS = %w[
    company_id
    destination_country
    origin_country
    tracking_number
    slug
    usps
  ]

  before_save :keep_data_changes
  after_commit :create_shipment_log

  private

  def keep_data_changes
    self.log_data_changes = changes.slice(*LOG_COLUMNS)
  end

  def create_shipment_log
    create_log(:created, data_changes: log_data_changes)
  end
end
```
    