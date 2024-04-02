json.records(@slots) do |slot|
  json.id(slot.id)
  json.reserved(slot.reserved)
  json.coach(slot.coach)
  json.timezone(slot.timezone)
  json.day_of_week(slot.day_of_week)
  json.available_at(slot.available_at)
  json.available_until(slot.available_until)
end
