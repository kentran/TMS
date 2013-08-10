class HomeController < ApplicationController
  def index
    @projects = current_user.projects.find(:all)
  end
end
