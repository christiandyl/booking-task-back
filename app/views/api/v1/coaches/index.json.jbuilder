json.records(@coaches) do |coach|
  json.id(coach.id)
  json.full_name(coach.full_name)
end
