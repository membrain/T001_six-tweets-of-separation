class Tweeter < ActiveRecord::Base
  
  #----------------------------------------------------------------------------
  # Core Definitions
  #----------------------------------------------------------------------------
  
  # Add validations
  validates_presence_of :name, :screen_name, :image_url
  
  attr_accessor :friend_id_lookups
  
  
  
  #----------------------------------------------------------------------------
  # Public methods
  #----------------------------------------------------------------------------
  
  # This class method encapsulates the difference between looking up a tweeter
  # by api id in the cache versus looking him up via the api. 
  def self.get_by_api_id(api_id)
    d_obj = Tweeter.get_from_database_by_api_id(api_id)
    if d_obj.nil?
      a_obj = Tweeter.get_from_api(api_id)
      if a_obj
        d_obj = Tweeter.create_new_and_save(a_obj)
      end
    end
    d_obj
  end
  
  
  # This class method encapsulates the difference between looking up a tweeter
  # by screen name in the cache versus looking him up via the api. 
  def self.get_by_screen_name(screen_name)
    d_obj = Tweeter.get_from_database_by_screen_name(screen_name)
    if d_obj.nil?
      a_obj = Tweeter.get_from_api(screen_name)
      if a_obj
        d_obj = Tweeter.create_new_and_save(a_obj)
      end
    end
    d_obj
  end

  
  # This instance method returns an array of friend api ids for this tweeter.
  def friend_ids
    a = TWITTER_CLIENT.graph(:friends, api_id) || []
    a.sort!
  end
  
  # This instance method returns an array of follower api ids for this tweeter.
  def follower_ids
    a = TWITTER_CLIENT.graph(:followers, api_id) || []
    a.sort!
  end
  
  

  #----------------------------------------------------------------------------
  # Private methods
  #----------------------------------------------------------------------------
  private
  
  
  # This class method uses the supplied twitter user to create a new model
  # object and store it in the database.  It returns the newly saved model 
  # object.
  def self.create_new_and_save(api_user)
    t             = Tweeter.new
    t.api_id      = api_user.id
    t.name        = api_user.name
    t.screen_name = api_user.screen_name
    t.location    = api_user.location
    t.image_url   = api_user.profile_image_url
    t.save
    t
  end
  
  
  # This class method uses the supplied twitter screen name or api id to 
  # return the corresponding user object from the twitter api.
  def self.get_from_api(screen_name)
    TWITTER_CLIENT.user(screen_name)
  end
  
  
  # This class method uses the supplied twitter api id to return the 
  # corresponding user object from the database.
  def self.get_from_database_by_api_id(api_id)
    f = nil
    a = Tweeter.find(:all, :conditions => ["api_id = ?", api_id])
    if (a.length > 0) 
      f = a[0]
    end
    f
  end
  
  
  # This class method uses the supplied twitter screen name to return the 
  # corresponding user object from the database.
  def self.get_from_database_by_screen_name(screen_name)
    f = nil
    a = Tweeter.find(:all, :conditions => ["screen_name = ?", screen_name])
    if (a.length > 0) 
      f = a[0]
    end
    f
  end
  
end