json.array!(@user_actions) do |user_action|
  json.extract! user_action, :id, :user_id, :action_type, :action_id
  json.url user_action_url(user_action, format: :json)
end
