class Slot < ApplicationRecord
  enum :day_of_week, [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]

  belongs_to :coach

  validates :available_at, uniqueness: { scope: [:coach_id, :day_of_week, :available_at, :available_until] } 

  def reserve(opts)
    ReservedSlot.new(
      slot: self,
      coach: coach,
      reserved_at: Date.parse(opts[:date]),
    ) => reserved_slot

    reserved_slot.save
  end
end
