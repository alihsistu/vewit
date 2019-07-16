class ApplicationController < Sinatra::Base
  register Sinatra::Flash #For sinatra-flash gem to work.
  register Sinatra::ActiveRecordExtension

  configure do
  	set :views, 'app/views'
    set :public_folder, 'public'
    #enables sessions as per Sinatra's docs. Session_secret is meant to encript the session id so that users cannot create a fake session_id to hack into your site without logging in. 
    enable :sessions
    set :session_secret, "secret"
  end

  # Renders the home or index page
  #Removed UserController Code. You can find it it in user_controller.rb under controllers directory. You May remove this comment after reading.
  get '/' do
    if check_tweets(session[:user_id]) != 0
      tweets = Tweet.where(user_id:user_id)
      @tweets_count = tweets
    else
      @tweets_count = 0
    end
    @user = User.find_by(id:session[:user_id])
    @followers = check_followers(@user.username)
    @followings = check_followers(@user.username)

  	erb :index
  end
  # ===========ALI(tweet)=============
  get '/delete/:id' do 
    @tweet =Tweet.find_by(id:params[:id])
    @tweet.destroy
    redirect '/tweets'
  end

  get '/create_tweet' do
    erb :create_tweet
  end

  get '/tweets' do
    # @reply =Reply.find(session[:reply_id])
    @tweets = Tweet.all
    erb :tweets
  end

  get '/display_tweet/:id' do

    @tweet =Tweet.find(params[:id])

    erb :display

  end

  post '/create_tweet'  do 
    @tweet = Tweet.create(params)
    @tweet.user_id = current_user.id

    @tweet.save
    session[:id] = @tweet.id

    redirect '/tweets'
  end

  get '/tweet/:id' do #
    @tweet = Tweet.find(params[:id])
    erb :'tweets/tweet' #temp path
  end

  post '/tweets/edit/:id' do 
    @tweet = Tweet.find(params[:id])
    @tweet.description = params[:description]
    @tweet.save
    redirect "/tweets"
  end

  get '/edit/:id' do
    @tweet = Tweet.find(params[:id])
    @des = @tweet.description
    
    erb  :'/edit_tweet'
  end
  # =====HELPER=====
  helpers do 

    def current_user
      @current_user ||= User.find(session[:user_id])
    end

    def logged_in?
      !!session[:user_id]
    end

    def check_followers(username)
      # byebug
      @user = User.find_by_username(username)
      @check_followers = Follower.where(following_id:@user.id)
      if @check_followers.nil?
        return 0
      else
        @check_followers.count
      end
    end

    def check_followings(username)

      # username = params[:username]
      @user = User.find_by_username(username)

      @check_followings = Follower.where(follower_id:@user.id)
      # using follower_id, access user names of all those current user is following
      if @check_followings.nil?
        return 0
      else
        @check_followings.count
      end
    end

    def check_tweets(user_id)
      tweets = Tweet.where(user_id:user_id)
      if !tweets == nil
        return tweets.count
      else
        return 0
      end
    end

  end

  # temporay working place
  # =======================


  get '/signup' do
    if !logged_in?
      @user = User.new
      erb :signup
    else
      redirect '/'
    end
  end

  post '/signup' do
    @user = User.new(params)
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

  get '/users/home' do
    erb :'/users/home'
  end

  # this is user progfil page
  # this page will only display user tweets and timeline followrs etc
  get '/user/:username' do
    # byebug
    username = params[:username]
    @user = User.find_by_username(username)
    # byebug
    @following_people = []
    if check_tweets(@user.id) != 0
      @user_tweets = Tweet.where(username:username).order("created_at DESC")
    else
      @user_tweets = 0
    end
    user_followings = Follower.find_by(following_id:@user.id)
    byebug
    if user_followings != nil
      
      user_followings.each do |following|
        @following_people<<following.username
      end
    end
    user_followers = Follower.find_by(follower_id:@user_id)
    if user_followers != nil
     
      user_followers.each do |followers|
        @followers<<followers.username
      end
    end
    @all_users = []
    people = User.all
    people.each do |person|
      @all_users <<person 
    end
    # display some random profile
    @some_users = @all_users.sample(2)
    erb :"users/profile" 

  end

  get '/follow/:username' do
    @following_person = User.find_by_username(params[:username])
    @user = @following_person
    User.follow(@following_person.username,current_user)
    redirect "/user/#{params[:username]}"
  end

  get '/unfollow/:username' do
    @unfollowing_person = User.find_by_username(params[:username])
    @user = @following_person
    User.unfollow(@unfollowing_person.username,current_user)
    redirect "/user/#{params[:username]}"
  end

  get '/users/:username/followers' do
    unless check_followers(params[:username]) == 0
      @followers = Follower.where(username:username)
    else
      @followers = 0
    end
    erb :'users/followers'
  end

  # thsi route will get a list of users whom that said user is following
  get '/users/:username/following' do
    unless check_followings(params[:username]) == 0
      @followings = Follower.where(username:username)
    else
      @followings = "This person does not follow anyone"
    end
    erb :"users/following"
  end


  get '/search' do
    @people = User.search(params[:search])
    erb :'users/search_results'
  end



end
