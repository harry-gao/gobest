require 'test_helper'

class UserHabitTest < ActiveSupport::TestCase
  test "set today" do
    user_habit = UserHabit.find_by_user_id(1)
    user_habit.set_progress(0)
    user_habit.save
    assert user_habit.is_finished?(0)
  end

  test "set yesterday" do
    user_habit = UserHabit.new(:user_id=>0, :habit_id=>0, :progress=>0, :created_at=> Date.today - 5)

    user_habit.set_progress(1)
    Rails::logger.debug("after set 1, progress is #{user_habit.progress}")

    assert !user_habit.is_finished?(0), "today should not finished"
    assert  user_habit.is_finished?(1), "yesterday should have finished"
  end

  test "check all days before today is finished" do
    user_habit = UserHabit.new(:user_id=>0, :habit_id=>0, :progress=>0, :created_at=> DateTime.now.to_date - 5)

    #Rails::logger.debug("------- since today is #{(Date.today - user_habit.created_at.to_date).to_i}")
    user_habit.set_progress(5)
    user_habit.set_progress(4)
    user_habit.set_progress(3)
    user_habit.set_progress(2)
    user_habit.set_progress(1)

    Rails::logger.debug("check all days before today is finished, after set, progress is #{user_habit.progress}")

    assert user_habit.is_all_days_finished_before_today?, "all days before today should have finished"
    assert !user_habit.is_finished?(0),  "today should not finished"
  end

end
