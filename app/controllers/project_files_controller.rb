class ProjectFilesController < ApplicationController
  def destroy
    @project_file = ProjectFile.find(params[:id])
    @project_file.destroy

    redirect_to :back, :alert => "File deleted"
  end 
end
