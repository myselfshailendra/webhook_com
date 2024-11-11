class DataChangeNotifierJob < ApplicationJob
  queue_as :default

  def perform(endpoint, record, notification)
    uri = URI.parse(endpoint)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')

    request = Net::HTTP::Post.new(uri.path, { 'Content-Type': 'application/json' })
    payload = {
      record_id: record.id,
      name: record.name,
      description: record.description,
      notification: notification,
      timestamp: Time.now.to_i,
      signature: generate_signature(record)
    }
    request.body = payload.to_json
    http.request(request)
  end

  private

  # Generate a basic signature for verification purposes
  def generate_signature(record)
    webhook_secret_key = Rails.application.credentials.webhook_secret_key
    Digest::SHA256.hexdigest("#{record.id}#{record.name}#{webhook_secret_key}")
  end
end
