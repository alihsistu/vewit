class UsersController < ApplicationController

	get '/signup' do
    if !logged_in?
      @user = User.new
      erb :signup
    else
      redirect '/'
    end
  end

  post '/signup' do
    @user = User.new(name: params[:name], username: params[:username], password: params[:password])
    if @user.save
      session[:user_id] = @user.id
      redirect '/'
    else
      erb :signup
    end
  end

  get '/login' do
    if !logged_in?
      erb :login
    else
      redirect '/'
    end
  end

  post '/login' do
   user = User.find_by_username(params[:username])
   if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect '/'
   else
    flash[:error] = "Invalid Credentials!"
    redirect '/login'
   end
  end

  get '/logout' do
    if logged_in?
      session.clear
    end
    redirect '/'
  end

  # this is user home page where all tweets from users current user is following will apppear
  get '/users/home' do
    erb :'/users/home'
  end

  # this is user progfil page
  #this page will only display user tweets and timeline followrs etc
  get '/users/:username' do
    username = params[:username]
    @user_posts = Tweet.where(username: username).order("created_at DESC")
    @user = User.find(id)
    erb :"users/profile" 
  end

  get '/users/:username/followers' do
    @user = User.find_by(username:params[:username])
    @follower_ids = Follower.where(user_id:@user.id)
    # using follower_id, access user names of all those following current user
    if @follower_ids.nil?
      session[:status_message] = "You do not have current followers. Follow others to get followers"
      erb :"users/followers" 
    else
      erb :"users/followers"
    end

  end

  # thsi route will get a list of users whom that said user is following
  get '/users/:username/following' do
      username = params[:username]
      @user = User.find_by_username(username)

      @following = Follower.where(follower_id:@user.id)
      # using follower_id, access user names of all those current user is following
      if @following.nil?
        session[:status_message] = "You not following anyone currently. Follow others to see their tweets"
        erb :"users/following" 
      else
        erb :"users/following"
      end
  end


  get '/search' do
    @persons = User.search(params[:search])
    erb :'users/search_results'
  end

end