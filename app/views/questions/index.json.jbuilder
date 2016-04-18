json.array!(@questions) do |question|
  json.extract! question, :id, :text, :question_type, :metadata_one, :metadata_two, :metadata_three, :metadata_four
  json.url question_url(question, format: :json)
end
