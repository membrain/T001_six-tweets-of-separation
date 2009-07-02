class FriendsController < ApplicationController
  
  # ------------------------------------------------------------
  # Filters
  # ------------------------------------------------------------
  
  before_filter :get_twitter_client, :only => [:show_links]



  # ------------------------------------------------------------
  # Public methods
  # ------------------------------------------------------------
  
  # This method is the root action for this controller.  Because this
  # action simply displays a form, no logic is needed here.  Because
  # an output is not specified, Rails assumes html output from a view
  # template with a corresponding name.
  def index
  end
  
  # This function uses paramaters to invoke a six degrees of separation
  # algorithm.  It returns the result to the view template with a 
  # corresponding name.
  def show_links
    start_time  = Time.now
    @links      = user_links
    @elapsed    = Time.now - start_time
  end


  
  # ------------------------------------------------------------
  # Private methods
  # ------------------------------------------------------------
  private

  # This method sets up a mock six degrees process in order to return
  # proper output to the view.  Additionally, it sets a set of threads,
  # which improves the performance of the twitter api fairly dramatically.
  def user_links
    links     = []
    threads   = []
    usernames = [params[:user1], "mdinstuhl", "caitlin", "jpdugan", "tlowrimore", params[:user2]]

    usernames.each do |username|
      threads << Thread.new(username, links) { |name, linx| linx << @twitter.user(name) }
    end

    threads.each do |thread| 
      thread.join
    end

    links
  end  
  
end 
