Rails.application.routes.draw do

  resources :locations
  resources :messages
  resources :games do
    resources :announces do
      get 'mark_announcement_as_read' => 'announces#mark_announcement_as_read', as: :mark_announcement_as_read
    end
  end
  resources :users do
    resources :announces do
      get 'mark_announcement_as_read' => 'announces#mark_announcement_as_read', as: :mark_announcement_as_read
    end
  end
  resources :teams do
    resources :announces do
      get 'mark_announcement_as_read' => 'announces#mark_announcement_as_read', as: :mark_announcement_as_read
    end
  end
  resources :tournaments do
    resources :announces do
      get 'mark_announcement_as_read' => 'announces#mark_announcement_as_read', as: :mark_announcement_as_read
    end
  end
  resources :leagues do
    resources :announces do
      get 'mark_announcement_as_read' => 'announces#mark_announcement_as_read', as: :mark_announcement_as_read
    end
  end
  resources :announces do
    get 'mark_announcement_as_read' => 'announces#mark_announcement_as_read', as: :mark_announcement_as_read
  end
  resources :user_sessions
  resources :players
  resources :referees

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  get 'user_session/destroy' => 'user_sessions#destroy', as: :logout

  get 'user_session/new' => 'user_sessions#new', as: :login
  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  get 'listallteams' => 'teams#all', as: :all_teams

  get 'listallplayers' => 'players#all', as: :all_players

  post 'team/clone' => 'teams#clone', as: :clone_team

  post 'player/clone' => 'player_participants#create', as: :player_participants

  get 'landing' => 'welcome#landing', as: :landing

  get 'volunteer' => 'tournaments#volunteer', as: :volunteer

  get 'announce/:id' => 'announces#mark_announcement_as_read', as: :mark_announcement_as_read


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
