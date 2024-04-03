class ReservedSlot < ApplicationRecord
  belongs_to :coach
  belongs_to :slot

  validates :reserved_at, uniqueness: { scope: [:coach_id, :slot_id, :reserved_at] } 
end
