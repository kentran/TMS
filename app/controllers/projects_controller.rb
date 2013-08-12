class ProjectsController < ApplicationController
  def new
    @project = Project.new
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

    if @project.update(params[:project])
      record_activity("updated project details: " + @project.id.to_s)
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def show
    @project = current_user.projects.find(params[:id])
    @project_files = @project.project_files.all
  end

  def upload
    @project = current_user.projects.find(params[:id])

    uploaded_io = params[:file]
    if uploaded_io == nil 
      render 'show', :alert => "File fails to upload"
    end 

    file_path = Rails.public_path + "/uploads/" + uploaded_io.original_filename
    File.open(file_path, 'wb') do |file|
      file.write(uploaded_io.read)
    end 

    @project_file = ProjectFile.new( :file_name => uploaded_io.original_filename, :file_path => file_path, :user_id => params[:user_id], :project_id => params[:project_id])
    if @project_file.save
      record_activity("uploaded " + uploaded_io.original_filename)
      redirect_to user_project_path(@project), :notice => "File uploaded successfully"
    else
      record_activity("upload failed " + uploaded_io.original_filename)
      render 'show', :alert => "File info is failed to save"
    end 
  end 

  def download
    record_activity("downloaded " + params[:file_name])
    send_file Rails.root.join('public', 'uploads', params[:file_name])
  end 

end
