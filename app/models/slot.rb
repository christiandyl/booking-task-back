class Slot < ApplicationRecord
  enum :day_of_week, [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]

  belongs_to :coach

  def reserve(opts)
    ReservedSlot.create(
      slot: self,
      coach: coach,
      reserved_at: Date.parse(opts[:date]),
    )  
  end
end
