class UniversitiesController < ApplicationController
	load_and_authorize_resource

	#
	# UniversitiesController:index
	#
	# Handle GET request to route /universities
	# Parameters: 
	#
	# Return all University objects to universities/index.html.erb
	#
	def index
		@universities = University.all
	end

	#
	# UniversitiesController:new
	#
	# Handle GET request to route /universities/new
	# Parameters: 
	#
	# Return a new University object to universities/new.html.erb
	#
	def new
		@university = University.new
	end

	#
	# UniversitiesController:create
	#
	# Handle POST request to route /universities
	# Parameters: university[]
	#
	# Create a new University object and redirect to /universities
	#
	def create
		@university = University.new(params[:university])

		if @university.save
			record_activity("created univeristy: " + @university.id.to_s)
			redirect_to universities_path
		else
			render 'new'
		end
	end

	#
	# UniversitiesController:show
	#
	# Handle GET request to route /universities/:id
	# Parameters: id (university id)
	#
	# Return a new University object, specified by id to universities/show.html.erb
	#
	def show
		@university = University.find(params[:id])
	end

	#
	# UniversitiesController:edit
	#
	# Handle GET request to route /universities/:id/edit
	# Parameters: id (university id)
	#
	# Return a new University object, specified by id to universities/edit.html.erb
	#
	def edit
		@university = University.find(params[:id])
	end

	#
	# UniversitiesController:update
	#
	# Handle PUT request to route /universities
	# Parameters: id (university id), university[]
	#
	# Update University object and redirect to /universities
	#
	def update
		@university = University.find(params[:id])

		if @university.update_attributes(params[:university])
			record_activity("updated univerisity details: " + @university.id.to_s)
			redirect_to universities_path, :notice => "University updated successfully"
		else
			render 'edit'
		end
	end

	#
	# UniversitiesController:destroy
	#
	# Handle DELETE request to route /universities
	# Parameters: id (university id)
	#
	# Delete a new University object, specified by id and redirect to /universities
	#
	def destroy
		@university = University.find(params[:id])
		@university.destroy
		redirect_to universities_path
	end
end
