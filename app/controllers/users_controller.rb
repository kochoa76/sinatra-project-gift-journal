class UsersController < ApplicationController


    get "/users/" do
      if logged_in?
        @users = User.all
        erb :"users/index"
      else
        flash[:message] = "You need to login to view users."
        redirect '/'
      end
    end

    get '/signup' do
      if !logged_in?
         erb :'users/create_user'
       else
         redirect to '/users/'
       end
     end

    post '/users/' do
      if params[:user][:username]== "" || params[:user][:email]== "" || params[:user][:password]== ""
        flash[:message] = "Please, fill in all the boxes."
        redirect to '/signup'
      else
        @user = User.create(username: params[:user][:username], email: params[:user][:email], password: params[:user][:password])
        @user.save
        session[:user_id]= @user.id
         flash[:message] = "You have successfully signed up."
        redirect to "/users/"
      end
    end

    get '/login' do
      if !logged_in?
     erb :'users/login'
     else
       redirect "/users/"
     end
  end

    post '/login' do
      @user = User.find_by(username: params[:user][:username])
      if @user && @user.authenticate(params[:user][:password])
        session[:user_id]= @user.id
        redirect to "/users/#{@user.slug}"
      else
        flash[:message]= "You have entered an incorrect username/password or have not yet signed up."
        redirect to '/signup'
      end
    end

    get '/users/:slug' do
     @user= User.find_by_slug(params[:slug])
     erb :'users/show'
   end

    get '/logout' do
      if logged_in?
        session.destroy
        redirect to '/login'
      else
        redirect to '/'
      end
    end


    get '/users/:slug/edit' do
      if logged_in?
        @user = User.find_by_slug(params[:slug])
        if @user = current_user
          erb :"users/edit"
        else
          flash[:message] = "You do not have permission to edit someone else's profile"
          redirect to '/users'
        end
      else
        redirect to '/login'
      end
    end

    patch "/users/:slug" do
        @user = User.find_by_slug(params[:slug])
        @user.update(username: params[:user][:username], email: params[:user][:email], password: params[:user][:password])
        flash[:message]= "You have successfully updated your profile"
        redirect to "users/#{@user.slug}"
      end

    get '/users/:slug/delete' do
      if logged_in?
        @user = User.find_by_slug(params[:slug])
        if @user = current_user
        @user.destroy
        session.clear
        flash[:message] = "You have successfully deleted your account"
        redirect to "/users/"
      else
        flash[:message] = "You do not have permission to delete another user's account"
      end
    else
      flash[:message] = "You need to login to delete your account"
      redirect to '/login'
    end
  end
end
