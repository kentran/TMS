class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role == 'Admin'
      can :manage, :all
      can :assign_super_admin, User
    elsif user.role == 'Student'
      can :manage, Project
      can :manage, ProjectReference
      cannot :destroy, Project
      unless user.projects.empty?
        cannot :create, Project
      end
      can :read, Department
    elsif user.role == 'Professor'
      can :read, Project
      can :read, ProjectReference
      can :download, Project
      can :upload, Project
      cannot :destroy, Project
      cannot :read, User, :index => true
      can :search_collaborator, User
      can :update, User
      can :read, Department
    elsif user.role == 'Manager'
      can :read, :all
      cannot :read, University
      can :manage, User
      cannot :assign_super_admin, User
      can :manage, Department
      can :manager_index, Project
      can :download, Project
    end

  end
end
