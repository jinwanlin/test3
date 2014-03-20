json.array!(@search_histories) do |search_history|
  json.id search_history.id
  json.keywords search_history.keywords
  json.created_at search_history.created_at.to_s(:db)
  json.updated_at search_history.updated_at.to_s(:db)
end
