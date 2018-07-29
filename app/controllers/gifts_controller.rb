class GiftsController < ApplicationController


  get '/gifts/create_gift' do
    if logged_in?
      erb :'/gifts/create_gift'
    else
      erb :login
    end
  end

  get '/users/:slug/gifts' do
    @user = User.find_by_slug(params[:slug])
    @gifts= Gift.all
      erb :'/users/mygifts'
    end

  get '/gifts' do
    if logged_in?
      @gifts = Gift.all
      erb :'/gifts/index'
    else
        redirect to '/login'
     end
  end

  post '/gifts' do
    if logged_in?
      if params[:gift][:name] == "" || params[:gift][:description] == ""
        flash[:message] = "Please fill all the boxes."
        redirect to "/gifts/create_gift"
      else
        @gift = current_user.gifts.build(name: params[:gift][:name], description: params[:gift][:description])
        if @gift.save
           flash[:message] = "You have successfully added a gift"
          redirect to "/gifts/#{@gift.slug}"
        else
           flash[:message] = "Gift has already been added, please choose a different name."
          redirect to "/gifts/create_gift"
        end
      end
    else
      redirect to '/login'
    end
  end

  get "/gifts/:slug" do
    @gift = Gift.find_by_slug(params[:slug])
    @user = @gift.user
      erb :"/gifts/show_gift"
  end

  get "/gifts/:slug/edit" do
    if logged_in?
      @gift = Gift.find_by_slug(params[:slug])
      if @gift && @gift.user == current_user
        erb :"gifts/edit_gift"
      else
        redirect to '/gifts'
      end
    else
      redirect to '/login'
    end
  end

  patch "/gifts/:slug" do
    if logged_in?
      if params[:gift][:name] == "" || params[:gift][:description] == ""
        redirect to "/gifts/#{params[:slug]}/edit"
      else
        @gift = Gift.find_by_slug(params[:slug])
        if @gift && @gift.user == current_user
          if @gift.update(name: params[:gift][:name], description: params[:gift][:description])
            @gift.save
            flash[:message] = "You have successfully edited your gift."
            redirect to "/gifts/#{@gift.slug}"
          else
            redirect to "gifts/#{@gift.slug}/edit"
         end
        else
          redirect to '/gifts'
         end
       end
    else
      flash[:message] = "Gift name has already been added, please choose a different name."
      redirect to "/login"
    end
  end

  get '/gifts/:slug/delete' do
    if logged_in?
     @gift = Gift.find_by_slug(params[:slug])
     if @gift && @gift.user == current_user
       @gift.destroy
        flash[:message] = "You have successfully deleted your gift."
     end
     redirect to "/users/#{current_user.slug}/gifts"
   else
     flash[:message] = "You do not have permission to delete another user's gift."
     redirect to '/login'
   end
 end




end
