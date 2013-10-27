class ProjectsController < ApplicationController
  # Authorize the users before they can use the method in ProjectsController
  load_and_authorize_resource

  #
  # ProjectsController:index
  #
  # Handle GET request to route /users/:user_id/projects
  # This method will be used by professors
  # Parameters:
  #
  # Return all Project objects and all Students that are linked
  # to the professor by any projects to projects/index.html.erb
  #
  def index 
    # Get all projects
    @projects = current_user.projects
    
    # Get all the students
    @students = Array.new
    @projects.each do |project|
      project.users.each do |user|
        if user.role == 'Student'
          @students.push user
        end
      end
    end

    # Get all the files of the students, and professors file accordingly
    @student_files = Hash.new
    @my_files = Hash.new
    @students.each do |student|
      @student_files[student] = student.project_files.order("updated_at DESC").all(
        :conditions => ["project_files.primary = ?", 1])

      @my_files[student] = current_user.project_files.order("updated_at DESC").all(
        :conditions => ["project_files.project_id = ?", student.projects[0].id])
    end
  end

  #
  # ProjectsController:manager_index
  #
  # Handle GET request to route /manage_projects
  # This method will be used by managers
  # Parameters:
  #
  # Return all Department objects and all Students that belongs
  # to the departments projects/manager_index.html.erb
  #
  def manager_index 
    # Get all departments
    @university = current_user.university
    @departments = @university.departments

    # Create a hash with key is department and value is all students object
    @department_students = Hash.new
    @departments.each do |department|
      @department_students[department] = Array.new
      department.users.each do |user|
        if user.role == 'Student'
          @department_students[department].push user
        end
      end
    end
  end

  #
  # ProjectsController:new
  #
  # Handle GET request to route /users/:user_id/projects/new
  # This method will be used by the super admin or students
  # Parameters: user_id
  #
  # Return a new Project object to projects/new.html.erb
  #
  def new
    @project = current_user.projects.build
  end

  #
  # ProjectsController:create
  #
  # Handle POST request to route /users/:user_id/projects
  # This method will be used by the students
  # Parameters: project[]
  #
  # Create a new Project and redirect to the home page of according user
  #
  def create
    @project = current_user.projects.create(params[:project])
    
    if @project.save
      record_activity("created new project: " + @project.id.to_s)
      redirect_to root_path, :notice => "Project created successfully"
    else
      render 'new'
    end
  end

  #
  # ProjectsController:edit
  #
  # Handle GET request to route /projects/:id/edit
  # This method will be used by the students
  # Parameters: id (project id)
  #
  # Return a Project object specified by id to projects/edit.html.erb
  #
  def edit
    @project = current_user.projects.find(params[:id])
  end

  #
  # ProjectsController:update
  #
  # Handle PUT request to route /projects/:id
  # This method will be used by the students
  # Parameters: project[]
  #
  # update Project information and redirect to /projects/:id
  #
  def update
    @project = current_user.projects.find(params[:id])

    if @project.update_attributes(params[:project])
      record_activity("updated project details: " + @project.id.to_s)
      redirect_to @project
    else
      render 'edit'
    end
  end

  #
  # ProjectsController:show
  #
  # Handle GET request to route /projects/:id
  # This is the home page for students
  # Parameters: id (project id)
  #
  # Return a Project object specified by id and its file to projects/show.html.erb
  #
  def show
    @project = current_user.projects.find(params[:id])
    @project_files = @project.project_files.order("updated_at DESC").all
    @project_references = @project.project_references.all
    @supervisors = @project.users.all(:conditions => ['role = ?', 'professor'])

    @my_files = current_user.project_files.order("updated_at DESC").all
    @file_groups = Hash.new
    @project.users.each do |user|
      # Get the file of all professors if current user is a student
      # or get the file of the student when current user is a professor
      if (user != current_user && student?) || (user != current_user && professor? && user.role != 'Professor')                                     
        @file_groups[user] = user.project_files.order("updated_at DESC").all(
          :conditions => ["project_files.primary = ? AND project_files.project_id = ?", true, @project.id])               
      end
    end
  end

  #
  # ProjectsController:create
  #
  # Handle POST request to route /projects/:id
  # Parameters: id (project id), file
  #
  # Upload the file to the server and record it in the database
  #
  def upload
    @project = current_user.projects.find(params[:id])

    uploaded_io = params[:file]
    if uploaded_io == nil 
      render 'show', :alert => "File fails to upload"
    end 

    file_name = Time.now.to_i.to_s + "_" + uploaded_io.original_filename    # Attach the timestamp to avoid overwriting old files
    file_path = Rails.public_path + "/uploads/" + file_name
    File.open(file_path, 'wb') do |file|
      file.write(uploaded_io.read)
    end 

    @project_file = ProjectFile.new( :file_name => file_name, 
      :file_path => file_path, 
      :user_id => params[:user_id], 
      :project_id => params[:project_id],
      :original_file_name => uploaded_io.original_filename)

    if @project_file.save
      record_activity("uploaded " + file_name)
      redirect_to :back, :notice => "File uploaded successfully"
    else
      record_activity("upload failed " + file_name)
      render 'show', :alert => "File info is failed to save"
    end 
  end 

  #
  # ProjectsController:download
  #
  # Handle GET request to route /download
  # Parameters: file_name
  #
  # Download the file from the server to local computer
  #
  def download
    record_activity("downloaded " + params[:file_name])
    send_file Rails.root.join('public', 'uploads', params[:file_name])
  end 

  #
  # ProjectsController:add_collaborator
  #
  # Handle POST request to route /projects/:id/add_collaborator
  # This method will be used by the students
  # Parameters: id (project id), (string) collaborator 
  #
  # Find the user object with the email address specified by collaborator
  # and attach it to the project
  #
  def add_collaborator
    @project = current_user.projects.find(params[:id])
    @collaborator = User.find_by_email(params[:collaborator])
    @project.users << @collaborator

    if @project.save
      record_activity("added supervisor " + params[:collaborator])
      redirect_to project_path(@project), :notice => "Supervisor is added successfully"
    else
      record_activity("error occured when added supervisor " + params[:collaborator])
      redirect_to project_path(@project), :alert => "Supervisor is already added"
    end
  end

  #
  # ProjectsController:remove_collaborator
  #
  # Handle DELETE request to route /projects/:id/remove_collaborator/:collaborator_id
  # This method will be used by the students
  # Parameters: id (project id), collaborator_id
  #
  # Detach the user from the project. The user object is left intact
  #
  def remove_collaborator
    @project = current_user.projects.find(params[:id])
    @collaborator = User.find(params[:collaborator_id])
    @project.users.delete(@collaborator)

    redirect_to project_path(@project), :alert => "Supervisor is deleted successfully"
  end

end
