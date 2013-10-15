class DepartmentsController < ApplicationController
	def index
		@university = University.find(params[:university_id])
		@departments = @university.departments
	end

	def new
		@university = University.find(params[:university_id])
		@department = @university.departments.build
	end

	def create
		@university = University.find(params[:university_id])
		@department = @university.departments.create(params[:department])
		redirect_to university_departments_path(@university)
	end

	def show
		@university = University.find(params[:university_id])
		@department = @university.departments.find(params[:id])
		@departments = @university.departments
	end

	def edit
		@university = University.find(params[:university_id])
		@department = @university.departments.find(params[:id])
	end

	def update
		@university = University.find(params[:university_id])
		@department = @university.departments.find(params[:id])
		@department.update_attributes(params[:department])
		redirect_to university_departments_path(@university)
	end

	def destroy
		@university = University.find(params[:university_id])
		@department = @university.departments.find(params[:id])
		@department.destroy
		redirect_to university_path(@university)
	end
end
