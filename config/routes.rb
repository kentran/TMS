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

  resources :users, shallow: true do 
    resources :projects, shallow: true do
      resources :project_references
      resources :notifications
    end

    resources :reminders
  end

  get "/download" => "projects#download"
  post "/projects/:id" => "projects#upload"
  delete "/project_files/:id" => "project_files#destroy", :as => "project_file"

  post "/projects/:id/add_collaborator" => "projects#add_collaborator", :as => "add_collaborator"
  delete "projects/:id/remove_collaborator/:collaborator_id" => "projects#remove_collaborator"

  get "home/index"
  root :to => "home#index"

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

end
