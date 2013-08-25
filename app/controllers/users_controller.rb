class UsersController < Devise::RegistrationsController
  load_and_authorize_resource

  def index
    @users = User.all
  end

  def add
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      record_activity("updated user details: " + @user.id.to_s)
      redirect_to user_path
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    record_activity("deleted user: " + @user.email)
    redirect_to users_path, :notice => "User deleted"
  end

  def create_new
    @user = User.new(params[:user])
    
    if @user.save
      record_activity("created new user: " + @user.email)
      UserMailer.welcome_email(@user).deliver
      redirect_to add_user_path, :notice => "User created successfully"
    else
      render 'add'
    end
  end

  def batch_create
    email_list = params[:email_list].split
 
    email_list.each do |email|
      generated_password = Devise.friendly_token.first(8)
      user = User.new(:email => email, :password => generated_password, :role => params[:role])

      if user.save
        record_activity("created new user (batch): " + user.email)
        UserMailer.welcome_email(user).deliver
      else
        record_activity("Failed - created new user (batch): " + email)
      end
    end

    redirect_to users_path
  end
  
end
