# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')



Rails::Initializer.run do |config|
  
  # -------------------------------------------------------------
  # This block specifies gems that this application depends on 
  # and has them installed with rake gems:install
  # -------------------------------------------------------------
  
  config.gem "twitter4r", 
                :version => "0.3.1", 
                :lib => "twitter"
                
  config.gem "mislav-will_paginate", 
                :version => "~> 2.3.8", 
                :lib =>     "will_paginate", 
                :source =>  "http://gems.github.com"  
  

  # -------------------------------------------------------------
  # This block sets the default time zone 
  # -------------------------------------------------------------
  
  config.time_zone = 'UTC'

  
  
  # -------------------------------------------------------------
  # This block attempts to use our twitter config file to 
  # our client class.  We do this so we can utilize additional
  # api requests that may be authorized for that account, if it
  # is in fact on the twitter whitelist.  If not, we just use an
  # unauthenticated client class and accept whatever constraints
  # twitter applies to generic api users.
  #
  # Whatever the result, we also create a global constant for
  # the api object.
  # -------------------------------------------------------------
  
  config.after_initialize do
    begin
      ::TWITTER_CLIENT = Twitter::Client.from_config("config/twitter.yml", RAILS_ENV)
    rescue
      ::TWITTER_CLIENT = Twitter::Client.new
    end
  end
end