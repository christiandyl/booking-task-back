require "csv"

class ImportCoaches
  def call
    CSV.foreach("coaches.csv").each_with_index do |row, index|
      # Each 'row' variable represents a line in the CSV file
      # You can access individual values in the row using array indexing
      # For example, row[0] for the first column, row[1] for the second column, and so on
      puts row.inspect # Print the entire row

      next if index == 0

      first_name, last_name = row[0].split(" ")

      timezone = row[1]

      day_of_week = row[2].strip.downcase

      available_at = Time.strptime(row[3].strip, "%I:%M%p")
      available_until = Time.strptime(row[4].strip, "%I:%M%p")

      Coach.find_or_create_by(
        first_name: first_name.strip,
        last_name: last_name.strip,
      ) => coach

      while (available_at + 30.minutes) < available_until
        Slot.create(
          coach: coach,
          timezone: timezone.strip,
          day_of_week: day_of_week,
          available_at: available_at,
          available_until: available_at + 30.minutes,
        )

        available_at += 30.minutes
      end
    end
  end
end
