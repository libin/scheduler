class EventsController < ApplicationController

  def set_user(user_id)
    user_id = 1 unless !user_id.nil?
    @user = User.find(user_id)
    @users = User.find :all
  end
  
  def parse_month_date(date)
    @date = Time.parse("#{date} || Time.now.utc")
    @next_month = 1.month.from_now(@date) #for next/prev links
    @last_month = 1.month.ago(@date)
  end
  
  # GET /event
  # GET /event.xml  
  def index
    set_user(params[:user_id])
    parse_month_date(params[:date])
    
    @events = Event.plot(@user.id, @last_month, @next_month)
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @events }
    end
  end
  
  def list
    set_user(params[:user_id])
    parse_month_date(params[:date])
    
    @events = Event.plot(@user.id, @last_month, @next_month)
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @events }
    end
  end

  def weekly
    set_user(params[:user_id])
    @date = Time.parse("#{params[:start_date]} || Time.now.utc")
    @start_date = Date.new(@date.year, @date.month, @date.day) 
    @end_date = Date.new(@date.year, @date.month, @date.day) + 6 
    
    @events = Event.plot(@user.id, @start_date, @start_date + 7)
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @events }
    end
  end
    
  # GET /event/1
  # GET /event/1.xml
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.haml
      format.xml  { render :xml => @event }
    end
  end

  # GET /event/new
  # GET /event/new.xml
  def new
    @users = User.find :all
    @event = Event.new

    respond_to do |format|
      format.html # new.haml
      format.xml  { render :xml => @event }
    end
  end

  # GET /event/1/edit
  def edit
    @users = User.find :all
    @event = Event.find(params[:id])
  end

  # POST /event
  # POST /event.xml
  def create
    @users = User.find :all
    @event = Event.new(params[:event])
    
    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to events_path }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /event/1
  # PUT /event/1.xml
  def update
    @users = User.find :all
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to(event_path(@event)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /event/1
  # DELETE /event/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
end
