# WeeklyCalendar
module WeeklyHelper
  
  def weekly_calendar(objects, *args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    concat(tag("div", :id => "week"))
    yield WeeklyBuilder.new(objects || [], self, options)
    concat("</div>")
    if options[:include_24_hours] == true
      concat("<b><a href='?business_hours=true'>Business Hours</a> | <a href='?business_hours=false'>24-Hours</a></b>")
    end
  end
  
  def weekly_links(options)
    start_date = options[:start_date]
    end_date = options[:end_date]
    concat("<a href='/weekly?start_date=#{start_date - 7}?user_id='>« Previous Week</a> ")
    concat("#{start_date.strftime("%B %d -")} #{end_date.strftime("%B %d")} #{start_date.year}")
    concat(" <a href='/weekly?start_date=#{start_date + 7}?user_id='>Next Week »</a>")
  end
  
  class WeeklyBuilder
    include ::ActionView::Helpers::TagHelper

    def initialize(objects, template, options)
      raise ArgumentError, "WeeklyBuilder expects an Array but found a #{objects.inspect}" unless objects.is_a? Array
      @objects, @template, @options = objects, template, options
    end

    def days(options = {})
      concat(tag("div", :id => "days"))
        concat(content_tag("div", options[:title], :id => "placeholder"))
        for day in @options[:start_date]..@options[:end_date]
          concat(tag("div", :id => "day"))
          concat(content_tag("b", day.strftime('%A')))
          concat(tag("br"))
          concat(day.strftime('%B %d'))
          concat("</div>")
        end
      concat("</div>")      
    end
    
    def week(options = {})
      if options[:business_hours] == "true" or options[:business_hours].blank?
        hours = ["6am","7am","8am","9am","10am","11am","12pm","1pm","2pm","3pm","4pm","5pm","6pm","7pm","8pm"]
        header_row = "header_row"
        day_row = "day_row"
        grid = "grid"
      else
        hours = ["1am","2am","3am","4am","5am","6am","7am","8am","9am","10am","11am","12pm","1pm","2pm","3pm","4pm","5pm","6pm","7pm","8pm","9pm","10pm","11pm","12am"]
        header_row = "full_header_row"
        day_row = "full_day_row"
        grid = "full_grid"
      end
      
      concat(tag("div", :id => "hours"))
        concat(tag("div", :id => header_row))
          for hour in hours
            header_box = "<b>#{hour}</b>"
            concat(content_tag("div", header_box, :id => "header_box"))
          end
        concat("</div>")
        
        concat(tag("div", :id => grid))
          for day in @options[:start_date]..@options[:end_date]
            concat(tag("div", :id => day_row))
            for event in @objects
              if event.starts_at.strftime('%A') == day.strftime('%A') and event.starts_at.strftime('%H').to_i >= 6 and event.ends_at.strftime('%H').to_i <= 24 
                concat(tag("div", :id => "week_event", :style =>"left:#{left(event.starts_at,options[:business_hours])}px;width:#{width(event.hours,event.minutes)}px;", :onclick => "location.href='/events/#{event.id}';"))
                  yield(event)
                concat("</div>")
              end
            end
            concat("</div>")
          end
        concat("</div>")
      concat("</div>")
    end
  
    
    private
    
    def concat(tag)
       @template.concat(tag)
    end

    def left(starts_at,business_hours)
      if business_hours == "true" or business_hours.blank?
        hour = starts_at.strftime('%H').to_i - 6
      else
        hour = starts_at.strftime('%H').to_i
      end
      position = hour * 75
    end

    def width(hours,minutes)
      min = (hours * 60) + minutes
      unless min < 60
        width = (min * 1.25) - 12
      else
        width = 63
      end
    end
    
  end
end