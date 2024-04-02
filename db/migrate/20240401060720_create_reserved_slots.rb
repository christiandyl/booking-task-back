class CreateReservedSlots < ActiveRecord::Migration[7.1]
  def change
    create_table :reserved_slots do |t|
      t.belongs_to :coach
      t.belongs_to :slot
      t.date :reserved_at, null: false
      t.timestamps
    end

    add_index :reserved_slots, [:coach_id, :slot_id, :reserved_at], unique: true
  end
end
