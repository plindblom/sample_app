class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    unless signed_in?
      @user = User.new
      @title = "Sign up"
    else
      flash[:notice] = "To sign up a new user, please sign out first."
      redirect_to(root_path)
    end
  end
  
  def create
    unless signed_in?
      @user = User.new(params[:user])
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to the Sample App!"
        redirect_to @user
      else
        @title = "Sign up"
        render 'new'
      end
    else
      flash.notice[:error] = "To sign up a new user, please sign out first."
      redirect_to(root_path)
    end
  end
  
  def edit
    @title = "Edit user"
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end 
  end
  
  def destroy
    user = User.find(params[:id])
    unless current_user?(user)
      name = user.name
      user.destroy
      flash[:success] = "User '#{name}' deleted."
      redirect_to users_path
    end
  end
  
  private
  
    def authenticate
      deny_access unless signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
