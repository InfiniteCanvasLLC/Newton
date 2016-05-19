Rails.application.routes.draw do
  resources :link_tos
  resources :events
  resources :parties
  resources :user_actions
  resources :questions
  resources :users

  post 'users/leave_group'
  post 'new_account/switch_party'
  post 'new_account/create_party'
  post 'new_account/edit_party'
  post 'new_account/leave_party'
  post 'new_account/join_party'
  post 'parties/unregister_event'

  get 'sessions/new'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'login_page#index'

  post 'login_page/submit_user_signup'
  post 'login_page/submit_user_feedback'
  
  post 'EnterAnswer' => 'new_account#enter_answer'

  get 'Home'     => 'new_account#home',       :as => :home
  get 'Calendar' => 'new_account#calendar',   :as => :calendar
  get 'Stats'    => 'new_account#stats',      :as => :stats
  get 'Party'    => 'new_account#party',      :as => :party_user_page
  get 'Feedback' => 'new_account#feedback',   :as => :feedback

  # Menu in the upper right hand part of the page (under user)
  get 'Profile'  => 'new_account#profile',    :as => :profile
  get 'Settings' => 'new_account#settings',   :as => :settings

  get '/action/handle_link_to' => 'new_account#handle_link_to', :as => :handle_link_to
  get '/auth/:provider/callback' => 'sessions#create'
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/signin' => 'sessions#new', :as => :signin

  get 'user_feedbacks' => 'user_feedbacks#index',   :as => :user_feedbacks
  
  get 'creatives/index'

  get 'administrator' => 'administrator#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
