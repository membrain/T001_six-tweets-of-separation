# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # This helper formats a string showing information about the authenticated user powering
  # the calls to the twitter api.
  def get_courtesy_of_text
    begin
      t = TWITTER_CLIENT.my(:info)
      s    = "Courtesy of <a target='_blank' href='http://twitter.com/#{t.screen_name}'>#{t.name}</a>"
    rescue
      s = ""
    end
  end
  
end
