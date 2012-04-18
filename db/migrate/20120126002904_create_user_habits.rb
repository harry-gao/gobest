class CreateUserHabits < ActiveRecord::Migration
  def change
    create_table :user_habits do |t|
      t.decimal :user_id,  :precision => 30, :scale => 0
      t.integer :progress
      t.references :habit
      t.timestamps
    end
  end
end

