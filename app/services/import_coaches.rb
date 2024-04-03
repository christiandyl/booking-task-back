require "csv"

class ImportCoaches
  DAYS = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ].freeze

  def call
    CSV.foreach("coaches.csv").each_with_index do |row, index|
      # Each 'row' variable represents a line in the CSV file
      # You can access individual values in the row using array indexing
      # For example, row[0] for the first column, row[1] for the second column, and so on
      #puts row.inspect # Print the entire row

      next if index == 0

      first_name, last_name = row[0].split(" ")

      timezone_str = row[1].split(") ")[1]
      time_zone = ActiveSupport::TimeZone.new(timezone_str)

      day_of_week = row[2].strip

      # available_hour_at, available_min_at = row[3].strip.split(":").map { |n| n.to_i }
      # available_hour_until, available_min_until = row[4].strip.split(":").map { |n| n.to_i }

      start = Time.strptime(row[3].strip, "%I:%M%p")
      stop = Time.strptime(row[4].strip, "%I:%M%p")

      # total_minutes = ((stop.hour - start.hour) * 60) + start.min + stop.min
      total_minutes = ((stop.hour * 60) + stop.min) - ((start.hour * 60) + start.min)

      available_at = ActiveSupport::TimeZone
        .new(timezone_str)
        .now
        .beginning_of_week
        # .advance(days: DAYS.index(day_of_week), hours: start.hour, minutes: start.min)
        .advance(days: DAYS.index(day_of_week), minutes: (start.hour * 60) + start.min)
        .in_time_zone("UTC")

      # available_until = ActiveSupport::TimeZone
        # .new(timezone_str)
        # .now
        # .beginning_of_week
        # .advance(days: DAYS.index(day_of_week), hours: start.hour + stop.hour, minutes: start.min + stop.min)
        # .advance(days: DAYS.index(day_of_week), hours: start.hour + stop.hour, minutes: start.min + stop.min)
        # .in_time_zone("UTC")

      Coach.find_or_create_by(
        first_name: first_name.strip,
        last_name: last_name.strip,
      ) => coach

      end_time = available_at + total_minutes.minutes
      # pp end_time

      while (available_at + 30.minutes) <= end_time
        Slot.create(
          coach: coach,
          timezone: row[1].strip,
          day_of_week: available_at.day - 1,
          available_at: available_at,
          available_until: available_at + 30.minutes,
        )

        available_at += 30.minutes
      end
    end
  end
end
