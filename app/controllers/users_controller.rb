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
      # Send an email notification to the user
      UserMailer.welcome_email(@user).deliver
      redirect_to add_user_path, :notice => "User created successfully"
    else
      render 'add'
    end
  end

  def batch_create
    email_list = params[:email_list].split
 
    email_list.each do |email|
      # Generate a password and create the user
      generated_password = Devise.friendly_token.first(8)
      user = User.new(:email => email, :password => generated_password, :role => params[:role])

      if user.save
        record_activity("created new user (batch): " + user.email)
        # Send an email with generated password to the user
        UserMailer.welcome_email(user).deliver
      else
        record_activity("Failed - created new user (batch): " + email)
      end
    end

    redirect_to users_path
  end

  def search
    # Search for email or name of professor
    term = "%#{params[:term]}%"
    @users = User.all(:conditions => ['(first_name LIKE ? OR last_name LIKE ? OR email LIKE ?) and role = ?', term, term, term, "professor"])

    # Return a JSON with "label" and "value" as key
    result = Array.new
    @users.each do |user| 
      label = user.email + " - " + user.first_name + " " + user.last_name
      item = Hash[ "label" => label, "value" => user.email ]
      result.push item
    end

    render :json => result
  end
  
end
