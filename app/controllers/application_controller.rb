# -----------------------------------------------------------------
# Require additional classes, modules, etc.
# -----------------------------------------------------------------

require "yaml"



# -----------------------------------------------------------------
# Define controller
# -----------------------------------------------------------------

class ApplicationController < ActionController::Base
  
  
  # -----------------------------------------------------------------
  # Config
  # -----------------------------------------------------------------
  
  # Include all helpers, all the time
  helper :all
  
  # Establish security settings
  protect_from_forgery 
  filter_parameter_logging :password
  
  
  
  # -----------------------------------------------------------------
  # Public methods
  # -----------------------------------------------------------------
  
  # This method returns an authenticated client of the twitter api
  # using the credentials in the corresponding yml file.
  def get_twitter_client
    @twitter = Twitter::Client.new(
      :login    => get_twitter_client_username,
      :password => get_twitter_client_password
    )
  end
  
  
  
  # -----------------------------------------------------------------
  # Private methods
  # -----------------------------------------------------------------
  private
  
  # This method returns the username from the twitter config file.
  def get_twitter_client_username
    config = get_twitter_config
    config["login"]["username"]
  end
  
  # This method returns the username from the twitter config file.
  def get_twitter_client_password
    config = get_twitter_config
    config["login"]["password"]
  end
  
  # This method returns the twitter config file.
  def get_twitter_config
    YAML.load_file("config/twitter.yml")
  end
  
end
