class FriendsController < ApplicationController
  before_filter :twitter_login

  def index
    @user = @twitter.user('jpdugan')
  end
  
  def show_common
    @user1 = @twitter.user(params[:user1])
    @user2 = @twitter.user(params[:user2])
  end
  
end 
