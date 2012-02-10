require 'base64'

class HomeController < ApplicationController
  #layout false, :except => :mypage
  include FbHelper

  def mypage
    if(session["fb_user_id"] != nil)
      render_user_page(true)
    elsif(params.has_key?(:signed_request))
      if(setup_user(params[:signed_request]))
        render_user_page(true)
      end
    else
      render :inline => "unexpected fb canvas behavior"
    end
  end

  def render_user_page(with_layout)
    @current_habit = UserHabit.get_latest_habit_for_user(session["fb_user_id"])
    if(@current_habit)
      render_user_with_habit(with_layout)
    else
      intro(with_layout)
    end
  end

  def render_user_with_habit(with_layout)
    render :habitstatus, :layout => with_layout
  end

  def habit_status
    status_code = params[:code].to_i
    @current_habit = UserHabit.get_latest_habit_for_user(session["fb_user_id"])
    if(status_code == 1) #expired
      render :inline => "expired"
    elsif (status_code == 2)  #this is a new habit, today is not finished
      render :firstday, :layout => false;
    elsif (status_code == 3) #some day is missed
      render :misseddays,  :layout => false
    elsif (status_code == 4) #everything is done
      render :todayfinished, :layout => false;
    elsif (status_code == 5) #everything is fine, today not finished

      render :todaynotfinished, :layout =>false
    end
  end

  def new_habit
    @habit = Habit.new(params[:habit])
    if(@habit.save)
      uid = session["fb_user_id"]
      @current_habit = UserHabit.create(:user_id => uid, :habit_id => @habit.id, :progress => 0)
      render_user_with_habit(true)
    else
      render action: "create"
    end

  end

  def restart
     @current_habit = UserHabit.get_latest_habit_for_user(session["fb_user_id"])
     @current_habit = UserHabit.create(:user_id => @current_habit.user_id, :habit_id=>@current_habit.habit_id, :progress => 0)
    render :nothing => true;
  end

  def mark_missed
    days_since_created = params[:days].to_i
    @current_habit = UserHabit.get_latest_habit_for_user(session["fb_user_id"])
    @current_habit.progress = 2 ** days_since_created - 1
    @current_habit.save
    render :nothing => true;
  end

  def mark_today
    @current_habit = UserHabit.get_latest_habit_for_user(session["fb_user_id"])
    @current_habit.progress |= 0x01 << @current_habit.get_finished_days
    @current_habit.save
    render :nothing => true;
  end

  def current
     render_user_page(false);
  end

  def history
    render :inline => "not implemented"
  end

  def hot_habits
    render :inline => "hot habits not implemented"
  end

  def intro(with_layout)
     render :intro, :layout => with_layout
  end

  def create
    @habit = Habit.new
    render "create", :layout => false
  end

=begin
  def mark_finished
    #set multiple days as finished. parameters like { days : "0, 1, 3, 5"  }
    finished_days= params['days'].split(',')
    current_habit = UserHabit.get_latest_habit_for_user(session["fb_user_id"])
    finished_days.each do |day|
      current_habit.set_progress(day.to_i)
    end
    render :nothing => true
  end




  def render_user_with_habit_old
    habit = Habit.find(@current_habit.habit_id)
        #render :inline => "you are practising #{habit.name}"
    if(!@current_habit.is_all_days_finished_before_today?)
    #user missed some day, remind user
      render :inline => "you missed some date #{habit.name}"
    elsif(!@current_habit.is_finished?(0))
       render :habitstatus
    else
       render :inline => "congratulations, you finished today"
    end

  end

=end

end