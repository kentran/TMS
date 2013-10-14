class UniversitiesController < ApplicationController
	load_and_authorize_resource

	def index
		@universities = University.all
	end

	def new
		@university = University.new
	end

	def create
		@university = University.new(params[:university])

		if @university.save
			record_activity("created univeristy: " + @university.id.to_s)
			redirect_to universities_path
		else
			render 'new'
		end
	end

	def show
		@university = University.find(params[:id])
		@departments = @university.departments
	end

	def edit
		@university = University.find(params[:id])
	end

	def update
		@university = University.find(params[:id])

		if @university.update_attributes(params[:university])
			record_activity("updated univerisity details: " + @university.id.to_s)
			redirect_to universities_path, :notice => "University updated successfully"
		else
			render 'edit'
		end
	end
end
