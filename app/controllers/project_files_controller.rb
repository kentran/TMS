class ProjectFilesController < ApplicationController

	#
	# ProjectFilesController:destroy
	#
	# Handle DELETE request to route /project_files/:id
	# Parameters: id (id of the file)
	#
	# Delete the file from the project and from the database
	# Redirect to previous page when done
	#
	def destroy
		@project_file = ProjectFile.find(params[:id])
		@project_file.destroy

		record_activity("deleted file " + @project_file.file_name + " in project id " + @project_file.project_id.to_s)
		redirect_to :back, :alert => "File deleted"
	end 

	#
	# ProjectFilesController:destroy
	#
	# Handle PUT request (AJAX) to route /project_files/:id
	# Parameters: id (id of the file)
	#
	# Toggle the attribute "primary" in the ProjectFile object
	# Return result as JSON for AJAX handling
	#
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
