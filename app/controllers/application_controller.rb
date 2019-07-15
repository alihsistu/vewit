class ApplicationController < Sinatra::Base

  register Sinatra::ActiveRecordExtension

  configure do
  	set :views, "app/views"
    set :public_dir, "public"
    #enables sessions as per Sinatra's docs. Session_secret is meant to encript the session id so that users cannot create a fake session_id to hack into your site without logging in. 
    enable :sessions
    set :session_secret, "secret"
  end

  # Renders the home or index page
  get '/signup' do
    if !logged_in?
      @user = User.new
      erb :signup
    else
      redirect '/'
    end
  end
  post '/signup' do
    @user = User.new(username: params[:username], password: params[:password])
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

end
