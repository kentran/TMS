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
    elsif user.role == 'Professor'
      can :read, Project
      can :read, ProjectReference
      can :download, Project
      can :upload, Project
      cannot :destroy, Project
      cannot :read, User, :index => true
      can :search_collaborator, User
      can :update, User
    elsif user.role == 'Manager'
      can :read, :all
      can :edit, User
      can :destroy, User
      can :add, User
      can :create_new, User
      can :batch_create, User
      can :manage, Department
    end

  end
end
