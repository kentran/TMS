class ProjectsController < ApplicationController
  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.create(params[:project])
    
    if @project.save
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
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def show
    @project = current_user.projects.find(params[:id])
  end
end
