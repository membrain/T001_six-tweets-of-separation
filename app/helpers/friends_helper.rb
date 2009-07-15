module FriendsHelper
  
  # This method accepts an twitter api id, retrieves the associated user, and
  # formats a display block. 
  def format_tweeter_from_api_id(api_id = 0)
    
    # get tweeter object
    begin
      t = Tweeter.get_by_api_id(api_id)
    rescue
      t = nil
    end
    
    # if not found, return empty string
    return "" if t.nil?
    
    # else, format response
    "#{t.api_id} - #{t.name} (#{t.screen_name})"
  end
  
  
  # This method returns the appropriate checked value for the paramter
  # and option value given.
  def get_checked_value(param, option)
    if (param.blank? && option == "degrees") || (param == option)
      "checked"
    else
      ""
    end 
  end
  
  
  # This method returns an appropriate search results header for the search
  # type
  def get_results_header(type = nil)
    case type
      when "degrees"
        "#{pluralize(@collection.total_entries-2, "Degree")} of Separation"
      when "followers"
        "#{@collection.total_entries} Shared Followers"
      when "friends"
        "#{@collection.total_entries} Shared Friends"
      else
        ""
    end
  end
end
