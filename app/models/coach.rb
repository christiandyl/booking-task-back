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

    local_time_start = ActiveSupport::TimeZone.new("UTC").parse("0:00 AM").in_time_zone(timezone)
    # local_time_start = ActiveSupport::TimeZone.new(timezone).parse("0:00AM").in_time_zone("UTC")
    # local_time_stop = ActiveSupport::TimeZone.new(timezone).parse("24:00PM").in_time_zone("UTC")

    filtered_slots = slots.includes(:coach).where(
      "day_of_week = ? AND available_at >= ?",
      Slot.day_of_weeks[date.strftime("%A").downcase],
      local_time_start,
      # local_time_stop,
    )

    booked_slots = reserved_slots.where("reserved_at > ?", Date.today)

    filtered_slots.map do |slot|
      reserved_slot = booked_slots.find do |booked_slot|
        booked_slot.slot_id == slot.id
      end

      slot_struct.new(
        slot.id,
        reserved_slot.present?,
        slot.coach,
        slot.timezone,
        slot.day_of_week,
        slot.available_at.in_time_zone(timezone).strftime('%Y-%m-%dT %H:%M:%S'),
        slot.available_until.in_time_zone(timezone).strftime('%Y-%m-%dT %H:%M:%S'),
      )
    end
  end
end
