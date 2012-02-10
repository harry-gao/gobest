class UserHabit < ActiveRecord::Base
  belongs_to :habit

  def create_time_second
    created_at.to_time.strftime('%s').to_i;
  end

  def self.get_latest_habit_for_user(user_id)
     UserHabit.where(:user_id => user_id).order("created_at DESC").first()
  end

  def get_finished_days
    return 0 unless self.progress != 0
    for i in 0..20
      break unless (self.progress & (0x01 << i)) != 0
    end
    i
  end





=begin
  def is_all_days_finished_before_today?
    days = days_since_created
    return true if days == 0
    self.progress == (2**days -1)
  end

  def is_finished?(nth_day_before_today)
    (self.progress & (0x01 << (days_since_created - nth_day_before_today))) != 0
  end

  #the last bit in progress is the first day of the habit
  def set_progress(nth_day_before_today)
    self.progress |= (0x01 << (days_since_created - nth_day_before_today))
    Rails::logger.debug("-----------------days since created: #{days_since_created} and nth day before #{nth_day_before_today}, then progress is #{self.progress}")
    save!
  end

  def days_since_created
    ((Time.now.utc - created_at.to_time)/86400).to_i
  end
=end

end
