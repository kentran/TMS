class HomeController < ApplicationController
  def index
    @projects = current_user.projects.find(:all)

    if @projects.count == 1
    	redirect_to project_path(@projects[0])
    elsif student?
    	redirect_to new_user_project_path(current_user)
    elsif professor?
    	redirect_to user_projects_path(current_user)
    end
  end
end
