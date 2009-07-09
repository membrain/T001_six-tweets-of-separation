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
  
  
  # This function uses paramaters to invoke either a shared friends
  # algorithm or a degrees of separation algorithm.  It returns a 
  # response object to the index page via ajax and an rjs template.
  #
  # NEEDS VALIDATION!!
  def search
    
    # get tweeple
    t1       = Tweeter.get_by_screen_name(params[:search][:tweeter1])
    t2       = Tweeter.get_by_screen_name(params[:search][:tweeter2])
    
    # build core response object
    @response = {
      "t1"          => t1,
      "t2"          => t2,
      "type"        => nil,
      "collection"  => []
    }
    
    # depending on search option, add remaining response pieces
    if params[:search][:type] == "friends"
      @response["type"]       = "friends"
      @response["collection"] = t1.get_shared_friends(t2) || []
    else
      @response["type"]       = "degrees"
      @response["collection"] = get_degrees_of_separation
    end
    
    # send response
    @response
  end
  
  
  
  # ------------------------------------------------------------
  # Private methods
  # ------------------------------------------------------------
  private
  
  # This is a super fast implementation of ideas discussed in the
  # third session. @tlowrimore
  def get_degrees_of_separation
    
    # Get tweeple and set initial connections array
    t1         = Tweeter.get_by_screen_name(params[:search][:tweeter1])
    t2         = Tweeter.get_by_screen_name(params[:search][:tweeter2])
    @connections = [t1]
    
    # Get friends of user 1
    t1_friends = t1.get_friends
    
    # See if user 2 is a friend of user 1
    t1_friends.each do |friend|
       if friend.screen_name == t2.screen_name
         @connections << t2
         return @connections
       end
    end
    
    t2_friends = t2.get_friends
    
    # User 2 is not a friend of user 1.  Now, let's find the intersection of
    # user 1's friends list and user 2's friends list.
    t1_friends.each do |friend_1|
      t2_friends.each do |friend_2|
        if friend_1.screen_name == friend_2.screen_name
          @connections << friend
          @connections << t2
          return @connections
        end
      end
    end
    
    # ----------------------------------------------------------------------------------
    # @jpdugan - commenting out this block and adding default return below to provide
    # a safer check-in point.  Revert this change when algorithm work resumes.
    # ----------------------------------------------------------------------------------
    # Find the smaller of the 2 friends lists
    # if t1_friends.length < t2_friends
    #       smaller = t1_friends
    #     else
    #       smaller = t2_friends
    #     end
    
    @connections
  end
  
end 
