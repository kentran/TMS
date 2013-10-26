class HomeController < ApplicationController

    #
    # HomeController:index
    #
    # Handle GET request to route /home/index
    # Parameters: 
    #
    # Redirect the user to correct home page based on who they are
    # Student to the project main page
    # Professor to the project index page
    #
    def index
        @projects = current_user.projects.find(:all)

        if @projects.count == 1
        	redirect_to project_path(@projects[0])
        elsif student?
        	redirect_to new_user_project_path(current_user)
        elsif professor?
        	redirect_to user_projects_path(current_user)
        elsif manager?
            redirect_to manager_home_path
        end
    end
end
