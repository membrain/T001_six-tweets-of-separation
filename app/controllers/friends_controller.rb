class FriendsController < ApplicationController
  
  # ------------------------------------------------------------
  # Public methods
  # ------------------------------------------------------------
  
  # This method is the root action for this controller.  Because this
  # action simply displays a form, no logic is needed here.  Because
  # an output is not specified, Rails assumes html output from a view
  # template with a corresponding name.
  def index
  end
  
  # This function uses paramaters to invoke a shared friends
  # algorithm.  It returns the result to the view template with a 
  # corresponding name.
  #
  # NEEDS VALIDATION!!
  def show_common
    start_time  = Time.now
    @tweeter1   = Tweeter.get_by_screen_name(params[:tweeter1])
    @tweeter2   = Tweeter.get_by_screen_name(params[:tweeter2])
    @shared     = @tweeter1.get_shared_friends(@tweeter2)
    @elapsed    = Time.now - start_time
  end
  

  def show_degrees_of_separation
    @t1         = Tweeter.get_by_screen_name(params[:tweeter1])
    @t2         = Tweeter.get_by_screen_name(params[:tweeter2])
    @connections = [@t1]
    
    # Get friends of user 1
    t1_friends = @t1.get_friends
    
    # See if user 2 is a friend of user 1
    t1_friends.each do |friend|
       if friend.screen_name == @t2.screen_name
         @connections << @t2
         return
       end
    end
    
    t2_friends = @t2.get_friends
    
    # User 2 is not a friend of user 1.  Now, let's find the intersection of
    # user 1's friends list and user 2's friends list.
    t1_friends.each do |friend_1|
      t2_friends.each do |friend_2|
        if friend_1.screen_name == friend_2.screen_name
          @connections << friend
          @connections << @t2
          return
        end
      end
    end
    
    # Find the smaller of the 2 friends lists
    if t1_friends.length < t2_friends
      smaller = t1_friends
    else
      smaller = t2_friends
    end
    
  end
  
  # This function uses paramaters to invoke a six degrees of separation
  # algorithm.  It returns the result to the view template with a 
  # corresponding name.
  def show_links
    start_time  = Time.now
    @links      = tweeter_links
    @elapsed    = Time.now - start_time
  end


  
  # ------------------------------------------------------------
  # Private methods
  # ------------------------------------------------------------
  private

  # This method sets up a mock six degrees process in order to return
  # proper output to the view.  Additionally, it sets a set of threads,
  # which improves the performance of the twitter api fairly dramatically.
  def tweeter_links
    links     = []
    threads   = []
    usernames = [params[:user1], "mdinstuhl", "caitlin", "jpdugan", "tlowrimore", params[:user2]]

    usernames.each do |username|
      #threads << Thread.new(username, links) { |name, linx| linx << Tweeter.get_by_screen_name(name) }
      links << Tweeter.get_by_screen_name(username)
    end

    # threads.each do |thread| 
    #   thread.join
    # end

    links
  end  
  
end 
