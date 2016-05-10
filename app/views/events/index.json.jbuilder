json.array!(@events) do |event|
  json.extract! event, :id, :description, :event_type, :start, :metadata
  json.url event_url(event, format: :json)
end
