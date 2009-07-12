class FriendsController < ApplicationController
  
  # ------------------------------------------------------------
  # Public methods
  # ------------------------------------------------------------
  
  # This method is the root action for this controller. It evaluates
  # the search parameters and creates the necessary response objects.
  def index
    
    # set default values
    @is_submitted = false
    
    # if form submitted, process
    if params[:tweeter1] && params[:tweeter2] && params[:type]
    
      # mark as submitted
      @is_submitted = true
      
      # get tweeple
      @t1       = Tweeter.get_by_screen_name(params[:tweeter1])
      @t2       = Tweeter.get_by_screen_name(params[:tweeter2])

      # save search type
      @type     = params[:type]

      # get collection for search type
      @collection = case @type
        when "degrees"
          get_degrees_of_separation
        when "followers"
          @t1.follower_ids & @t2.follower_ids
        when "friends"
          @t1.friend_ids & @t2.friend_ids
        else
          []
      end

      # paginate collection
      options = {
        :page     => params[:page] || 1,
        :per_page => 10
      }
      @collection = @collection.paginate(options)
      
    end
    
  end
  
  
  
  # ------------------------------------------------------------
  # Private methods
  # ------------------------------------------------------------
  private
  
  # This is a super fast implementation of ideas discussed in the
  # third session. @tlowrimore
  def get_degrees_of_separation
    
    # get tweeple and set initial connections array
    connections = [@t1.api_id]
    
    # get friends of user 1
    t1_friend_ids = @t1.friend_ids
    
    # See if user 2 is a friend of user 1
    if t1_friend_ids.index(@t2.api_id)
       connections << @t2.api_id
       return connections
    end
    
    # get friends of user 2
    t2_friend_ids = @t2.friend_ids
    
    # User 2 is not a friend of user 1.  Now, let's find the intersection of
    # user 1's friends list and user 2's friends list.
    shared = t1_friend_ids & t2_friend_ids
    if shared.length
      connections << shared[0]
      connections << @t2.api_id
      return connections
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
    
    connections
  end
  
end 
