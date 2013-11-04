Tms::Application.routes.draw do
  devise_for :users, :path => 'accounts'

  devise_scope :user do
    get "/users" => "users#index", :as => "users"
    get "/users/add" => "users#add", :as => "add_user"
    get "/users/import_users" => "users#import", :as => "import_users"
    get "/users/:id" => "users#show", :as => "user"
    get "/users/:id/edit" => "users#edit"
    put "/users/:id" => "users#update"
    post "/users" => "users#create_new"
    delete "/users/:id" => "users#destroy"
    post "/users/import_users" => "users#batch_create"
    get "/search_prof" => "users#search_prof"
    get "/search_collaborator" => "users#search_collaborator"
  end

  resources :universities do
    resources :departments
  end

  resources :users, shallow: true do 
    resources :projects, shallow: true do
      resources :project_references
      resources :project_files
    end

    resources :reminders
  end

  get "/users/:user_id/new_notifications" => "notifications#index_new", :as => "user_new_notifications"
  get "/users/:user_id/notifications" => "notifications#index", :as => "user_notifications"
  post "/projects/:project_id/notifications" => "notifications#create", :as => "project_notifications"

  get "/manage_projects" => "projects#manager_index", :as => "manager_home"
  get "/download" => "projects#download"
  post "/projects/:id" => "projects#upload", :as => "file_upload"
  delete "/project_files/:id" => "project_files#destroy", :as => "project_file"

  post "/projects/:id/add_collaborator" => "projects#add_collaborator", :as => "add_collaborator"
  delete "projects/:id/remove_collaborator/:collaborator_id" => "projects#remove_collaborator"

  get "/about_us" => "home#about_us"
  get "/contact_us" => "home#contact_us"
  get "/term_of_service" => "home#term_of_service"
  get "/privacy_policy" => "home#privacy_policy"
  get "home/index"
  root :to => "home#index"

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

end
