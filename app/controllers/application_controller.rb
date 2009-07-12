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
  
end
