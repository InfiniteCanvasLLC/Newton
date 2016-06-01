json.array!(@link_tos) do |link_to|
  json.extract! link_to, :id, :title, :description, :url, :link_text, :icon_style, :panel_style, :type_id
  json.url link_to_url(link_to, format: :json)
end
