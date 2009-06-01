class Event < ActiveRecord::Base
  belongs_to :user
  before_validation :set_hours_and_minutes_if_nil
  before_validation :calculate_ends_at

  validates_presence_of :user_id, :on => :create, :message => "can't be blank"
  validates_presence_of :name, :on => :create, :message => "can't be blank"
  validates_presence_of :starts_at, :on => :save, :message => "invalid. Please select a date."
  validates_presence_of :hours, :on => :save, :message => "need to be selected or zero."
  validates_presence_of :minutes, :on => :save, :message => "need to be selected or zero."
  validates_numericality_of :hours, :on => :save, :message => "is not a number"
  validates_numericality_of :minutes, :on => :save, :message => "is not a number"
  
  named_scope :plot, lambda {|user, start_date, end_date| {:conditions => ['user_id = ? and starts_at between ? and ?', user, start_date, end_date], :order => "starts_at ASC"}}
  
  def set_hours_and_minutes_if_nil
    if hours.nil? and minutes.nil?
      self.hours = 1
      self.minutes = 0
    end
  end
   
  def calculate_ends_at
    starts_at = Time.now unless !starts_at.nil?
    minutes = hours * 60
    time = minutes + minutes
    self.ends_at = starts_at + time.minutes
    self.day = starts_at.strftime('%j') #also include numerical day of the year for ex 124
  end
  
  #validates the date selected does not conflict with others
  private
  def validate
    for schedule in Event.find_all_by_user_id(user_id)
      unless schedule.id = id
        if starts_at >= schedule.starts_at and starts_at <= schedule.ends_at
          errors.add("The Date you selected conflicts with another event that was scheduled from #{schedule.starts_at.strftime("%I:%M%p")} to #{schedule.ends_at.strftime("%I:%M%p")} on #{schedule.starts_at.strftime("%B %d")}. Date/time ")
        else
          if ends_at >= schedule.starts_at and ends_at <= schedule.ends_at
            errors.add("The Date you selected conflicts with another assignment that was scheduled from #{schedule.starts_at.strftime("%I:%M%p")} to #{schedule.ends_at.strftime("%I:%M%p")} on #{schedule.starts_at.strftime("%B %d")}. Date/time ")
          end
        end
      end
    end
  end
end