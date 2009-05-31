module EventsHelper
  def left(starts_at)
    hour = starts_at.strftime('%H').to_i - 6
    position = hour * 75
    return position
  end
  
  def full_left(starts_at)
    hour = starts_at.strftime('%H').to_i
    position = hour * 75
    return position
  end
  
  def width(hours,minutes)
    min = (hours * 60) + minutes
    unless min < 60
      width = (min * 1.25) - 12
    else
      width = 63
    end
    return width
  end
end