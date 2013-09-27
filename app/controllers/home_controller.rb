class HomeController < ApplicationController
  def index
    @projects = current_user.projects.find(:all)

    if @projects.count == 1
    	redirect_to project_path(@projects[0])
    end
  end
end
