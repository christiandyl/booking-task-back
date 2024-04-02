class Coach < ApplicationRecord
  has_many :slots
  has_many :reserved_slots

  def full_name
    "#{first_name} #{last_name}"
  end

  def available_slots(date_str, timezone)
    Struct.new(
      :id,
      :reserved,
      :coach,
      :timezone,
      :day_of_week,
      :available_at,
      :available_until,
    ) => slot_struct

    date = Date.parse(date_str)

    filtered_slots = slots.includes(:coach).where("day_of_week = ?", Slot.day_of_weeks[date.strftime("%A").downcase])

    booked_slots = reserved_slots.where("reserved_at > ?", Date.today)

    filtered_slots.map do |slot|
      reserved_slot = booked_slots.find do |booked_slot|
        booked_slot.slot_id == slot.id
      end

      slot_struct.new(
        slot.id,
        reserved_slot.present?,
        slot.coach,
        slot.timezone.in_time_zone(timezone),
        slot.day_of_week,
        slot.available_at,
        slot.available_until,
      )
    end
  end
end
