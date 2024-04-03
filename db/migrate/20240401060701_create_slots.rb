class CreateSlots < ActiveRecord::Migration[7.1]
  def change
    create_table :slots do |t|
      t.belongs_to :coach
      t.string :timezone, null: false
      t.integer :day_of_week, default: 0
      t.time :available_at, null: false
      t.time :available_until, null: false
      t.timestamps
    end

    add_index :slots, [:coach_id, :day_of_week, :available_at, :available_until], unique: true
  end
end
