class DepartmentsController < ApplicationController
	load_and_authorize_resource

	#
	# DepartmentsController:index
	#
	# Handle GET request to route /universities/:university_id/departments
	# Parameters: university_id
	#
	# Return the University object and all Department objects that
	# belong to the university to departments/index.html.erb
	#
	def index
		@university = University.find(params[:university_id])
		@departments = @university.departments
	end

	#
	# DepartmentsController:new
	#
	# Handle GET request to route /universities/:university_id/departments/new
	# Parameters: university_id
	#
	# Return the University object and a new Department object that
	# belongs to the university to departments/new.html.erb
	#
	def new
		@university = University.find(params[:university_id])
		@department = @university.departments.build
	end

	#
	# DepartmentsController:create
	#
	# Handle POST request to route /universities/:university_id/departments
	# Parameters: university_id, department[]
	#
	# Create the new department and redirect to /universities/:university_id/departments
	#
	def create
		@university = University.find(params[:university_id])
		@department = @university.departments.create(params[:department])
		redirect_to university_departments_path(@university)
	end

	#
	# DepartmentsController:show
	#
	# Handle GET request to route /universities/:university_id/departments/:id
	# Parameters: university_id, id (department id)
	#
	# Return the University object, a Department object that
	# belongs to the university, specified by id parameter and all other
	# Department objects to departments/show.html.erb
	#
	def show
		@university = University.find(params[:university_id])
		@department = @university.departments.find(params[:id])
		@departments = @university.departments
	end

	#
	# DepartmentsController:edit
	#
	# Handle GET request to route /universities/:university_id/departments/:id/edit
	# Parameters: university_id, id (department id)
	#
	# Return the University object and a Department object that
	# belongs to the university, specified by id parameter to departments/edit.html.erb
	#
	def edit
		@university = University.find(params[:university_id])
		@department = @university.departments.find(params[:id])
	end

	#
	# DepartmentsController:update
	#
	# Handle PUT request to route /universities/:university_id/departments/:id
	# Parameters: university_id, id (department id), department[]
	#
	# Update the department information and redirect to /universities/:university_id/departments
	#
	def update
		@university = University.find(params[:university_id])
		@department = @university.departments.find(params[:id])
		@department.update_attributes(params[:department])
		redirect_to university_departments_path(@university)
	end

	#
	# DepartmentsController:destroy
	#
	# Handle PUT request to route /universities/:university_id/departments/:id
	# Parameters: university_id, id (department id)
	#
	# destroy the department object and redirect to /universities/:university_id/departments
	#
	def destroy
		@university = University.find(params[:university_id])
		@department = @university.departments.find(params[:id])
		@department.destroy
		redirect_to university_departments_path(@university)
	end
end
