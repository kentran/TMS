class ProjectFilesController < ApplicationController
  def destroy
    @project_file = ProjectFile.find(params[:id])
    @project_file.destroy

    record_activity("deleted file " + @project_file.file_name + " in project id " + @project_file.project_id.to_s)
    redirect_to :back, :alert => "File deleted"
  end 
end
