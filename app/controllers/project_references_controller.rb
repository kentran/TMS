class ProjectReferencesController < ApplicationController
  load_and_authorize_resource

  #
  # ProjectReferencesController:create
  #
  # Handle POST request (AJAX) to route /projects/:project_id/project_references
  # Parameters: project_id
  #
  # Create a ProjectReference object and return it in JSON format for AJAX handling
  #
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
  
  #
  # ProjectReferencesController:edit
  #
  # Handle GET request (AJAX) to route /project_references/:id
  # Parameters: id (project reference id)
  #
  # Return a ProjectReference object specified by id in JSON format for AJAX handling
  #
  def edit
    @project_reference = ProjectReference.find(params[:id])
    
    respond_to do |format|
      format.js {}
      format.json { render json: @project_reference }
    end
  end
  
  #
  # ProjectReferencesController:update
  #
  # Handle PUT request (AJAX) to route /project_references/:id
  # Parameters: id (project reference id)
  #
  # Update the ProjectReference information specified by id parameter
  # Return the object in JSON format for AJAX handling
  #
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
  
  #
  # ProjectReferencesController:destroy
  #
  # Handle DELETE request to route /project_references/:id
  # Parameters: id (project reference id)
  #
  # Delete the ProjectReference object specified by id parameter
  # Redirect to the previous page
  #
  def destroy
    @project_reference = ProjectReference.find(params[:id])
    @project_reference.destroy
    
    redirect_to :back, :alert => "Reference deleted"
  end
end
