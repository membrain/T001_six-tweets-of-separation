class AddColumnsToTweeters < ActiveRecord::Migration

  # ----------------------------------------------------------------
  # This function is called when rake runs the migrate command.
  # ----------------------------------------------------------------
  
  def self.up
    
    # Drop friends table, which we no longer need
    drop_table :friends
    
    # Recreate tweeters
    drop_table  :tweeters
    create_table :tweeters do |t|
      t.integer     :api_id,      :null => false
      t.string      :name,        :null => false
      t.string      :screen_name, :null => false
      t.string      :location,    :null => true
      t.string      :image_url,   :null => false
      
      t.timestamps
    end
    
  end
  


  # ----------------------------------------------------------------
  # This function is called when rake runs the migrate command.
  # ----------------------------------------------------------------
  
  def self.down
    
    # Drop existing tables
    drop_table :tweeters
    
    # Recreate tweeters table
    create_table :tweeters do |t|
      t.string      :name,        :null => false
      t.string      :screen_name, :null => false
      
      t.timestamps
    end
    
    # Recreate friends table
    create_table :friends, :id => false do |t|
      t.integer     :tweeter_id,  :null => false
      t.integer     :friend_id,   :null => false
    end
    
    # Drop new columns from tweeters
    remove_column :tweeters, :location
    remove_column :tweeters, :image_url
    
  end

end
