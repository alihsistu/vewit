class ApplicationController < Sinatra::Base
  register Sinatra::Flash #For sinatra-flash gem to work.
  register Sinatra::ActiveRecordExtension

  configure do
  	set :views, "app/views"
    set :public_dir, "public"
    #enables sessions as per Sinatra's docs. Session_secret is meant to encript the session id so that users cannot create a fake session_id to hack into your site without logging in. 
    enable :sessions
    set :session_secret, "secret"
  end

  # Renders the home or index page
  #Removed UserController Code. You can find it it in user_controller.rb under controllers directory. You May remove this comment after reading.

  # ===========ALI(posts)=============
  # creates a post
  post '/post'  do #temp path
    @post = Post.create(params)
    @post.user_id = current_user.id

    @post.save
    session[:id] = @post.id

    redirect '/'
  end

  delete '/posts/:id' do
    @post = Post.delete(params[:id])
    redirect '/' #after post is deleted, it is redirected to home
  end

  get '/posts/:id/edit' do #load the edit form
    @post = Post.find(params[:id])
    erb :'posts/edit' #temp path for editing the post
  end

  get '/post/:id' do #
    @post = Post.find(params[:id])
    erb :'posts/post' #temp path
  end

  patch 'posts/:id' do 
    @post = Tweet.find(params[:id])
    @post.description = params[:description]
    @post.save
    redirect "/posts/#{@post.id}"
  end

end
