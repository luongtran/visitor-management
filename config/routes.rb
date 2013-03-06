VisitorManagement::Application.routes.draw do
  
  root :to => 'dashboard#index'
  
  match '/welcome' => 'welcome#index', :as => 'welcome'
  
  match '/visitors/checkout' => 'visitors#visitor_checkout', :as => 'visitor_checkout'
  match '/visitors/twelve-plus' => 'visitors#twelve_plus', :as => 'twelve_plus'
  
  match '/visitors/search' => 'visitors#search', :as => 'visitor_search'
  
  resources :visitors
  
  match '/dashboard' => 'dashboard#index', :as => :dashboard_index
  match '/dashboard/view-options' => 'dashboard#view_options', :as => :dashboard_option_view

  #devise_for :users
  
  devise_for :user,:path => '',
             :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'secret', :confirmation => 'verification', :unlock => 'unblock', :sign_up => 'register' }

  
  resources :photos do
    post 'upload', :on => :collection
  end
  
  resources :me, :only => [:index, :edit] 
  
  match 'me/upload-logo' => 'me#upload_logo', :as => :upload_logo
  match 'me/change-password' => 'me#change_password', :as => 'change_password'
  match 'me/update' => "me#update", :as => 'me_update'
  match 'me/update-organisation' => "me#update_organisation", :as => 'update_organisation'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
