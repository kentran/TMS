class UsersController < Devise::RegistrationsController
  load_and_authorize_resource :only => [:index, :destroy, :create_new, :batch_create]

  def index
    @users = User.order("updated_at DESC").all
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
      if can? :read, User, :index => true
        redirect_to user_path, :notice => "User updated successfully"
      else
        redirect_to :back, :notice => "User updated successfully"
      end
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

  def search_prof
    # Search for email or name of professor
    term = "%#{params[:term]}%"
    @users = User.all(:conditions => ["(first_name LIKE ? OR last_name LIKE ? OR email LIKE ?) and role = ?", term, term, term, "professor"])

    # Return a JSON with "label" and "value" as key
    result = Array.new
    @users.each do |user| 
      label = user.first_name + " " + user.last_name + " - " + user.email
      item = Hash[ "label" => label, "value" => user.email ]
      result.push item
    end

    render :json => result
  end

  def search_collaborator
    # Search for email or name of collaborator
    projects = current_user.projects
    @users = Array.new
    projects.each do |project|
      project.users.each do |user|
        if user != current_user
          @users.push user
        end
      end
    end
    @users.push current_user

    # Return a JSON with "label" and "value" as key
    result = Array.new
    @users.each do |user| 
      label = user.first_name + " " + user.last_name + " - " + user.email
      item = Hash[ "label" => label, "value" => user.email ]
      result.push item
    end

    render :json => result
  end
  
end
