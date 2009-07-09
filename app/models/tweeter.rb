class Tweeter < ActiveRecord::Base
  
  #----------------------------------------------------------------------------
  # Core Definitions
  #----------------------------------------------------------------------------
  
  # Add relationships
  has_and_belongs_to_many :friends, 
                          :class_name               => "Tweeter", 
                          :join_table               => "friends", 
                          :foreign_key              => "tweeter_id", 
                          :association_foreign_key  => "friend_id"
  
  
  # Add validations
  validates_presence_of :name, :screen_name
  
  
  
  #----------------------------------------------------------------------------
  # Public methods
  #----------------------------------------------------------------------------
  
  # This class method encapsulates the difference between looking up a tweeter
  # in the cache versus looking him up via the api. 
  def self.get_by_screen_name(screen_name)
    d_friend = Tweeter.get_database_user(screen_name)
    if d_friend.nil?
      t_user = Tweeter.get_twitter_user(screen_name)
      if t_user
        d_friend = Tweeter.create_new_and_save(t_user)
      end
    end
    d_friend
  end
  
  # This instance method determines the friends shared by the argument and the
  # instance.
  def get_shared_friends(other_tweeter)
    my_friends  = get_friends
    her_friends = other_tweeter.get_friends
    shared      = []
    if my_friends.length && her_friends.length
      my_friends.each do |m_f|
        idx = her_friends.index { |item| item.screen_name == m_f.screen_name }
        if !idx.nil?  
          shared << her_friends[idx]
        end
      end
    end
    shared
  end
  
  # This instance method abstracts the difference between friends retireved from
  # the database and those retrieved from the api.
  def get_friends
    a = []
    if friends.length > 0
      a = friends 
    else
      t_user    = Tweeter.get_twitter_user(screen_name)
      t_friends = t_user.friends
      t_friends.each do |t_friend|
        d_friend = Tweeter.get_database_user(t_friend.screen_name)
        if d_friend.nil?
          d_friend = Tweeter.create_new_and_save(t_friend)
        end
        friends << d_friend
        a       << d_friend
      end
      save
    end
    a
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
    t.name        = api_user.name
    t.screen_name = api_user.screen_name
    t.save
    t
  end
  
  # This class method uses the supplied twitter screen name to return the 
  # corresponding user object from the database.
  def self.get_database_user(screen_name)
    f = nil
    a = Tweeter.find(:all, :conditions => ["screen_name = ?", screen_name])
    if (a.length > 0) 
      f = a[0]
    end
    f
  end
  
  # This method uses hard-coded credentials to return an authenticated client
  # to the twitter API
  def self.get_twitter_client
    @@twitter ||= Twitter::Client.new(
      :login    => Tweeter.get_twitter_client_username,
      :password => Tweeter.get_twitter_client_password
    )
  end
  
  # This method returns the username from the twitter config file.
  def self.get_twitter_client_username
    config = Tweeter.get_twitter_config
    config["login"]["username"]
  end
  
  # This method returns the username from the twitter config file.
  def self.get_twitter_client_password
    config = Tweeter.get_twitter_config
    config["login"]["password"]
  end
  
  # This method returns the twitter config file.
  def self.get_twitter_config
    YAML.load_file("config/twitter.yml")
  end
  
  # This class method uses the supplied twitter screen name to return the 
  # corresponding user object from the twitter api.
  def self.get_twitter_user(screen_name)
    Tweeter.get_twitter_client
    @@twitter.user(screen_name)
  end
  
end