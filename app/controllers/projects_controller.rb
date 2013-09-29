class ProjectsController < ApplicationController
  load_and_authorize_resource

  def new
    @project = current_user.projects.build
  end

  def create
    @project = current_user.projects.create(params[:project])
    
    if @project.save
      record_activity("created new project: " + @project.id.to_s)
      redirect_to root_path, :notice => "Project created successfully"
    else
      render 'new'
    end
  end

  def edit
    @project = current_user.projects.find(params[:id])
  end

  def update
    @project = current_user.projects.find(params[:id])

    if @project.update_attributes(params[:project])
      record_activity("updated project details: " + @project.id.to_s)
      redirect_to @project
    else
      render 'edit'
    end
  end

  def show
    @project = current_user.projects.find(params[:id])
    @project_files = @project.project_files.order("updated_at DESC").all
    @project_references = @project.project_references.all
    @supervisors = @project.users.all(:conditions => ['role = ?', 'professor'])
  end

  def upload
    @project = current_user.projects.find(params[:id])

    uploaded_io = params[:file]
    if uploaded_io == nil 
      render 'show', :alert => "File fails to upload"
    end 

    file_name = Time.now.to_i.to_s + "_" + uploaded_io.original_filename
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
      redirect_to project_path(@project), :notice => "File uploaded successfully"
    else
      record_activity("upload failed " + file_name)
      render 'show', :alert => "File info is failed to save"
    end 
  end 

  def download
    record_activity("downloaded " + params[:file_name])
    send_file Rails.root.join('public', 'uploads', params[:file_name])
  end 

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

  def remove_collaborator
    @project = current_user.projects.find(params[:id])
    @collaborator = User.find(params[:collaborator_id])
    @project.users.delete(@collaborator)

    redirect_to project_path(@project), :alert => "Supervisor is added successfully"
  end

end
