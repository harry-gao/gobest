class Habit < ActiveRecord::Base
  validates :name, :presence =>true
end
