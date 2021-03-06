Feedbacker::Application.routes.draw do
  
  resources :announcements

  resources :people

  resources :key_datas

  resource :chat_messages

  resources :clients

  resources :hours do
     get :autocomplete_project_name, :on => :collection
  end

  resources :work_categories

  resources :images do
    resources :comments
    resources :surveys do
        resources :questions do
            resources :answers 
        end
    end
  end

  resources :surveys
  
  resources :answers

  resources :assignments

  resources :projects do
    resources :plan_hours
    resources :user_plan_hours
    resources :fixed_costs
  end

  get "home/index"
  
  match 'add_plan_hour' => 'plan_hours#new', :as => :add_plan_hour
  
  match 'comments' => 'comments#new', :as => :comments
  
  match 'accounting' => 'key_datas#index', :as => :accounting
  
  match 'chat'  =>  'chat_messages#index', :as => :chat

  match 'signup' => 'users#new', :as => :signup

  match 'logout' => 'sessions#destroy', :as => :logout

  match 'login' => 'sessions#new', :as => :login  
  
  match 'get_user_hours' =>  'hours#show_xml', :as => :get_user_hours
  
  match 'hour_list' =>  'hours#list', :as => :hour_list
  
  match 'hide_announcement' => 'javascripts#hide_announcement', :as => :hide_announcement

  resources :sessions

  resources :users

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
  root :to => "home#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
