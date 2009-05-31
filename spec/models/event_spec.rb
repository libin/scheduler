require File.dirname(__FILE__) + '/../spec_helper'

module EventSpecHelper
  def valid_event_attributes
    { :name => "Pick up the milk", :starts_at => Time.now, :hours => 2, :minutes => 30, :user_id => 1 }
  end
end

describe Event do
  include EventSpecHelper
  before(:each) do
    @event = Event.new
  end
  
  it "should be valid" do
    @event.attributes = valid_event_attributes
    @event.should be_valid
  end
  
  it "should have 3 errors" do
    @event.should have(1).error_on(:name)
    @event.should have(1).error_on(:starts_at)
    @event.should have(1).error_on(:user_id)
  end
  
  it "should not conflict with other events" do
    @event.attributes = valid_event_attributes
    @event.should be_valid
    @event.save
    @event2 = Event.new(:name => "Pick up the kids", :starts_at => Time.now, :hours => 2, :minutes => 30, :user_id => 1)
    @event2.save
    @event2.should_not be_valid
  end  
  
  it "should have calculated ends_at and day when saved" do
    @event.attributes = valid_event_attributes
    @event.ends_at.should be_nil
    @event.day.should be_nil
    @event.save
    @event.ends_at.should_not be_nil
    @event.day.should_not be_nil
  end
  
  it "should default hours/min if nil" do
    @event.attributes = valid_event_attributes
    @event.hours = nil
    @event.minutes = nil
    @event.should be_valid
    @event.hours.should equal(1)
    @event.minutes.should equal(0)
  end
end
