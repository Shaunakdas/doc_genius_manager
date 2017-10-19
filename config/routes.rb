Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users  do 
        collection do
          get 'users' => 'users#index'
          get 'first' => 'users#show'
        end
      end
    end
  end
end
