class CreateTweetersAndHabtm < ActiveRecord::Migration
  
  # ----------------------------------------------------------------
  # This function is called when rake runs the migrate command.
  # ----------------------------------------------------------------
  
  def self.up
    
    # Create a simple tweeters table to hold the twitter user data
    # we intend to display
    create_table :tweeters do |t|
      t.string      :name,        :null => false
      t.string      :screen_name, :null => false
      
      t.timestamps
    end
  
    # Create the bridge table that forms a many-to-many join
    # between the tweeters table and itself.
    create_table :friends, :id => false do |t|
      t.integer     :tweeter_id,  :null => false
      t.integer     :friend_id,   :null => false
    end
  
  end
  


  # ----------------------------------------------------------------
  # This function is called when rake runs the migrate command.
  # ----------------------------------------------------------------
  
  def self.down
    
    # Drop both tables
    drop_table :tweeters
    drop_table :friends
    
  end
  
end
