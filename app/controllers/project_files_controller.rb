class ProjectFilesController < ApplicationController
	def destroy
		@project_file = ProjectFile.find(params[:id])
		@project_file.destroy

		record_activity("deleted file " + @project_file.file_name + " in project id " + @project_file.project_id.to_s)
		redirect_to :back, :alert => "File deleted"
	end 

	# Toggle the primary attribute of the file
	def update
		@project_file = ProjectFile.find(params[:id])
		if @project_file.primary == false
			@project_file.update_attributes(:primary => true)
		else
			@project_file.update_attributes(:primary => false)
		end

		respond_to do |format|
			format.js {}
			format.json { render json: @project_file}
		end
	end
end
