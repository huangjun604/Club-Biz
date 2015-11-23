json.array!(@events) do |event|
  json.extract! event, :id, :name, :date, :society_id, :ticketnum
  json.url event_url(event, format: :json)
end
