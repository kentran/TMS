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
        @projects = current_user.projects


        if student?
            if current_user.projects.empty?
                redirect_to new_user_project_path(current_user)
            else
                redirect_to project_path(@projects[0])
            end
        elsif professor?
        	redirect_to user_projects_path(current_user)
        elsif manager?
            redirect_to manager_home_path
        end
    end

    def about_us
    end

    def contact_us
    end

    def term_of_service
    end

    def privacy_policy
    end
end
