class ProjectReferencesController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    @project_reference = @project.project_references.create(params[:project_reference])
      
    respond_to do |format|
      if @project_reference.save
        format.js {}
        format.json { render json: @project_reference, status: :created }
      else
        format.json { render json: @project_reference.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
    @project_reference = ProjectReference.find(params[:id])
    
    respond_to do |format|
      format.js {}
      format.json { render json: @project_reference }
    end
  end
  
  def update
    @project_reference = ProjectReference.find(params[:id])
    
    respond_to do |format|
      if (@project_reference.update_attributes(params[:project_reference]))
        format.js {}
        format.json { render json: @project_reference, status: :updated }
      else
        format.json { render json: @project_reference.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @project_reference = ProjectReference.find(params[:id])
    @project_reference.destroy
    
    redirect_to :back, :alert => "Reference deleted"
  end
end
