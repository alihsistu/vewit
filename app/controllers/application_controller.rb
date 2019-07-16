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
  	erb :index
  end
  # ===========ALI(posts)=============
  # creates a post
  post '/tweet'  do #temp path
    @tweet = Tweet.create(params)
    @tweet.user_id = current_user.id

    @tweet.save
    session[:id] = @tweet.id

    redirect '/'
  end

  delete '/tweets/:id' do
    @tweet = Tweet.delete(params[:id])
    redirect '/' #after tweet is deleted, it is redirected to home
  end

  get '/tweets/:id/edit' do #load the edit form
    @tweet = Tweet.find(params[:id])
    erb :'tweets/edit' #temp path for editing the post
  end

  get '/tweet/:id' do #
    @tweet = Tweet.find(params[:id])
    erb :'tweets/tweet' #temp path
  end

  patch 'tweets/:id' do 
    @tweet = Tweet.find(params[:id])
    @tweet.description = params[:description]
    @tweet.save
    redirect "/tweets/#{@tweet.id}"
  end

  helpers do 

    def current_user
      @current_user ||= User.find(session[:user_id])
    end

    def logged_in?
      !!session[:user_id]
    end

  end
end
