json.array!(@search_histories) do |search_history|
  json.partial! "search_history", search_history: search_history
end
