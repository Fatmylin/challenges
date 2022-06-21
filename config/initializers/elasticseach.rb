return if Rails.env.test?

Elasticsearch::Model.client = Elasticsearch::Client.new(
  host: Rails.application.config_for(:elasticsearch).host,
  port: Rails.application.config_for(:elasticsearch).port,
  scheme: Rails.application.config_for(:elasticsearch).scheme
)