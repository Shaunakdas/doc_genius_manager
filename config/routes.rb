Rails.application.routes.draw do

  devise_for :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do

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
      
      # resources :users  do 
      #   collection do
      #     get 'users' => 'users#index'
      #     get 'first' => 'users#show'
          
      #   end
      # end

      # Standards
      # Get Standards List using search, filter and pagination. Req: (Auth token, Role, Standard, Region, TargetExam, Query, Board, Page, Limit). Response: (Standard Array)
      get "standards" => "standards#index"
      # Create Standard. Req: (Auth token, Name, Email, Standardname, Mobile, OAuth/Password, Age). Response: (Auth token)
      post "standards" => "standards#create"
      # Get Standard Details. Req: (Auth token, id, login)
      get "standard/:id" => "standards#details"
      # Updates Standard Details. Req: (Auth token)
      put "standard/:id" => "standards#update"
      # Delete Standard Req: (Admin AuthToken, User Id)
      delete "standard/:id" => "standards#delete"
      # HomePage Req: (Admin AuthToken)
      get "homepage" => "standards#homepage"

      # resources :standards  do 
      #   collection do
      #   end
      # end



      # QuestionType
      # Get QuestionType List using search, filter and pagination. Req: (Auth token, Role, QuestionType, Region, TargetExam, Query, Board, Page, Limit). Response: (QuestionType Array)
      get "question_types" => "question_types#index"
      # Create QuestionType. Req: (Auth token, Name, Email, QuestionTypename, Mobile, OAuth/Password, Age). Response: (Auth token)
      post "question_types" => "question_types#create"
      # Get QuestionType Details. Req: (Auth token, id, login)
      get "question_type/:id" => "question_types#details"
      # Updates QuestionType Details. Req: (Auth token)
      put "question_type/:id" => "question_types#update"
      # Delete QuestionType Req: (Admin AuthToken, User Id)
      delete "question_type/:id" => "question_types#delete"
      # HomePage Req: (Admin AuthToken)
      get "question_type/:id" => "question_types#show"

      # GameSession
      # Get GameSession List using search, filter and pagination. Req: (Auth token, Role, GameSession, Region, TargetExam, Query, Board, Page, Limit). Response: (GameSession Array)
      get "game_sessions" => "game_sessions#index"
      # Create GameSession. Req: (Auth token, Name, Email, GameSessionname, Mobile, OAuth/Password, Age). Response: (Auth token)
      post "game_sessions" => "game_sessions#create"
      # Get GameSession Details. Req: (Auth token, id, login)
      get "game_session/:id" => "game_sessions#details"
      
      # Registrations
      # Sign up User by Number. Req: (Mobile  Number, Password). Response: (Auth Token)
      # post "registrations/sign_up_number" => "registrations#sign_up_number"
      post "sign_up/email" => "registrations#sign_up_email"
      # Activate User by verifying OTP. Req: (Number, OTP). Response: (Auth Token)
      post "activate" => "registrations#activate"
      # Fill User Details. Req: (Auth Token, First Name, Last Name, Date of birth, Sex, EMail, First Time). Response: (Success)
      put "fill_form" => "registrations#update"
      # Get User details. Req: (Auth Token, First Name, Last Name, Date of birth, Sex, EMail, First Time). Response: (Success)
      get "me" => "registrations#details"
      # Login User using Mobile Number. Req: (Mobile Number, Password). Response: (Auth Token)
      post "login/email" => "registrations#login_email"
      # Logout User. Req: (Auth token). Response: ()
      post "logout" => "registrations#logout"

      # resources :registrations  do 
      #   collection do
      #   end
      # end
      
      # Passwords
      # Forgot Password. Req: (Login). Response: ()
      post "password/forgot" => "passwords#forgot"
      # Reset Password. Req: (Username, OTP). Response: ()
      get "password/reset" => "passwords#reset"
      # Modify Password. Req: (Login, New Password). Response: (Auth Token)
      put "password/modify" => "passwords#modify"
      
      # resources :passwords  do 
      #   collection do
      #   end
      # end
      
    end
  end
end
  
  


