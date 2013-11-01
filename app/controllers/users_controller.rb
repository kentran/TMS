class UsersController < Devise::RegistrationsController
  # Authorize the user for some certain action in this controller
  load_and_authorize_resource :only => [:index, :destroy, :create_new, :batch_create]

  #
  # UsersController:index
  #
  # Handle GET request to route /users
  # Parameters:
  #
  # Return all User objects to users/index.html.erb
  #
  def index
    if admin?
      @users = User.order("updated_at DESC").all
    else
      @users = current_user.university.users
    end
  end

  #
  # UsersController:add
  #
  # Handle GET request to route /users/add
  # Parameters:
  #
  # Return a new User object to users/add.html.erb
  #
  def add
    @user = User.new
  end

  #
  # UsersController:show
  #
  # Handle GET request to route /users/:id
  # Parameters: id (user id)
  #
  # Return a User object specified by id parameter to users/show.html.erb
  #
  def show
    @user = User.find(params[:id])
  end

  #
  # UsersController:edit
  #
  # Handle GET request to route /users/:id/edit
  # Parameters: id (user id)
  #
  # Return a User object specified by id parameter to users/edit.html.erb
  #
  def edit
    @user = User.find(params[:id])
  end

  #
  # UsersController:update
  #
  # Handle PUT request to route /users/:id
  # Parameters: id (user id)
  #
  # Update the user information and redirect to /users if possible,
  # else return to previous page
  #
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      # Attach the user to according university and department
      # If there is any university update
      if params[:university]
        @university = University.find(params[:university])
        #@department = Department.find(params[:department])
        @university.users << @user
        #@department.users << @user
      end

      record_activity("updated user details: " + @user.id.to_s)
      if can? :read, User, :index => true                                   # redirect to user index page if current_user
        redirect_to user_path, :notice => "User updated successfully"       # has permission to view it
      else
        redirect_to :back, :notice => "User updated successfully"
      end
    else
      render 'edit'
    end
  end

  #
  # UsersController:destroy
  #
  # Handle DELETE request to route /users/:id
  # Parameters: id (user id)
  #
  # Delete the user object specified by id parameter and redirect to /users
  #
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    record_activity("deleted user: " + @user.email)
    redirect_to users_path, :notice => "User deleted"
  end

  #
  # UsersController:create_new
  #
  # Handle POST request to route /users
  # Parameters: user[]
  #
  # Create a new user object and redirect to /users/add
  # Send an email notification to the newly created user
  #
  def create_new
    @user = User.new(params[:user])
    @university = University.find(params[:university])
    
    if @user.save
      @university.users << @user
      record_activity("created new user: " + @user.email)
      # Send an email notification to the user
      UserMailer.welcome_email(@user).deliver
      redirect_to add_user_path, :notice => "User created successfully"
    else
      render 'add'
    end
  end

  #
  # UsersController:batch_create
  #
  # Handle POST request to route /users/import_users
  # Parameters: email_list
  #
  # Create a batch of new users according to the email_list received
  # Send an email notification to the newly created users
  #
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

  #
  # UsersController:search_prof
  #
  # Handle GET request (AJAX) to route /users/search_prof
  # Parameters: term (a string)
  #
  # Return a json of the users that have first name, last name or email
  # match the search term. The result will be handle by JQueryUI autocomplete
  #
  def search_prof
    # Search for email or name of professor
    term = "%#{params[:term]}%"
    @users = User.all(:conditions => ["(LOWER(first_name) LIKE LOWER(?) OR LOWER(last_name) LIKE LOWER(?) OR LOWER(email) LIKE LOWER(?)) AND role = ?", term, term, term, "Professor"])

    # Return a JSON with "label" and "value" as key required by JQUeryUI autocomplete
    result = Array.new
    @users.each do |user| 
      label = user.first_name + " " + user.last_name + " - " + user.email
      item = Hash[ "label" => label, "value" => user.email ]
      result.push item
    end

    render :json => result
  end

  #
  # UsersController:search_collaborator
  #
  # Handle GET request (AJAX) to route /users/search_collaborator
  # Parameters: 
  #
  # Return a json of the users that are connected through one or more projects.
  # If the user is a manager, get all users in the univeristy
  # The result will be handle by JQueryUI autocomplete
  #
  def search_collaborator
    # Search for email or name of collaborator
    projects = current_user.projects
    @users = Array.new
    projects.each do |project|
      project.users.each do |user|
        unless @users.include? user
          @users.push user
        end
      end
    end

    # Get all users if current user is a manager
    if manager?
      @users = current_user.university.users
    end

    # Return a JSON with "label" and "value" as key required by JQueryUI autocomplete
    result = Array.new
    @users.each do |user| 
      label = user.first_name + " " + user.last_name + " - " + user.email
      item = Hash[ "label" => label, "value" => user.email ]
      result.push item
    end

    render :json => result
  end
  
end
