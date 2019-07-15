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
  get '/' do
    @message = session[:message]
    if @message == nil 
      @message = "Please enter the new url"
    end
    erb :home, layout: :layout

  end

  # Renders the sign up/registration page in app/views/registrations/signup.erb
  get '/registrations/signup' do
    erb :'/registrations/signup'
  end

  post '/registrations' do
    user = User.create(name:params["name"], email:params["email"])
    user.password = params["psw"]
    user.save
    session[:user_id] = user.id
    puts session[:user_id]
    redirect '/users/home'
  end
  
  get '/sessions/login' do
    erb :'/sessions/login'
  end

  post '/sessions' do
    user_s = User.find_by(name: params["uname"])
    if user_s == nil
      session[:status_message] = "Sorry there is no such user"
      redirect '/sessions/login'   
    elsif user_s.password == params["psw"]
      session[:status_message] = "Welcome back"
      session[:user_id] = user_s.id
      redirect '/users/home'
    else
      session[:status_message]="Sorry, your username or password is incorrect"
      redirect '/sessions/login'
    end
  end

end
