require File.dirname(__FILE__) + '/../spec_helper'

describe EventsController, "handling GET /events" do

  before do
    @user = mock_model(User)
    User.stub!(:find).and_return([@user])
    @event = mock_model(Event)
    Event.stub!(:find).and_return([@event])
  end
  
  def do_get
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render index template" do
    do_get
    response.should render_template('index')
  end
  
  it "should assign the found events for the view" do
    do_get
    assigns[:events].should == [@event]
  end
end

describe EventsController, "handling GET /events/1" do

  before do
    @event = mock_model(Event)
    Event.stub!(:find).and_return(@event)
  end
  
  def do_get
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render show template" do
    do_get
    response.should render_template('show')
  end
  
  it "should find the event requested" do
    Event.should_receive(:find).with("1").and_return(@event)
    do_get
  end
  
  it "should assign the found event for the view" do
    do_get
    assigns[:event].should equal(@event)
  end
end


describe EventsController, "handling GET /events/new" do

  before do
    @event = mock_model(Event)
    Event.stub!(:new).and_return(@event)
  end
  
  def do_get
    get :new
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render new template" do
    do_get
    response.should render_template('new')
  end
  
  it "should create an new event" do
    Event.should_receive(:new).and_return(@event)
    do_get
  end
  
  it "should not save the new event" do
    @event.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new event for the view" do
    do_get
    assigns[:event].should equal(@event)
  end
end

describe EventsController, "handling GET /events/1/edit" do

  before do
    @event = mock_model(Event)
    Event.stub!(:find).and_return(@event)
  end
  
  def do_get
    get :edit, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render edit template" do
    do_get
    response.should render_template('edit')
  end
  
  it "should find the event requested" do
    Event.should_receive(:find).and_return(@event)
    do_get
  end
  
  it "should assign the found event for the view" do
    do_get
    assigns[:event].should equal(@event)
  end
end

describe EventsController, "handling POST /events" do

  before do
    @event = mock_model(Event, :to_param => "1")
    Event.stub!(:new).and_return(@event)
  end
  
  def post_with_successful_save
    @event.should_receive(:save).and_return(true)
    post :create, :event => {}
  end
  
  def post_with_failed_save
    @event.should_receive(:save).and_return(false)
    post :create, :event => {}
  end
  
  it "should create a new event" do
    Event.should_receive(:new).with({}).and_return(@event)
    post_with_successful_save
  end

  it "should redirect to the new event on successful save" do
    post_with_successful_save
    response.should redirect_to(event_url("1"))
  end

  it "should re-render 'new' on failed save" do
    post_with_failed_save
    response.should render_template('new')
  end
end

describe EventsController, "handling PUT /events/1" do

  before do
    @event = mock_model(Event, :to_param => "1")
    Event.stub!(:find).and_return(@event)
  end
  
  def put_with_successful_update
    @event.should_receive(:update_attributes).and_return(true)
    put :update, :id => "1"
  end
  
  def put_with_failed_update
    @event.should_receive(:update_attributes).and_return(false)
    put :update, :id => "1"
  end
  
  it "should find the event requested" do
    Event.should_receive(:find).with("1").and_return(@event)
    put_with_successful_update
  end

  it "should update the found event" do
    put_with_successful_update
    assigns(:event).should equal(@event)
  end

  it "should assign the found event for the view" do
    put_with_successful_update
    assigns(:event).should equal(@event)
  end

  it "should redirect to the event on successful update" do
    put_with_successful_update
    response.should redirect_to(event_url("1"))
  end

  it "should re-render 'edit' on failed update" do
    put_with_failed_update
    response.should render_template('edit')
  end
end

describe EventsController, "handling DELETE /event/1" do

  before do
    @event = mock_model(Event, :destroy => true)
    Event.stub!(:find).and_return(@event)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the event requested" do
    Event.should_receive(:find).with("1").and_return(@event)
    do_delete
  end
  
  it "should event destroy on the found event" do
    @event.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the events list" do
    do_delete
    response.should redirect_to(events_url)
  end
end
