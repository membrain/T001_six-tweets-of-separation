class FriendsController < ApplicationController
  
  before_filter :get_twitter_client

  def index
  end
  
  def show_common
    @user1 = @twitter.user(params[:user1])
    @user2 = @twitter.user(params[:user2])
  end
  
end 
