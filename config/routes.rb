Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users  do 
        collection do
          get 'users' => 'users#index'
          get 'first' => 'users#show'
          # Users
          # Get Users List using search, filter and pagination. Req: (Admin Auth token, Role, Standard, Region, TargetExam, Query, Board, Page, Limit). Response: (User Array)
          get "users" => "users#index"
          # Create User. Req: (Admin Auth token, Name, Email, Username, Mobile, OAuth/Password, Age). Response: (Auth token)
          post "users" => "users#create"
          # Get User Details. Req: (Admin Auth token, id, login)
          get "user/:id" => "users#details"
          # Get User Details. Req: (Auth token)
          get "user/me" => "users#me"
          # Updates User Details. Req: (Auth token)
          put "user/:id" => "users#update"
          # User Invite . Create User
          post "user/invite" => "users#invite"
          # Image Upload(Will take username or email)
          post "photo/profile" => "users#photo_upload"
          # Delete User Req: (Admin AuthToken, User Id)
          delete "user/:id" => "users#delete"
        end
      end
      resources :login  do 
        collection do
          # Login
          # Sign up User. Req: (Name, Email, Username, Mobile, OAuth/Password, Age). Response: ()
          post "sign_up" => "login#sign_up"
          # Login User. Req: (Login(Email/Username/Mobile), OAuth/Password). Response: (Auth token)
          post "login" => "login#login"
          # Logout User. Req: (Auth token). Response: ()
          post "logout" => "login#logout"
          # Activate User by verifying OTP. Req: (Login, OTP). Response: ()
          post "activate" => "login#activate"
        end
      end
      resources :passwords  do 
        collection do
          # Passwords
          # Forgot Password. Req: (Login). Response: ()
          post "password/forgot" => "passwords#forgot"
          # Reset Password. Req: (Username, OTP). Response: ()
          get "password/reset" => "passwords#reset"
          # Modify Password. Req: (Login, New Password). Response: (Auth Token)
          put "password/modify" => "passwords#modify"
        end
      end
    end
  end
end
  
  


